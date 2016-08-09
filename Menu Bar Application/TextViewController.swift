//
//  TextViewController.swift
//  Menu Bar Application
//
//  Created by Philipp Eibl on 8/6/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Cocoa
import CloudKit

class TextViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet var customView: NSView!
    @IBOutlet var textView: NSScrollView!
    @IBOutlet var mainView: NSView!
    @IBOutlet var logoButton: NSButton!
    @IBOutlet var realTextView: NSTextView!
    @IBOutlet var quitButton: NSButton!
    @IBAction func quitButtonPressed(sender: NSButton) {
        NSApp.terminate(self)
    }
    @IBAction func hideButtonPressed(sender: NSButton) {
        NSApp.hide(self)
    }
    @IBAction func logoButtonPressed(sender: NSButton) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    let popover = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do view setup here.
        popover.contentViewController = InfoViewController(nibName: "InfoViewController", bundle: nil)
        logoButton.bordered = false
        realTextView.layer?.cornerRadius = 5
        logoButton.bezelStyle = .HelpButtonBezelStyle
        realTextView.delegate = self
        
        view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        customView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        if Data.data != "" { realTextView.string = Data.data }
        
    }
    
    func showPopover(sender: AnyObject?) {
        //popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        popover.showRelativeToRect(logoButton.bounds, ofView: logoButton, preferredEdge: NSRectEdge.MinY)
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    @objc func textDidChange(notification: NSNotification) { //Handle the text changes here
        Data.data = self.realTextView.textStorage!.string //the textView parameter is the textView where text was changed
    }
    
}
