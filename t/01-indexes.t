use Test::Modern;
use t::lib::Harness qw(alg skip_unless_has_keys);

skip_unless_has_keys;

subtest 'Index management' => sub {
    my $indexes = alg->get_indexes;
    cmp_deeply $indexes => [],
        'Correctly retrieved no indexes'
        or diag explain $indexes;

    my $name = 'foo';
    my $index = alg->create_index($name, { bar => { baz => 'bat'}});
    cmp_deeply $index => TD->superhashof({
            createdAt => TD->ignore(),
            objectID  => TD->re('\d+'),
            taskID    => TD->re('\d+'),
        }), "Returned index '$name' with valid IDs"
        or diag explain $index;

    sleep 1;

    my $query = alg->query_index($name, { query => 'bat' });
    cmp_deeply $query => [ TD->superhashof({
            bar => { baz => 'bat'},
        })], 'Correctly matched index values from query'
        or diag explain $query;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes => [ TD->superhashof({
            createdAt => TD->ignore(),
        })], "Returned index '$name' in listing"
        or diag explain $indexes;

    alg->delete_index('foo');

    sleep 1;

    $indexes = alg->get_indexes();
    cmp_deeply $indexes => [],
        'Correctly retrieved no indexes again'
        or diag explain $indexes;
};

done_testing;
