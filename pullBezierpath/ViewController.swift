//
//  ViewController.swift
//  pullBezierpath
//
//  Created by Daniel Hjärtström on 2018-07-16.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var shapeLayer: CAShapeLayer!
    var animatedPath: UIBezierPath = UIBezierPath()
    var path: UIBezierPath!

    private lazy var panGesture: UIPanGestureRecognizer = {
        let temp = UIPanGestureRecognizer()
        temp.addTarget(self, action: #selector(didPan(_:)))
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(panGesture)
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.minX, y: view.frame.maxY / 2))
        path.addQuadCurve(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY / 2), controlPoint: CGPoint(x: view.frame.maxX / 2, y: view.frame.maxY / 2))

        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 4.0
        shapeLayer.frame = view.bounds
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1.0
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)

        switch sender.state {
        case .began, .changed:
            moveLineWithTranslation(translation)
        case .ended:
            animateToOrigin()
        default:
            break
        }
    }
    
    func moveLineWithTranslation(_ translation: CGPoint) {
        animatedPath = UIBezierPath()
        animatedPath.move(to: CGPoint(x: view.frame.minX, y: view.frame.maxY / 2))
        animatedPath.addQuadCurve(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY / 2), controlPoint: CGPoint(x: translation.x + view.frame.maxX / 2, y: translation.y + view.frame.maxY / 2))
        shapeLayer.path = animatedPath.cgPath
        shapeLayer.layoutIfNeeded()
    }
    
    func animateToOrigin() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.minX, y: view.frame.maxY / 2))
        path.addQuadCurve(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY / 2), controlPoint: CGPoint(x: view.frame.maxX / 2, y: view.frame.maxY / 2))
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.shapeLayer.path = path.cgPath
            self.shapeLayer.removeAllAnimations()
        })
        
        let anim: CASpringAnimation = CASpringAnimation(keyPath: "path")
        anim.duration = 0.9
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        anim.fromValue = animatedPath.cgPath
        anim.toValue = path.cgPath
        shapeLayer.add(anim, forKey: "path")
        
        CATransaction.commit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

