//
//  StringExt.swift
//  BBQuotes18
//
//  Created by Apple on 25/10/24.
//

extension String{
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeSpaceAndLowerCase() -> String {
        self.removeSpaces().lowercased()
    }
    
    func replaceSpaceByPlus() -> String{
        self.replacingOccurrences(of: " ", with: "+")
    }
}
