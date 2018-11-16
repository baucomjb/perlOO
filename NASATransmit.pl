#!/usr/bin/perl
# Client Program
use IO::Socket::INET;
print ">> NASA Rover Transmission Program <<";

# Create a new socket
$MySocket=new IO::Socket::INET->new(PeerPort=>1234,Proto=>'udp',PeerAddr=>'localhost');

# Send messages
$def_msg="Enter message to send to Rover. Enter \"DONE\" to terminate instruction set : ";
print "\n",$def_msg;
while($msg=<STDIN>)
{
    chomp $msg;
    # ignore blank lines
    if($msg ne '')
    {
        print "\nSending message '",$msg,"'";
        if($MySocket->send($msg))
        {
            print ".....<done>","\n";
            print $def_msg;
        }
    }
    if ( $msg eq 'DONE' )
    {
        last;
    }
}

# If we get directions from a file we might not have a terminting DONE,
# so we check to see if we sent DONE to the Rover.
if ( $msg ne 'DONE' )
{
    $MySocket->send('DONE');
}

# We get coordinates first, then pictures.
print "Waiting to receive Rover coordinates!\n";
while(1)
{
    $MySocket->recv($text,128);

    # This is our anticipated generic error message for a bad
    # input set.
    if ($text eq "Incorrect transmitted instruction set")
    {
        print "Bad input instructions\n";
        print "Try again!\n";
        exit 1;
    }

    if($text ne '')
    {
        print "Rover statistics: ", $text,"\n";
    }
    # If client message is empty exit
    else
    {
        print "Transmission has ended! All information received\n";
        last;
    }
}

# We now wait for pictures from our rovers to arrive. We will have 1 for
# each rover. We will need to manually check for signs of ET.
# pictures numbered sequentially.

print "Waiting to receive Rover pictures!\n";
my $file = "\./NASAPics/Rover0.jpg";
open PICTURE, "> $file";
my $roverNum = 0;

while(1)
{
    $MySocket->recv($text,100000);
    if($text ne 'NEXT' && $text ne 'END')
    {
        print PICTURE $text;
    }

    # we are at last line of the picture, so open up a new file
    # for the next rover transmission.
    elsif ( $text eq 'NEXT')
    {
        close PICTURE;
        $roverNum++;
        $file = "\./NASAPics/Rover" . $roverNum . "\.jpg";
        open PICTURE, ">$file";
    }

    # We have them all now. Delete the last file. Our strategy
    # leaves one empty file at the end.
    else
    {
        print "Pictures received. Please check at \./NASAPics\n";
        print "Did we find ET?\n";
        close PICTURE;
        unlink $file;
        exit 1;
    }
}
