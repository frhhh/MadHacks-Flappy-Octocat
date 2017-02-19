//
//  RandomFunction.swift
//  FlappyOctocat
//
//  Created by Frank Hu on 2017/2/19.
//  Copyright © 2017年 WeichuHu. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    
    public static func random() -> CGFloat{
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min : CGFloat, max : CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max - min) + min
    }
}
