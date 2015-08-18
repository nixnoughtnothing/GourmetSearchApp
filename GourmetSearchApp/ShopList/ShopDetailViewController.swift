//
//  ShopDetailViewController.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 8/7/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController,UIScrollViewDelegate {

    // MARK: - IBOutlet -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var shop = Shop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Photo
        if let url = shop.photoUrl{
            photo.sd_setImageWithURL(NSURL(string: url),
                placeholderImage: UIImage(named: "loading"),
                options:nil)
        }else{
            photo.image = UIImage(named: "loading")
        }
        
        // Shop name
        name.text = shop.name
        
        // tel
        tel.text = shop.tel
        
        // Addiress
        address.text = shop.address
        
        // お気に入り状態をボタンラベルに反映
        updateFavoriteButton()
    }
    
    
    // MARK: - アプリケーションロジック
    // 表示中の店舗がお気に入りに入っているかを調べ、
    // その状態をお気に入りアイコンとラベルの文字列に反映させている
    func updateFavoriteButton(){
        if Favorite.inFavorites(shop.gid){
            // お気に入りに入っている
            favoriteIcon.image = UIImage(named: "star-on")
            favoriteLabel.text = "UnFavorite"
        }else{
            // お気に入りに入っていない
            favoriteIcon.image = UIImage(named: "star-off")
            favoriteLabel.text = "Favorite"
        }
    }
    
    
    // ShopDetailViewControllerのviewが表示される前にcallされる
    override func viewWillAppear(animated: Bool) {
        self.scrollView.delegate = self
        super.viewWillAppear(animated)
    }
    
    // ShopDetailViewControllerのviewが非表示になった後にCallされる
    override func viewDidDisappear(animated: Bool) {
        self.scrollView.delegate = nil // delegateを解除
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // 店舗名や住所の高さを動的に変える(viewDidLayoutSubviewsはAutoLayoutの制約に従ってビューが配置された後に実行されるメソッド)
    override func viewDidLayoutSubviews() {
        let nameFrame = name.sizeThatFits(CGSizeMake(name.frame.width, CGFloat.max))
        nameHeight.constant = nameFrame.height
        
        let addressFrame = address.sizeThatFits(CGSizeMake(address.frame.width, CGFloat.max))
        addressContainerHeight.constant = addressFrame.height
        
        view.layoutIfNeeded()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 初期位置からどれだけ移動したかを計算(scrollView.contentOffset.yの初期値は-64、なので、scrollView.contentInset.top(navigationbarとstatusbar,64px)を足して0に戻す
        let scrollOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        
        // もし初期状態よりも下にスクロールされた場合(scrollOffsetは マイナスの値になる)
        if scrollOffset <= 0{
            photo.frame.origin.y      = scrollOffset // 常にy座標をViewのtopに固定
            photo.frame.size.height   = 200 - scrollOffset // scrolloffsetの分heightを伸ばす
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func telTapped(sender: UIButton) {
        println("telTapped")
    }

    @IBAction func addressTapped(sender: UIButton) {
        println("addressTapped")
    }
    @IBAction func favoriteTapped(sender: UIButton) {
        println("favoriteTapped")
        // お気に入りセル: お気に入り状態を変更する
        Favorite.toggle(shop.gid)
        updateFavoriteButton()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
