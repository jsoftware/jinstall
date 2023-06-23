# get info from version.txt for github actions

#wget https://github.com/jsoftware/dist/releases/download/build/revision.txt -OutFile revision.txt
#wget https://github.com/cdburke/jstest/releases/download/build/revision.txt  -OutFile revision.txt
#Invoke-WebRequest "https://www.jsoftware.com/download/jengine/revision.txt" -OutFile revision.txt

$rev = Get-Content -Path "revision.txt"

$t = $rev.Split(".")
$maj = $t[0]
$min = $t[1]
$num = ($maj + "." + $min)

$tgt = ("j" + $num + "_win64.exe")
$tgts = ("j" + $num + "_win64_slim.exe")

echo ("rev = " + $rev)
echo ("tgt = " + $tgt)
echo ("tgts = " + $tgts)

Set-Content -NoNewline -Path 'target.txt' -Value $tgt
Set-Content -NoNewline -Path 'targets.txt' -Value $tgts
