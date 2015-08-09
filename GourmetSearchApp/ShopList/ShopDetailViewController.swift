//
//  ShopDetailViewController.swift
//  GourmetSearchApp
//
//  Created by nixnoughtnothing on 8/7/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
