# get windows AIO files into resources folder
#
# arguments (must be given)
#  [0] 0=full, 1=slim
#  [1] 0=amd, 2=arm

echo "getfiles $args = " + $args

# e.g. 9.6.0-beta1
$ver = Get-Content -Path "revision.txt" -Raw

# get major, minor, revision numbers:
$t = $ver.Split(".")
$maj = $t[0]
$min = $t[1]
$rev = $t[2].Split("-")[0].Trim()

$rnum = ($maj + "." + $min)
$rver = ($rnum + "." + $rev)
$rel = ("j" + $rnum)

$bin = "resources\x64\bin"
$obin = ("-o" + $bin)

if ($args[0] -eq 1) {
  $slim = "_slim"
}

if ($args[1] -eq 1) {
  $arm64 = "-arm64"
  $rwin = "warm64"
  $zip = "winarm64.zip"
}
else {
  $rwin = "win64"
  $zip = "win64.zip"
}

$jqt = "jqt-win" + $arm64 + $slim + ".zip"
$qtl = "qt68-win" + $arm64 + $slim + ".zip"

echo ("ver = " + $ver)
echo ("args = " + $args)
echo ("rnum = " + $rnum)
echo ("rver = " + $rver)
echo ("rwin = " + $rwin)
echo ("rel = " + $rel)
echo ("zip = " + $zip)

Copy-Item -Path aio\* -Destination . -Recurse

$ini = "install.nsi"
((Get-Content -path $ini -Raw) -replace 'VVV',$rwin) | Set-Content -path $ini
((Get-Content -path $ini -Raw) -replace 'XXX',$rnum) | Set-Content -path $ini
((Get-Content -path $ini -Raw) -replace 'YYY',$rver) | Set-Content -path $ini
((Get-Content -path $ini -Raw) -replace 'ZZZ',$slim) | Set-Content -path $ini

cat $ini

$pfn = "c:\program files (x86)\nsis\"
cp CPUFeatures.dll ($pfn + "plugins\x86-unicode")
cp CPUFeatures.nsh ($pfn + "include")

mkdir temp
mkdir resources\je

cd temp
$url = ("www.jsoftware.com/download/" + $rel)
mv ..\$zip .
#Invoke-WebRequest -UseBasicParsing ($url + "/install/" + $zip) -outfile $zip
Invoke-WebRequest -UseBasicParsing ($url + "/qtide/" + $jqt) -outfile $jqt
Invoke-WebRequest -UseBasicParsing ($url + "/qtlib/" + $qtl) -outfile $qtl
cd ..

# unzip
7z x ("temp\" + $zip)
move $rel\* resources\x64

function ferase ($a) { if (Test-Path "$a") { Remove-Item "$a" } }

7z x temp\$jqt $obin
ferase $obin\qt.exp
ferase $obin\qt.lib
7z x temp\$qtl $obin

cd resources\je
$url = ("www.jsoftware.com/download/jengine/" + $rel + "/windows/j64/")
Invoke-WebRequest -UseBasicParsing ($url + "javx2.dll") -outfile "javx2.dll"
cd ..\..

dir resources
dir resources\x64
dir resources\x64\bin
dir resources\je
