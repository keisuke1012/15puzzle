//
//  LoaderFile.swift
//  15パズル
//
//  Created by 輝幸友金 on 2016/01/11.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class LoaderFile {
    
    var cells: String! = ""
    
    func csvLoedar(indx: Int) ->String{
        
        if let csvPath = NSBundle.mainBundle().pathForResource("sample", ofType: "csv"){
            var csvString = ""
            var attr: [String]
            
            do{
                csvString = try NSString(contentsOfFile: csvPath, encoding:NSUTF8StringEncoding) as String
                attr = csvString.componentsSeparatedByString(",")
                cells = attr[indx]
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
        return cells!
    }
}
