//
//  SearchTopTableViewController.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 8/2/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit

class SearchTopTableViewController: UITableViewController,UITextFieldDelegate {
    var freeword: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("Freeword", forIndexPath: indexPath) as! FreewordTableViewCell
            
            // UITextFieldへの参照を保存しておく
            freeword = cell.freeword
            // UITextFieldDelegateを自身に設定
            cell.freeword.delegate = self
            // タップを無視
            cell.selectionStyle = .None // Textfieldがタップを受けるので、cell自体のtapは無視させる
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITextFieldDelegate
    
    // UITextFieldDelegateによってUITextFieldで検索キーがタップされたときに実行されるメソッド
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // キーボードを消すメソッド
        textField.resignFirstResponder()
        // 名前を指定してsegueを実行するメソッド (画面遷移する）
        performSegueWithIdentifier("PushShopList", sender: self)
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        // TextFieldの編集状態を終了し、キーボードを隠すメソッド
        freeword?.resignFirstResponder()
    }

    // MARK: - Navigation
    
    // segueによる画面遷移のときに次の画面にparametaを渡したいときに使うメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushShopList" {
            let vc = segue.destinationViewController as! ShopListViewController // 遷移先のコントローラを取得
            vc.yahooSearch.condition.query = freeword?.text // queryプロパティに検索条件を設定している
        }
    }
}
