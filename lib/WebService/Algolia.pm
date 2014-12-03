package WebService::Algolia;
use Moo;
with 'WebService::Client';

# VERSION

use Method::Signatures;

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
    my $result = $self->get('/indexes');
    return $result->{items} if $result;
}

method query_index(Str $name, HashRef $params) {
    my $result = $self->get("/indexes/$name", $params);
    return $result->{hits} if $result;
}
method create_index(Str $name, HashRef $data) {
    return $self->post("/indexes/$name", $data);
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
