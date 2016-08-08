//
//  TextViewController.swift
//  Menu Bar Application
//
//  Created by Philipp Eibl on 8/6/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Cocoa

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
        //view.layer?.backgroundColor = NSColor(red:0.94, green:0.94, blue:0.94, alpha:1.0).CGColor
        //customView.layer?.backgroundColor = NSColor(red:0.94, green:0.94, blue:0.94, alpha:1.0).CGColor

        if Data.data != "" { realTextView.string = Data.data }
        
    }
    
    func showPopover(sender: AnyObject?) {
            //popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
            popover.showRelativeToRect(logoButton.bounds, ofView: logoButton, preferredEdge: NSRectEdge.MinY)
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func textView(textView: NSTextView, shouldChangeTextInRange affectedCharRange: NSRange, replacementString: String?) -> Bool {
        Data.data = self.realTextView.textStorage!.string
        return true
    }
    
}
