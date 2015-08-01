//
//  ShopListItemTableViewCell.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 6/20/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit

class ShopListItemTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var stationWidth: NSLayoutConstraint!
    @IBOutlet weak var stationX: NSLayoutConstraint!
    
    
    var shop: Shop = Shop(){
        didSet {
            // URLがあれば画像を表示する
            if let url = shop.photoUrl{
                photo.sd_cancelCurrentImageLoad() // セルを再利用するので、以前の画像ロードが遅延してたら、事前にロードをキャンセルしておく
                // SDWebImageによるUIImageを拡張したメソッド
                photo.sd_setImageWithURL(
                    NSURL(string: url),
                    placeholderImage: UIImage(named: "loading"),
                    options: .RetryFailed // 読み込み失敗時に再試行するオプション
                )
            }
            
            
            // 店舗名をラベルに設定
            name.text = shop.name
            
            // クーポン表示
            var x: CGFloat = 0
            let margin: CGFloat = 10
            
            if shop.hasCoupon {
                coupon.hidden = false
                x += coupon.frame.width + margin
                // ラベルを角丸にする
                coupon.layer.cornerRadius = 4
                // 文字がラベルからはみ出さないようにする
                coupon.clipsToBounds = true
            }else {
                coupon.hidden = true
            }
            
            
            
            
            // 駅表示
            if shop.station != nil{
                station.hidden = false
                station.text = shop.station
                // ラベルの位置を設定する
                stationX.constant = x
                // ラベルの幅を計算する
                let labelSize = station.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max))
                if x + labelSize.width + margin > iconContainer.frame.width{
                    // ラベルの幅が右端を超える場合、最大サイズを設定する
                    stationWidth.constant = iconContainer.frame.width - x
                }else{
                    // ラベルの幅が右端を超えない場合そのまま設定する
                    stationWidth.constant = labelSize.width + margin
                }
                // ラベルを角丸にする
                station.clipsToBounds = true
                station.layer.cornerRadius = 4
            }else{
                // shop.stationがnilなら表示しない
                station.hidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // ビューがautolayoutによって配置されたあとに実行されるメソッド
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 行数を最大2行に限定してラベルの高さを計算する
        let maxFrame = CGRectMake(0, 0, name.frame.width, name.frame.height)
        let actualFrame = name.textRectForBounds(maxFrame, limitedToNumberOfLines: 2)
        
        // 計算したサイズを設定する
        nameHeight.constant = actualFrame.height
    }

}
