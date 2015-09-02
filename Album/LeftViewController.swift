//
//  LeftViewController.swift
//  Album
//
//  Created by Tomas Radvansky on 31/08/2015.
//  Copyright © 2015 Radvansky Solutions. All rights reserved.
//

import UIKit
import KVNProgress
import Photos

class LeftViewController: UITableViewController {
    
    var collectionsFetchResults:NSMutableArray = NSMutableArray()
    let collectionsLocalizedTitles:Array<String> = ["Smart Albums","Albums"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LoadAlbums()
        // Adds a status below the circle
        
    }
    
    func LoadAlbums()
    {
        KVNProgress.showWithStatus("Loading Albums...")
        collectionsFetchResults.removeAllObjects()
        let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumRegular, options: nil)
        let topLevelUserCollections:PHFetchResult = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        self.collectionsFetchResults = [smartAlbums, topLevelUserCollections]
        self.tableView.reloadData()
        KVNProgress.dismiss()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + self.collectionsFetchResults.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if (section == 0) {
            numberOfRows = 1 // "All Photos" section
        } else {
            let fetchResult:PHFetchResult = self.collectionsFetchResults[section-1] as! PHFetchResult
            numberOfRows = fetchResult.count
        }
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
        let label:UILabel = cell.viewWithTag(100) as! UILabel
        if (indexPath.section == 0) {
            label.text = "All Photos"
        }
        else
        {
            let fetchResult:PHFetchResult = self.collectionsFetchResults[indexPath.section-1] as! PHFetchResult
            let collection:PHCollection = fetchResult[indexPath.row] as! PHCollection
            label.text = collection.localizedTitle
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainNavVC:UINavigationController = self.slideMenuController()?.mainViewController as! UINavigationController
        let mainVC:ViewController = mainNavVC.viewControllers[0] as! ViewController
        if indexPath.section == 0
        {
            //All Photos
            // Fetch all assets, sorted by date created.
            let options:PHFetchOptions = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            mainVC.assetsFetchResults = PHAsset.fetchAssetsWithOptions(options)
        }
        else
        {
            let fetchResult:PHFetchResult = self.collectionsFetchResults[indexPath.section - 1] as! PHFetchResult
            let collection:PHCollection? = fetchResult[indexPath.row] as? PHCollection
            if let assetCol:PHAssetCollection = collection as? PHAssetCollection
            {
                let assetsFetchResult:PHFetchResult = PHAsset.fetchAssetsInAssetCollection(assetCol, options: nil)
                mainVC.assetsFetchResults = assetsFetchResult
                mainVC.assetCollection = assetCol
            }
        }
        mainVC.tableView.reloadData()
        self.slideMenuController()?.closeLeft()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String?
        if (section > 0) {
            title = self.collectionsLocalizedTitles[section - 1]
        }
        return title
    }
}
