##############################################################
#### UTIL METHOD - 
#### get value of passed request parameter:
####
#### INPUT:         string url parameter to check.
#### OUTPUT:        string the parameter value.
#### DEPENDANCIES:  none.
#### (TODO: cope with value arrays)
##############################################################

sub getRequest
{
  my $param = $_[0];
  if ($ENV{'REQUEST_METHOD'} eq "GET")
  {
    my $request = $ENV{'QUERY_STRING'};
    my $query_length = length($request);
    my @pairs;
    my $name;
    my $value;
    if($query_length > 0)
    {
      #get query values:
      @pairs = split(/&/,$request);
      foreach(@pairs)
      {
        #we need just the param, so check for this:
        #unencode url parameters:
        s/\+/ /g;
        s/%([0-9A-F][0-9][A-F])/pack("c",hex($1))/ge;
        
        ($name, $value) = split(/=/);
        if($name eq $param)
        {
          return $value;
        }
      }
    }
  } 
}

1;  #must always return 1.
