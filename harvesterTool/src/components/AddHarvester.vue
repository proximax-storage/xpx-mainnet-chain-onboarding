<template>
<div class="body">
  <section class="container">
    <h1>AddHarvester Page</h1>
    <div class="columns">
        <div class="column">
            <div>
                <label class="label">Harvester Public Key</label>
                <input type="text" v-model="inputPublic"/>
            </div>
            <div >
                <label class="label">Signature Private Key</label>
                <input type="text" v-model="inputPrivate"/>
            </div>
            <div class="sign">
                <button @click=createHarvester(inputPublic,inputPrivate)>Sign</button>
            </div>
        </div>
    </div>
<!--https://api-2.testnet2.xpxsirius.io/transactionStatus-->
</section>
</div>
</template>

<script lang="ts">
import { defineComponent} from 'vue';
import {NetworkType, TransactionHttp,HarvesterTransaction,Deadline, Account, PublicAccount} from 'tsjs-xpx-chain-sdk';
export default defineComponent({
    data(){
        return{
            inputPublic:'',
            inputPrivate:'',
        }
    },
  setup(){

    function createHarvester(publicKey:string, privateKey:string){
        
    const sender = Account.createFromPrivateKey(
    privateKey, NetworkType.TEST_NET);

    const recipient = PublicAccount.createFromPublicKey(
    publicKey, NetworkType.TEST_NET);


    const tx = HarvesterTransaction.createAdd(
    Deadline.create(),
    recipient,
    NetworkType.TEST_NET
);

    const generationHash= "56D112C98F7A7E34D1AEDC4BD01BC06CA2276DD546A93E36690B785E82439CA9";
    const signedTransaction = sender.sign(tx, generationHash);

    console.log(signedTransaction)

    const url = 'https://api-2.testnet2.xpxsirius.io';
    const transactionHttp = new TransactionHttp(url);

    transactionHttp
        .announce(signedTransaction)
        .subscribe(x => console.log(x), err => console.error(err));
    }; 
    return{
        createHarvester
    }
    }
    });
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.body {
  margin: 0;
  width: 75w;
  height: 75vh;
  display: flex;
  align-items: center;
  text-align: center;
  justify-content: center;
  place-items: center;
  overflow: hidden;
}
.container {
  text-align: center;
  width: 350px;
  height: 500px;
  border-radius: 20px;
  padding: 40px;
  box-sizing: border-box;
  background: #ecf0f3;
  box-shadow: 14px 14px 20px #cbced1, -14px -14px 20px white;
}
.input{
    margin-left:10px;
}
.columns,h1{
    text-align: center;
}
.sign{
    margin:10px
}
.button{
    margin-left:5px;
}

.inv{ 
    display: none; 
}
</style>
