package Rover;

##--------------------------------------------------------
##	Jason Baucom
##	Rover program
##      Package Vehicle
##
##	The Rover package inplments the Vehicle package
##      and offers new functionality. We will overwrite the
##      move functionality, since we might expect more than
##      1 vehicle and limited by maximum grid coordinates.
##      We will need to validate the move functionality
##      so we have the check function to validate we are moving
##      to a valid location and modified the move routine to make
##      sure we are in the proper limits of our grid.
##
##      Some functionality did not need to change, such
##      as changeDirection. We can rotate without regard
##      for the location of other rovers.
##
##      Return Value: Grid coordinates and direction required
##      for return to NASA. Format will look as follows:
##      1 2 W
##      where 1 is the X coordinate, 2 is the Y coordinate and W 
##      is the direction the rover is facing.
##--------------------------------------------------------

require Vehicle;
our @ISA = qw(Vehicle);
my @GridLocations;

my @Locations = 0;

#-----------------------------------------------------------------------
# Function: New
# Set up our initial rover statistics, such as initial coordinates and
# direction.
#
# Call: my $newVehicle = new Rover($init_location,$maxX,$maxY,@CoordLocations);
# Input: Initial Location for rover, max and min dimensions of the operational
#        grid and an array that contains the location of all other rovers. 
# Output: New Rover object or error code if grid location already occupied.
#-----------------------------------------------------------------------

sub new
{
    my $self = {};
    @GridLocations = ();
    my $initial_stuff = shift;
    $initial_stuff = shift;
    chomp($initial_stuff);
    $self->{maxX} = shift;
    $self->{maxY} = shift;
    while (my $x = shift)
    {
        # Push every rover location into a grid array.
        push (@GridLocations, $x);
    }

    # Get (X,Y) coords and direction
    my @initial_array = split(" ",$initial_stuff);
    $self->{Location}{XCord} = @initial_array[0];
    $self->{Location}{YCord} = @initial_array[1];
    $self->{Location}{Direction} = @initial_array[2];
    my $grid = $self->{Location}{XCord} . " " . $self->{Location}{YCord};
    bless $self;

    # Is the location already occupied? If so, we return -1.
    if ( $self->check($grid))
    {
        push( @GridLocations, $grid ); 
        return $self;
    }
    else
    {
        return -1;
    }
}

#-----------------------------------------------------------------------
# Function: processInstruction
# Steps through the commands given by NASA. 
#
# Call: my $return_value = $MyRover->processInstructions($direction);
# Input: directions, formed like: "MLLRMM", where M represents ubove one
#        grid point, L means rotate left and R means rotate right.
#        maxX and maxY details the limits of our grid.
# Output: Grid coordinates and direction in the form "1 2 N"
#-----------------------------------------------------------------------

sub processInstruction
{
    my $self = shift;
    #my ( $instruction) = @_; 
    my $instruction = shift; 
    chomp($instruction);

    # Split every character and step through
    @directions = split(undef,$instruction);
    foreach my $step (@directions)
    {
        if ( $step eq "L" || $step eq "R" )
        {
            # Rotate left or right;
            $self->changeDirection($step);
        }
        elsif ( $step eq "M" )
        {
            $self->move();
        }
        else
        {
            # Complain to NASA. This should not happen really, since we
            # prune out bad commands in our RoverTransmit program. Just
            # being redundant, since is is possible for another program
            # to call this module.
            print "NASA must be stupid sending us errant instruction!\n";
        }
    }
    return $self->{Location}{XCord} . " " . $self->{Location}{YCord} . " " . $self->{Location}{Direction};
}

#-----------------------------------------------------------------------
# Function: move
# moves the Vehicle according to directions.
# used for debugging.
#
# Cal:   $self->move();
# Input: maxX and maxY, detailing the limits of our grid.
# Output: Changes the location of the Rover. Error checking will verify
#         that the movement is valid, meaning it stays inside of the grid
#         and does not run over another Rover. If there is a conflict then
#         the movement does not take place.
#-----------------------------------------------------------------------

sub move
{
    my $self = shift;
    my $NewLocation;
    my $ReadyToMove = 1;


    # Start checking to see if we are in our grid boundies. If so, create a
    # hypothetical next step.

    if ($self->{Location}{Direction} eq "N" && ($self->{Location}{YCord} + 0) <  ( $self->{maxY} + 0 ) )
    {
        $NewLocation = $self->{Location}{XCord} . " " . ( $self->{Location}{YCord} + 1 );
    }
    elsif ($self->{Location}{Direction} eq "S" && ($self->{Location}{YCord} + 0) > 0 )
    {
        $NewLocation = $self->{Location}{XCord} . " " . ($self->{Location}{YCord} - 1);
    }
    elsif ($self->{Location}{Direction} eq "E" && ($self->{Location}{XCord} + 0) < ( $self->{maxX} + 0 ))
    {
        $NewLocation = ($self->{Location}{XCord} + 1) . " " . $self->{Location}{YCord};
    }
    elsif ($self->{Location}{Direction} eq "W" && ($self->{Location}{XCord} + 0) > 0)
    {
        $NewLocation = ($self->{Location}{XCord} - 1) . " " . $self->{Location}{YCord};
    }
    else
    {
        # We are out of bounds! Don't engage in a move
        $ReadyToMove = 0;
        print "\nWe just attempted to move outside of our bounds, not moving\n";
    }


    my $CurrentLocation = $self->{Location}{XCord} . " " . $self->{Location}{YCord};
    if ( $self->check($NewLocation) && $ReadyToMove )
    # The new site seems unoccupied, so we move our Rover there.
    # No else, because if the site is occupied we won't updated our
    # location. This is an assumption that conflicting directions
    # will result in no motion.
    {
        if ($self->{Location}{Direction} eq "N")
        {
            $self->{Location}{YCord} = $self->{Location}{YCord} + 1;
        }
        if ($self->{Location}{Direction} eq "S")
        {
            $self->{Location}{YCord} = $self->{Location}{YCord} - 1;
        }
        if ($self->{Location}{Direction} eq "E")
        {
            $self->{Location}{XCord} = $self->{Location}{XCord} + 1;
        }
        if ($self->{Location}{Direction} eq "W")
        {
            $self->{Location}{XCord} = $self->{Location}{XCord} - 1;
        }


        for ( my $i = 0; $i <= $#GridLocations; $i++)
        {
            # We keep the location of the rovers in an array. We now will
            # loop through the array, looking for our old location and overwrite
            # it with our destination.

            if ($GridLocations[$i] eq $CurrentLocation)
            {
                $GridLocations[$i] = $NewLocation;
            }
        } 
    }
    else
    {
        "We are not moving to an allowed position. We stay where we are\n";
    }
}


#-----------------------------------------------------------------------
# Function: check
# Validates the the desired move location is empty. Called during Rover
# placement and movement.
#
# Call:   if ( $self->check($NewLocation) && $ReadyToMove )
# Input:  Location we want to move to.
# Output: binary yes or no. Yes indicates the location is empty.
#         This is used in an If statement.
#-----------------------------------------------------------------------

sub check
{
    my $self = shift;
    my $coords = shift;
    
    # Loop through all occupied locations and see if our desired destination
    # is occupied. If so, return 0 so we know not to move there.

    foreach my $LocationScan ( @GridLocations )
    {
        if ( $coords eq $LocationScan )
        {
            return 0;
        } 
    }
    return 1;
}

1;
