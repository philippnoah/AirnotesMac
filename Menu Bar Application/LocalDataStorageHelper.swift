//
//  LocalDataStorageHelper.swift
//  Airnotes
//
//  Created by Philipp Eibl on 8/9/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation

class LocalDataStorageHelper {

    static func write() {
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
    
    static func read() {
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
}