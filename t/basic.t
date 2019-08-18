use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

sub test_interest_calc {
  my ($t, $request_json, $expected_result) = @_;

  $t->post_ok('/calc/interest' => json => $request_json)
    ->status_is(200)
    ->content_type_is('application/json;charset=UTF-8')
    ->json_is($expected_result);
}

my $t = Test::Mojo->new('KidsBank');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

my $request_json = {
  balance => 27.75,
  child_age => 7,
  amount_per_age_of_balance => 0.25
};

my $expected_result = {
  interest => 0.75,
  new_balance => 28.5,
};

test_interest_calc($t, $request_json, $expected_result);

$request_json->{balance} = 28.5;
$expected_result = {
  interest => 1,
  new_balance => 29.5,
};
test_interest_calc($t, $request_json, $expected_result);


done_testing();
