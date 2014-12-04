# NAME

WebService::Algolia

# VERSION

version 0.0100

# SYNOPSIS

    use WebService::Algolia;

    my $alg = WebService::Algolia->new(
        application_id => '12345',
        api_key        => 'abcde',
    );

    $alg->get_indexes;

# DESCRIPTION

This module provides bindings for the
[Algolia](https://www.algolia.com/doc) API.

[![Build Status](https://travis-ci.org/aanari/WebService-Algolia.svg?branch=master)](https://travis-ci.org/aanari/WebService-Algolia)

# METHODS

## new

Instantiates a new WebService::Algolia client object.

    my $alg = WebService::Algolia->new(
        application_id => $application_id,
        api_key        => $api_key,
        timeout        => $retries,    # optional
        retries        => $retries,    # optional
    );

**Parameters**

- - `application_id`

    _Required_
     

    A valid Algolia application ID for your account.

- - `api_key`

    _Required_
     

    A valid Algolia api key for your account.

- - `timeout`

    _Optional_
     

    The number of seconds to wait per request until timing out.  Defaults to `10`.

- - `retries`

    _Optional_
     

    The number of times to retry requests in cases when Lob returns a 5xx response.  Defaults to `0`.

## get\_indexes

Returns a list of all existing indexes.

**Request:**

    get_indexes();

**Response:**

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

## browse\_index

Returns all content from an index.

**Request:**

    browse_index('foo');

**Response:**

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

## query\_index

Returns objects that match the query.

**Request:**

    query_index({ index => 'foo', query => 'bat' });

**Response:**

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

## query\_indexes

Query multiple indexes with one API call.

**Request:**

    query_indexes([
        { index => 'foo', query => 'baz' },
        { index => 'foo', query => 'bat' },
    ]);

**Response:**

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

## clear\_index

Deletes the index content. Settings and index specific API keys are kept untouched.

**Request:**

    clear_index('foo');

**Response:**

    {
        taskID    => 26036480,
        updatedAt => "2014-12-04T00:53:40.957Z",
    }

## delete\_index

Deletes an existing index.

**Request:**

    delete_index('foo');

**Response:**

    {
        deletedAt => "2014-12-04T00:56:00.773Z",
        taskID    => 26040530,
    }

## create\_index\_object

Creates a new object in the index, and automatically assigns an Object ID.

**Request:**

    create_index_object('foo', { bar => { baz => 'bat' }});

**Response**

    {
        createdAt => "2014-12-04T00:47:21.781Z",
        objectID  => 5333250,
        taskID    => 26026500,
    }

## get\_index\_object

Returns one object from the index.

**Request:**

    get_index_object('foo', 5333250);

**Response**

    {
        delicious => 'limoncello',
        objectID  => 5333250,
    }

## update\_index\_object

Creates a new object in the index, and automatically assigns an object ID.
Creates or replaces an object (if the object does not exist, it will be created). When an object already exists for the specified object ID, the whole object is replaced: existing attributes that are not replaced are deleted.

**Request:**

    update_index_object('foo', 5333250, { delicious => 'limoncello' });

**Response**

    {
        objectID  => 5333250,
        taskID    => 26034540,
        updatedAt => "2014-12-04T00:52:32.416Z",
    }

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/aanari/WebService-Algolia/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Ali Anari <ali@anari.me>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ali Anari.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
