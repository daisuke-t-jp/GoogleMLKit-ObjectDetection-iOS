//
//  OverlayView.swift
//  GoogleMLKit-ObjectDetection-iOS
//
//  Created by Daisuke TONOSAKI on 2021/02/22.
//

import UIKit


struct OverlayObject {
    let rect: CGRect
    let color: UIColor
}


class OverlayView: UIView {
    private static let lineWidth: CGFloat = 5
    
    var overlayObjects: [OverlayObject] = []
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for overlay in overlayObjects {
            let path = UIBezierPath(rect: overlay.rect)
            path.lineWidth = OverlayView.lineWidth
            overlay.color.setStroke()
            
            path.stroke()
        }
    }
    
}
