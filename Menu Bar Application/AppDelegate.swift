//
//  AppDelegate.swift
//  Menu Bar Application
//
//  Created by Philipp Eibl on 8/6/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Cocoa
import CloudKit
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: NSUbiquitousKeyValueStore.defaultStore(), queue: NSOperationQueue.mainQueue()) { (notification) in
            let ubiquitousKeyValueStore = notification.object as! NSUbiquitousKeyValueStore
            Data.data = ubiquitousKeyValueStore.objectForKey("note")! as! String
            ubiquitousKeyValueStore.synchronize()
        }
        
        NSApplication.sharedApplication().activateIgnoringOtherApps(false)
        popover.behavior = NSPopoverBehavior.Transient
        
        if let button = statusItem.button {
            button.image = NSImage(named: "feather")
            button.action = Selector("togglePopover:")
            button
        }
        iCloudSetUp()
        popover.contentViewController = TextViewController(nibName: "TextViewController", bundle: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        saveToiCloud()
    }
    
    func applicationWillHide(notification: NSNotification) {
        saveToiCloud()
    }

    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
            saveToiCloud()
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func iCloudSetUp() {
        if let savedString = iCloudKeyStore?.stringForKey("note") {
            Data.data = savedString
            print(savedString)
        }
    }
    
    func saveToiCloud() {
        let iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
        
        iCloudKeyStore!.setString(Data.data, forKey: "note")
        iCloudKeyStore!.synchronize()
    }
}

