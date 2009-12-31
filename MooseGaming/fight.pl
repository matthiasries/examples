#!/usr/bin/perl -w
#######
# Author Matthias Ries (mad)
# Version: > 0.1   Zweck: Moose-Uebung mit HeldenKlassen ( keine delegieren)
#######
#use Smart::Comments; #Funktioniert nicht richtig mit Padre. Werden STDOUT und STDERR nacheinander ausgegeben?
use v5.10;
our $VERSION = "0.1";

package Person;
use Any::Moose;
 has 'name' => ( is => 'rw' , isa => 'Str' , is_required => '1', default => "Junge");
 
   
 sub talk { 
    my ($self) = shift;
    my  $param = shift || "Stranger";
    say $self->name . ": " . "Hello $param";
    };
    
1;
package Weapon;
use Any::Moose;
  has 'name'   => ( is => 'rw' , isa => 'Str' , is_required => '1');
  has 'level'  => ( is => 'rw' , isa => 'Int' , is_required => '1', default => "1" );
  has 'damage' => ( is => 'rw' , isa => 'Int' , is_required => '1', default => "2" );
  sub attack { my $self = shift; say "Attack Monster with " . $self->name; };
1;
package Weapon::Fist;
use Any::Moose;
  extends 'Weapon';
  has 'name'   => ( is => 'ro' , isa => 'Str' , default => 'fists');

1;
package Weapon::Sword;
use Any::Moose;
  extends 'Weapon';
  has 'name'   => ( is => 'ro' , isa => 'Str' , default => 'sword');
  after attack =>  sub {say 'Die bitch!!' };

1;
package Hero;
use Any::Moose;
extends 'Person';
  has 'name' => ( is => 'rw' , isa => 'Str' , is_required => '1', default => "Junger Held");
  has 'level'=> ( is => 'rw' , isa => 'Int' , is_required => '1', default => "1" );
  has 'live' => ( is => 'rw' , isa => 'Int' , is_required => '1', default => "10" );
  has 'weapon' => ( is => 'rw' , isa =>  'Object');#  handles => [ "attack" ]     );

1;
package Hacker;
use Any::Moose;
extends 'Person';
  has 'name' => ( is => 'rw' , isa => 'Str' , is_required => '1', default => "Junger Padavan");
  has 'level'=> ( is => 'rw' , isa => 'Int' , is_required => '1', default => "99" );
  has 'live' => ( is => 'rw' , isa => 'Int' , is_required => '1', default => "9999" );
  sub talk {
    say "I have nothing to say!"
    };

1;
package Main;
#
### Eine neuer Held betritt die Buehne.
my $mein_held = Hero->new();#'name'=>'Link');
#
### Er begegnet einem Monster und zieht seine Waffe
$mein_held->weapon( Weapon::Sword->new() );
#
### Der Held Spricht zum Monster
$mein_held->talk("BadGuy");
### klirr.. Ihre Schwerter Kreuzen sich
$mein_held->weapon->attack("Monster");
#$mein_held->hand("$weapon");
#
### Ein Hacker betritt die Buehne
my $new_hacker = Hacker->new();
   $new_hacker->talk();
