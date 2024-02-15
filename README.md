<!-- @format -->

# English README 　[Jump to Japanese Version](#japanese)

# On-chain contract challenges solutions

<br/>
<p align="center">
<img src="https://jer-b.github.io/assets/projects_img/security.avif" width="600" alt="Foundry Challenges">
</p>
<br/>

- Note: It is not like other other Foundry and HardHat challenges which needs basic / advanced solidity knowledges. It needs a deep dive in lower level of Solidity. Beginners won't clear it easily. 😛
- This is Various `security` challenge solutions for contracts that have already been deployed on the testnet and made by `Patrick Collins` / `Cyfrin`.
- It's a way to practice how to interact with and read other contracts. There are simple challenges as well as challenges that require interaction with external contracts or to exploit them.
- The problem description of each challenge is included in the smart-contract.
- Upon solving a challenge, the reward is an NFT.
- Problems are available on `Sepolia` and `Arbitrum`.

Here are the writeups of my solutions levels I cleared.
** I will not recommend you to look at solutions I wrote. Solve it yourself for your learning 😛 **

# How to interact with contracts

- You can use [Remix](https://remix.ethereum.org/) and `Foundry` to interact with the contracts.
- If your confortable with Foundry and Methods call using `cast` and `send` and contract interaction requiring an external contract, then you can also solve problem from Foundry only.
- You can use `chisel` or make separate contract for some value checking. As you wish
- In higher difficulty challenges, you will need to wrote smart contracts and interfaces to hack some smart contract externally for clearing chellenges.

# Verify your result

- There is 2 way to verify if your solution was correct or not.

1. Verify the transaction you made on the blockchain explorer.
2. Easiest way is just to take a look at Opensea and see if you have the NFT: [Here](https://testnets.opensea.io/account)

<br/>
<p align="center">
<img src="./images/opensea_verify.png" width="600" alt="Foundry Challenges">
</p>
<br/>

# The list of all challenges

0.

- Arbitrum https://arbiscan.io/address/0xf923431da74ecc873c4d641fbdfa2564baafca9f#code
- Sepolia https://sepolia.etherscan.io/address/0x39338138414df90ec67dc2ee046ab78bcd4f56d9#code

1.

- Arbitrum https://arbiscan.io/address/0x7a0f40757f6ba868b44ce959a1d4b8bc22c21d59#code

- Sepolia https://sepolia.etherscan.io/address/0x76d2403b80591d5f6af2b468bc14205fa5452ac0#code

2.

- Arbitrum
- Sepolia

3.

- Arbitrum
- Sepolia

4.

- Arbitrum
- Sepolia

5.

- Arbitrum
- Sepolia

6.

- Arbitrum
- Sepolia

7.

- Arbitrum
- Sepolia

8.

- Arbitrum
- Sepolia

9.

- Arbitrum
- Sepolia

10.

- Arbitrum
- Sepolia

11.

- Arbitrum
- Sepolia

## Challenge 0

Introductory level.<br /><br />

- You just need to pass a 'Twitter handle' to the 'solveChallenge' function

### Contract

<br/>
<p align="center">
<img src="./Challenge_0/00_contract_0.png" width="900" alt="Security Challenges">
</p>
<br/>

0.

- Arbitrum https://arbiscan.io/address/0xf923431da74ecc873c4d641fbdfa2564baafca9f#code
- Sepolia https://sepolia.etherscan.io/address/0x39338138414df90ec67dc2ee046ab78bcd4f56d9#code

### Solution

- `Twitter handle` = `@xxxxxxx`

<br/>
<p align="center">
<img src="./Challenge_0/01_solve_challenge_0.png" width="900" alt="Security Challenges">
</p>
<br/>

### NFT challenge 0

<br/>
<p align="center">
<img src="./images/NFT_challenge_0.avif" width="250" alt="Security Challenges">
</p>
<br/>

## Challenge 1

- Goal is to input the selector signature and bytes format of the input data of some functions to the contract. including your twitter handle.
- Fill in your Twitter handle.

```
selectorOne (bytes4)
inputData (bytes)
yourTwitterHandle (string)
```

### Contract

1.

- Arbitrum https://arbiscan.io/address/0x7a0f40757f6ba868b44ce959a1d4b8bc22c21d59#code

- Sepolia https://sepolia.etherscan.io/address/0x76d2403b80591d5f6af2b468bc14205fa5452ac0#code

By reading the contract we can see that checkers put in places are looking for booleans.
If we look closer at the contract it uses an interface helperContract.sol and calling it while using abi.encodeWithSignature.

```
i_helperContract.call(abi.encodeWithSelector(selectorOne));
```

```
i_helperContract.call(inputData);
```

<br/>
<p align="center">
<img src="./Challenge_1/00_contract.png" width="900" alt="Security Challenges">
</p>
<br/>

- Here is the helper contract: [https://sepolia.etherscan.io/address/0x6E6Fe04023Fa82465418FE1b821134C039e44D2b#code](https://sepolia.etherscan.io/address/0x6E6Fe04023Fa82465418FE1b821134C039e44D2b#code)

<br/>
<p align="center">
<img src="./Challenge_1/01_helper_link.png" width="900" alt="Security Challenges">
</p>
<br/>
<br/>
<p align="center">
<img src="./Challenge_1/02_helper_contract.png" width="900" alt="Security Challenges">
</p>
<br/>

- You can also check functions if you need.

<p align="center">
<img src="./Challenge_1/03_helper_contract_calls.png" width="900" alt="Security Challenges">
</p>
<br/>

### Solution

- So the first function, is `returnTrue()`. Let's get the selector of it. For this to work we need to have it declared in our contract / chisel as well.
  (I assume you have foundry installed) Use chisel or create a new contract that contains below functions or use Remix:

```
function returnTrue() external pure returns (bool) {
        return true;
    }
function getSignature() public pure returns (bytes memory) {
        return (abi.encodeWithSignature("returnTrue()"));
    }
```

- Then call `getSignature()` and you will get the selector of the function.

```
getSignature()
```

<p align="center">
<img src="./Challenge_1/04_selector_chisel.png" width="900" alt="Security Challenges">
</p>
<br/>

- Note: the signature value on chisel comes out in full hex length. Actually it is just first 8 bytes. Depends what your habits are. Remix will show 0x and first 8 bytes.

```
Contents ([0x40:..]): 0xf613a68700000000000000000000000000000000000000000000000000000000
```

so this -> `0xf613a687`

If you want you can use this site : [https://openchain.xyz/signatures?query=returnTrue](https://openchain.xyz/signatures?query=returnTrue) if selector is registered there.

<p align="center">
<img src="./Challenge_1/05_selector_check.png" width="900" alt="Security Challenges">
</p>
<br/>

We got SelectorOne. Now `inputData`.

- Actually, you can cheat on this one and reuse the earlier selector as input. But let's do it properly.

- The next function that requires an input in i_helperContract is `returnTrueWithGoodValues(uint256 nine, address contractAddress)`
  But in the bytes format of `uint256` and `address`.

You can make a separate contract of the below, I am gonna just put it into chisel.

```
    function getSignatureTwo(uint256 nine, address contractAddress) public pure returns (bytes memory) {
        return abi.encodeWithSignature("returnTrueWithGoodValues(uint256,address)", nine, contractAddress);
    }
```

<p align="center">
<img src="./Challenge_1/06_chisel_getSignatureTwo.png" width="900" alt="Security Challenges">
</p>
<br/>

- Remember to cut last zeroes on chisel:

```
0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b00000000000000000000000000000000000000000000000000000000
 ↓
0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b
```

Now we have the `inputData` value → `0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b`

- input everything that is needed and you are good to go.

- `selectorOne` = `0xf613a687`
- `inputData` = `0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b`
- `Twitter handle` = `@xxxxxxx`

### NFT challenge 1

<br/>
<p align="center">
<img src="./images/NFT_challenge_1.avif" width="200" alt="Security Challenges">
</p>
<br/>

## Challenge 2

### Contract

### Solution

### NFT challenge 2

## Challenge 3

### Contract

### Solution

### NFT challenge 3

# TO CONTINUE...

<a name="japanese"></a>

# 日本語版の README

# オンチェーン問題チャレンジの解決策

<br/>
<p align="center">
<img src="https://jer-b.github.io/assets/projects_img/.avif" width="600" alt="Foundry Challenges">
</p>
<br/>

- 注意：これは基本的/高度な Solidity の知識が必要な他の Foundry や HardHat の課題とは異なります。Solidity の低レベルに深く潜る必要があります。初心者は簡単にはクリアすることは難しい。 😛
- テストネット上に既にデプロイされており、`Patrick Collins` / `Cyfrin` によって作成された様々なコントラクトの`セキュリティ`チャレンジソリューションです。
- これは、他のコントラクトとどのようにやり取りし、読み取るかを実践する方法です。シンプルなチャレンジから、外部コントラクトとのやり取りやそれらを利用する必要があるチャレンジまであります。
- 各チャレンジの問題の説明はスマートコントラクトに含まれています。
- チャレンジを解決すると、報酬として NFT がもらえます。
- 問題は `Sepolia` と `Arbitrum` で利用可能です。

これはクリアしたレベルの解決策です。
**解決策を見ることをお勧めしません。学習のために自分で解決してください 😛 **

# コントラクトとのやり取り方法

- コントラクトとやり取りするには、[Remix](https://remix.ethereum.org/)と Foundry を使用できます。
- Foundry と`cast`や`send`を使ったメソッド呼び出し、外部コントラクトが必要なコントラクトのやり取りに慣れている場合は、Foundry だけで問題を解決することもできます。
- `chisel`を使用するか、いくつかの値のチェックのために別のコントラクトを作成することができます。ご希望に応じて
- より高難度のチャレンジでは、スマートコントラクトとインターフェースを作成して、いくつかのスマートコントラクトを外部からハッキングするために解チャレンジをクリアする必要があります。

# 結果を確認する

- 解決策が正しかったかどうかを確認する方法は 2 つあります。

1. ブロックチェーンエクスプローラーで行ったトランザクションを確認します。
2. もっとも簡単な方法は、Opensea で NFT を持っているかどうかを確認することです： [こちら](https://testnets.opensea.io/account)

<br/>
<p align="center">
<img src="./images/opensea_verify.png" width="600" alt="Security Challenges">
</p>
<br/>

# 全てのチャレンジ一覧

0.

- Arbitrum https://arbiscan.io/address/0xf923431da74ecc873c4d641fbdfa2564baafca9f#code
- Sepolia https://sepolia.etherscan.io/address/0x39338138414df90ec67dc2ee046ab78bcd4f56d9#code

1.

- Arbitrum https://arbiscan.io/address/0x7a0f40757f6ba868b44ce959a1d4b8bc22c21d59#code

- Sepolia https://sepolia.etherscan.io/address/0x76d2403b80591d5f6af2b468bc14205fa5452ac0#code

2.

- Arbitrum
- Sepolia

3.

- Arbitrum
- Sepolia

4.

- Arbitrum
- Sepolia

5.

- Arbitrum
- Sepolia

6.

- Arbitrum
- Sepolia

7.

- Arbitrum
- Sepolia

8.

- Arbitrum
- Sepolia

9.

- Arbitrum
- Sepolia

10.

- Arbitrum
- Sepolia

11.

- Arbitrum
- Sepolia

## チャレンジ 0 と 1.

入門レベル。<br /><br />

- 'Twitter handle' を 'solveChallenge' 関数に渡すだけです。

### コントラクト

<br/>
<p align="center">
<img src="./Challenge_0/00_contract_0.png" width="900" alt="Security Challenges">
</p>
<br/>

0.

- Arbitrum https://arbiscan.io/address/0xf923431da74ecc873c4d641fbdfa2564baafca9f#code
- Sepolia https://sepolia.etherscan.io/address/0x39338138414df90ec67dc2ee046ab78bcd4f56d9#code

### 解決策

- `Twitter handle` = `@xxxxxxx`

<br/>
<p align="center">
<img src="./Challenge_0/01_solve_challenge_0.png" width="900" alt="Security Challenges">
</p>
<br/>

### NFT チャレンジ 0

<br/>
<p align="center">
<img src="./images/NFT_challenge_0.avif" width="250" alt="Security Challenges">
</p>
<br/>

## チャレンジ 1

- 目標は、いくつかの関数のセレクタシグネチャと入力データのバイト形式をコントラクトに入力することです。
- Twitter ハンドルを含めて。

```
selectorOne (bytes4)
inputData (bytes)
yourTwitterHandle (string)
```

### コントラクト

1.

- Arbitrum https://arbiscan.io/address/0x7a0f40757f6ba868b44ce959a1d4b8bc22c21d59#code

- Sepolia https://sepolia.etherscan.io/address/0x76d2403b80591d5f6af2b468bc14205fa5452ac0#code

コントラクトを読むことで、チェッカーがブーリアンを探していることがわかります。
コントラクトをより詳しく見ると、helperContract.sol のインターフェースを使用して abi.encodeWithSignature を使用しながら呼び出しています。

```
i_helperContract.call(abi.encodeWithSelector(selectorOne));

i_helperContract.call(inputData);
```

<br/>
<p align="center">
<img src="./Challenge_1/00_contract.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>

- ヘルパーコントラクトはこちら：[https://sepolia.etherscan.io/address/0x6E6Fe04023Fa82465418FE1b821134C039e44D2b#code](https://sepolia.etherscan.io/address/0x6E6Fe04023Fa82465418FE1b821134C039e44D2b#code)

<br/>
<p align="center">
<img src="./Challenge_1/01_helper_link.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>
<br/>
<p align="center">
<img src="./Challenge_1/02_helper_contract.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>

- 必要の場合は関数もチェックできます。

<p align="center">
<img src="./Challenge_1/03_helper_contract_calls.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>

### 解決策

- 最初の関数は`returnTrue()`です。それのセレクタを取得しましょう。これを機能させるためには、コントラクト/Chisel にそれを宣言する必要があります。
  (Foundry がインストールされていると仮定します) Chisel を使用するか、以下の関数を含む新しい契約を作成するか、Remix を使用してください：

```
function returnTrue() external pure returns (bool) {
return true;
}
function getSignature() public pure returns (bytes memory) {
return (abi.encodeWithSignature("returnTrue()"));
}
```

- 次に`getSignature()`を呼び出すと、関数のセレクタが取得できます。

```
getSignature()
```

<p align="center">
<img src="./Challenge_1/04_selector_chisel.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>

- Chisel でのシグネチャ値は完全な 16 進数の長さで出力されます。実際には最初の 8 バイトだけです。あなたの習慣に依存します。Remix は 0x と最初の 8 バイトを表示します。

```
Contents ([0x40:..]): 0xf613a68700000000000000000000000000000000000000000000000000000000
```

これ -> `0xf613a687`

このサイトを使用することもできます：[https://openchain.xyz/signatures?query=returnTrue](https://openchain.xyz/signatures?query=returnTrue) セレクタがそこに登録されている場合。

<p align="center">
<img src="./Challenge_1/05_selector_check.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>

SelectorOne を手に入れました。今`inputData`です。

- 実際には、この 1 つでは先ほどのセレクタを入力として再利用してチートすることができます。しかし、適切に行いましょう。

- 次に入力が必要な i_helperContract の関数は`returnTrueWithGoodValues(uint256 nine, address contractAddress)`です
  しかし、`uint256`と`address`のバイト形式で。

以下のものの別の契約を作ることができますが、私はそれをチゼルに入れるだけです。

```
function getSignatureTwo(uint256 nine, address contractAddress) public pure returns (bytes memory) {
    return abi.encodeWithSignature("returnTrueWithGoodValues(uint256,address)", nine, contractAddress);
}
```

<p align="center">
<img src="./Challenge_1/06_chisel_getSignatureTwo.png" width="900" alt="セキュリティチャレンジ">
</p>
<br/>

- チゼルで最後のゼロを切り取ることを忘れないでください：

```
0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b00000000000000000000000000000000000000000000000000000000
↓
0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b
```

これで`inputData`の値が手に入りました → `0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b`

- 必要なものをすべて入力して、完了です。

- `selectorOne` = `0xf613a687`
- `inputData` = `0x5a780edd00000000000000000000000000000000000000000000000000000000000000090000000000000000000000006e6fe04023fa82465418fe1b821134c039e44d2b`
- `Twitterハンドル` = `@xxxxxxx`

### NFT チャレンジ 1

<br/>
<p align="center">
<img src="./images/NFT_challenge_1.avif" width="200" alt="Foundryチャレンジ">
</p>
<br/>
<br />
<br />

## チャレンジ 2

### コントラクト

### 解決策

### NFT チャレンジ 2

## チャレンジ 3

### コントラクト

### 解決策

### NFT チャレンジ 3
