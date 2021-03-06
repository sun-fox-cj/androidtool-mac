//
//  ObbHandler.swift
//  AndroidTool
//
//  Created by Morten Just Petersen on 1/20/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol ObbHandlerDelegate {
    func obbHandlerDidStart(bytes:String)
    func obbHandlerDidFinish()
}

class ObbHandler: NSObject {
    var filePath:String!
    var delegate:ObbHandlerDelegate?
    var device:Device!
    var fileSize:UInt64?
    
    init(filePath:String, device:Device){
        print(">>obb init obbhandler")
        super.init()
        self.filePath = filePath
        self.device = device
        self.fileSize = Util.getFileSizeForFilePath(filePath)
    }
    
    func pushToDevice(){
        print(">>zip flash")

        let shell = ShellTasker(scriptFile: "installObbForSerial")
        let bytes = (fileSize != nil) ? Util.formatBytes(fileSize!) : "? bytes"
        
        delegate?.obbHandlerDidStart(bytes)
        
        print("startin obb copying the \(bytes) file")
        shell.run(arguments: [self.device.adbIdentifier!, self.filePath]) { (output) -> Void in
            print("done copying OBB to device")
            self.delegate?.obbHandlerDidFinish()
        }
    }

}

