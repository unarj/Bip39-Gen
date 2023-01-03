## this is a 24 word random seed phrase generator in PowerShell
## from the method described on https://developers.ledger.com/docs/embedded-app/psd-masterseed/
# $a is random 256 bit string 
# $b is sha256 hash of $a
# $c is first 8 bits of $b
# $d is $a+$c (full dataset for the seed)
# $x is $a cut into 24*11 bit strings
# $y is $x in decimal for look up on https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md

$a=''
for($i=0; $i -lt 256; $i++){
	$a=$a+([Convert]::ToString((Get-Random -Maximum:2)))
}
# hashing not returning expected results, not being read as binary?
$b=(Get-FileHash -InputStream:([IO.MemoryStream]([byte[]]($a -split '(.{2})' -ne '')))).Hash
$c=([Convert]::ToString(('0x'+$b.SubString(0,2)),2)).PadLeft(8,'0')
$d=$a+$c

for($i=0; $i -lt 24; $i++){
	if($i -eq 0){ "in binary      decimal" }
	$x=$d.SubString(($i*11),11)
	$y=([Convert]::ToInt32($x,2))+1 #BIP39 index starts at 1
	"{0,2} {1} {2}" -f ($i+1),$x,$y
}
