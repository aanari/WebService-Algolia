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

method get_index_object(Str $name, Str $id) {
    return $self->get("/indexes/$name/$id");
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

method create_index(Str $name, HashRef $data) {
    return $self->post("/indexes/$name", $data);
}

method update_index_object(Str $name, Str $id, HashRef $data) {
    return $self->put("/indexes/$name/$id", $data);
}

method clear_index(Str $name) {
    return $self->post("/indexes/$name/clear", {});
}

method delete_index(Str $name) {
    return $self->delete("/indexes/$name");
}

=head1 SYNOPSIS

    use WebService::Algolia;

    my $alg = WebService::Algolia->new(
        application_id => '12345',
        api_key        => 'abcde',
    );

=head1 DESCRIPTION

This module provides bindings for the
L<Algolia|https://www.algolia.com/doc> API.

=for markdown [![Build Status](https://travis-ci.org/aanari/WebService-Algolia.svg?branch=master)](https://travis-ci.org/aanari/WebService-Algolia)

=cut

1;