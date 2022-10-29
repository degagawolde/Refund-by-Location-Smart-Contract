# Refund-by-Location-Smart-Contract
The refund by location smart contract is aimed to be used when one party, for example an employer, agrees to pay another party, for example an employee, for being present in a certain geographic area for a certain duration.

# Objecetive 

The employee’s phone sends its GPS location to a smart contract at a certain interval. Based on the pre-agreed contract codified in an Ethereum smart contract, a cryptocurrency payment is executed when all the agreed conditions are met.  If, at any point, the GPS sensor indicates that an employee is outside the range of the agreed GPS area, the contract state will be updated to indicate that it is out of compliance. By the end of this project, you should produce an Ethereum based dApp that has both the smart contract tested and deployed in a testnet and a front end that will allow monitoring of the status.

# Flutter Frontend mobile dApp 

- [flutterdapp](https://github.com/degagawolde/Refund-by-Location-Smart-Contract/flutterdapp/)
- The packages http, we3dart, web_socket_channel facilitate the linking between the frontend and the smart contract

Create an endpoints for the smart contract deployed on [Ganache](https://trufflesuite.com/ganache/) local network.
```
final String _rpcURl = "http://192.168.1.5:7545";
final String _wsURl = "ws://192.168.1.5:7545/";

_client = Web3Client(_rpcURl, Client(), socketConnector: () {return IOWebSocketChannel.connect(_wsURl).cast<String>();});

String abiStringFile = await rootBundle.loadString("src/artifacts/RefundContract.json");
var jsonAbi = jsonDecode(abiStringFile);
_abiCode = jsonEncode(jsonAbi["abi"]);

_contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
_credentials = EthPrivateKey.fromHex(_privateKey);

_contract = await DeployedContract(ContractAbi.fromJson(_abiCode, "RefundContract"), _contractAddress);
// Extracting the functions, declared in contract.
_getEmployees = _contract.function("getEmployees");
_setEmployee = _contract.function("setEmployeeAccount");
_empContractStatus = _contract.function("empContractStatus");
```


```
cd flutterapp
```
Install dependencies
```
flutter pub add web3dart
flutter pub add http
flutter pub add web_socket_channel
```

Run the app
```
flutter run --no-sound-null-safety
```

# Backend smart contract

- [flutterdapp/contracts](https://github.com/degagawolde/Refund-by-Location-Smart-Contract/flutterdapp/contracts) - the smart contract written in [solidity](https://docs.soliditylang.org/en/v0.8.17/)
- The smart contract is devloped on [truffle](https://trufflesuite.com/docs/truffle/) which is a world class development environment, testing framework and asset pipeline for blockchains using the Ethereum Virtual Machine (EVM), aiming to make life as a developer easier.
```
module.exports = {
    development: {
     host: "192.168.1.5",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },

contracts_build_directory: "./src/artifacts/",
```

# Build
- By running the truffle migrate, the smart contract artifact will be saved in './src/artifacts/' directory.

# Test 
- [flutterdapp/test/RefundContract.js](https://github.com/degagawolde/Refund-by-Location-Smart-Contract/blob/main/flutterdapp/test/RefundContract.js)

# Deploy
- The smart contract is deployed on [Ganache](https://trufflesuite.com/ganache/) 
- [Ganache](https://trufflesuite.com/ganache/)  is a personal blockchain for rapid Ethereum dApp