PQI_AirCardのDPOFファンクションFTPトランスポート用シェルスクリプトについて
===========


1.概要
PQI AirCardのシェルスクリプトをカード内MMCに生成しカメラ側でフォーマットした後にも常時、スクリプトが自動生成され
利用出来る様にする為の手法です。

2.実装機能
1)カメラ側のDPOF機能を利用しFTPにて任意のサーバーに画像転送が可能。
2)カード内部MMCにスクリプト他を保存するので、フォーマットしても機能が損なわれません。
3)Aircardに割り振られたUPアドレスをブラウザーで確認できます。

3.インストール方法
1)スマートフォン等の画像を保存するデバイスにftpアプリケーションをインストールして下さい。インストールするアプリケーションの必要機能条件は以下です。
 -保存フォルダを任意に変更出来る事。
 -匿名ログインが可能なｆｔｐサーバーで有ること。本スクリプトでは匿名以外のログインはサポートしておりません。

2)PQI より最新のファームウェアをダウンロードし解凍して下さい。

注意!!!!
もし、貴方が特別なファームウェアを利用している場合に、本スクリプトを利用する場合は常にPQIより提供されているファームウェアの最新版に戻してから実施して下さい。

3)SDカードをフォーマットします。
4)PQIよりダウンロードしたファームウェアからinitramfs3.gzだけをSDカードに保存します。

[以下の配置になるように、スクリプト、バイナリ他を保存して下さい。]
SD
├BBADD
│├autorun.sh
│├DPOFftp.sh
│└FtpControl.sh
├add8arm
├autorun.sh
├dhcp.script
├kcard_edit_config.pl
├kcard_save_config.pl
├initramfs3.gz(PQI origin)
└rcS

5)PQI AirCardをカメラ、USBカードリーダー等のAircardが適切に作動していたデバイスに差し込んで下さい。
6)カード内部で上記ファイルが自動的に所定の位置に展開され新しいinitramfs3.gzが生成されます。全て完了するまでにおおよそ、4分程度ですが、念の為6分間はそのまま待機してください。

7)6分経過後、Aircardに差し込まれたSDカードのファイル状況が以下の通りとなっている事を確認して下さい。
SD
├MISC
├DCIM
├autorun.sh
├initramfs3.gz(Modified)
└good.txt

8)もし、error.txtが生成されていれば、ステップ３）に戻ってもう一度トライして下さい。
9)新しく生成されたinitramfs3.gzをSDカード以外の適切な場所に保存して下さい。
10)SDカードをフォーマットして下さい。

11)フォーマットされたSDカードに以下の構成にてファイルをコピーして下さい。
SD
├initramfs3.gz(新しく生成された物を利用して下さい。新しいものは、ファイルサイズがおおよそ３Mあります。古いものは2.6M程度しかありません。）
├image3
├autoload.tbl
├mtd_jffs2.bin
└program.bin

12)PQIの所定の手法にて通常のファームウェアアップデートを実施して下さい。
13)ファームウェアアップデートが完了すればスクリプト、バイナリーのアップデートは完了しています。

正常に完了していれば、SDカードのファイル構成は以下の様になっています。
SD
├MISC
├DCIM
│└199_WIFI
│ ├WSD00001.JPG
│ ├WSD00002.JPG
│ └WSD00003.JPG
├autorun.sh
├DPOFftp.sh
└FtpControl.sh

4.オプション
rcSファイルを修正することにより,他のファイルのコピーが可能です。ただし、initramfs3.gzのファイルサイズは完成後３M以下でなければなりません。これは、u-bootでinitramfs3.gzを3000000byte読みこむように設定されているからです。勿論、バイナリエディタで変更する事は可能ですがその場合は十分な知識をもってバイナリをエディットして下さい。

5.注意
本スクリプトにおけるいかなるトラブル・損害に付きましては全て免責とさせて頂きます。尚、二次損害についても同様に免責とさせて頂きます。よって、本スクリプト及びバイナリーを利用するに当たっては全て自己責任にてお願いいたします。

6.ライセンス
BusyBox v1.21.0 (2013-05-09 10:31:21 JST) multi-call binary.
BusyBox is copyrighted by many authors between 1998-2012.
Licensed under GPLv2. See source distribution for detailed
copyright notices.

add8arm is Licensed under GPLv2.

Please ask me without hesitation if you have a question.
my twitter is @ijime110
