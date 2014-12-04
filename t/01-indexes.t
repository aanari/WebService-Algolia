use Test::Modern;
use t::lib::Harness qw(alg skip_unless_has_keys);
use Data::Dump;

skip_unless_has_keys;

subtest 'Index Management' => sub {
    my $indexes = alg->get_indexes;
    cmp_deeply $indexes->{items} => [],
        'Correctly retrieved no indexes'
        or diag explain $indexes;

    my $name = 'foo';
    my $content = { bar => { baz => 'bat'}};
    my $index = alg->create_index_object($name, $content);
    cmp_deeply $index => TD->superhashof({
            createdAt => TD->ignore(),
            objectID  => TD->re('\d+'),
            taskID    => TD->re('\d+'),
        }), "Returned index '$name' with valid IDs"
        or diag explain $index;

    sleep 1;

    my $query = alg->query_index({ index => $name, query => 'bat' });
    cmp_deeply $query->{hits} => [ TD->superhashof($content) ],
        'Correctly matched index values from query'
        or diag explain $query;

    my $queries = alg->query_indexes([
        { index => $name, query => 'baz' },
        { index => $name, query => 'bat' },
    ]);
    is @{$queries->{results}} => 2,
        'Retrieved two sets of results from batch route'
        or diag explain $queries;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes->{items} => [ TD->superhashof({
            createdAt => TD->ignore(),
        })], "Returned index '$name' in listing"
        or diag explain $indexes;

    my $contents = alg->browse_index($name);
    cmp_deeply $contents->{hits} => [ TD->superhashof($content) ],
        "Matched contents of index '$name'"
        or diag explain $contents;

    ok alg->clear_index($name), "Cleared index '$name' content";

    sleep 1;

    $contents = alg->browse_index($name);
    cmp_deeply $contents->{hits} => [],
        "Successfully cleared index '$name'"
        or diag explain $contents;

    my $name2 = 'foo2';
    ok alg->copy_index($name => $name2), "Copied index '$name' to '$name2'";

    sleep 1;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes->{items} => [ map { TD->superhashof({ name => $_ })}
        ($name, $name2)],
        "Found indexes '$name' and '$name2'"
        or diag explain $indexes;

    my $name3 = 'foo3';
    ok alg->move_index($name2 => $name3), "Moved index '$name2' to '$name3'";

    sleep 1;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes->{items} => [ map { TD->superhashof({ name => $_ })}
        ($name, $name3)],
        "Found indexes '$name' and '$name3'"
        or diag explain $indexes;

    ok alg->delete_index($_), "Deleted index '$_' completely"
        for ($name, $name3);

    sleep 1;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes->{items} => [],
        'Correctly retrieved no indexes again'
        or diag explain $indexes;
};

subtest 'Index Object Management' => sub {
    my $name = 'bourbon';
    my $content = { delicious => 'limoncello' };
    my $index = alg->create_index_object($name, $content);
    my $object_id = $index->{objectID};

    $content = { terrible => 'cabbage' };
    ok alg->update_index_object($name, $object_id, $content),
        "Updating contents of object '$object_id'";

    sleep 1;

    my $object = alg->get_index_object($name, $object_id);
    cmp_deeply $object => TD->superhashof($content),
        "Successfully updated contents of object '$object_id'"
        or diag explain $object;

    ok alg->delete_index($name), "Deleted index '$name' completely";
};

done_testing;
