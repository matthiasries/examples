#!/usr/bin/perl -w
select STDOUT;$|=1; # IDE-Fix
#######
# Author Matthias Ries
# Version: > 0.7   What: playing with Moose/MooseX::Declare, delegation, observer and decorator pattern
#######

use v5.10;
use MooseX::Declare;
our $VERSION = "0.7";



### Weapons 

class Weapon {
    
    has 'name'   => (is => 'rw', isa => 'Str');
    has 'level'  => (is => 'rw', isa => 'Num', default => "1");
    has 'damage' => (is => 'rw', isa => 'Int', default => "2");
    method attack($enemy? = 'Satan') { 
        
        say "Attacks $enemy with ".$self->name;
        
        }
}


class Weapon::Sword extends Weapon {
    no warnings;
    has name  => (is => 'ro', isa => 'Str', default => 'sword');
    after attack  { say 'He scream\'s: die bitch!!' };

}
class Weapon::Fist extends Weapon {

    has 'name' => (is => 'ro', isa => 'Str', default => 'fists');

}
class Weapon::Brain extends Weapon {

    has 'name' => (is => 'ro', isa => 'Str', default => 'brain');
    after attack { say 'Chess in less than 5 moves.' };
}


#### Observer-Pattern
role Observable {
        method update($subject,$wert?) { 
          
          say $self->name.": And the " . $subject->name() . " has changed";
          
        }
        method changes { 
            foreach my $Observer ( @{$self->{Observer}} ){           
                my $life = '-1';
                $Observer->update($self ,$life);
            }
        
        }
    
    }
role Observer {
        method update($subject,$wert?) { 
          
          say $self->name.": And the " . $subject->name() . " has changed";
          
        }
    
    
    }

## Die Welt als Subject in einem Observer-Szenario

class World with Observable {
    has name    => ( is => 'rw' , default => 'World');
    has Observer => ( 
                        is => 'rw',
                        isa     => 'ArrayRef[Item]',
                        traits  => ['Array'],
                        default => sub { [ ] },
                        handles => {
                                   add_Observer    => 'push',
                                   remove_Observer => 'shift',
                                   },
                       );
    
    };

## Die Personnen als Beobachter/Watcher in einem Observer-Szenario
class Person with Observer  {

    has 'name' => (is => 'rw', isa => 'Str', default => "Junge");
    has 'life' => (is => 'rw', 
                   traits => ['Number'],
                   isa => 'Int',
                   default => 3, 
#                   trigger => sub { 
#                                        $_->check_alive()
#                                        } 
                   );    
    method check_alive { 
                    say 'died' if $self->life() == 0;
                    exit; 
                    }
    method talk( $person? = 'Stranger' ) { 
        say $self->name . ": Hello $person";
    }
    

}

class Weapon::Factory {
    
    method get_weapon( $name ) {
        my $weaponclass;
        given ( $name ){
            when ('Sword'){$weaponclass = 'Weapon::Sword'}
            when ('Fist' ){$weaponclass = 'Weapon::Fist'}
            default { $weaponclass = 'Weapon::Fist' }            
            };
        return  $weaponclass->new();        
    };

    
    };

class Hero extends Person {
    
    has 'name'  => (is => 'rw', isa => 'Str', default => "Junger Held");
    has 'level' => (is => 'rw', isa => 'Int', default => "1");
    has 'life'  => (is => 'rw', isa => 'Num', default => "10");
    has 'weapon'=> (  is => 'rw', 
                     isa => 'Weapon',
                 handles => qr(attack),
                 default => sub { Weapon::Fist->new }, 
                 );
                 
    method set_weapon($weapon) { 
# i love method-chaining :-)
                    $self->weapon( Weapon::Factory->new->get_weapon( $weapon ) );

                     }
}


class Hacker extends Hero  {

    has 'name'  => (is => 'rw', isa => 'Str', default => "Agent");
    has 'level' => (is => 'rw', isa => 'Int', default => "99");
    has 'life'  => (is => 'rw', traits => ['Number'],isa => 'Int', default => 3  );
    before attack { say 'This is the end.' };
    method talk { say "Hello, Mr Anderson." };

}



######



### Eine Held wird geboren
my $mein_held = Hacker->new();

### Und betritt die Buehne
my $world = World->new();
$world->add_Observer($mein_held);

### Er begegnet einem Monster und zieht seine Waffe
$mein_held->set_weapon('Sword');
#$mein_held->set_weapon('Brain');

### Der Held Spricht zum Monster
#$mein_held->talk();
$mein_held->talk("Neo");
### klirr.. Ihre Schwerter Kreuzen sich
$mein_held->attack("Neo");

#$mein_held->hand("$weapon");
#
# Das leben geht weiter
foreach (1..2){
    $world->changes;
    sleep 2;
}
