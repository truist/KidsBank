use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('KidsBank');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);

sub test_calc {
  my ($calc_type, $request_json, $expected_result) = @_;

  $t->post_ok("/calc/$calc_type" => json => $request_json)
    ->status_is(200)
    ->content_type_is('application/json;charset=UTF-8')
    ->json_is($expected_result);
}
sub test_interest_calc {
  my ($request_json, $expected_result) = @_;
  test_calc('interest', $request_json, $expected_result);
}
sub test_match_calc {
  my ($request_json, $expected_result) = @_;
  test_calc('match', $request_json, $expected_result);
}

my $request_json = {
  balance => 27.75,
  child_age => 7,
  amount_per_age_of_balance => 0.25
};

my $expected_result = {
  interest => 0.75,
  new_balance => 28.5,
};

test_interest_calc($request_json, { interest => 0.75, new_balance => 28.5 });

$request_json->{balance} = 28.5;
test_interest_calc($request_json, { interest => 1, new_balance => 29.5 });

$request_json->{amount_per_age_of_balance} = 5.35;
test_interest_calc($request_json, { interest => 21.4, new_balance => 49.9 });

$request_json->{child_age} = 30;
test_interest_calc($request_json, { interest => 0, new_balance => 28.5 });


$request_json = {
  balance => 27.75,
  deposit_total => 7.25,
  match_settings => {
    rate => 0.5,
    granularity => 1,
    min => 2,
    max => 4,
  }
};

test_match_calc($request_json, { match => 3, new_balance => 30.75 });

$request_json->{balance} = 28.75;
test_match_calc($request_json, { match => 3, new_balance => 31.75 });

$request_json->{deposit_total} = 1.5;
test_match_calc($request_json, { match => 0, new_balance => 28.75 });

$request_json->{deposit_total} = 11.5;
test_match_calc($request_json, { match => 4, new_balance => 32.75 });

$request_json->{deposit_total} = 7.5;
$request_json->{match_settings}->{granularity} = 0.25;
test_match_calc($request_json, { match => 3.75, new_balance => 32.50 });


done_testing();

