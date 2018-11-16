#!/usr/bin/perl
# Server Program
use IO::Socket::INET;
use Vehicle;
use Rover;

print ">> Rover Transmitter <<\n";

# Create a new socket locally
$MySocket=new IO::Socket::INET->new(LocalPort=>1234,Proto=>'udp');

# We wait patiently for instructions from NASA.

my @instr;
# Wait until we get a "DONE". This signals no more Rovers are coming over.
while(1)
{
    $MySocket->recv($text,2000);
    if($text ne 'DONE')
    {
        print "\nReceived message '", $text,"'\n";
        push(@instr,$text);
    }
    # If client message is empty exit
    else
    {
        print "Transmission from NASA has ended!\n";
        last;
    }
}



# Show what instructions we have.
foreach (@instr)
{
    print $_,"\n";
}

my $line= shift @instr;
chomp $line;

# Make sure we have a properly formatted grid line at top of file.
# If not, we can't do much!
if ( $line !~ /^\d+ \d+$/ )
{
    $MySocket->send("Incorrect transmitted instruction set");
    print "Incorrect grid Coordinates\n";
    $MySocket->send('');
    exit 1;

}
my @inst_array = split(" ",$line);
my $maxX = shift @inst_array;
my $maxY = shift @inst_array;

# For simplicity two arrays will be maintained. This is perhaps a bit redundant
# but it simplies the process of validating occupied coordinates in the Rover
# package.
#
# MetaGridLocations will contain grid coordinates as well as direction. This
# will primarily be used for the final output back to NASA.
# CoordGridLocations will contain grid coordinates only.

my @MetaGridLocations;
my @CoordGridLocations;

while (1)
# Cycle through all potential sets of instructions
# we check for matched pairs of initial location and directions.
{
    if ( my $init_location = shift @instr )
    {
        # Make sure the init_location is of form: "x y D" with X and Y both
        # being positive integers and D one of N, E, S, W.

        if ( $init_location !~ /^\d+ \d+ (N|W|S|E)$/ )
        {
            $MySocket->send("Incorrect transmitted instruction set");
            print "Incorrect initial Coordinates\n";
            # We got bad instructions. We need to terminate.
            $MySocket->send('');
            exit 1;
        }

        if ( my $directions = shift @instr)
        {
            # Make sure our directions are valid. otherwise we fail.
            if ( $directions !~ /^(M|R|L)+$/ )
            {
                $MySocket->send("Incorrect transmitted instruction set");
                print "Incorrect directions\n";
                $MySocket->send('');
                exit 1;
            }

            # Rover needs to be aware of its starting location, direction
            # grid limits and current occupants of the grid.

            my $Rover1 = new Rover($init_location, $maxX, $maxY, @CoordGridLocations);
            # Rover placed off of the grid. Next rover!
            if ( $Rover1 == -1 )
            {
                $MySocket->send("Bad Rover Placement!");
                print "Can't use this Rover, bad instructions\n";
                next;
            }
            
            my $Loc = $Rover1->processInstruction($directions);

            # Split out x-y coordinates for our Coordinate array
            my @CoordArray = split(" ", $Loc);
            my $CoordLoc = $CoordArray[0] . " " . $CoordArray[1];
            push(@MetaGridLocations,$Loc);
            push(@CoordGridLocations,$CoordLoc);
        }
        else
        {
            print "We are screwed, unmatched directions\n";
            $MySocket->send("Incorrect transmitted instruction set");
            print "unmatched placement and directions.\n";
            $MySocket->send('');
            exit 1;
        }
    }
    else
    {
        # we are finished with input
        last;
    }

}

# Send information back to NASA!
foreach my $line ( @MetaGridLocations )
{
    $MySocket->send($line);
}
$MySocket->send('');

# Send pictures back to NASA. What good is a Mars mission without
# pictures!
foreach my $line ( @MetaGridLocations )
{
    print "Sending a picture\n";
    # For each Rover we will send a random picture. We are looking for a
    # Martian! How exciting! We have a 10% chance of finding ET.
    my $number = rand(100);
    if ( $number < 90 )
    {
        # We did not find ET!
        open PICTURE, "< \./MarsPics/mars_rocks1\.jpg";
        my @picLines = <PICTURE>;
        foreach (@picLines)
        {
            $MySocket->send($_); 
        }
        $MySocket->send('NEXT'); 
    }
    else
    {
        # We found ET!
        open PICTURE, "< ./MarsPics/ET.jpg";
        my @picLines = <PICTURE>;
        foreach (@picLines)
        {
            $MySocket->send($_); 
        }
        $MySocket->send('NEXT'); 
    }
}
$MySocket->send('END'); 
