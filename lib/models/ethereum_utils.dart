import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class EthereumUtils {
  late Web3Client web3client;
  late http.Client httpClient;
  final contractAddress = dotenv.env['CONTRACT_ADDRESS'];

  void initial() {
    httpClient = http.Client();
    String infuraApi =
        "https://goerli.infura.io/v3/a31be2a4b17648389fe4351c5448d0c9";
    web3client = Web3Client(infuraApi, httpClient);
  }

  Future getBalance() async {
    final contract = await getDeployedContract();
    final etherFunction = contract.function('getBalance');
    final result = await web3client
        .call(contract: contract, function: etherFunction, params: []);
    List<dynamic> res = result;
    return res[0];
  }

  Future<String> sendBalance(int amount) async {
    var bigAmount = BigInt.from(amount);
    EthPrivateKey privateKeyCred =
        EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final etherFunction = contract.function('sendBalance');
    final result = await web3client.sendTransaction(
        privateKeyCred,
        Transaction.callContract(
            contract: contract,
            function: etherFunction,
            parameters: [bigAmount],
            maxGas: 1000000),
        chainId: 5,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<String> withdrawBalance(int amount) async {
    var bigAmount = BigInt.from(amount);
    EthPrivateKey privateKeyCred =
        EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final etherFunction = contract.function('withDrawBalance');
    final result = await web3client.sendTransaction(
        privateKeyCred,
        Transaction.callContract(
            contract: contract,
            function: etherFunction,
            parameters: [bigAmount],
            maxGas: 1000000),
        chainId: 5,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<DeployedContract> getDeployedContract() async {
    String abiCode = await rootBundle.loadString("assets/abi.json");
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "BasicdApp"),
        EthereumAddress.fromHex(contractAddress!));
    return contract;
  }
}
