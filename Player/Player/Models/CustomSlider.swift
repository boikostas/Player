//
//  CustomSlider.swift
//  Player
//
//  Created by Стас Бойко on 10.12.2022.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
  
  //To set line height value from IB, here ten is default value
  @IBInspectable var trackLineHeight: CGFloat = 7
  
  //To set custom size of track so here override trackRect function of slider control
  override func trackRect(forBounds bound: CGRect) -> CGRect {
    //Here, set track frame
    return CGRect(origin: bound.origin, size: CGSize(width: bound.width, height: trackLineHeight))
  }
}
