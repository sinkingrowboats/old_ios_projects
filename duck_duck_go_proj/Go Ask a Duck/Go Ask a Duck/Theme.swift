//
//  Theme.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/11/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

enum themeTypes {
    case Default, Night
}

class Theme {
    var theme: themeTypes = .Default

    //- Attribution: https://www.raywenderlich.com/108766/uiappearance-tutorial How to use UIAppearance
    func setColors() {
        let summer = UIColor.init(red: 219/255, green: 237/255, blue: 161/255, alpha: 1)
        let fog = UIColor.init(red: 61/255, green: 136/255, blue: 170/255, alpha: 1)
        let dusk = UIColor.init(red: 82/255, green: 99/255, blue: 122/255, alpha: 1)
        let stars = UIColor.init(red: 247/255, green: 242/255, blue: 187/255, alpha: 1)
        
        switch theme {
        case .Default:
            let sharedApplication = UIApplication.shared
            sharedApplication.delegate?.window??.tintColor = fog
            UINavigationBar.appearance().barTintColor = summer
            UINavigationBar.appearance().tintColor = UIColor.black
            UIToolbar.appearance().barTintColor = summer
            UISearchBar.appearance().barTintColor = summer
        case .Night:
            let sharedApplication = UIApplication.shared
            sharedApplication.delegate?.window??.tintColor = stars
            UINavigationBar.appearance().barTintColor = dusk
            UINavigationBar.appearance().tintColor = UIColor.white
            UIToolbar.appearance().barTintColor = dusk
            UISearchBar.appearance().barTintColor = dusk
            
        }
    }
}
