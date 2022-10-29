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

# Backend smart contract

- [flutterdapp/contracts](https://github.com/degagawolde/Refund-by-Location-Smart-Contract/flutterdapp/contracts)

# Build

# Test 

# Deploy