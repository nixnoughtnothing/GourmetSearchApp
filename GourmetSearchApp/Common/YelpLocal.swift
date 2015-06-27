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
        // 下記は読み取り専用
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