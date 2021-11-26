//
//  ShareViewController.swift
//  SendToKodiAction
//
//  Created by Tobias Tangemann on 15.01.16.
//  Copyright © 2016 Tobias Tangemann. All rights reserved.
//  Updated by Max Grass to support SendToKodi of firsttris on 17.03.18.

import Cocoa

class ShareViewController: NSViewController {
    @IBOutlet weak var progress: NSProgressIndicator!
    
    override func loadView() {
        super.loadView()
        
        progress.startAnimation(nil)
        
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
            if let attachment = item.attachments?.first,
               attachment.hasItemConformingToTypeIdentifier("public.url") {
                attachment.loadObject(ofClass: NSURL.self, completionHandler: {(res, err) in
                    self.sendRequestToKodi(res as! URL)
                })
            }
            else {
                let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
                self.extensionContext!.cancelRequest(withError: cancelError)
            }
        }
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        progress.stopAnimation(nil)
        
        self.extensionContext!.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
    }
    
    func sendRequestToKodi(_ url: URL) {
        Utils.sendRequestToKodi(url, completionHandler: {
            
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
            
        }) { (Error) in
            
            self.extensionContext!.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
        }
    }
}
