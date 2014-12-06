# NAME

WebService::Algolia

# VERSION

version 0.0300

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

## copy\_index

Copies an existing index. If the destination index already exists, its specific API keys will be preserved and the source index specific API keys will be added.

**Request:**

    copy_index('foo' => 'foo2');

**Response:**

    {
        taskID    => 26071750,
        updatedAt => "2014-12-04T01:16:20.307Z",
    }

## move\_index

Moves an existing index. If the destination index already exists, its specific API keys will be preserved and the source index specific API keys will be added.

**Request:**

    move_index('foo' => 'foo2');

**Response:**

    {
        taskID    => 26079100,
        updatedAt => "2014-12-04T01:21:01.815Z",
    }

## delete\_index

Deletes an existing index.

**Request:**

    delete_index('foo');

**Response:**

    {
        taskID    => 26040530,
        deletedAt => "2014-12-04T00:56:00.773Z",
    }

## get\_index\_settings

Retrieves index settings.

**Request:**

    get_index_settings('foo');

**Response:**

    {
        'attributeForDistinct'  => undef,
        'attributesForFaceting' => undef,
        'attributesToHighlight' => undef,
        'attributesToIndex'     => [ 'bat' ],
        'attributesToRetrieve'  => undef,
        'attributesToSnippet'   => undef,
        'customRanking'         => undef,
        'highlightPostTag'      => '</em>',
        'highlightPreTag'       => '<em>',
        'hitsPerPage'           => 20,
        'minWordSizefor1Typo'   => 4,
        'minWordSizefor2Typos'  => 8,
        'optionalWords'         => undef,
        'queryType'             => 'prefixLast',
        'ranking'               => [
            'typo',
            'geo',
            'words',
            'proximity',
            'attribute',
            'exact',
            'custom'
        ],
        'removeWordsIfNoResults'  => 'none',
        'separatorsToIndex'       => '',
        'unretrievableAttributes' => undef
    }

## update\_index\_settings

Updates part of an index's settings.

**Request:**

    update_index_settings('foo', { attributesToIndex => ['bat'] });

**Response:**

    {
        taskID    => 27224430,
        updatedAt => "2014-12-04T19:52:29.54Z",
    }

## create\_index\_object

Creates a new object in the index, and automatically assigns an Object ID.

**Request:**

    create_index_object('foo', { bar => { baz => 'bat' }});

**Response**

    {
        objectID  => 5333250,
        taskID    => 26026500,
        createdAt => "2014-12-04T00:47:21.781Z",
    }

## get\_index\_object

Returns one object from the index.

**Request:**

    get_index_object('foo', 5333250);

**Response**

    {
        objectID  => 5333250,
        delicious => 'limoncello',
    }

## get\_index\_objects

Retrieve several objects with one API call.

**Request:**

    get_index_objects([
        { index => 'foo', object => 5333250 },
        { index => 'foo', object => 5333251 },
    ]);

**Response**

    {
        results => [{
            objectID  => 5333250,
            delicious => 'limoncello',
        },
        {
            objectID  => 5333251,
            terrible => 'cabbage',
        }],
    }

## replace\_index\_object

Creates or replaces an object (if the object does not exist, it will be created). When an object already exists for the specified object ID, the whole object is replaced: existing attributes that are not replaced are deleted.

**Request:**

    replace_index_object('foo', 5333250, { delicious => 'limoncello' });

**Response**

    {
        objectID  => 5333250,
        taskID    => 26034540,
        updatedAt => "2014-12-04T00:52:32.416Z",
    }

## update\_index\_object

Updates part of an object (if the object does not exist, it will be created. You can avoid an automatic creation of the object by passing `createIfNotExists=false` as a query argument).

**Request:**

    update_index_object('foo', 5333251, { another => 'pilsner?' });

**Response**

    {
        objectID  => 5333251,
        taskID    => 29453760,
        updatedAt => "2014-12-06T02:49:40.859Z",
    }

## get\_task\_status

Retrieves the status of a given task (published or notPublished). Also returns a `pendingTask` flag that indicates if the index has remaining task(s) running.

**Request:**

    get_task_status('foo', 29734242);

**Response**

    {
        pendingTask => bless(do{\(my $o = 0)}, "JSON::PP::Boolean"),
        status => "published",
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
