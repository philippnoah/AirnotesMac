//
//  AppDelegate.swift
//  Menu Bar Application
//
//  Created by Philipp Eibl on 8/6/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        read()
        NSApplication.sharedApplication().activateIgnoringOtherApps(false)
        popover.behavior = NSPopoverBehavior.Transient
        
        if let button = statusItem.button {
            button.image = NSImage(named: "feather")
            button.action = Selector("togglePopover:")
            button
        }
        
        popover.contentViewController = TextViewController(nibName: "TextViewController", bundle: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        write()
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func read() {
        let file = "/airnotes/file.txt" //this is the file. we will write to and read from it
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            //reading
            do {
                let text = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
                print(text)
                Data.data = text as String
            }
            catch {/* error handling here */
                print("reading error")
            }
        }
        
    }
    
    func write() {
        let file = "/airnotes/file.txt" //this is the file. we will write to and read from it
        
        let text = Data.data
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            //writing
            do {
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                print("writing succeeded")
            }
            catch {/* error handling here */
                print("writing error")
                
                do {
                    let manager = NSFileManager.defaultManager()
                    try manager.createDirectoryAtPath(dir + "/airnotes", withIntermediateDirectories: true, attributes: nil)
                        print("shouldve created dir")
                
                    try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                } catch {
                    print("oh god - ")
                }
            }
        }
        else {
            print("couldnt find dir i guess")
        }
    }
}

