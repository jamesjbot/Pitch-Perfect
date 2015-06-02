//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by James Jongsurasithiwat on 5/31/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init (filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}