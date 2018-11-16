# perlOO
Read SDD.doc in this directory to learn more about the Rover program.

This was tested using Cygwin on a Windows XP machine, so it should function
on Cygwin or a true *NIX machine. Cygwin is a linux emulator that runs on
Windows and can be downloaded at http://www.cygwin.com/.

Install: open a shell and navigate to a desired directory in install.
$ tar -xvf rover.tar

Execute:
All test cases will follow the same process:

1) Open two terminals.
2) in both terminals:
        $ cd rover
3) in one terminal:
        $ ./RoverTransmitter.pl
   IT IS IMPORTANT TO DO THIS STEP BEFORE STEP 4 !!
   Windows might complain about the sockets being opened, but this
   can be safely ignored. I do use socket 1234, so if there is a
   collision the code might need to be appropriately modified to
   an available socket. A grep can find all locations of 1234.
4) in the second terminal:
        $ ./NASATransmit.pl
   or
        $ ./NASATransmit.pl < input.txt
   where input.txt is test case dependent.


Execute using each test case using the above procedure, replacing
input.txt with the files as specified and executing steps 3 and 4
for each input file. You can check the picture outputs if desired,
but the text output should be sufficient to validate correct function.


Proper execution input file (Rover functioning as expected):
-------------------------------------------------------------------------
good1.txt  # This is the sample input given in the specifications
good2.txt  # This validates the Rover will not move off of the grid.
good3.txt  # This validates a Rover can not be placed on top of another
           # Rover.
good4.txt  # This validates a Rover will not collide.
good5.txt  # This validates the Rover will not move off of the grid into
           # negative coordinates.


Improper execution input file (We don't expect Rover to do anything):
-------------------------------------------------------------------------
bad1.txt   # Test an invalid initial grid size, in this case a negative
           # number for one coordinate.
bad2.txt   # Test an invalid initial location, in this case a bad grid
           # coordinate.
bad3.txt   # Test an invalid command, in this case a command not in our
           # preapproved list.
bad4.txt   # Test an incomplete file. We don't have matched directions
           # for our rover, so we won't execute anything. This happens
           # if we have an initial location, but no commands. We expect
           # at least one command.
