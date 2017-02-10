//
//  WinkLoadingView.swift
//  Pods
//
//  Created by Botond Magyarosi on 11/02/2017.
//
//

import UIKit

private struct KeyPath {
    static let rotate   = "rotate"
    static let smile    = "smile"
    static let wink     = "wink"
}

@IBDesignable
public class WinkLoadingView: UIView {

    // MARK: - Public attributes

    /// The padding between the inner and outter circles.
    @IBInspectable open var padding: CGFloat = 10

    /// The line width of the inner outter circle.
    @IBInspectable open var lineWidth: CGFloat = 8

    /// The color of the layers.
    @IBInspectable open var color: UIColor = UIColor.black

    /// The duration of a phase of the animation. default is **1.5**
    @IBInspectable open var duration: Double = 1.5

    /// A timing function used for movement animations.
    open var timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.1, 0.4, 0.9)

    /// This completion block gets called after finishLoading was called and the component finished animating.
    open var animationCompletionHandler: (() -> Void)?

    // MARK: - Properties

    fileprivate var rightEye = CAShapeLayer()
    fileprivate var leftEye = CAShapeLayer()
    fileprivate var outterCircle = CAShapeLayer()

    fileprivate var finished = false

    // MARK: - UI

    func initUI() {
        let dotSize = min(bounds.size.width, bounds.size.height) / 2
        let dotOffset = dotSize / 2

        [leftEye, rightEye].forEach { eye in
            eye.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: dotSize, height: dotSize)).cgPath
            eye.frame = CGRect(x: dotOffset, y: dotOffset, width: dotSize, height: dotSize)
            eye.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            eye.fillColor = color.cgColor
            layer.addSublayer(eye)
        }

        let radius = dotSize / 2 + padding
        let circleOffset = dotSize / 2 - padding

        outterCircle.path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -CGFloat.pi / 4, endAngle: -(3 * CGFloat.pi / 4), clockwise: false).cgPath
        outterCircle.frame = CGRect(x: circleOffset, y: circleOffset, width: radius * 2, height: radius * 2)
        outterCircle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        outterCircle.lineWidth = lineWidth
        outterCircle.strokeColor = color.cgColor
        outterCircle.fillColor = nil
        layer.addSublayer(outterCircle)
    }

    open func startLoading() {
        initUI()
        startSpinning()
    }

    open func finishLoading() {
        finished = true
    }
}

// MARK: - Animation phases

extension WinkLoadingView {

    fileprivate func startSpinning() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = -CGFloat.pi * 2
        anim.duration = 1.5
        anim.delegate = self
        anim.timingFunction = timingFunction
        anim.isRemovedOnCompletion = false
        outterCircle.add(anim, forKey: KeyPath.rotate)
    }

    fileprivate func startSmileyTransition() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = -CGFloat.pi
        anim.duration = 0.7
        anim.delegate = self
        anim.timingFunction = timingFunction
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        outterCircle.add(anim, forKey: nil)

        scale(layer: leftEye, to: 0.3, moveX: outterCircle.frame.minX + outterCircle.frame.width / 4, duration: 0.7, delegate: nil)
        scale(layer: rightEye, to: 0.3, moveX: outterCircle.frame.maxX - outterCircle.frame.width / 4, duration: 0.7, delegate: self)
    }

    fileprivate func wink() {
        let anim = CABasicAnimation(keyPath: "transform.scale.y")
        anim.toValue = 0.2
        anim.delegate = self
        anim.autoreverses = true
        anim.isRemovedOnCompletion = false
        rightEye.add(anim, forKey: KeyPath.wink)
    }

    private func scale(layer: CALayer, to: CGFloat, moveX: CGFloat, duration: Double, delegate: CAAnimationDelegate?) {
        let anim1 = CABasicAnimation(keyPath: "transform.scale")
        anim1.fromValue = 1
        anim1.toValue = to

        let anim2 = CABasicAnimation(keyPath: "position.x")
        anim2.toValue = moveX

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.duration = duration
        group.timingFunction = timingFunction
        group.delegate = delegate
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        layer.add(group, forKey: KeyPath.smile)
    }
}

// MARK: - CAAnimationDelegate

extension WinkLoadingView: CAAnimationDelegate {

    // spinning -> smile -> wink
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == outterCircle.animation(forKey: KeyPath.rotate) {
            if finished {
                startSmileyTransition()
            } else {
                startSpinning()
            }
        } else if anim == rightEye.animation(forKey: KeyPath.smile) {
            wink()
        } else if anim == rightEye.animation(forKey: KeyPath.wink) {
            animationCompletionHandler?()
        }
    }
}
