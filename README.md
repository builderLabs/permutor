## Homegrown Perl-based Permutor


This script forms the core of a personal project of mine in which I needed  
to generate all possible permutations of a select list of terms.  

I didn't need or want anything fancy (there are all sorts of [modules](http://search.cpan.org/search?query=permute&mode=all) to do  
this in a more professional way) but was looking for more of a  
'back-of-the-envelope' solution and decided to take a stab it.  So here  
it is, my homegrown solution.  

I figured I'd share this in the event that others might also find it useful and  
appreciate its simplicity.


### Important

I use recursive calls in this script.  The original purpose of this script  
was to generate a relatively limited set of permuted terms but more than  
otherwise permitted by Perl's default recursive call warnings.  

**As a result, Perl's recursion call warning is turned-off** and I exercise  
a hard-coded limit to exit the script if too many terms are supplied, since  
generated permutations follow a factorial of the number of terms supplied.  
Thus, you should take care to *exercise caution when changing any recursion  
ceiling limits.*  

Possible improvements for the future (so long as these don't amount to  
re-inventing the wheel) could be:

1). Consider using an iterator to work around memory issues  
2). Definitely use a sanity check to avoid blow-ups (especially when turning  
&nbsp;&emsp;Perl's recursion level warnings off, as in this example).  

**Sample Usage:**

Call the function with a comma-separated array of terms like so:  

`perl -w permute.pl \Moe,Curly,Larry`  

Returns:  
```
Preparing: 6 (all-terms) permutations...
Moe
MoeCurly
CurlyMoe
MoeCurlyLarry
MoeLarryCurly
CurlyMoeLarry
CurlyLarryMoe
LarryMoeCurly
LarryCurlyMoe
```  

