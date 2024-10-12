# recruitment-gemma-2-2B-to-VECR

## はじめに
こちらはオリジナルの[`README`](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/blob/main/README.md)を参考に現在は開発の備忘録や日記として使っています。  
現時点では整理が十分ではないため、後ほど整備を行いますが、個人開発のリアルな過程を残すのもドキュメンタリーみたいで面白そうだったので、どこか別のセクションに残します。

## 注意
本プロジェクトでは、Googleが開発した"Gemma 2 2B"モデルを使用しています。  
Gemma 2 2Bは、Google LLCが提供する機械学習モデルの一部です。  
詳しくは、[Hugging faceの公式プロジェクトページ](https://huggingface.co/collections/google/gemma-2-jpn-release-66f5d3337fdf061dff76a4f1)をご覧ください。

## フォーク元のプロジェクト
このプロジェクトは[takoyaki-3さん](https://github.com/takoyaki-3)が公開されている、[docker-gemma-2-2b-jpn-it](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/tree/main)プロジェクトをフォークし、改変を行なっています。
オリジナルのプロジェクトはフリーで利用可能なスクリプトを提供しており、合法的なライセンスのもとで利用されています。([Link](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/tree/main?tab=readme-ov-file#%E3%83%A9%E3%82%A4%E3%82%BB%E3%83%B3%E3%82%B9))、

なお、改変によって生じたバグなどの責任は筆者の[佐々木 翔太](https://github.com/s-sasaki-earthsea-wizard)に帰属します。
ただし、このプロジェクトの使用によって生じたいかなる損害や問題についても、使用者自身の責任となります。使用前に十分な検証を行い、自己責任で使用してください。

## プロジェクトのサマリー生成スクリプト
このプロジェクトでは、[Olemi-llm-apprenticeさん](https://github.com/Olemi-llm-apprentice)が提供する、プロジェクトサマリー生成スクリプトを使用しています。

このスクリプトはMITライセンスで提供されており、開発のワークフローに組み込まれています。
なお、このスクリプトを実行して得られる`txt`ファイルはバージョン管理から除外されています。スクリプトの元ソースコードや詳細なドキュメントについては[こちら](https://github.com/Olemi-llm-apprentice/generate-project-summary)をご覧ください。

## 環境変数
1. `.env.sample` ファイルを `.env` にコピーします
2. `.env` ファイルを開き、必要な値を設定します
3. 特に `HF_TOKEN` には有効な Hugging Face API トークンを設定してください (TBD)
**注意： 実際の環境変数はセキュリティ上の理由でリポジトリにプッシュしません。**

## 開発環境
実験的な意味合いが強いプロジェクトなので、備忘録とするためにも赤裸々に事情を記録します。

### ハードウェア
- **サーバー: Linux (Jetson Nano)**
  - 「なぜわざわざJetson Nanoを？」と思った方も多いと思いますが、エッジデバイスでLLMを動かすってどんなものだろう、という興味で使っています。
  - もしエッジデバイスのポータブル性をうまく活用できるアイディアがあったら嬉しいな、くらいの気持ちです
  - もしかしたらJetson Orin Nanoなどの方が適したマシンなのかもしれません。有識者のGitHub Issuesでのコメントを歓迎します。
- **追加メモリ: USBメモリ(Sandisk Ultra Fit 32GB)をスワップ**
  - Jetson Nanoは小型ながらもパワフルなマシンですが、今回のプロジェクトでは[メモリ不足が予想された](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/tree/main?tab=readme-ov-file#%E5%BF%85%E8%A6%81%E3%82%B9%E3%83%9A%E3%83%83%E3%82%AF)ので、USBメモリをスワップして増設しました
  - USBメモリをスワップして使用した場合、Gemma 2 2Bを使用してどの程度保つのか、試す意味合いもあります (ケースバイケースとしか言いようがないと思いますが)。スワップとして使用するので使用頻度と書き込み量が大きくなり、早く劣化すると予想しています。
  - 田舎の小さなPC関連ショップでたまたま売ってたものを買っただけなので、選んだデバイスに意味は全くありません
  
### ソフトウェア
- OS: Ubuntu 18.04
- Docker: version 24.0.2
- and so on (TBA)

### USBメモリをスワップとして設定する方法
1. USBメモリを接続し、デバイス名を確認する
```
$ lsusb
Bus 002 Device 003: ID 0781:5583 SanDisk Corp.
```
```bash
$ lsblk
*******
sda            8:0    1  28.7G  0 disk 
└─sda1         8:1    1  28.7G  0 part 
```
などのコマンドでどれがUSBメモリか確かめましょう。
上記の結果はSanDiskのUSBメモリが接続されており、
それが`/dev/sda1/`に対応することを示しています。
以下で紹介するコマンドのデバイスの部分は各自の環境に合わせたものを利用してください。

1. USBメモリ全体を`ext4`でフォーマットする (必要な場合)
以下のコマンドでUSBメモリ全体をext4でフォーマットします
```bash
sudo mkfs.ext4 /dev/sda
```
**USBメモリが`vfat`でフォーマットされている場合、
ファイルサイズの上限が最大4GBに制限されます** (筆者の買った製品はこれに引っかかった)  
ここでの例のように`ext4`などの大きなファイルを扱える形式でフォーマットしましょう。

1. マウントポイントを作成し、USBメモリをマウントする
```bash
sudo mkdir -p /media/usb
```
でマウントポイントを作成します。
- **マウントポイントはroot権限で作成することが強く推奨されます！**

その後、作成したマウントポイントに
```bash
sudo mount /dev/sda /media/usb
```
でUSBメモリをマウントします。  

マウントが成功したかを以下のコマンドで確認します
```bash
mount | grep /media/usb
```

以下のような結果が返ってきていれば無事マウントされています
```
$ mount | grep /media/usb
/dev/sda on /media/usb type ext4 (rw,relatime,data=ordered)
```

3. スワップファイルを作成する
以下のコマンドでスワップファイルを作成します: 
```
sudo dd if=/dev/zero of=/media/usb/swapfile bs=1M count=16384
```
- `dd`: 
  - `dd`は"data duplicator"の略で、ファイルの複製やデータの変換を行うためのコマンドです
- `if=/dev/zero`: 
  - `if`は"input file"の略。入力元のファイルを指定するパラメータです。`/dev/zero`は特殊なデバイスファイルで、読み取ると無限にゼロ（null文字）を生成します。つまりフォーマットするようなことですね。
- `of=/media/usb/swapfile`: 
  - `of`は"output file"の略。出力先のファイルを指定するパラメータです。`/media/usb/swapfile`は、作成するスワップファイルのパスと名前を指定しています。

ブロックサイズ(`bs`)を1MBとすると、1GiBが
$$ 2^{10} = 1024 \ \text{count}$$ 
となるので、上記のコマンドは 1024 * 16 = 16384 count, つまり16GiBのスワップメモリを作成するという意味です。

16GiBのスワップファイルを作成するのは時間がかかるので、コーヒー☕️を飲んだりお風呂🛀に入ったりしてゆっくりしましょう。ゆっくりしていってね！！！


コマンドの実行が完了したら、以下のコマンドで新しく作成されたswapfileとそのサイズが表示されます:
```bash
$ ls -lh /media/usb/swapfile
TBA
```

1. hoge



# recruitment-gemma-2-2B-to-VECR
This is a section of the original [`README`](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/blob/main/README.md) that Sasaki has modified.
As it's not yet fully organized, further refinement will be done later.

## Note
This project uses the "Gemma 2 2B" model developed by Google.  
Gemma 2 2B is part of the machine learning models provided by Google LLC.  
For more details, please visit the [official project page on Hugging Face](https://huggingface.co/collections/google/gemma-2-jpn-release-66f5d3337fdf061dff76a4f1).

## Original Project
This project is forked and modified from the [docker-gemma-2-2b-jpn-it](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/tree/main) project published by [takoyaki-3](https://github.com/takoyaki-3).
The original project provides freely usable scripts under a legal license. ([Link](https://github.com/takoyaki-3/docker-gemma-2-2b-jpn-it/tree/main?tab=readme-ov-file#%E3%83%A9%E3%82%A4%E3%82%BB%E3%83%B3%E3%82%B9))

Any bugs resulting from the modifications are the responsibility of the author, [Syota Sasaki](https://github.com/s-sasaki-earthsea-wizard).
However, any damages or issues arising from the use of this project are the sole responsibility of the user. Please conduct thorough testing before use and proceed at your own risk.

## Project Summary Generation Script
This project uses a project summary generation script provided by [Olemi-llm-apprentice](https://github.com/Olemi-llm-apprentice).

This script is provided under the MIT license and is incorporated into the development workflow.
The `txt` files generated by running this script are excluded from version control. For the original source code of the script and detailed documentation, please refer to [this link](https://github.com/Olemi-llm-apprentice/generate-project-summary).

## Environment Variables

1. Copy the `.env.sample` file to `.env`
2. Open the `.env` file and set the necessary values
3. Specifically, set a valid Hugging Face API token for `HF_TOKEN` (TBD)

**Note: Actual environment variables are not pushed to the repository for security reasons.**