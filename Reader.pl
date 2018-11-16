#!/usr/bin/perl
use Vehicle;
use Rover;
open INSTRUCTION, "<instruction.txt" or die "NASA we have a problem!\n";
my @instr = <INSTRUCTION>;
foreach (@instr)
{
    print $_,"\n";
}
my $line= shift @instr;
chomp $line;
my @inst_array = split(" ",$line);
my $maxX = shift @inst_array;
my $maxY = shift @inst_array;

my @MetaGridLocations;
push(@MetaGridLocations,"1 5");

while (1)
# Cycle through all potential sets of instructions
{
    if ( my $init_location = shift @instr )
    {
        print "Got instructions\n";
        if ( my $directions = shift @instr)
        {
            print "Got directions\n";
            #my $Rover1 = new Vehicle;
            my $Rover1 = new Rover($init_location, @MetaGridLocations);
            my $Loc = $Rover1->processInstruction($directions);
            push(@MetaGridLocations,$Loc);
            print "----------------------\n";
        }
        else
        {
            print "We are screwed, unmatched directions\n";
        }
    }
    else
    {
        print "We are finished now\n";
        last;
        # we are finished with input
    }

}
