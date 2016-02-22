//
//  ViewController.swift
//  CollectionView
//
//  Created by Peter Lafferty on 16/09/2015.
//  Copyright © 2015 Peter Lafferty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var emoji: Emoji?
    let skinTones = ["🏿", "🏾", "🏽", "🏼", "🏻", ""]
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let e = emoji else {
            return
        }
        
        //self.title = e.value
        
        self.value.text = e.value

        var items = [UIBarButtonItem]()
        
        if e.hasSkinTone {
            for tone in skinTones {
                items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))

                let barButtonItem = UIBarButtonItem(
                    title: emoji!.value + tone,
                    style: UIBarButtonItemStyle.Plain,
                    target: self,
                    action: "updateSkinTone:"
                )
                
                items.append(barButtonItem)
                items.append(
                    UIBarButtonItem(
                        barButtonSystemItem: .FlexibleSpace,
                        target: nil,
                        action: nil
                    )
                )
            }
        } else {
            //make sure the share button is on the right
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }

        //add button for sharing
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "share"
        )
        items.append(shareButton)
        
        self.toolbarItems = items
        
        self.desc.text = "Description: " + e.description
        self.tags.text = "Tags: " + e.tags.joinWithSeparator(", ")
        
        if e.version.isEmpty == false {
            self.version.text = "From Unicode: " + e.version
        } else {
            self.version.text = ""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSkinTone(sender:AnyObject) {
        if let button = sender as? UIBarButtonItem {
            self.value.text = button.title
        }
    }
    
    func share(){
        guard let e = emoji else {
            return
        }
        
        UIPasteboard.generalPasteboard().string = e.value

        let textToShare = "\(e.value), \(e.description) @emojirama https://appsto.re/ie/4b-q-.i"
        print(textToShare)
        
        let objectsToShare = [textToShare, screenshot()]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func screenshot() -> NSData {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageJPEGRepresentation(image, 0.7)!
    }
    
    @IBAction func copyEmoji(sender: AnyObject) {
        guard let e = emoji else {
            return
        }
        UIPasteboard.generalPasteboard().string = e.value
    }
    
}

