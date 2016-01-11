//
//  ViewController.swift
//  15パズル
//
//  Created by keisuke on 2016/01/05.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
//    //クイズテキスト設定
//    let label = UILabel(frame: CGRectZero)
    
    
    //定数
    let xFrame:CGFloat = 640.0 //１５枚のタイルを入れる枠の幅
    let yFrame:CGFloat = 640.0 //枠の高さ
    let tileSize:CGFloat = 160.0 //タイルの縦横サイズ
    let lineWidth:CGFloat = 2.0 //外枠の線の幅
    let numOfTiles:Int = 16 //タイル数（空タイルも含む）
    let numOfSwap:Int = 5 //シャッフル時のタイル交換回数
    
    //タイルの背景色パターンを保存する配列
    let colors:Array<UIColor> = [UIColor.cyanColor(),UIColor.yellowColor(),UIColor.greenColor()]
    
    //タイルクラスのインスタンスをnemOfTiles分保持するための配列定義
    var tiles:Array<Tile> = []
    
    //実際の並び順をtile.tagで保存する配列。
    var tileTags:Array<Int> = []
    
    //タイルが動く範囲を指定するための変数
    var frameMinX:CGFloat = 0
    var frameMinY:CGFloat = 0
    var frameMaxX:CGFloat = 0
    var frameMaxY:CGFloat = 0
    
    //外側のフレームの左上の絶対座標
    var fOrigin:CGPoint = CGPoint()
    
    //タップされたタイルの場所と、空白の場所を覚えるための変数
    var curTileIdx:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        //クイズテキスト読み出し
//        label.frame = view.bounds
//        label.textAlignment = .Center
//        view.addSubview(label)
//        
//        // sample.txtファイルを読み込み
//        let path = NSBundle.mainBundle().pathForResource("sample", ofType: "csv")!
//        if let data = NSData(contentsOfFile: path){
//            label.text = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
//        }else{
//            label.text = "データなし"
//        }
        
        
        
        //枠線はLayerで描画
        let dLayer = CALayer()
        
        //高さと幅を外枠の分も考慮して確保する。
        dLayer.frame = CGRect(x: self.view.center.x - xFrame*0.5 - lineWidth/2 ,y: self.view.center.y - yFrame * 0.5 - lineWidth/2 ,width:xFrame + lineWidth, height:yFrame+lineWidth)
        
        //フレームの左上の座標を格納する。
        fOrigin = CGPoint(x: self.view.center.x - xFrame*0.5, y: self.view.center.y - yFrame * 0.5)
        
        //レイヤをかぶせる
        self.view.layer.addSublayer(dLayer)
        
        //タイルの動く領域がわかりやすいようにバックを赤にする。
        dLayer.backgroundColor = UIColor.redColor().CGColor
        
        //デリゲート設定
        dLayer.delegate = self
        dLayer.setNeedsDisplay() //画面更新する
        
        //枚数分タイル生成（空に見えるところでもタイルは透明にして作る）
        for idx in 0..<self.numOfTiles {
            
            //タイル生成
            let ti = Tile()
            
            //タグをつける(1から開始.最後は空タイル用に０をつけるので、余りを求めている)
            ti.tag = (idx+1)%self.numOfTiles
            
            //16枚を重ならないようにx,yをずらして指定する。
            ti.frame = CGRect(x: fOrigin.x + tileSize*CGFloat(idx%4), y: fOrigin.y + tileSize*CGFloat(idx/4), width:tileSize, height:tileSize)
            
            if(idx < self.numOfTiles-1) {
                //タイルの色を１枚目青、２枚目黄、３枚目緑、４枚目黒とする。
                ti.backgroundColor = self.colors[idx%3]
            }else{
                //空タイルはイベントに反映させない。
                ti.userInteractionEnabled = false
                //透明にする。
                ti.backgroundColor = UIColor.clearColor()
            }
            
            //ターゲットの追加
            ti.addTarget(self, action: "touchDown:", forControlEvents: UIControlEvents.TouchDown)
            ti.addTarget(self, action: "touchDrag:forEvent:", forControlEvents: UIControlEvents.TouchDragInside)
            ti.addTarget(self, action: "touchUp:forEvent:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            //ラベルをタイルの上に貼る
            let la = UILabel()
            
            if(idx < self.numOfTiles-1) {
                //普通のタイル
                if(idx==0){
                    la.text = String("for(")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==1){
                    la.text = String("i=2;")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==2){
                    la.text = String("i<=num;")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==3){
                    la.text = String("i++){")
                    la.textAlignment=NSTextAlignment.Center
                }
                    
                else if(idx==4){
                    la.text = String("if")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==5){
                    la.text = String("(")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==6){
                    la.text = String("i=num")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==7){
                    la.text = String("){")
                    la.textAlignment=NSTextAlignment.Center
                }
                    
                else if(idx==8){
                    la.text = String("}else if(")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==9){
                    la.text = String("(num%i)")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==10){
                    la.text = String("==0)")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==11){
                    la.text = String("{")
                    la.textAlignment=NSTextAlignment.Center
                }
                    
                else if(idx==12){
                    la.text = String("break")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==13){
                    la.text = String(";")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==14){
                    la.text = String("}")
                    la.textAlignment=NSTextAlignment.Center
                }else if(idx==15){
                    la.text = String("素数判定")
                    la.textAlignment=NSTextAlignment.Center
                }
            } else {
                //空タイル（ラベルを空文字で設定し、背景色透明にする）
                la.text = String("")
                la.backgroundColor = UIColor.clearColor()
            }
            
            //ラベルをタイルに貼る
            la.frame = CGRect(x: 0, y: 0, width: ti.bounds.width, height: ti.bounds.height)
            ti.addSubview(la)
            
            //タイルを貼る。画面に表示。
            self.view.addSubview(ti)
            
            //配列に格納（ビュー部品管理用とデータ管理用）
            tiles.append(ti)
            tileTags.append(ti.tag)
            
        }
        //タイルをかき混ぜる
        shuffle()
        
        
    }
    
    //touchDown
    func touchDown(tile:Tile){
        
        //タッチされた現在の場所（tileTagsのインデックス）を取り出す。
        curTileIdx = tileTags.indexOf(tile.tag)!
        
        //隣の空白箇所の場所を返す（tagが０のタイルのインデックス）を取り出す
        var blankIdx:Int? = nil
        blankIdx = getIndexOfBlank(curTileIdx!)
        
        //隣に空きがなければ、移動はできない。ここで処理は終わり。
        if blankIdx == nil {
            //println("touchDownの中のblankIdxがnilの時の処理")
            curTileIdx = nil
            return
        }
        
        //色を薄くする
        tile.alpha = 0.5
        
        //tileタグのインデックスから可動領域を計算する。
        //現在タッチされたタイルと、空白箇所のタイルの領域を計算。
        var absCurTileRect:CGRect = CGRect()
        var absBlankTileRect:CGRect = CGRect()
        absCurTileRect = getSelectedTileRect(curTileIdx!)
        absBlankTileRect = getSelectedTileRect(blankIdx!)
        
        //タイルが動ける範囲を計算。左上のx座標、y座標、右下のx座標、y座標
        frameMinX = (absBlankTileRect.minX <= absCurTileRect.minX ? absBlankTileRect.minX : absCurTileRect.minX )
        frameMaxX = (absBlankTileRect.maxX >= absCurTileRect.maxX ? absBlankTileRect.maxX : absCurTileRect.maxX )
        frameMinY = (absBlankTileRect.minY <= absCurTileRect.minY ? absBlankTileRect.minY : absCurTileRect.minY )
        frameMaxY = (absBlankTileRect.maxY >= absCurTileRect.maxY ? absBlankTileRect.maxY : absCurTileRect.maxY )
        
    }
    
    //選択されたタイルインデックスからCGRectを生成
    func getSelectedTileRect(idx: Int) -> CGRect!{
        let xbounds = tileSize * CGFloat(idx % 4) + fOrigin.x
        let ybounds = tileSize * CGFloat(idx / 4) + fOrigin.y
        return CGRect(x: xbounds, y: ybounds, width: tileSize, height: tileSize)
    }
    
    //touchDrag
    func touchDrag(tile:Tile, forEvent: UIEvent!){
        
        //最新のタッチイベントを取る。（UIEventからタイルへのタッチ情報を取り出し、さらにUITouchにキャストをかける）
        //イベントを取得する。
        if let touch = forEvent.touchesForView(tile)!.first! as? UITouch {
            // タッチされた座標を取得
            let location = touch.locationInView(tile)
            //タッチされた場所がタイルの上か？
            if tile.bounds.contains(location){
                //周りにtagが０のタイルがあるかをチェック
                //タッチされた現在の場所（tileTagsのインデックス）を取り出す。
                curTileIdx = tileTags.indexOf(tile.tag)!
                
                //上左右下どなりに空きがないかチェックする。空きがあればその場所（tileTagsのインデックス）を返す(getIndexOfBlank)
                var blankIdx:Int? = nil
                blankIdx = getIndexOfBlank(curTileIdx!)
                
                //空きがなければそこで処理は終わり。return
                if blankIdx == nil {curTileIdx = nil; return}
                
                //色を薄くする。
                tile.alpha = 0.5
                
                //ここで座標を変更する処理。空きがあれば、動ける領域を計算する。
                //親ビュー上での座標を取る
                let sLocation = touch.locationInView(tile.superview)
                
                //可動領域を考慮して、タイルのFrameを更新する。
                tile.frame = self.tileFrame(tile, location: sLocation)
                
            } else {
                //タッチイベントが時々nilを返すことがあるので、その対応
                if(curTileIdx == nil){return}
                
                //色を戻す。
                tile.alpha = 1.0
                tile.frame = self.tileFrameMove(moved: self.moved)
            }
        }
        
    }
    
    
    //touchUp
    func touchUp(tile:Tile, forEvent: UIEvent!){
        //touchDownやtouchesMovedを実行する前にtouchUpが実行されることへの対策。
        if curTileIdx == nil {return}
        
        //色を戻す
        tile.alpha = 1.0
        
        //最新のタッチイベントを取る。（UIEventからタイルへのタッチ情報を取り出し、さらにUITouchにキャストをかける）
        //イベントを取得する。
        if let touch = forEvent.touchesForView(tile)!.first! as? UITouch {
            
            // タッチされた座標を取得
            let location = touch.locationInView(tile)
            //親ビュー上での座標を取る
            let sLocation = touch.locationInView(tile.superview)
            
            //タッチされた現在の場所（tileTagsのインデックス）を取り出す。
            curTileIdx = tileTags.indexOf(tile.tag)!
            
            //空タイルの場所を取得する。
            var blankIdx:Int? = nil
            blankIdx = getIndexOfBlank(curTileIdx!)
            
            //現在タッチされたタイルと、空白箇所のタイルの領域を計算。
            var absCurTileRect:CGRect = CGRect()
            var absBlankTileRect:CGRect = CGRect()
            absCurTileRect = getSelectedTileRect(curTileIdx!)
            absBlankTileRect = getSelectedTileRect(blankIdx!)
            
            //タッチされた場所がタイルの上か？
            if tile.bounds.contains(location){
                
                //反応領域内かどうか調べる。以前自分がいた場所の領域内であればtrue、領域外であればfalseとする。
                let newMoved:Bool = !(absCurTileRect.contains(sLocation))
                if(self.moved != newMoved){
                    
                    self.moved = newMoved
                    tile.sendActionsForControlEvents(.ValueChanged)
                    
                    //movedプロパティの値でタイルの矩形を設定。
                    tile.frame = self.tileFrameMove(moved: self.moved)
                    
                    //tilesの移動したタイルと空タイルのtailTags配列内の値(TileのTag値)を交換
                    let tmpTileTag:Int
                    tmpTileTag = tileTags[curTileIdx!]
                    tileTags[curTileIdx!] = tileTags[blankIdx!]
                    tileTags[blankIdx!] = tmpTileTag
                    
                    //初期状態に戻す(returnの直前に置くと、curTileidxがnilとなり落ちる)
                    self.moved = false
                    curTileIdx = nil
                    
                    //終了判定
                    if checkFinish() {
                        //println("完成！")
                        //リプレイ用ダイアログを出力
                        rePlay(self)
                    }
                    
                    return
                }
                
            } else {
                //タイルの外でクリック（この処理はない）
            }
            
            //movedプロパティの値でタイルの矩形を設定。
            tile.frame = self.tileFrameMove(moved: self.moved)
        }
    }
    
    //今動かしているタイルのFrameを指の位置を元にして、かつ可動領域をはみ出ないように変更。
    private func tileFrame(curTile:Tile, location:CGPoint) -> CGRect {
        
        var tFrame = curTile.frame
        //xとyをタップした場所を中心としてタイルのフレームを変更
        tFrame.origin.x = location.x - tFrame.size.width/2.0
        tFrame.origin.y = location.y - tFrame.size.width/2.0
        
        //新しいタイルの矩形が可動領域をはみ出さないように調整
        //x座標
        if(tFrame.origin.x < frameMinX ) {
            tFrame.origin.x = frameMinX
        } else if (tFrame.maxX > frameMaxX){
            tFrame.origin.x = frameMaxX - tileSize
        }
        //y座標
        if(tFrame.origin.y < frameMinY ) {
            tFrame.origin.y = frameMinY
        } else if (tFrame.maxY > frameMaxY){
            tFrame.origin.y = frameMaxY - tileSize
        }
        
        return tFrame
    }
    
    //上左右下どなりに空きがないかチェックする。空きがあればその場所（tileTagsのインデックス）を返す.空きがなければnilを返す
    private func getIndexOfBlank(idx: Int) -> Int? {
        
        switch(idx){
        case 0:
            //左上角は右と下のチェック
            return (tileTags[idx+1]==0 ? idx+1 :(tileTags[idx+4]==0 ? idx+4 : nil))
            
        case 1,2:
            //上辺は左と右と下のチェック
            return (tileTags[idx-1]==0 ? idx-1 :(tileTags[idx+1]==0 ? idx+1 :(tileTags[idx+4]==0 ? idx+4 : nil)))
            
        case 3:
            //右上角は左と下のチェック
            return (tileTags[idx-1]==0 ? idx-1 :(tileTags[idx+4]==0 ? idx+4 : nil))
            
        case 4,8:
            //左辺は上と右と下のチェック
            return (tileTags[idx-4]==0 ? idx-4  :(tileTags[idx+1]==0 ? idx+1 :(tileTags[idx+4]==0 ? idx+4 : nil)))
            
        case 5,6,9,10:
            //中央部分は上左右下のチェック
            return (tileTags[idx-4]==0 ? idx-4 :(tileTags[idx-1]==0 ? idx-1 :(tileTags[idx+1]==0 ? idx+1 :(tileTags[idx+4]==0 ? idx+4 : nil))))
            
        case 7,11:
            //右辺は上と左と下のチェック
            return (tileTags[idx-4]==0 ? idx-4 :(tileTags[idx-1]==0 ? idx-1 :(tileTags[idx+4]==0 ? idx+4 : nil)))
            
        case 12:
            //左下角は上と右のチェック
            return (tileTags[idx-4]==0 ? idx-4 :(tileTags[idx+1]==0 ? idx+1 :nil))
            
        case 13,14:
            //下辺は上と左と右のチェック
            return (tileTags[idx-4]==0 ? idx-4 :(tileTags[idx-1]==0 ? idx-1 :(tileTags[idx+1]==0 ? idx+1 :nil)))
            
        case 15:
            //右下角は上と左のチェック
            return (tileTags[idx-4]==0 ? idx-4 :(tileTags[idx-1]==0 ? idx-1 : nil ))
        default:
            //これはあり得ない
            print("あり得ない処理")
        }
        //空きがなければそこで処理は終わり。実際はここも通らない。
        return nil
    }
    
    
    //移動したかどうかを保存するフラグ
    var moved:Bool = false {
        didSet {
            //tileTag[curTileIdx]が０の時（空タイル）は抜ける。
            if(tileTags[curTileIdx!]==0) {return}
            //現在操作しているタイルを値の変更に合わせ移動させる。タグ番号が１多いため実際の要素位置と合わせるために−１する。
            tiles[tileTags[curTileIdx!]-1].frame = self.tileFrameMove(moved: self.moved)
        }
    }
    
    //移動できたかできないかにより、タイルのフレームを描画する。
    private func tileFrameMove(moved moved:Bool) -> CGRect {
        
        //親座標に変換（タグ番号が１多いため実際の要素位置と合わせるために−１する。
        var curTileFrame:CGRect = tiles[tileTags[curTileIdx!]-1].convertRect(tiles[tileTags[curTileIdx!]-1].bounds, toView: self.view)
        
        //空白箇所の場所を返す（tagが０のタイルのインデックス）を取り出す
        var blankIdx:Int? = nil
        blankIdx = getIndexOfBlank(curTileIdx!)
        
        //万が一blankIdxがnilを返した場合（隣接した空白がない）は、そのまま現在位置を返す。
        if blankIdx == nil {return curTileFrame}
        
        //選択中のタイルの新しい位置を返す。空白との位置関係で４パターンある。
        //ここではすでにcurTileIdxとblankIdxが隣接している条件で求まっているので、簡単な差でよい。
        switch( curTileIdx! - blankIdx!) {
        case 4: //空白が上にある
            curTileFrame.origin.y = moved ? frameMinY : (frameMaxY - tileSize)
        case 1: //空白が左にある
            curTileFrame.origin.x = moved ? frameMinX : (frameMaxX - tileSize)
            
        case -1: //空白が右にある
            curTileFrame.origin.x = moved ? (frameMaxX - tileSize) : frameMinX
            
        case -4: //空白が下にある
            curTileFrame.origin.y = moved ? (frameMaxY - tileSize) : frameMinY
        default:
            print("あり得ない")
        }
        //新しい位置を返す。
        return curTileFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //layer用のオフスクリーン描画（枠を書く）
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        let r1TopY:CGFloat = 0.0
        let r1LeftX:CGFloat = 0.0
        let r1RightX:CGFloat = layer.bounds.size.width
        let r1BottomY:CGFloat = layer.bounds.size.height
        
        //描画用パス作成（左上から時計回りに）
        CGContextBeginPath(ctx)
        CGContextSetLineWidth(ctx,lineWidth)
        CGContextMoveToPoint(ctx, r1LeftX, r1TopY)
        CGContextAddLineToPoint(ctx, r1RightX, r1TopY)
        CGContextAddLineToPoint(ctx, r1RightX, r1BottomY)
        CGContextAddLineToPoint(ctx, r1LeftX, r1BottomY)
        CGContextAddLineToPoint(ctx, r1LeftX, r1TopY)
        CGContextClosePath(ctx)
        //パス描画
        CGContextStrokePath(ctx)
    }
    
    //タイル交換。tileTag配列内のタグ番号を交換するのみ。
    private func tileSwap(idx1: Int, idx2:Int){
        var tmpval:Int = 0
        tmpval = tileTags[idx1]
        tileTags[idx1] = tileTags[idx2]
        tileTags[idx2] = tmpval
    }
    
    //タイルをかき混ぜる
    private func shuffle() {
        //tileTagsを交換する
        var emptyTileIdx:Int = -1
        for _ in 0..<numOfSwap {
            //まず０を見つける
            for j in 0..<16 {
                if (tileTags[j] == 0) {emptyTileIdx = j}
            }
            let x = emptyTileIdx % 4;
            let y = emptyTileIdx / 4;
            let dir = arc4random()%4;
            switch (dir) {
            case 0:
                if (x > 0) {tileSwap(emptyTileIdx - 1, idx2: emptyTileIdx);break;}
            case 1:
                if (x < 3) {tileSwap(emptyTileIdx, idx2: emptyTileIdx + 1);break;}
            case 2:
                if (y > 0) {tileSwap(emptyTileIdx - 4, idx2: emptyTileIdx);break;}
            case 3:
                if (y < 3) {tileSwap(emptyTileIdx, idx2: emptyTileIdx + 4);break;}
            default:
                print("ここは通らない")
            }
        }
        //ビューに反映する（左上から順に配置していく）
        for idx in 0..<self.numOfTiles {
            var tmpTile:Tile
            if tileTags[idx]==0 {
                tmpTile = tiles[15] //tiles[15]は空タイルが格納されている
            }else {
                //tilesには数字付きのタイルが格納されている。タグはタイル初期生成時に＋１されているので、−１する。
                tmpTile = tiles[tileTags[idx]-1]
            }
            //タイルを置き直す
            tmpTile.frame = CGRect(x: fOrigin.x + tileSize*CGFloat(idx%4), y: fOrigin.y + tileSize*CGFloat(idx/4), width:tileSize, height:tileSize)
        }
    }
    
    //完成チェック。完成の場合true、未完成の場合falseを返す。
    private func checkFinish() -> Bool {
        //要素0から14まで、tagが1から15まで順に格納されている。
        for i in 0..<numOfTiles-1 {
            if tileTags[i] != i+1 {return false}
        }
        //tileTagsの最後が０（１５枚目まであっていれば自明なので、本当は必要ない）
        if tileTags[numOfTiles-1] != 0 {return false};
        
        //全部合っていたらtrueを返す。
        return true;
    }
    
    //リプレイ問い合わせ用アラート
    func rePlay(sender: AnyObject){
        //アクションシートを作る
        let alertController = UIAlertController(title: "完成！", message: "リプレイしますか？", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "もう一度やる", style: .Default, handler: { action in self.rePlayAction()}))
        
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .Default, handler: { action in self.cancelAction()}))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func rePlayAction(){
        //shuffleを再び呼ぶ
        shuffle()
    }
    func cancelAction(){
        //何もしない
    }
    
}

//Tileクラスを別ファイルで作成。継承元はUIControl
//現在は未使用
class Tile:UIControl{
    
}