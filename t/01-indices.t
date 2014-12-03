use Test::Modern;
use t::lib::Harness qw(alg skip_unless_has_keys);

skip_unless_has_keys;

subtest 'Index creation' => sub {
    ok alg();
};

done_testing;
