import React, { Component } from "react";
// import SimpleStorageContract from "./contracts/SimpleStorage.json";
import getWeb3 from "./utils/getWeb3";
import PollingAdminContract from "./contracts/PollingAdmin.json";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = PollingAdminContract.networks[networkId];
      const instance = new web3.eth.Contract(
        PollingAdminContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, contract } = this.state;
    // Stores a given value, 5 by default.
    await contract.methods.createPoll(100,"Student-Union").send({from: accounts[0]},(error,response) =>{
      if(!error){
        console.log(response);
      }
      else  
        console.log("Error Occured");
    });
    // await contract.methods.addpost(100,"President").send({from :accounts[0]});
    
    // await contract.methods.addvoter(5).send({from :accounts[0]},(error, response) =>{
    //   if(!error){
    //       console.log(response);
    //       // key=String(response);
    //   }
    // });
    // await contract.methods.getvoterkey(5).call((error,resonse) =>{
    //   console.log(resonse);
    // });
    // await contract.methods.addCandidate(38,"Abhsihek Rustagi",100,"President","Lapis -43").send({from:accounts[0]},(error, response) =>{
    //   console.log(response);
    // });
    // const key = "0x036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0";
    // await contract.methods.Vote(5,38,key).send({from:accounts[0]},(error,response)=>{
    //   if(!error)
    //     console.log(response);
    // });

    // await contract.methods.getCandidates(100).call((error,response)=>{
    //   if(!error){
    //     console.log(response);
    //     // console.log(response['0']['candidate'] + " -> "+ response['0']['votes']);
    //   }
    // });
    // Get the value from the contract to prove it worked.
    // const vote_given = await contract.methods.getPosts(100).call();
    
    
    await contract.methods.calculateResult(100,"President").send({from:accounts[0]})
    await contract.methods.getResult().call((error,response)=>{
      if(!error){
        console.log(response);
        // console.log(response['0']['candidate'] + " -> "+ response['0']['votes']);
      }
    });
    
    // this.setState({ storageValue: response });
  };
  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    // console.log(this.state.storageValue);
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 40</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.storageValue}</div>
      </div>
    );
  }
}

export default App;
