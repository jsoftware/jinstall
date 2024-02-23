# get info from version.txt for github actions

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
