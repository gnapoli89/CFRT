#!/usr/bin/perl

# 
# @file
# Converter tool, from Apache Common Log file to CSV.
# 
# All code is released under the GNU General Public License.
# See COPYRIGHT.txt and LICENSE.txt.
#
if ("$ARGV[0]" =~ /^-h|--help$/) {
  print "Usage: $0 access_log_file > csv_output_file.csv\n";
  print "   Or, $0 < access_log_file > csv_output_file.csv\n";
  print "   Or, $0 < access_log_file > csv_output_file.csv 2> invalid_lines.txt\n";
  exit(0);
}

@alphabet = (('A'..'Z'), 0..9);
%collection;
$lenkey = 16; #lenght of RequestID
%MONTHS = ( 'Jan' => '01', 'Feb' => '02', 'Mar' => '03', 'Apr' => '04', 'May' => '05', 'Jun' => '06',
  'Jul' => '07', 'Aug' => '08', 'Sep' => '09', 'Oct' => '10', 'Nov' => '11', 'Dec' => '12' );

print STDOUT "\"Bucket Owner\",\"Bucket\",\"Time\",\"Remote IP\",\"Requester\",\"Request ID\",\"Operation\",\"Key\",\"Request URI\",\"HTTP Status\",\"Error Code\",\"Bytes Sent\",\"Object Size\",\"Total Time\",\"Processing Time\",\"Referer\",\"User Agent\",\"Version ID\"\n";
$line_no = 0;

while (<>) {
  ++$line_no;
  if (/^([\w\.:-]+)\s+([\w\.:-]+)\s+([\w\.-]+)\s+\[(\d+)\/(\w+)\/(\d+):(\d+):(\d+):(\d+)\s?([\w:\+-]+)]\s+"(\w+)\s+(\S+)\s+HTTP\/1\.\d"\s+(\d+)\s+([\d-]+)((\s+"([^"]+)"\s+")?([^"]+)")?\s(\d+)\s\?atk=(\d+)$/) {
    $host = $1;
    $other = $2;
    $logname = $3;
    $day = $4;
    $month = $MONTHS{$5};
    $year = $6;
    $hour = $7;
    $min = $8;
    $sec = $9;
    $tz = $10;
    $method = $11;
    $url = $12;  
    $code = $13;
    if ($14 eq '-') {
      $bytesd = 0;
    } else {
      $bytesd = $14;
    }
    $referer = $17;
    $ua = $18;
	$resptime = $19;
	$atkcode = $20;
	
	#print STDOUT "$resptime $atkcode";

    substr $url, 0, 1, ""; #remove initial "/" from url 
    
    # modified for fit the S3 logs - this controls filter all requests  
#    if(index($referer, ".php") == -1 && index($url, ".php") == -1 && index($ua,"bot")==-1){ #filter requests
	 #if(index($url, ".html") != -1 || index($url, ".css") != -1 || index($url,".js")!=-1){ #filter requests
    	#if($method eq "GET" || $method eq "HEAD"){							#filter the request type
		  	my $requestID = join '', map {$alphabet[rand(@alphabet)]} 1..$lenkey;
  			$collection{$requestID} ? redo : $collection{$requestID}++;
  			
  			#HTTP response checks
  			$error = "-";
  			if($code eq "304")	{ $turnAroundTime = "-"; } 
  			if($code eq "403")	{ $error = "AccessDenied"; }  
  			
			#if($code eq "500")	{ $error = "InternalError"; } 
			if($code eq "500" && $atkcode eq "1")	{ $error = "InternalError"; } 
			if($code eq "500" && $atkcode eq "0")	{ $error = "-"; $code = "200"; } 
			
			if($code eq "404")	{ $error = "NoSuchKey"; }
			if($code eq "503")	{ $error = "ServiceUnavailable"; }
  			
  			#increase dimension of image files
  			#if(index($url, ".jpg") != -1 && $bytesd != 0){
			#	$bytesd = $bytesd+1024**2;  				
  			#}
  						  			
  			#$processingTime = int(rand(140))+10;
  		
			$processingTime = $resptime;
  			$sign = int(rand(2))+1;
  			
  			$megaByte = $bytesd/(1024**2);
  			$meanTransferRate = 50; #MB/sec
  			$TransferRate = $meanTransferRate + (((-1)**$sign)*(int(rand(40))));
  			$netTime = ($megaByte/$TransferRate);
  			$netTime = $netTime*(10**3);
  			
  			$time =  int($processingTime + $netTime);
  			
			$keyRequest = $url;
			$uriRequest = "/".$keyRequest;
  			
			$paramIndex = index($url,"?");		
  			if($paramIndex != -1)
  			{
  				$keyRequest = substr($url,0,$paramIndex);
  				if($keyRequest eq "")
  				{
  					$keyRequest = "index.html";
  					$uriRequest = $keyRequest.$url;
  				}
  			}
  			if(substr($url,length($url)-1,1) eq "/")
  			{
	  			$keyRequest = $url."index.html";	
  			}
  			
  			
  			#write on CSV file
    		#print STDOUT "\"5927116389e7d406047097a41cba2ef5830ad74cdaf67351d74682eeaa07ea2b\",\"mybucketwebsite\",\"[$day/$month/$year:$hour:$min:$sec $tz]\",\"$host\",\"-\",\"$requestID\",\"WEBSITE.$method.OBJECT\",\"$url\",\"$method /$url\",\"$code\",\"$error\",\"$bytesd\",\"$bytesd\",\"$time\",\"$processingTime\",\"$referer\",\"$ua\",\"-\"\n";

    		#print as S3 log file
    		print STDOUT "5927116389e7d406047097a41cba2ef5830ad74cdaf67351d74682eeaa07ea2b mybucketwebsite [$day/$month/$year:$hour:$min:$sec $tz] $host - $requestID WEBSITE.$method.OBJECT $keyRequest \"$method $uriRequest HTTP/1.1\" $code $error $bytesd $bytesd $time $processingTime \"$referer\" \"$ua\" - \n";
    	#}
    #}
  } 
  else {
    print STDERR "Invalid Line at $line_no: $_";
  }
}

