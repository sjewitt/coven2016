####################################
#GENERIC FILE MANIPULATION FUNCTIONS
####################################

#get file contents. Accepts relative path/filename as a parameter.
#calls getRoot() to determine filesystem path:
sub getFile
{
  my $path            = $_[0];    #relative path to file
  my $root            = getRoot();
  my $fullpath        = $root . $path;
  logger("getFile(): $fullpath");
  my $filecontents    = "";

  #open F, "< $f" or die "Can't open $f : $!";
  open FILE, $fullpath || die logger("cannot open $fullpath : $!");
  while( <FILE> )  #this syntax gets the input line.
  {
    $filecontents .= $_ ;
  }
  close FILE;
  return $filecontents;
}

sub getPath
{
  my $page =$ENV{'SCRIPT_NAME'};
  my $returnval = "/";
  my @pathparts = split(/\//,$page);
  
  if(scalar(@pathparts) eq 3) #its a subfolder
  {
    $returnval = @pathparts[1];
  }
  logger("getPath: returning $returnval");
  return $returnval;
}

#determine the filesystem root:
sub getRoot
{
    return $ENV{'DOCUMENT_ROOT'};
}

#checks for existance of passed path/file.
#calls getRoot() to determine filesystem path:
sub fileExists
{

  my $path            = $_[0];    #relative path to file
  my $root            = getRoot();
  my $fullpath        = $root . $path;
  if(-e $fullpath)
  {
    logger("fileExists(): $fullpath - yes");
    return 1;
  }
  else
  {
    logger("fileExists(): $fullpath - yes");
    return 0;
  }
}

#file utility: Get file name without extension or path:
sub getPureFileName
{
  my $src = $_[0];
  my @path_no_extension = split(/\./,$src);
  my @path_sections = split(/\//,@path_no_extension[0]);
  
  #funky length syntax - a scalar cannot hold an array, so it determines length instead:
  $length = @path_sections;
  
  #now we want the last element of the array:
  logger("getPureFileName(): " . @path_sections[$length - 1]);
  return @path_sections[$length - 1];
}

#not quite same as above.
sub updateFile
{
  logger("updating file $file");
  
  my $root            = getRoot();
  my $file            = $_[0];
  my $filecontents    = $_[1];
  my $result          = "";
  logger("NEW XML:<xmp>$filecontents</xmp>");
  #$result = $root . $file;
  $result = "";
  $fullpath = $root . $file;
  #print $fullpath;
  if(-e $fullpath)
  {
    $result .= " Updating file " . $fullpath . "<br>";
    open UPDATEFILE, ">" . $fullpath;
    
    #set execute permissions as it's a .pl file...:
    chmod 0755, $fullpath;
    
    print UPDATEFILE $filecontents;
    close UPDATEFILE;
  }
  return $result;
}

sub logger
{
  my $logstring = $_[0];
  my $root      = getRoot();
  my $file      = "logfile.log";
  
  open (LOGFILE, ">>" .$root . $file || die "Cannot open logfile...");
  print LOGFILE $logstring . "\n";
  close LOGFILE;
  
}

########################################
#END GENERIC FILE MANIPULATION FUNCTIONS
########################################

######################################
#EDITING - PAGE CREATE FUNCTIONS######
######################################
#accepts a filename, a relative path, string file contents and an extension.
sub createFile
{
  my $root            = getRoot();
  my $filename        = $_[0];
  my $relativepath    = $_[1];
  my $filecontents    = $_[2];
  my $fileextension   = $_[3];
  my $result          = "";
  my $fullpath        = "";
  
  $result   = $root . $relativepath . "/" . $filename;
  $fullpath = $root . $relativepath . "/" . $filename;
  
  logger("createFile(): creating file $fullpath");
  
  if(!(-e $fullpath))
  {
    open NEWFILE, ">" . $fullpath;
    
    #set execute permissions as it's a .pl file...:
    chmod 0755, $fullpath;
    
    print NEWFILE $filecontents;
    close NEWFILE;
    $result = "File $fullpath successfully created.";
  }
  else
  {
    $result .= "File exists already. Cannot continue."
  }
  logger("createFile(): $result");
  return $result;
}
1;  #must always return 1.
