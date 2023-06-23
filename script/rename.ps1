# rename exe builds

$nms =(ls *.exe).Name

foreach ($n in $nms)
{
 if ( $n[0] -eq "j" )
  {
   $p=$n.Substring($n.IndexOf("win"))
   Rename-Item -Path $n -NewName $p
  }
}



