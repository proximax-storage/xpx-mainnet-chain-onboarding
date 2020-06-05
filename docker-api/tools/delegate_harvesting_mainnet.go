package main

import (
    "errors"
	"context"
	// "golang.org/x/crypto/ssh/terminal"
	"fmt"
	"os"
	"time"
	"github.com/manifoldco/promptui"
	crypto "github.com/proximax-storage/go-xpx-crypto"
	"github.com/proximax-storage/go-xpx-chain-sdk/sdk"
)

const (
    // Sirius-chain-api-rest server.
    baseUrl = "http://canismajor.xpxsirius.io:3000"
)

func main() {
	
	fmt.Print("Enter your account private key: ")
	accountPrivateKey := promptPrivateKey()

	conf, err := sdk.NewConfig(context.Background(), []string{baseUrl})
    if err != nil {
        fmt.Printf("NewConfig returned error: %s", err)
        return
    }

    // Use the default http client
    client := sdk.NewClient(nil, conf)

	account, err := client.NewAccountFromPrivateKey(string(accountPrivateKey))
    if err != nil {
        fmt.Printf("NewAccountFromPrivateKey returned error: %s", err)
        return
	}

	remoteAccountKeyPair,_ := crypto.NewRandomKeyPair()
	var remoteAccountPublicKey string = remoteAccountKeyPair.PublicKey.String()
	remoteAccount, err := client.NewAccountFromPublicKey(remoteAccountPublicKey)
    if err != nil {
        fmt.Printf("NewAccountFromPublicKey returned error: %s", err)
        return
    }
	
	fmt.Printf("Your PublicKey:\t%x\n", account.KeyPair.PublicKey.Raw)

	fmt.Println("Proceed with Delegated Harvesting?")
	if !yesNo() {
		os.Exit(0)
	}

    // Create a address alias transaction
    transaction, err := client.NewAccountLinkTransaction(
        // The maximum amount of time to include the transaction in the blockchain.
        sdk.NewDeadline(time.Hour),
        // The remote account to which signer wants to delegate importance.
        remoteAccount,
        // The type of action ( in this case we want to link entities ).
        sdk.AccountLink,
	)
	
    if err != nil {
        fmt.Printf("NewAccountLinkTransaction returned error: %s", err)
        return
    }

    // Sign transaction
    signedTransaction, err := account.Sign(transaction)
    if err != nil {
        fmt.Printf("Sign returned error: %s", err)
        return
	}

	// Announce transaction
	restTx, err := client.Transaction.Announce(context.Background(), signedTransaction)
    if err != nil {
        fmt.Printf("Transaction.Announce returned error: %s", err)
        return
    }
	
	fmt.Printf("%s\n", restTx)
	fmt.Printf("Transaction Hash: \t%v\n", signedTransaction.Hash)
	fmt.Printf("Signer: \t\t%X\n\n", account.PublicAccount.PublicKey)

	fmt.Println("Please add the delegated remote account private key in config-harvesting.properties")
	fmt.Printf("Private Key:\t%x\n\n",remoteAccountKeyPair.PrivateKey.Raw)
	
}

func yesNo() bool {
    prompt := promptui.Select{
        Label: "[Yes/No]",
        Items: []string{"Yes", "No"},
    }
    _, result, err := prompt.Run()
    if err != nil {
        fmt.Println("Prompt failed %v\n", err)
    }
    return result == "Yes"
}

func promptPrivateKey() string {

    validate := func(input string) error {
		if len(input) != 64 {
			return errors.New("Key must be 64 characters")
		}
		return nil
    }
    
    prompt := promptui.Prompt{
        Label: "Private Key",
        Validate: validate,
        Mask: '*',
    }
    result, err := prompt.Run()
    if err != nil {
		fmt.Printf("Prompt failed %v\n", err)
    }
    return result
}
