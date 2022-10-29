import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import "package:flutter/widgets.dart";
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class childModel extends ChangeNotifier {
  final String _rpcURl = "http://192.168.1.5:7545";
  final String _wsURl = "ws://192.168.1.5:7545/";
  final String _privateKey =
      "08f0242a6ffa48ca38a3e906f53ef42656d36e168ec88a8ddf030d808a0bc9cc";
  bool isLoading = true;
  // late Client _httpClient;
  late EthereumAddress _contractAddress;
  late String _abiCode;
  late Web3Client _client;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;
  late String x;
  late String y;
  late String latitude;
  late String longitude;
  late ContractFunction _updateCompCountStatus;
  childModel() {
    initiateSetup();
  }
  Future<void> initiateSetup() async {
    // _httpClient = Client();
    // _client = Web3Client(
    //     "https://rinkeby.infura.io/v3/84ee596119e643cdb6e534c7c3674cfa",
    //     _httpClient);
    _client = Web3Client(_rpcURl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsURl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // _abi = await rootBundle.loadString("../assets/.json");
    // _contractAddress = "0x4943030bce7e49dd13b4dd120c0fef7dde3c18a0";

    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/RefundContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    // _credentials = EthPrivateKey.fromHex(
    //     "d585835f87981557df21fbaf99df4c9d06fd374b6efd121c027e0655cee5b627");
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    // _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Project"),
    // EthereumAddress.fromHex(_contractAddress));
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "RefundContract"), _contractAddress);
    // Extracting the functions, declared in contract.

    _updateCompCountStatus = _contract.function('updateCompCountStatus');
  }

  updateCompCountStatus(String latitude, String longitude) async {
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _updateCompCountStatus,
            parameters: [
              BigInt.from(int.parse(latitude)),
              BigInt.from(int.parse(longitude))
            ]));
    print('set employee executed');
    isLoading = false;
    notifyListeners();
  }
}
  // getCoordinates() async {
  //   List readCoordinates = await _client
  //       .call(contract: _contract, function: _readCoordinates, params: []);
  //   x = readCoordinates[0];
  //   y = readCoordinates[1];

  // addCoordinates(String lat, String lon) async {
  //   latitude = EncryptionDecryption.encryptAES(lat);
  //   longitude = EncryptionDecryption.encryptAES(lon);
  //   await _client.sendTransaction(
  //     _credentials,
  //     Transaction.callContract(
  //       contract: _contract,
  //       function: _sendCoordinates,
  //       parameters: [latitude, longitude],
  //       maxGas: 100000,
  //     ),
  //     chainId: 4,
  //   );

  //   getCoordinates();
  //   isLoading = false;
  //   notifyListeners();
  // }

