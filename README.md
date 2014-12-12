# NAME

WebService::Algolia - Algolia API Bindings

# VERSION

version 0.0900

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

**Response:**

    {
        objectID  => 5333250,
        taskID    => 26026500,
        createdAt => "2014-12-04T00:47:21.781Z",
    }

## get\_index\_object

Returns one object from the index.

**Request:**

    get_index_object('foo', 5333250);

**Response:**

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

**Response:**

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

**Response:**

    {
        objectID  => 5333250,
        taskID    => 26034540,
        updatedAt => "2014-12-04T00:52:32.416Z",
    }

## update\_index\_object

Updates part of an object (if the object does not exist, it will be created. You can avoid an automatic creation of the object by passing `createIfNotExists=false` as a query argument).

**Request:**

    update_index_object('foo', 5333251, { another => 'pilsner?' });

**Response:**

    {
        objectID  => 5333251,
        taskID    => 29453760,
        updatedAt => "2014-12-06T02:49:40.859Z",
    }

## delete\_index\_object

Deletes an existing object from the index.

**Request:**

    delete_index_object('foo', 5333251);

**Response:**

    {
        objectID  => 5333251,
        taskID    => 29453761,
        deletedAt => "2014-12-11T02:49:40.859Z",
    }

## batch\_index\_objects

To reduce the amount of time spent on network round trips, you can create, update, or delete several objects in one call, using the batch endpoint (all operations are done in the given order).

The following methods can be passed into the `batch_index_objects` method as anonymous subroutines: `create_index_object`, `update_index_object`, `replace_index_object`, and `delete_index_object`.

**Request:**

    my $batch = alg->batch_index_objects('foo', [
        sub { alg->create_index_object('foo', { hello => 'world' })},
        sub { alg->create_index_object('foo', { goodbye => 'world' })},
    ]);

**Response:**

    {
        objectIDs => [5698830, 5698840],
        taskID => 40684520,
    }

**Request:**

    my $batch = alg->batch_index_objects('foo', [
        sub { alg->update_index_object('foo', 5698830, { 1 => 2 })},
        sub { alg->update_index_object('foo', 5698840, { 3 => 4 })},
    ]);

**Response:**

    {
        objectIDs => [5698830, 5698840],
        taskID => 40684521,
    }

**Request:**

    my $batch = alg->batch_index_objects('foo', [
        sub { alg->delete_index_object('foo', 5698830 )},
        sub { alg->delete_index_object('foo', 5698840 )},
    ]);

**Response:**

    {
        objectIDs => [5698830, 5698840],
        taskID => 40684522,
    }

## get\_index\_keys

If an indexName is passed, retrieves API keys that have access to this index with their rights.  Otherwise, retrieves all API keys that have access to one index with their rights.

**Request:**

    get_index_keys();

**Response:**

    {
        keys => [
            {
                acl      => [],
                index    => "pirouette",
                validity => 0,
                value    => "181b9114149666398628faa37b31cc8d",
            },
            {
                acl      => ['browse'],
                index    => "gelato",
                validity => 0,
                value    => "1428a48214792ac9f6324a823991aa4c",
            },
        ],
    }

**Request:**

    get_index_keys('pirouette');

**Response:**

    {
        keys => [
            {
                acl      => [],
                validity => 0,
                value    => "181b9114149666398628faa37b31cc8d",
            }
        ],
    }

## get\_index\_key

Returns the rights of a given index specific API key that has been created with the add index specific key API.

**Request:**

    get_index_key('pirouette', '181b9114149666398628faa37b31cc8d');

**Response:**

    {
        acl      => [],
        validity => 0,
        value    => "181b9114149666398628faa37b31cc8d",
    }

## create\_index\_key

Adds a new key that can access this index.

**Request:**

    create_index_key('pirouette', { acl => ['search']});

**Response:**

    {
        createdAt => "2014-12-08T15:54:22.464Z",
        key       => "181b9114149666398628faa37b31cc8d",
    }

## update\_index\_key

Updates a key that can access this index.

**Request:**

    update_index_key('pirouette', '181b9114149666398628faa37b31cc8d', { acl => ['search', 'browse']});

**Response:**

    {
        updatedAt => "2014-12-08T16:39:11.9Z",
        key       => "181b9114149666398628faa37b31cc8d",
    }

## delete\_index\_key

Deletes an index specific API key that has been created with the add index specific key API.

**Request:**

    delete_index_key('pirouette', '181b9114149666398628faa37b31cc8d');

**Response:**

    {
        deletedAt => "2014-12-08T16:40:49.86Z",
    }

## get\_task\_status

Retrieves the status of a given task (published or notPublished). Also returns a `pendingTask` flag that indicates if the index has remaining task(s) running.

**Request:**

    get_task_status('foo', 29734242);

**Response:**

    {
        pendingTask => bless(do{\(my $o = 0)}, "JSON::PP::Boolean"),
        status => "published",
    }

## get\_keys

Retrieves global API keys with their rights. These keys have been created with the add global key API.

**Request:**

    get_keys();

**Response:**

    {
        keys => [
            {
                acl      => [],
                validity => 0,
                value    => "28b555c212728a7f462fe96c0e677539",
            },
            {
                acl      => [],
                validity => 0,
                value    => "6ef88c72a6a4fc7e660f8819f111697c",
            }
        ],
    }

## get\_key

Returns the rights of a given global API key that has been created with the add global Key API.

**Request:**

    get_key('28b555c212728a7f462fe96c0e677539');

**Response:**

    {
        acl      => [],
        validity => 0,
        value    => "28b555c212728a7f462fe96c0e677539",
    }

## update\_key

Updates a global API key.

**Request:**

    update_key('28b555c212728a7f462fe96c0e677539', { acl => ['search', 'browse']});

**Response:**

    {
        updatedAt => "2014-12-08T16:39:11.9Z",
        key       => "28b555c212728a7f462fe96c0e677539",
    }

## delete\_key

Deletes a global API key that has been created with the add global Key API.

**Request:**

    delete_key('28b555c212728a7f462fe96c0e677539');

**Response:**

    {
        deletedAt => "2014-12-08T16:40:49.86Z",
    }

## get\_logs

Return last logs.

**Request:**

    get_logs();

**Response:**

    {
        logs => [
            {
                answer             => "\n{\n  \"keys\": [\n  ]\n}\n",
                answer_code        => 200,
                ip                 => "199.91.170.132",
                method             => "GET",
                nb_api_calls       => 1,
                processing_time_ms => 1,
                query_body         => "",
                query_headers      => "TE: deflate,gzip;q=0.3\nConnection: TE, close\nHost: 9KV4OFXW8Z.algolia.io\nUser-Agent: libwww-perl/6.08\nContent-Type: application/json\nX-Algolia-API-Key: 28d*****************************\nX-Algolia-Application-Id: 9KV4OFXW8Z\n",
                sha1 => "b82f8d002ccae799f6629300497725faa670cc7b",
                timestamp => "2014-12-09T05:08:05Z",
                url => "/1/keys",
            },
            {
                answer             => "\n{\n  \"value\": \"3bfccc91bb844f5ba0fc816449a9d340\",\n  \"acl\": [\n    \"search\"\n  ],\n \"validity\": 0\n}\n",
                answer_code        => 200,
                ip                 => "199.91.170.132",
                method             => "GET",
                nb_api_calls       => 1,
                processing_time_ms => 1,
                query_body         => "",
                query_headers      => "TE: deflate,gzip;q=0.3\nConnection: TE, close\nHost: 9KV4OFXW8Z.algolia.io\nUser-Agent: libwww-perl/6.08\nContent-Type: application/json\nX-Algolia-API-Key: 28d*****************************\nX-Algolia-Application-Id: 9KV4OFXW8Z\n",
                sha1 => "4915e88a309ea42f8f0ee46c9358b57b9a37a3d9",
                timestamp => "2014-12-09T05:08:04Z",
                url => "/1/keys/3bfccc91bb844f5ba0fc816449a9d340",
            },
        ],
    }

**Request:**

    get_logs({
        offset => 4,
        length => 2,
    });

**Response:**

    {
        logs => [
            {
                answer             => "\n{\n  \"message\": \"Key does not exist\"\n}\n",
                answer_code        => 404,
                index              => "pirouette",
                ip                 => "50.243.54.51",
                method             => "GET",
                nb_api_calls       => 1,
                processing_time_ms => 1,
                query_body         => "",
                query_headers      => "TE: deflate,gzip;q=0.3\nConnection: TE, close\nHost: 9KV4OFXW8Z.algolia.io\nUser-Agent: libwww-perl/6.07\nContent-Type: application/json\nX-Algolia-API-Key: 28d*****************************\nX-Algolia-Application-Id: 9KV4OFXW8Z\n",
                sha1               => "e2d3de10f69d8efb16caadaa22c6312ac408ed48",
                timestamp          => "2014-12-08T16:06:32Z",
                url                => "/1/indexes/pirouette/keys/25c005baabd13ab5c3ac14a79c9d5c27",
            },
            {
                answer             => "\n{\n  \"message\": \"Key does not exist\"\n}\n",
                answer_code        => 404,
                index              => "pirouette",
                ip                 => "50.243.54.51",
                method             => "GET",
                nb_api_calls       => 1,
                processing_time_ms => 1,
                query_body         => "",
                query_headers      => "TE: deflate,gzip;q=0.3\nConnection: TE, close\nHost: 9KV4OFXW8Z.algolia.io\nUser-Agent: libwww-perl/6.07\nContent-Type: application/json\nX-Algolia-API-Key: 28d*****************************\nX-Algolia-Application-Id: 9KV4OFXW8Z\n",
                sha1               => "d0799be3ccf05d2d5a0c902f6e80917468d5e6ff",
                timestamp          => "2014-12-08T16:06:07Z",
                url                => "/1/indexes/pirouette/keys/b7fbe3bcc26322af222edf2a9ca934ee",
            },
        ],
    }

## get\_popular\_searches

Return popular queries for a set of indices.

**Request:**

    get_popular_searches(['foo']);

**Response:**

    {
        lastSearchAt => "2014-12-09T05:00:00.000Z",
        searchCount  => 48,
        topSearches  => [
            {
                avgHitCount             => 0,
                avgHitCountWithoutTypos => 0,
                count                   => 32,
                query                   => "bat"
            },
        ],
    }

## get\_unpopular\_searches

Return queries matching 0 records for a set of indices.

**Request:**

    get_unpopular_searches(['foo']);

**Response:**

    {
        lastSearchAt        => "2014-12-09T05:00:00.000Z",
        searchCount         => 48,
        topSearchesNoResuls => [ { count => 16, query => "baz" } ],
    }

# SEE ALSO

[https://www.algolia.com/doc](https://www.algolia.com/doc) - the API documentation for [https://www.algolia.com](https://www.algolia.com).

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
