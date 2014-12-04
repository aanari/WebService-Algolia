package WebService::Algolia;
use Moo;
with 'WebService::Client';

# VERSION

use Carp;
use Method::Signatures;
use Storable qw(dclone);
use URI;

has api_key        => ( is => 'ro', required => 1 );
has application_id => ( is => 'ro', required => 1 );

has '+base_url' => ( default => method {
    'https://' . $self->application_id . '.algolia.io/1'
});

method BUILD(...) {
    $self->ua->default_header('X-Algolia-Application-Id' => $self->application_id);
    $self->ua->default_header('X-Algolia-API-Key' => $self->api_key);
}

method get_indexes {
    return $self->get('/indexes');
}


method browse_index(Str $name) {
    return $self->get("/indexes/$name/browse");
}

method query_index(HashRef $query) {
    my $index = delete $query->{index};
    croak 'The \'index\' parameter is required' unless $index;
    return $self->get("/indexes/$index", $query);
}

method query_indexes(ArrayRef $queries) {
    $queries = [ map {
        my $index = delete $_->{index};
        croak 'The \'index\' parameter is required' unless $index;
        my $uri = URI->new;
        $uri->query_form( %$_ );
        { indexName => $index, params => substr($uri, 1) };
    } @$queries ];
    return $self->post('/indexes/*/queries', { requests => $queries });
}

method clear_index(Str $name) {
    return $self->post("/indexes/$name/clear", {});
}

method delete_index(Str $name) {
    return $self->delete("/indexes/$name");
}

method get_index_object(Str $name, Str $id) {
    return $self->get("/indexes/$name/$id");
}

method create_index_object(Str $name, HashRef $data) {
    return $self->post("/indexes/$name", $data);
}

method update_index_object(Str $name, Str $id, HashRef $data) {
    return $self->put("/indexes/$name/$id", $data);
}

=head1 SYNOPSIS

    use WebService::Algolia;

    my $alg = WebService::Algolia->new(
        application_id => '12345',
        api_key        => 'abcde',
    );

    $alg->get_indexes;

=head1 DESCRIPTION

This module provides bindings for the
L<Algolia|https://www.algolia.com/doc> API.

=for markdown [![Build Status](https://travis-ci.org/aanari/WebService-Algolia.svg?branch=master)](https://travis-ci.org/aanari/WebService-Algolia)

=head1 METHODS

=head2 new

Instantiates a new WebService::Algolia client object.

    my $alg = WebService::Algolia->new(
        application_id => $application_id,
        api_key        => $api_key,
        timeout        => $retries,    # optional
        retries        => $retries,    # optional
    );

B<Parameters>

=over 4

=item - C<application_id>

I<Required>E<10> E<8>

A valid Algolia application ID for your account.

=item - C<api_key>

I<Required>E<10> E<8>

A valid Algolia api key for your account.

=item - C<timeout>

I<Optional>E<10> E<8>

The number of seconds to wait per request until timing out.  Defaults to C<10>.

=item - C<retries>

I<Optional>E<10> E<8>

The number of times to retry requests in cases when Lob returns a 5xx response.  Defaults to C<0>.

=back

=head2 get_indexes

Returns a list of all existing indexes.

B<Request:>

    get_indexes();

B<Response:>

    [{
        createdAt      => "2014-12-03T23:20:19.745Z",
        dataSize       => 42,
        entries        => 1,
        lastBuildTimeS => 0,
        name           => "foo",
        pendingTask    => bless(do{\(my $o = 0)}, "JSON::PP::Boolean"),
        updatedAt      => "2014-12-04T00:41:14.120Z",
    },
    {
        createdAt      => "2014-12-03T23:20:18.323Z",
        dataSize       => 36,
        entries        => 1,
        lastBuildTimeS => 0,
        name           => "bar",
        pendingTask    => bless(do{\(my $o = 0)}, "JSON::PP::Boolean"),
        updatedAt      => "2014-12-04T00:42:13.231Z",
    }]

=head2 browse_index

Returns all content from an index.

B<Request:>

    browse_index('foo');

B<Response:>

    {
        hits             => [{ bar => { baz => "bat" }, objectID => 5333220 }],
        hitsPerPage      => 1000,
        nbHits           => 1,
        nbPages          => 1,
        page             => 0,
        params           => "hitsPerPage=1000&attributesToHighlight=&attributesToSnippet=&attributesToRetrieve=*",
        processingTimeMS => 1,
        query            => "",
    }

=head2 query_index

Returns objects that match the query.

B<Request:>

    query_index({ index => 'foo', query => 'bat' });

B<Response:>

    {
        hits => [
            {   _highlightResult => {
                    bar => {
                        baz => {
                            matchedWords => [ "bat" ],
                            matchLevel   => "full",
                            value        => "<em>bat</em>"
                        },
                    },
                },
                bar      => { baz => "bat" },
                objectID => 5333370,
            },
        ],
        hitsPerPage      => 20,
        nbHits           => 1,
        nbPages          => 1,
        page             => 0,
        params           => "query=bat",
        processingTimeMS => 1,
        query            => "bat",
    }

=head2 query_indexes

Query multiple indexes with one API call.

B<Request:>

    query_indexes([
        { index => 'foo', query => 'baz' },
        { index => 'foo', query => 'bat' },
    ]);

B<Response:>

    {
        results => [
            {   hits             => [],
                hitsPerPage      => 20,
                index            => "foo",
                nbHits           => 0,
                nbPages          => 0,
                page             => 0,
                params           => "query=baz",
                processingTimeMS => 1,
                query            => "baz",
            },
            {   hits => [
                    {   _highlightResult => {
                            bar => {
                                baz => {
                                    matchedWords => [ "bat" ],
                                    matchLevel   => "full",
                                    value        => "<em>bat</em>"
                                },
                            },
                        },
                        bar      => { baz => "bat" },
                        objectID => 5333380,
                    },
                ],
                hitsPerPage      => 20,
                index            => "foo",
                nbHits           => 1,
                nbPages          => 1,
                page             => 0,
                params           => "query=bat",
                processingTimeMS => 1,
                query            => "bat",
            },
        ],
    }

=head2 clear_index

Deletes the index content. Settings and index specific API keys are kept untouched.

B<Request:>

    clear_index('foo');

B<Response:>

    {
        taskID    => 26036480,
        updatedAt => "2014-12-04T00:53:40.957Z",
    }

=head2 delete_index

Deletes an existing index.

B<Request:>

    delete_index('foo');

B<Response:>

    {
        deletedAt => "2014-12-04T00:56:00.773Z",
        taskID    => 26040530,
    }

=head2 create_index_object

Creates a new object in the index, and automatically assigns an Object ID.

B<Request:>

    create_index_object('foo', { bar => { baz => 'bat' }});

B<Response>

    {
        createdAt => "2014-12-04T00:47:21.781Z",
        objectID  => 5333250,
        taskID    => 26026500,
    }

=head2 get_index_object

Returns one object from the index.

B<Request:>

    get_index_object('foo', 5333250);

B<Response>

    {
        delicious => 'limoncello',
        objectID  => 5333250,
    }

=head2 update_index_object

Creates a new object in the index, and automatically assigns an object ID.
Creates or replaces an object (if the object does not exist, it will be created). When an object already exists for the specified object ID, the whole object is replaced: existing attributes that are not replaced are deleted.

B<Request:>

    update_index_object('foo', 5333250, { delicious => 'limoncello' });

B<Response>

    {
        objectID  => 5333250,
        taskID    => 26034540,
        updatedAt => "2014-12-04T00:52:32.416Z",
    }

=cut

1;
