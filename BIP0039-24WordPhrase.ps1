## this is a 24 word random seed phrase generator in PowerShell
## from the method described here... https://developers.ledger.com/docs/embedded-app/psd-masterseed/
## the BIP39 word list can be found here... https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md
# $a is random 264bit string
# $x is $a cut into 24 11bit strings
# $y is $x in decimal to look up in BIP39 list 

$a=''
for($i=0; $i -lt 256; $i++){
	$a=$a+([Convert]::ToString((Get-Random -Maximum:2)))
}
$a=$a+($a.SubString(0,8))
$a

for($i=0; $i -lt 24; $i++){
	$x=$a.SubString(($i*11),11)
	$y=[Convert]::ToInt32($x,2)
	"{0,2} {1} {2}" -f ($i+1),$x,$y
}
