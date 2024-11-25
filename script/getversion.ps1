# get info from version.txt for github actions
#
# where is this used?

$rev = Get-Content -Path "revision.txt"

$t = $rev.Split(".")
$maj = $t[0]
$min = $t[1]
$num = ($maj + "." + $min)

$tgt = ("j" + $num + "_win64.exe")
$tgts = ("j" + $num + "_win64_slim.exe")
$tgtas = ("j" + $num + "_win64_arm64_slim.exe")

echo ("rev = " + $rev)
echo ("tgt = " + $tgt)
echo ("tgts = " + $tgts)
echo ("tgtas = " + $tgtas)

Set-Content -NoNewline -Path 'target.txt' -Value $tgt
Set-Content -NoNewline -Path 'targets.txt' -Value $tgts
Set-Content -NoNewline -Path 'targetas.txt' -Value $tgtas
