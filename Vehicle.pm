package Vehicle;

##--------------------------------------------------------
##	Jason Baucom
##	Rover program
##      Package Vehicle
##      7/22/2009
##
##	The Vehicle package offers the generic vehicle
##      functionality desired by NASA. It will operate on
##      on a X-Y grid;
##
##      This package will receive instructions and "move"
##      our vehicle appropriately. There is no logic for
##      a limited grid or concern about running over other
##      vehicles.
##--------------------------------------------------------

# Hash used for enumerating directions. Makes rotation of vehicle simpler.
my %MapLogic = ( N => 0,
                 E => 1,
                 S => 2,
                 W => 3, );

#-----------------------------------------------------------------------
# Function: New
# Set up our initial vehicle statistics, such as initial coordinates and
# direction.
#
# Call: my $newVehicle = new Vehicle($init_location);
# Input: Initial Location
# Output: New Vehicle object
#-----------------------------------------------------------------------

sub new
{
    #my $class = shift;
    my $self = {};
    my $initial_stuff = shift;
    $initial_stuff = shift;
    chomp($initial_stuff);

    # Set up our initial coordinates
    my @initial_array = split(" ",$initial_stuff);
    $self->{Location}{XCord} = @initial_array[0];
    $self->{Location}{YCord} = @initial_array[1];
    $self->{Location}{Direction} = @initial_array[2];
    bless $self;
    return $self;
}

#-----------------------------------------------------------------------
# Function: processInstruction
# Steps through the commands given by NASA. 
#
# Call: my $return_value = $VMyVehicle->processInstructions($direction);
# Input: directions, formed like: "MLLRMM", where M represents move one
#        grid point, L means rotate left and R means rotate right.
# Output: Grid coordinates and direction in the form "1 2 N"
#-----------------------------------------------------------------------

sub processInstruction
{
    my $self = shift;
    my ($instruction) = @_; 
    chomp($instruction);

    # split up instruction set
    @directions = split(undef,$instruction);
    #$self->printLocation();

    # Walk through each step
    foreach my $step (@directions)
    {

        # If we are rotating the vehicle we call changeDirection
        if ( $step eq "L" || $step eq "R" )
        {
            $self->changeDirection($step);
        }

        # If we are movine the vehicle we call move
        elsif ( $step eq "M" )
        {
            $self->move();
        }

        # We don't do anything if the step is invalid. Gripe to NASA!
        else
        {
            print "NASA must be stupid sending us errant instruction!\n";
        }
    }
    return $self->{Location}{XCord} . " " . $self->{Location}{YCord} . " " . $self->{Location}{Direction};
}

#-----------------------------------------------------------------------
# Function: printLocation
# prints the current location and direction of our Vehicle. Mostly
# used for debugging.
#
# Call:  $VMyVehicle->printLocation();
# Input: none
# Output: prints location and direction of vehicle.
#-----------------------------------------------------------------------

sub printLocation
{
    my $self = shift;
    print $self->{Location}{XCord} . " " . $self->{Location}{YCord} . " " . $self->{Location}{Direction}  . " is our location and direction\n";
}


#-----------------------------------------------------------------------
# Function: move
# moves the Vehicle according to directions.
# used for debugging.
#
# Cal:   $self->move();
# Input: none
# Output: changes the location of the vehicle. No error checking in Vehicle.
#-----------------------------------------------------------------------

sub move
{
    my $self = shift;

    # Check our direction and step in that direction.

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
    #$self->printLocation();
}


#-----------------------------------------------------------------------
# Function: changeDirection
# Rotates the Vehicle according to directions.
#
# Cal:   $self->changeDirection($step);
# Input: $step, which is L or R.
# Output: changes the direction of the vehicle. No error checking in Vehicle.
#-----------------------------------------------------------------------
sub changeDirection
{
    my $self = shift;
    my ( $change ) = @_;

    # If we get "R", then we change direction to the right. Have modulus 4
    # in case we "wrap" around the compass. Otherwise, we rotate left.
    # Keep in mind N = 0, E = 1, S = 2, W = 3;

    my $MapPoints = $MapLogic{$self->{Location}{Direction}};
    
    my $funky = ($change eq "R")?1:-1;
    $value = ( $funky + $MapPoints) % 4;  

    for my $key ( keys %MapLogic )
    {
        if ($value eq $MapLogic{$key} )
        {
            $self->{Location}{Direction} = $key;
        }

    }
    # TODO fix sizeof here
    #$self->printLocation();
}

1;
