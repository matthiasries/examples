#!/usr/bin/perl -w
select STDIN; $|=1;select STDOUT;$|=1; #IDE-Fix
#######
# Author Matthias Ries <matthias AT mad4milk.de>
# Version: 0.1   What: Head First Design Patterns - Decorator Pattern - Example01
# Page 95 in german book
#######


use 5.10.00;
use MooseX::Declare;

role Zutat {
	has Zutat 	=> is => 'rw',isa => 'Zutat';
	has description => isa => 'Str',is => 'rw', default => 'Drink';
	has price	=> isa => 'Num',is => 'rw', default => .0;
	method getprice       { return $self->price + $self->Zutat->getprice  };
	method getdescription { return $self->Zutat->getdescription . ' '. $self->description };
}


class Espresso with Zutat{
	has price	=> isa => 'Num',is => 'rw', default => 1.0;	
	has description => isa => 'Str',is => 'rw', default => 'Espresso';
	method getdescription { return $self->description  };
	method getprice       { return $self->price };

}

class Schoko with Zutat{
	has price	=> isa => 'Num',is => 'rw', default => .5;
	has description => isa => 'Str',is => 'rw', default => 'Schoko';

}

class Vanille with Zutat{
	has price	=> isa => 'Num',is => 'rw', default => .5;
	has description => isa => 'Str',is => 'rw', default => 'Vanille';
}
		

		
my $drink    = Espresso->new;
   $drink    = Schoko->new(  Zutat=>$drink);
   $drink    = Vanille->new( Zutat=>$drink);
say '- Bestellung -';
say   'Produkt: '.$drink->getdescription;
say   'Preis: '  .$drink->getprice;

		
		
		
		
