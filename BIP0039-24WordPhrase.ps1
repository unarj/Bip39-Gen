## this is a random mnemonic seed phrase generator for PowerShell

$entropyLen=256 #must be multiple of 32, 256 = 24 words
"  >> generating $entropyLen bits of randomness..."
$entropy=''
for($i=0; $i -lt $entropyLen; $i++){
	$entropy=$entropy+([Convert]::ToString((Get-Random -Maximum:2)))
}

"  >> calculating sha256 hash..."
$entropyBytes=$entropy -split '(.{8})' -ne '' |%{[Convert]::ToByte($_,2)}
$hash=(Get-FileHash -InputStream:([IO.MemoryStream]([byte[]]$entropyBytes)) -Algorithm:SHA256).Hash
$hashBinary=([Convert]::FromBase64String($hash) |%{[Convert]::ToString($_,2).PadLeft(8,'0')}) -join ''

$checksumLen=$entropyLen/32
"  >> adding $checksumLen checksum bits..."
$seed=$entropy+($hashBinary.SubString(0,$checksumLen))

"  >> converting to 11bit decimal, +1 for index offset..."
$i=1
$seed -split '(.{11})' -ne '' |%{
	"{0,2} {1} {2}" -f $i,$_,(([Convert]::ToInt32($_,2))+1)
	$i++
}
"  >> BIP39 word list https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md"
