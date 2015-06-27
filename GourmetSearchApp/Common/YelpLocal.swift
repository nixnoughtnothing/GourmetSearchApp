//
//  YelpLocal.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 6/24/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import Foundation


/* APIから渡ってきたJSON Dataのパースに使用するSwiftJSONの値がOptional型を返すので、
   構造体Shop型のプロパティは基本的にすべてOptional型にする。こうすることでコード量を減らすことができる。
   Printableプロトコルついて => http://nekogata.hatenablog.com/entry/2014/12/19/060122
*/

public struct Shop : Printable {
    public var gid: String? = nil
    public var name: String? = nil
    public var photoUrl: String? = nil
    public var yomi: String? = nil
    public var tel: String? = nil
    public var address: String? = nil
    public var lat: Double? = nil
    public var lon: Double? = nil
    public var tagline: String? = nil
    public var hasCoupon = false
    public var location: String? = nil


    public var description: String{
        // Read-Only
        get{
            var string = "\nGid: \(gid)\n"
            string += "Name: \(name)\n"
            string += "PhotoUrl: \(photoUrl)\n"
            string += "Yomi: \(yomi)\n"
            string += "Tel: \(tel)\n"
            string += "Address: \(address)\n"
            string += "Lat & Lon \(lat), \(lon))\n"
            string += "tagline: \(tagline)\n"
            string += "hasCoupon:\(hasCoupon)\n"
            string += "Location: \(location)\n"
            return string
        }
    }
}

// added struct "Shop" in YelpLocal.swift
public struct QueryCondition{
    // キーワード
    public var query: String? = nil
    // 店舗ID
    public var gid: String? = nil
    // ソート順(列挙型で定義）
    public enum Sort: String{
        case BestMatched = "bestMatched"
        case Distance = "distance"
        case HighestRated = "highestRated"
    }
    public var sort: Sort = .BestMatched
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
            case    .BestMatched:
                params["sort"] = "Score"
            case    .Distance:
                params["sort"] = "Geo"
            case    .HighestRated:
                params["sort"] = "highestRated"
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
//            params["category_filter"] = "01"
            
            return params
        }
    }
}













