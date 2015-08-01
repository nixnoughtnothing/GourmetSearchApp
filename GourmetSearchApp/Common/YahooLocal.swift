//
//  yahooLocal.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 6/24/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


/* APIから渡ってきたJSON Dataのパースに使用するSwiftJSONの値がOptional型を返すので、
   構造体Shop型のプロパティは基本的にすべてOptional型にする。こうすることでコード量を減らすことができる。
   Printableプロトコルついて => http://nekogata.hatenablog.com/entry/2014/12/19/060122
*/
// MARK: - APIから取得した店舗情報を格納するプロパティ一覧 -
public struct Shop : Printable {
    public var gid: String? = nil
    public var name: String? = nil
    public var photoUrl: String? = nil
    public var yomi: String? = nil
    public var tel: String? = nil
    public var address: String? = nil
    public var latitude: Double? = nil
    public var longitude: Double? = nil
    public var tagline: String? = nil
    public var hasCoupon = false
    public var station: String? = nil


    public var description: String{
        // Read-Only
        get{
            var string = "\nGid: \(gid)\n"
            string += "Name: \(name)\n"
            string += "PhotoUrl: \(photoUrl)\n"
            string += "Yomi: \(yomi)\n"
            string += "Tel: \(tel)\n"
            string += "Address: \(address)\n"
            string += "Latitude & Longiture \(latitude), \(longitude))\n"
            string += "tagline: \(tagline)\n"
            string += "hasCoupon:\(hasCoupon)\n"
            string += "station: \(station)\n"
            return string
        }
    }
}



// MARK: - 検索条件 -
public struct QueryCondition{
    // キーワード
    public var query: String? = nil
    // 店舗ID
    public var gid: String? = nil
    // ソート順(列挙型で定義）
    public enum Sort: String{
        case Score = "score"
        case Geo = "geo"
    }
    public var sort: Sort = .Score
    // 緯度
    public var latitude: Double? = nil
    // 経度
    public var longitude: Double? = nil
    // 距離
    public var distance: Double? = nil
    
    // 検索パラメータdictionary(コンピューテッドプロパティ)
    public var queryParams: [String: String]{
        // Read-Only
        get{
            var params = [String:String]()
            // key word
            if let unwrapped = query{
                params["query"] = unwrapped
            }
            // Shop ID
            if let unwrapped = gid{
                params["gid"] = unwrapped
            }
            // sort order
            switch sort{
            case    .Score:
                params["sort"] = "score"
            case    .Geo:
                params["sort"] = "geo"
            }
            // 緯度
            if let unwrapped = latitude{
                params["latitude"] = "\(unwrapped)"
            }
            // 経度
            if let unwrapped = longitude{
                params["longitude"] = "\(unwrapped)"
            }
            // 距離
            if let unwrapped = distance{
                params["distance"] = "\(unwrapped)"
            }
            // デバイス:mobile固定
            params["device"] = "mobile"
            // grouping:gid固定
            params["group"] = "gid"
            // 画像があるデータのみを検索する: true固定
            params["image"] = "true"
            // 業種コード:01(グルメ)固定
            params["gc"] = "01"
            
            return params
        }
    }
}



// MARK: - APIにアクセスするためのクラス -
public class YahooLocalSearch{
    // 読み込み開始Nofitication
    public let YLSLoadStartNotification = "YLSLoadStartNotification"
    // 読み込み完了Notification
    public let YLSCompleteNotification = "YLSLoadCompleteNotification"
    
    
    
    // yahooサーチAPIのアプリケーションID
    let apiId = "dj0zaiZpPUNHWm54MXNqa2FXMiZzPWNvbnN1bWVyc2VjcmV0Jng9NzE-"
    // APIのベースURL
    let apiURL = "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch"
    // 1ページのレコード数
    let perPage = 10
    // 読み込み済みの店舗
    public var shops = [Shop]()
    // trueだと読み込み中
    var loading = false
    // 全何件か
    public var total = 0
    
    //検索条件
    var condition: QueryCondition = QueryCondition(){
        // プロパティオブサーバ: 新しい値がセットされた後に読み込み済の店舗を捨てる
        // *didSetはプロパティの値が変更された後に呼ばれる
        didSet{
            shops = []
            total = 0
        }
    }
    
    // パラメータ無しのinitializer
    public init(){}
    
    // 検索条件をパラメータとして持つinitializer
    public init(condition: QueryCondition){self.condition = condition}

    
    // APIリクエスト実行開始を通知する
//    NSNotificationCenter.defaultCenter().postNotificationName("YLSLoadStartNotification",object:nil)
    
    // APIからデータを読み込む
    // reset = trueならデータを捨てて最初から読み込む
    public func loadData(reset: Bool = false){
        
        // 読み込み中ならなにもせずに帰る
        if loading{ return }
        
        // reset = trueなら今までの結果を捨てる
        if reset{
            shops = []
            total = 0
        }
        
        // API実行中フラグをON
        loading = true

        // 条件dictionaryを取得
        var params = condition.queryParams
        //　検索条件以外のAPIパラメータを設定
        params["appid"] = apiId
        params["output"] = "json"
        params["start"] = String(shops.count + 1)
        params["results"] = String(perPage)
        
        
        // API実行開始をオブザーバーに通知する
        NSNotificationCenter.defaultCenter().postNotificationName(YLSLoadStartNotification, object: nil)

        
        // APIリクエストを実行(https://github.com/SwiftyJSON/Alamofire-SwiftyJSONを参照)
        Alamofire.request(.GET, apiURL, parameters: params).responseSwiftyJSON({
            // リクエストが完了した時に実行されるクロージャ
            (request, response, json, error) -> Void in
        
            // エラーがあれば終了
            if error != nil{
                // API実行中フアグをOFF
                self.loading = false
                
                // API実行終了を通知する
                var message = "Unknown error."
                if let description = error?.description{
                    message = description
                }
                NSNotificationCenter.defaultCenter().postNotificationName(
                    self.YLSCompleteNotification,
                    object: nil,
                    userInfo: ["error":message]) // エラーメッセージも含めてオブザーバーへ渡す
                return
            }
        
            
            // 店舗データをself.shopsに追加する
            for(key,item) in json["Feature"]{
                var shop = Shop() // 構造体Shopをインスタンス化して変数shopに代入
                
                // 店舗ID
                shop.gid = item["Gid"].string
                // 店舗名
                var name = item["Name"].string
                // 'が&#39という形でエンコードされているのでデコードする
                shop.name = name?.stringByReplacingOccurrencesOfString("&#39",withString:"'",options: .LiteralSearch,range:nil)
                // Yomi
                shop.yomi = item["Property"]["Yomi"].string
                // tel
                shop.tel = item["Property"]["Tel1"].string
                // address
                shop.address = item["Property"]["Address"].string
                // 緯度と経度
                if let geometry = item["Geometry"]["Coordinates"].string{
                    let components = geometry.componentsSeparatedByString(",")
                    // 緯度
                    shop.latitude = (components[1] as NSString).doubleValue
                    // 経度
                    shop.longitude = (components[0] as NSString).doubleValue
                }
                // tagline
                shop.tagline = item["Property"]["CatchCopy"].string
                // 店舗写真
                shop.photoUrl =  item["Property"]["LeadImage"].string
                // クーポン有無
                if item["Property"]["CouponFlag"].string == "true"{
                    shop.hasCoupon = true
                }
                // Station
                if let stations = item["Property"]["Station"].array{
                    // 路線名
                    var line = ""
                    if let lineString = stations[0]["Railway"].string{
                        // componentsSeparatedByStringは文字列を指定した区切り文字列で分割するメソッド
                        let lines = lineString.componentsSeparatedByString("/")
                        line = lines[0]
                    }
                    // 駅名
                    if let station = stations[0]["Name"].string{
                        // 駅名と路線名があればここで両方入れる
                        shop.station = "\(line) \(station)"
                    } else{
                        // 駅名がなければ路線名のみ入れる
                        shop.station = "\(line)"
                    }
                }
                
                println(shop)
                self.shops.append(shop)
            }
            // 総件数を反映
            if let total = json["ResultInfo"]["Total"].int {
                self.total = total
            }else{
                self.total = 0
            }
            println(self.total)
            
            // API実行中フラグをOFF
            self.loading = false
            
            // API終了を通知する
            NSNotificationCenter.defaultCenter().postNotificationName(self.YLSCompleteNotification, object: nil)
        })
    }
}








