//
//  TextViewController.swift
//  Menu Bar Application
//
//  Created by Philipp Eibl on 8/6/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Cocoa
import CloudKit

class TextViewController: NSViewController, NSTextViewDelegate, NSPopoverDelegate {
    
    @IBOutlet var customView: NSView!
    @IBOutlet var textView: NSScrollView!
    @IBOutlet var mainView: NSView!
    @IBOutlet var logoButton: NSButton!
    @IBOutlet var realTextView: NSTextView!
    @IBAction func logoButtonPressed(sender: NSButton) {

    }
    @IBOutlet var hideButton: NSButton!
    @IBAction func hideButtonPressed(sender: NSButton) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.togglePopover(sender)
    }
    @IBOutlet var settingsButton: NSPopUpButton!
    
    func showFontMenu(sender: AnyObject) {
        let fontManager = MyManager()
        fontManager.delegate = self
        let fontPanel = fontManager.fontPanel(true)
        fontManager.target = realTextView
        fontPanel!.makeKeyAndOrderFront(sender)
        realTextView.selectAll(nil)
        
    }
    
    let settingsPopover = NSPopover()
    let popover = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        logoButton.bordered = false
        realTextView.layer?.cornerRadius = 5
        realTextView.usesFontPanel = true
        realTextView.font? = Settings.font
        logoButton.bezelStyle = .HelpButtonBezelStyle
        realTextView.delegate = self
        
        view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        customView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        if Data.data != "" { realTextView.string = Data.data }
        
        settingsButton.removeAllItems()
        settingsButton.addItemsWithTitles(["","Share on Facebook","Customize font","Copy link","Quit Airnotes"])
        settingsButton.itemAtIndex(0)?.image = NSImage(named: "settingsIcon")
        settingsButton.itemAtIndex(1)?.image = NSImage(named: "")
        settingsButton.itemAtIndex(2)?.image = NSImage(named: "changeFontIcon")
        settingsButton.itemAtIndex(3)?.image = NSImage(named: "")
        settingsButton.itemAtIndex(1)?.target = self
        settingsButton.itemAtIndex(1)?.action = #selector(self.shareOnFacebook)
        settingsButton.itemAtIndex(2)?.target = self
        settingsButton.itemAtIndex(2)?.action = #selector(self.showFontMenu(_:))
        settingsButton.itemAtIndex(3)?.target = self
        settingsButton.itemAtIndex(3)?.action = #selector(self.copyLink)
        settingsButton.itemAtIndex(4)?.target = self
        settingsButton.itemAtIndex(4)?.action = #selector(self.quitAirnotes)
    }
    
    func copyLink() {
        NSPasteboard.generalPasteboard().clearContents()
        NSPasteboard.generalPasteboard().setString("https://itunes.apple.com/at/app/airnotes/id1141710809?l=en&mt=12", forType: NSStringPboardType)
    }
    
    func shareOnFacebook() {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.facebook.com/sharer.php?src=sp&u=https%3A%2F%2Fitunes.apple.com%2Fat%2Fapp%2Fairnotes%2Fid1141710809?l=en&mt=12%2F")!)
    }
    
    func quitAirnotes() {
        NSApp.terminate(nil)
    }
    
    @objc func textDidChange(notification: NSNotification) { //Handle the text changes here
        Data.data = self.realTextView.textStorage!.string //the textView parameter is the textView where text was changed
    }
}
