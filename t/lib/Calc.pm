package Calc::Test;

use base 'Test::Class';

use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

sub make_mojo : Tests(startup) {
  my ($self) = @_;

  $self->{t} = Test::Mojo->new('KidsBank');
}

#########

sub _test_calc {
  my ($self, $calc_type, $request_json, $expected_result) = @_;

  $self->{t}->post_ok("/calc/$calc_type" => json => $request_json)
    ->status_is(200)
    ->content_type_is('application/json;charset=UTF-8')
    ->json_is($expected_result);
}

sub _test_match_calc {
  my ($self, $request_json, $expected_result) = @_;

  $self->_test_calc('match', $request_json, $expected_result);
}

#########

sub make_interest_request_json : Tests(setup) {
  my ($self) = @_;

  $self->{request_json} = {
    balance => 27.75,
    child_age => 7,
    amount_per_age_of_balance => 0.25
  };
}

sub _test_interest_calc {
  my ($self, $value_to_change, $new_value, $expected_interest) = @_;

  $self->{request_json}->{$value_to_change} = $new_value;
  $self->_test_calc('interest', $self->{request_json}, { interest => $expected_interest });
}

sub basic_case : Test(4) {
  shift->_test_interest_calc('balance', 27.75, 0.75);
}

sub different_case : Test(4) {
  shift->_test_interest_calc('balance', 28.5, 1);
}

sub odd_amount : Test(4) {
  shift->_test_interest_calc('amount_per_age_of_balance', 5.35, 16.05);
}

sub zero_balance : Test(4) {
  shift->_test_interest_calc('balance', 0, 0);
}

sub under_age : Test(4) {
  shift->_test_interest_calc('child_age', 30, 0);
}


#########

sub test_match : Test(20) {
  my ($self) = @_;

  my $request_json = {
    balance => 27.75,
    deposit_total => 7.25,
    match_settings => {
      rate => 0.5,
      granularity => 1,
      min => 2,
      max => 4,
    }
  };

  $self->_test_match_calc($request_json, { match => 3, new_balance => 30.75 });

  $request_json->{balance} = 28.75;
  $self->_test_match_calc($request_json, { match => 3, new_balance => 31.75 });

  $request_json->{deposit_total} = 1.5;
  $self->_test_match_calc($request_json, { match => 0, new_balance => 28.75 });

  $request_json->{deposit_total} = 11.5;
  $self->_test_match_calc($request_json, { match => 4, new_balance => 32.75 });

  $request_json->{deposit_total} = 7.5;
  $request_json->{match_settings}->{granularity} = 0.25;
  $self->_test_match_calc($request_json, { match => 3.75, new_balance => 32.50 });
}

1;

