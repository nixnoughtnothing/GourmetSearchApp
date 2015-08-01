//
//  ShopListViewController.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 6/20/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit

class ShopListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    // MARK: - outlets -
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // yahooLocalSearchのインスタンスに現在表示している店舗の一覧を保持するために、APIリクエスト終了後もyahooLocalSearchのインスタンスを保存する必要がある。
    // 下記はそのためのプロパティ
    var yahooSearch:YahooLocalSearch = YahooLocalSearch()
    var loadDataObserver: NSObjectProtocol?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var qc = QueryCondition()
        qc.query = "ハンバーガー"
        yahooSearch = YahooLocalSearch(condition: qc)
        
        //読み込み完了通知を受信したときの処理
        loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            yahooSearch.YLSCompleteNotification,
            object: nil,
            queue: nil,
            usingBlock: {
                (notification) in
                
                // UITableViewの描画を再描写するメソッド
                // ここではAPIから店舗データを読み取り完了したところで実行しており、これによって、APIから取得した店舗データが画面表示に反映される
                self.tableView.reloadData()
                
                println("APIリクエスト終了")
                
                // エラーがあればダイアログを開く
                if notification.userInfo != nil{
                    if let userInfo = notification.userInfo as? [String: String!]{
                        if userInfo["error"] != nil{
                            let alertView = UIAlertController(
                                title: "通信エラー",
                                message: "通信エラーが発生しました",
                                preferredStyle: .Alert)
                            alertView.addAction(
                                UIAlertAction(title: "OK", style: .Default){
                                    action in return
                                }
                            )
                            self.presentViewController(alertView, animated: true, completion: nil)
                        }
                    }
                }
            }
        )
        
        yahooSearch.loadData(reset: true) // 初回のみresetパラメータをtrueに
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // 通知の待ち受けを終了
        NSNotificationCenter.defaultCenter().removeObserver(self.loadDataObserver!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate -
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100 // cellのheightを返す
    }
    
    // MARK: - UITableViewDataSource -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            // セルの数は店舗数
            return yahooSearch.shops.count
        }
        
        // 通常はここに到達しない
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // もし最初のsectionが0番目であるなら
        if indexPath.section == 0{
            if indexPath.row < yahooSearch.shops.count{
                // rowが店舗数以下なら店舗セルを返す
                let cell = tableView.dequeueReusableCellWithIdentifier("ShopListItem") as! ShopListItemTableViewCell
                cell.shop = yahooSearch.shops[indexPath.row]
                
                return cell
            }
        }
        // 通常は呼ばれない
        return UITableViewCell()
    }
    

}

