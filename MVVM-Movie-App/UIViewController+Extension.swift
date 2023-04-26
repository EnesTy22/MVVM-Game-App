//
//  UIViewController+Extension.swift
//  MVVM-Movie-App
//
//  Created by Enes Talha Yılmaz on 21.04.2023.
//

import UIKit
extension UIViewController
{
    static var identifier : String{
        return String(describing: self)
    }
    static func instantiate()->Self{
        let storyboard = UIStoryboard(name:"Main",bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
