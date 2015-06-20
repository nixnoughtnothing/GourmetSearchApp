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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate -
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100 // cellのheightを返す
    }
    
    // MARK: - UITableViewDataSource -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 // sectionの中のrowの数を返す
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // もし最初のsectionが0であるなら
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("ShopListItem") as! ShopListItemTableViewCell // dequeueReusable〜メソッドはAnyobject型を返すのでキャストしておく
            cell.name.text = "\(indexPath.row)" // 一旦cellのname labelのtextに列番号を代入
            return cell
        }
        // 通常は呼ばれない
        return UITableViewCell()
    }
    

}

