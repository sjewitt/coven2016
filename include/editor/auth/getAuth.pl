##############################################################
#### AUTH METHOD - 
#### checks for an auth cookie. Used to check that a user has
#### previously authenticated.
####
#### INPUT:         none.
#### OUTPUT:        boolean authenticated
####                found.
#### DEPENDANCIES:  none.
##############################################################

sub getAuth
{
  #check for cookie:
  my $cookiestring = $ENV{'HTTP_COOKIE'};    #get all the cookies
  my @cookies = split(/;/, $cookiestring);   #get an array of cookies
  my $cookie;
  my $auth = false;
  
  #iterate over cookies:
  foreach $cookie (@cookies)
  {
    if ($cookie eq "authorised=yes")
    {
      $auth = true;
    }
  }
  return $auth;
}

1;  #must always return 1.
