// import 'dart:math' show log;

import 'package:flutter/foundation.dart' show Uint8List, debugPrint;
import 'package:solana/dto.dart' show ProgramAccount;
import 'package:solana/solana.dart'
    show
        Commitment,
        Ed25519HDKeyPair,
        Ed25519HDPublicKey,
        Mint,
        SolanaClient,
        SolanaClientAssociatedTokenAccontProgram,
        SolanaClientTokenProgram,
        lamportsPerSol;
// import 'package:solana_web3/programs.dart' show TokenProgram;
import 'package:solana_web3/solana_web3.dart'
    show
        BlockhashWithExpiryBlockHeight,
        Cluster,
        Connection,
        Keypair,
        Pubkey,
        TokenAmount,
        Transaction;
import 'package:solana_web3/solana_web3.dart' as web3 show Commitment;

class SolanaService {
  static Future<void> fullRun(List<String> info) async {
    try {
      final Connection solanaConnection = Connection(
        Cluster(Uri.parse('https://api.mainnet-beta.solana.com')),
        websocketCluster:
            Cluster(Uri.parse('wss://api.mainnet-beta.solana.com')),
        commitment: web3.Commitment.confirmed,
      );
      final SolanaClient solanaClient = SolanaClient(
        rpcUrl: Uri.parse('https://api.mainnet-beta.solana.com'),
        websocketUrl: Uri.parse('wss://api.mainnet-beta.solana.com'),
        timeout: const Duration(seconds: 90),
      );
      debugPrint("<<<<<<< Start InterSOL >>>>>>>");
      info.add("<<<<<<< Start InterSOL >>>>>>>");
      debugPrint("Lamport per SOL: $lamportsPerSol\n");
      info.add("Lamport per SOL: $lamportsPerSol\n");
      final Ed25519HDKeyPair payer = await Ed25519HDKeyPair.fromMnemonic(
        'MNEMONIC_PHRASE',
        account: 0,
        change: 0,
      );
      // final Ed25519HDKeyPair payee = await Ed25519HDKeyPair.fromMnemonic(
      //     'sword ceiling oppose camp proud danger rib rail there bean sample unit');
      debugPrint("Payer Account: ${payer.publicKey}");
      info.add("Payer Account: ${payer.publicKey}");
      // debugPrint("Payee Account: ${payee.publicKey}");
      // info.add("Payee Account: ${payee.publicKey}");
      debugPrint("Loading Wallet Successfully.\n");
      info.add("Loading Wallet Successfully.\n");
      final int payerBalance = await solanaConnection
          .getBalance(Pubkey.fromBase58(payer.publicKey.toBase58()));
      // final int payeeBalance = await solanaConnection
      //     .getBalance(Pubkey.fromBase58(payee.publicKey.toBase58()));
      debugPrint("Payer Balance: $payerBalance");
      info.add("Payer Balance: $payerBalance");
      // debugPrint("Payee Balance: $payeeBalance\n");
      // info.add("Payee Balance: $payeeBalance\n");
      debugPrint("Initialize Token...");
      info.add("Initialize Token...");
      final Mint token = await solanaClient.getMint(
        address: Ed25519HDPublicKey.fromBase58(
          '6nmsoBwQGHKgx33qfwanC84g49QKmygmHHuexZHcsiN2',
        ),
        commitment: Commitment.confirmed,
      );
      debugPrint("Done Init Token: ${token.address.toBase58()}\n");
      info.add("Done Init Token: ${token.address.toBase58()}\n");
      debugPrint("Getting or Creating Payer Account to Hold Token...");
      info.add("Getting or Creating Payer Account to Hold Token...");
      final ProgramAccount payerProgramAccount =
          await solanaClient.getAssociatedTokenAccount(
                owner: payer.publicKey,
                mint: token.address,
                commitment: Commitment.confirmed,
              ) ??
              await solanaClient.createAssociatedTokenAccount(
                owner: payer.publicKey,
                mint: token.address,
                funder: payer,
                commitment: Commitment.confirmed,
              );
      debugPrint("Payer ATA Account: ${payerProgramAccount.pubkey}");
      info.add("Payer ATA Account: ${payerProgramAccount.pubkey}");
      debugPrint("Getting or Creating Payee Account to Hold Token...");
      info.add("Getting or Creating Payee Account to Hold Token...");
      // final ProgramAccount payeeProgramAccount =
      //     await solanaClient.getAssociatedTokenAccount(
      //           owner: payee.publicKey,
      //           mint: token.address,
      //           commitment: Commitment.confirmed,
      //         ) ??
      //         await solanaClient.createAssociatedTokenAccount(
      //           owner: payee.publicKey,
      //           mint: token.address,
      //           funder: payer,
      //           commitment: Commitment.confirmed,
      //         );
      // debugPrint("Payee ATA Account: ${payeeProgramAccount.pubkey}");
      // info.add("Payee ATA Account: ${payeeProgramAccount.pubkey}");
      debugPrint("Done Getting or Creating Accounts.\n");
      info.add("Done Getting or Creating Accounts.\n");
      final TokenAmount tokenSupply = await solanaConnection
          .getTokenSupply(Pubkey.fromBase58(token.address.toBase58()));
      debugPrint("Total Supply of Token: ${tokenSupply.amount}\n");
      info.add("Total Supply of Token: ${tokenSupply.amount}\n");
      // const int mintAmount = 0 * lamportsPerSol;
      // const int transferAmount = 0 * lamportsPerSol;
      // const int burnAmount = 0 * lamportsPerSol;

      // debugPrint(
      //     "Minting ${mintAmount ~/ lamportsPerSol} TAG to Payer Account...");
      // info.add(
      //     "Minting ${mintAmount ~/ lamportsPerSol} TAG to Payer Account...");
      // final mintInstruction = TokenProgram.mintToChecked(
      //   mint: Pubkey.fromBase58(token.address.toBase58()),
      //   account: Pubkey.fromBase58(payerProgramAccount.pubkey),
      //   mintAuthority: Pubkey.fromBase58(payer.publicKey.toBase58()),
      //   amount: BigInt.from(mintAmount),
      //   decimals: (log(lamportsPerSol) / log(10)).round(),
      // );

      // debugPrint(
      //     "Transferring ${transferAmount ~/ lamportsPerSol} Riel to Payee Account...");
      // info.add(
      //     "Transferring ${transferAmount ~/ lamportsPerSol} Riel to Payee Account...");
      // final transferInstruction = TokenProgram.transferChecked(
      //   mint: Pubkey.fromBase58(token.address.toBase58()),
      //   decimals: (log(lamportsPerSol) / log(10)).round(),
      //   source: Pubkey.fromBase58(payerProgramAccount.pubkey),
      //   destination: Pubkey.fromBase58(payeeProgramAccount.pubkey),
      //   owner: Pubkey.fromBase58(payer.publicKey.toBase58()),
      //   amount: BigInt.from(transferAmount),
      //   signers: [Pubkey.fromBase58(payer.publicKey.toBase58())],
      // );

      // debugPrint(
      //     "Burning ${burnAmount ~/ lamportsPerSol} Riel to Payer Account...");
      // info.add(
      //     "Burning ${burnAmount ~/ lamportsPerSol} Riel to Payer Account...");
      // final burnInstruction = TokenProgram.burnChecked(
      //   account: Pubkey.fromBase58(payerProgramAccount.pubkey),
      //   mint: Pubkey.fromBase58(token.address.toBase58()),
      //   authority: Pubkey.fromBase58(payer.publicKey.toBase58()),
      //   amount: BigInt.from(burnAmount),
      //   decimals: (log(lamportsPerSol) / log(10)).round(),
      // );

      final BlockhashWithExpiryBlockHeight recentBlockhash =
          await solanaConnection.getLatestBlockhash();
      final Uint8List seed = Uint8List.fromList((await payer.extract()).bytes);
      final Transaction transaction = Transaction.v0(
        payer: Pubkey.fromBase58(payer.publicKey.toBase58()),
        instructions: [
          // mintInstruction,
          // transferInstruction,
          // burnInstruction,
        ],
        recentBlockhash: recentBlockhash.blockhash,
      )..sign([Keypair.fromSeedSync(seed)]);
      final startTime = DateTime.now();
      await solanaConnection
          .sendAndConfirmTransaction(transaction)
          .then((signature) {
        debugPrint(
            "Signature: https://solscan.io/tx/$signature?cluster=mainnet-beta");
        info.add(
            "Signature: https://solscan.io/tx/$signature?cluster=mainnet-beta");
        debugPrint(
            "Processing Time: ${DateTime.now().difference(startTime).inMilliseconds} milliseconds.");
        info.add(
            "Processing Time: ${DateTime.now().difference(startTime).inMilliseconds} milliseconds.");
      });
      debugPrint("Done Transferring Money to Payee Account.\n");
      info.add("Done Transferring Money to Payee Account.\n");
      debugPrint("Getting Token Account Balances...");
      info.add("Getting Token Account Balances...");
      final TokenAmount payerTokenBalance =
          await solanaConnection.getTokenAccountBalance(
              Pubkey.fromBase58(payerProgramAccount.pubkey));
      // final TokenAmount payeeTokenBalance =
      //     await solanaConnection.getTokenAccountBalance(
      //         Pubkey.fromBase58(payeeProgramAccount.pubkey));
      debugPrint("Payer Token Balance: ${payerTokenBalance.amount}");
      info.add("Payer Token Balance: ${payerTokenBalance.amount}");
      // debugPrint("Payee Token Balance: ${payeeTokenBalance.amount}");
      // info.add("Payee Token Balance: ${payeeTokenBalance.amount}");
      debugPrint("<<<<<<< Done InterSOL >>>>>>>");
      info.add("<<<<<<< Done InterSOL >>>>>>>");
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("Resending...");
      info.add("Resending...");
      // fullRun(info);
    }
  }
}
