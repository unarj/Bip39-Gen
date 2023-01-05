## THIS IS CURRENTLY NOT WORKING WITH LEDGER S PLUS DEVICE, ASSUMING THE SHA256 HASH IS CALCULATED DIFFERENTLY 

$entropyLen=256 #must be multiple of 32

# above may need to change for your use-case, below should not

$checksumLen=$entropyLen/32
">> this is a random mnemonic seed phrase generator and is configured for a {0}b seed ({1} words)..." -f ($entropyLen+$checksumLen),(($entropyLen+$checksumLen)/11)

">> generating $entropyLen bits of randomness..."
$entropy=''
for($i=0; $i -lt $entropyLen; $i++){
	$entropy=$entropy+([Convert]::ToString((Get-Random -Maximum:2)))
}

">> calculating sha256 hash..."
$entropyBytes=$entropy -split '(.{8})' -ne '' |%{[Convert]::ToByte($_,2)}
$hash=([Security.Cryptography.HashAlgorithm]::Create('sha256')).ComputeHash($entropyBytes)
$hashBinary=($hash |%{[Convert]::ToString($_,2).PadLeft(8,'0')}) -join ''

">> adding $checksumLen checksum bits..."
$seed=$entropy+($hashBinary.SubString(0,$checksumLen))

">> converting to 11b decimal, +1 for index offset..."
$i=1
$seed -split '(.{11})' -ne '' |%{
	"{0,3} {1} {2}" -f $i,$_,(([Convert]::ToInt32($_,2))+1)
	$i++
}
">> BIP39 word list https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md"
