//
//  SettingsViewController.swift
//  Airnotes
//
//  Created by Philipp Eibl on 8/22/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import Cocoa

class SettingsViewController: NSMenu, NSPopoverDelegate {
    let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
    let window1 = NSWindow(contentRect: NSMakeRect(500,500,600,300), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, backing: NSBackingStoreType.Buffered, defer: false)

    @IBOutlet var shareButton: NSButton!
    @IBAction func shareButtonPressed(sender: NSButton) {
        NSPasteboard.generalPasteboard().clearContents()
        NSPasteboard.generalPasteboard().setString("https://itunes.apple.com/at/app/airnotes/id1141710809?l=en&mt=12", forType: NSStringPboardType)
    }
    @IBOutlet var changeFontButton: NSButton!
    @IBAction func changeFontButtonPressed(sender: NSButton) {
        
    }
    @IBOutlet var quitAirnotesButton: NSButton!
    @IBAction func quitAirnotesButtonPressed(sender: NSButton) {
        NSApp.terminate(sender)
    }
}