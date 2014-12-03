use Test::Modern;
use t::lib::Harness qw(alg skip_unless_has_keys);

skip_unless_has_keys;

subtest 'Index management' => sub {
    my $indexes = alg->get_indexes;
    cmp_deeply $indexes->{items} => [],
        'Correctly retrieved no indexes'
        or diag explain $indexes;

    my $name = 'foo';
    my $content = { bar => { baz => 'bat'}};
    my $index = alg->create_index($name, $content);
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

    alg->clear_index($name);

    sleep 1;

    $contents = alg->browse_index($name);
    cmp_deeply $contents->{hits} => [],
        "Successfully cleared index '$name'"
        or diag explain $contents;

    ok alg->delete_index($name), "Deleted index '$name' completely";

    sleep 1;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes->{items} => [],
        'Correctly retrieved no indexes again'
        or diag explain $indexes;
};

done_testing;
