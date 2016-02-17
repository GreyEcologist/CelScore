//
//  SlideItBehavior.swift
//  CelScore
//
//  Created by Gareth.K.Mensah on 2/16/16.
//  Copyright © 2016 Gareth.K.Mensah. All rights reserved.
//

import UIKit

class SlideItBehavior: UIDynamicBehavior {

    //MARK: Properties
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    //MARK: Initializer
    init(rightDirection: Bool) {
        super.init()
        self.gravity.gravityDirection = CGVector(dx: rightDirection ? 0.7 : -0.7, dy: 0.0)
        self.gravity.magnitude = 2.5
        self.collider.addBoundaryWithIdentifier("barrier",
            fromPoint: CGPoint(x: rightDirection ? Constants.kDetailWidth : 2 * Constants.kPadding, y: 0),
            toPoint: CGPoint(x: rightDirection ? Constants.kDetailWidth : 2 * Constants.kPadding, y: Constants.kScreenHeight))
        addChildBehavior(gravity)
        addChildBehavior(collider)
    }
    
    //MARK: Methods
    func addSlide(slide: UIView) {
        dynamicAnimator?.referenceView?.addSubview(slide)
        gravity.addItem(slide)
        collider.addItem(slide)
    }
    
    func removeSlide(slide: UIView) {
        gravity.removeItem(slide)
        collider.removeItem(slide)
        slide.removeFromSuperview()
    }
}
