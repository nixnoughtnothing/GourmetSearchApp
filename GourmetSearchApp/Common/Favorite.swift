//
//  Favorite.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 8/10/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import Foundation

public struct Favorite {
    
    public static var favorites = [String]()
    
    public static func load(){
        let ud = NSUserDefaults.standardUserDefaults()
        ud.registerDefaults(["Favorites":[String]()]) // NSUserDefaultsのデフォルト値を設定
        favorites = ud.objectForKey("favorites") as! [String]
    }
    
    
    
    
    public static func save(){
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(favorites, forKey: "favorites")
        ud.synchronize()
    }
    
    
    
    public static func add(gid: String?){
        if gid == nil || gid == "" {
            return
        }
        
        // contains関数は第2引数の値が第1引数の配列の要素の中に含まれているか調べる関数
        if contains(favorites, gid!){
            // 含まれていたらそのidを配列から取り除く
            remove(gid!)
        }

        // 配列になければ、配列に追加し、保存
        favorites.append(gid!)
        save()
    }
    
    
    public static func remove(gid: String?){
        if gid == nil || gid == ""{
            return
        }
        
        if let index = find(favorites, gid!){
            favorites.removeAtIndex(index)
        }
        save()
    }
        
    
    public static func toggle(gid: String?){
        if gid == nil || gid == ""{
            return
        }
        
        if inFavorites(gid!){
            remove(gid!)
        }else{
            add(gid!)
        }
    }
    
    public static func inFavorites(gid: String?) -> Bool{
        if gid == nil || gid == ""{
            return false
        }
        
        // 配列Favoritesの中にgidが含まれるならばtrueを返す
        return contains(favorites,gid!)
        
    }
    
    public static func move(sourceIndex: Int, destinationIndex: Int){
        if sourceIndex >= favorites.count || destinationIndex >= favorites.count{
            return
        }
        
        let srcGid = favorites[sourceIndex]
        favorites.removeAtIndex(sourceIndex)
        favorites.insert(srcGid, atIndex: destinationIndex)
        
        save()
    }
    
}