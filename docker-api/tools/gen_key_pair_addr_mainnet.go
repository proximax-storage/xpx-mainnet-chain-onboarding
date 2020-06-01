package main

import (
    "fmt"
    crypto "github.com/proximax-storage/go-xpx-crypto"
    "github.com/proximax-storage/go-xpx-chain-sdk/sdk"
)

func main() {
    KeyPair, _ := crypto.NewRandomKeyPair()
    
    fmt.Printf("PublicKey:\t%x\n",KeyPair.PublicKey.Raw)
    fmt.Printf("PrivateKey:\t%x\n",KeyPair.PrivateKey.Raw)
    
    Address, _ := sdk.NewAddressFromPublicKey(KeyPair.PublicKey.String(), sdk.Public)
    fmt.Printf("Address:\t%v\n",Address.Address)

}
