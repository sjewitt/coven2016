##############################################################
#### UTIL METHOD - 
#### get value of passed cookie name:
####
#### INPUT:         string cookiename.
#### OUTPUT:        string cookievalue, or false if name not
####                found.
#### DEPENDANCIES:  none.
##############################################################

sub getCookie
{
  my $cookie_name   = $_[0];
  my $cookiestring  = $ENV{'HTTP_COOKIE'};          #get all the cookies
  my @cookies       = split(/;/, $cookiestring);    #get an array of cookies
  my $result        = false;
  foreach $cookie (@cookies)
  {
    if (index($cookie,$cookie_name . "=") >= 0)
    {
      $result = substr($cookie,index($cookie,"=")+1,length($cookie));
    }
  }
  return($result);
}

1;  #must always return 1.
