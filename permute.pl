#====================================================================
#
#  Filename:        permute.pl
#  Author:          Ozan Akcin
#  Created:         2017-01-22
#  Purpose:         Return unique permutations of an array
#  Notes:           We turn off 'recursion' warning as our permute
#                   function calls itself and 100 is no longer a big
#                   worry (but use your judgement) but we *do* exercise
#                   a sanity-check (see sub sanityCheck).
#
#====================================================================

#!/usr/bin/perl -w



use strict;
use warnings;
no warnings 'recursion';       #---turning off default 100-level recursion warning




my ( $arr, @arr, $lim1, $lim2, @permutations, $arrLen );
my ( $threshold, @mapidx, $cnt, $warnMsg, $dieMsg);
my ( @srcArray, $defUseAll, $useAll, $defRankByExt, $rankByExt, %permRank );


#---task-specific settings-------------------------------------------

$defUseAll    =  0;  #---use every term in each permutation?

$threshold = 5913;   #--->die after this many iterations (basic sanity check)
$lim1 = 5;           #--->return ranked permutations report only
$lim2 = 7;           #--->don't run (without iterator)
$cnt  = 0;

#--------------------------------------------------------------------


#==============================================================================
sub initArgs
{

   die "Received empty preference terms array - try again." if ( ! $ARGV[0] );

   @arr = split /\,/, $ARGV[0];
   $useAll     = defined($ARGV[1]) ? $ARGV[1] : $defUseAll;

   $dieMsg  = "That's too many!! Please narrow down your choice terms.\n";

}
#==============================================================================


#==============================================================================
sub sanityCheck
{

   #-----------------------------------------------------------------
   # As we're running a plain-vanilla recursion with no tail call
   # optimization in our permute function for the moment, we keep a 
   # close-check on the recursion depth for now to avoid a blow-up.
   # Future improvements could include:
   # a). Use tail call optimization
   # b). Turn our permute function into an iterator to avoid memory
   #     issues and introduce the option to simply list all permutations
   #     rather than actually check availability on these as well.
   #-----------------------------------------------------------------
   

   my ( $permNum, $incr );
   $permNum = 1;   
   $incr    = 1;

   $permNum *= $incr++ while $incr <= scalar(@arr);
   print "Preparing: ".$permNum." (all-terms) permutations..."."\n";

   die   $dieMsg  if scalar(@arr) > $lim2;

}
#==============================================================================


#==============================================================================
sub swapidx 
{
   my ( $idx_1, $idx_2 ) = @_;

   ($mapidx[$idx_1], $mapidx[$idx_2]) = ( $mapidx[$idx_2], $mapidx[$idx_1] );

}
#==============================================================================


#==============================================================================
sub permute 
{

   #-----------------------------------------------------------------
   # Beginning from the end of our input array, swap pairs of
   # elements until we have iterated through all indices
   #-----------------------------------------------------------------

   $cnt++;

   #---first commit form as-is:
   push @permutations, join("",@srcArray[@mapidx]);
   my ( $idx1, $idx2 ) = ($arrLen-1,$arrLen);

   while ( $idx1 >= 0 and $mapidx[$idx1] > $mapidx[$idx1+1] ){
      $idx1--;
      return(0) if ( $idx1 < 0 );
   }

   while ( $mapidx[$idx1] > $mapidx[$idx2] ) {
      $idx2--;
   }
   
   swapidx($idx2, $idx1++);

   $idx2 = $arrLen;
   while ( $idx2 > $idx1 ) {
      swapidx($idx2--,$idx1++)
   }

   die("Exiting after a lot of recursions ($cnt)...") if $cnt > $threshold;

   #---loop such that all cnt-1 to end pairings have reversed
   permute();
   
}
#==============================================================================


#==============================================================================
sub runPermute
{

   if ( ! $useAll ) {

      #---allow parsimonious permutations starting with most favored terms
      if ( scalar(@arr) > 1) {
         for (my $idx=0; $idx <= $#arr; $idx++){
            @srcArray = @arr[(0..$idx)];
            if ( scalar(@srcArray) == 1 ) {
               push @permutations, $srcArray[0]; 
               next;
            } else {
               $arrLen = $#srcArray;
               @mapidx = (0..$arrLen);
               permute()
            }
         }
      } else {
         push @permutations, $arr[0];
      }

   } else {

      @srcArray = @arr;
      $arrLen = $#srcArray;
      @mapidx = (0..$arrLen);
      permute();

   }

}
#==============================================================================


#==============================================================================
sub report
{

   foreach my $rung ( @permutations ) {
      print "$rung\n";
   }

}
#==============================================================================


exit(main());


#==============================================================================
sub main
{

   initArgs;
   sanityCheck;
   runPermute;
   report;

}
#==============================================================================

