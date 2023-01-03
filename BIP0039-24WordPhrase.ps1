## this is a 24 word random seed phrase generator in PowerShell
## from the method described on https://developers.ledger.com/docs/embedded-app/psd-masterseed/
# $a is random 256 + 8 bit string 
# $x is $a cut into 24*11 bit strings
# $y is $x in decimal for look up on https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md

$a=''
for($i=0; $i -lt 256; $i++){
	$a=$a+([Convert]::ToString((Get-Random -Maximum:2)))
}
$a=$a+($a.SubString(0,8))
$a

for($i=0; $i -lt 24; $i++){
	$x=$a.SubString(($i*11),11)
	$y=([Convert]::ToInt32($x,2))+1 #BIP39 index starts at 1
	"{0,2} {1} {2}" -f ($i+1),$x,$y
}
