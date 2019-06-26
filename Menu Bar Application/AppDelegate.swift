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
    let window1 = NSWindow(contentRect: NSMakeRect(500,500,600,300), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, backing: NSBackingStoreType.Buffered, defer: false)

    func applicationDidFinishLaunching(notification: NSNotification) {
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        
        if launchedBefore  {
            print("not first launch")
            openMyWindow()

        } else {
            print("First launch, setting NSUserDefault.")
            //showTutorial()
            openMyWindow()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: NSUbiquitousKeyValueStore.defaultStore(), queue: NSOperationQueue.mainQueue()) { (notification) in
            let ubiquitousKeyValueStore = notification.object as! NSUbiquitousKeyValueStore
            Data.data = ubiquitousKeyValueStore.objectForKey("note")! as! String
            ubiquitousKeyValueStore.synchronize()
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named: "feather")
            button.action = #selector(AppDelegate.togglePopover(_:))
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
        }
    }
    
    func saveToiCloud() {
        let iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
        iCloudKeyStore!.setString(Data.data, forKey: "note")
        iCloudKeyStore!.synchronize()
    }
    
    func openMyWindow()
    {
        window1.backgroundColor             =   NSColor.whiteColor()
        window1.movableByWindowBackground   =   true
        window1.titlebarAppearsTransparent  =   true
        window1.titleVisibility             =   .Visible
        window1.showsToolbarButton          =   false
        window1.title = "Airnotes"
        window1.makeKeyAndOrderFront(self)
        
        let imageView = NSImageView(frame: NSMakeRect(0, 0, 600, 150))
        imageView.image = NSImage(named: "tutorialScreenshot")!
        imageView.display()
        window1.contentView!.addSubview(imageView)
        
        let textField: NSTextField = NSTextField(frame: NSMakeRect(50, 225, 500, 50))
        textField.stringValue = "Welcome to Airnotes! You can access your notes by clicking on the Airnotes icon in the menubar."
        textField.bezeled = false
        textField.drawsBackground = false
        textField.editable = false
        textField.selectable = false
        textField.textColor = NSColor.blackColor()
        textField.font = NSFont(name: "HelveticaNeue-Thin", size: 16)
        window1.contentView!.addSubview(textField)
        
        let myButton: NSButton = NSButton(frame: NSMakeRect(273, 180, 50, 25))
        myButton.title = "Got it."
        myButton.bezelStyle = .RoundRectBezelStyle
        myButton.target = self
        myButton.bordered = true
        myButton.layer?.backgroundColor = NSColor.greenColor().CGColor
        myButton.layer?.borderColor = NSColor.greenColor().CGColor
        myButton.layer?.cornerRadius = 5
        myButton.action =  #selector(self.gotItAction)
        window1.contentView!.addSubview(myButton)
    }
    
    func gotItAction() {
        window1.close()
    }
}

