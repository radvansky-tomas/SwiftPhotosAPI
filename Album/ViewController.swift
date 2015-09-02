//
//  ViewController.swift
//  Album
//
//  Created by Tomas Radvansky on 31/08/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

import UIKit
import Photos

class ViewController: UITableViewController {
    
    var assetsFetchResults:PHFetchResult?
    var assetCollection:PHAssetCollection?
    
    let imageManager:PHCachingImageManager = PHCachingImageManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.assetsFetchResults != nil
        {
            return self.assetsFetchResults!.count
        }
        else
        {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ImageCell")!
        let imgView:UIImageView = cell.viewWithTag(100) as! UIImageView
        let asset:PHAsset = self.assetsFetchResults![indexPath.item] as! PHAsset
        self.imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(tableView.frame.width, 100.0), contentMode: PHImageContentMode.AspectFill, options: nil) { (img:UIImage?, info:[NSObject : AnyObject]?) -> Void in
            imgView.image = img
        }
        return cell
    }

    @IBAction func MenuBtnClicked(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}

