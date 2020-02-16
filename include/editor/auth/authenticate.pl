##############################################################
#### AUTH METHOD - 
#### check for an authorised login attempt:
####
#### INPUT:         string username, string password.
#### OUTPUT:        boolean authenticated.
#### DEPENDANCIES:  configured array of users, @USERS.
##############################################################

sub authenticate
{
  my $user      = $_[0];
  my $password  = $_[1];
  my $result    = false;
  
  for(my $a = 0; $a < scalar(@USERS); $a++)
  {
    if(($user eq $USERS[$a]{'user'}) && ($password eq $USERS[$a]{'password'}))
    {
      $result = true;
    }
  }
  return $result;
}

1;  #must always return 1.
