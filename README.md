## this is a 24 word random seed phrase generator in PowerShell created to avoid using prebuilt phrases
## from the method described here... https://evgemedvedev.medium.com/custom-mnemonic-for-ledger-nano-s-a01f24a43b48
# $x is a decimal word index from... https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md
# $y is $x in binary
# $z is 3bit random salt
# $a is 264bit word used for checksum
# $b is the sha256 checksum of $a
# $c is the binary index of our 24th seed phrase word
# $d is the decimal index of $c (append to the 23 words in list $x)

$a=''
for($i=0;$i -lt 23;$i++){
	$x=Get-Random -Maximum:2049
	$y=([Convert]::ToString($x,2)).PadLeft(11,'0')
	"{0,-3}{1,-6}{2}" -f ($i+1),$x,$y
	$a=$a+$y
}

$z=''
for($i=0;$i -lt 3;$i++){
	$z=$z+[convert]::ToString((Get-Random -Maximum:2))
}
$a=$a+$z

$b=(Get-FileHash -InputStream:([IO.MemoryStream]::new([char[]]$a)) -Algorithm:sha256).Hash

$c=$z+([Convert]::ToString([Convert]::ToInt32('0x'+$b.Substring(0,2),16),2).PadLeft(8,'0'))
$d=[Convert]::ToInt32($c,2)
"{0,-3}{1,-6}{2}" -f '24',$d,$c
