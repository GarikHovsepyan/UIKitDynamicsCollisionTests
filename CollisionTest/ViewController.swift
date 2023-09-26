//
//  ViewController.swift
//  CollisionTest
//
//  Created by Garik Hovsepian on 25.09.23.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var animator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    var blueBox: UIView!
    var redBox: UIView!
    var purpleBox: UIView!
    var cyanBox: UIView!
    var pushBehavior: UIPushBehavior!
    var tapGesture: UITapGestureRecognizer!
    var tapGesture2: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a container view to hold the animated views
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 350))
        containerView.backgroundColor = UIColor.lightGray
        self.view.addSubview(containerView)

        // Create a blue box
        blueBox = UIView(frame: CGRect(x: 200, y: 200, width: 50, height: 50))
        blueBox.backgroundColor = UIColor.blue
        containerView.addSubview(blueBox)

        // Create a cyan box
        cyanBox = UIView(frame: CGRect(x: 140, y: 200, width: 50, height: 200))
        cyanBox.backgroundColor = UIColor.cyan
        containerView.addSubview(cyanBox)

        
        // Create a purple box
        purpleBox = UIView(frame: CGRect(x: 590, y: 200, width: 50, height: 50))
        purpleBox.backgroundColor = UIColor.purple
        containerView.addSubview(purpleBox)

        // Create a red box
        redBox = UIView(frame: CGRect(x: 650, y: 200, width: 50, height: 200))
        redBox.backgroundColor = UIColor.red
        containerView.addSubview(redBox)

        
        
        
        
        pushBehavior = UIPushBehavior(items: [], mode: .instantaneous)
        gravityBehavior = UIGravityBehavior(items: [])
        
        // Initialize the animator
        animator = UIDynamicAnimator(referenceView: containerView)

        // Initialize collision behavior for blue and red boxes
        collisionBehavior = UICollisionBehavior(items: [blueBox, redBox, purpleBox, cyanBox])

        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self // Set the collision delegate
        animator.addBehavior(collisionBehavior)

        // Initialize the gravity behavior
        gravityBehavior = UIGravityBehavior(items: [blueBox, redBox, purpleBox, cyanBox])
        animator.addBehavior(gravityBehavior)

        let redBoxBehaviour = UIDynamicItemBehavior(items: [redBox])
        redBoxBehaviour.density = 0.5
        animator.addBehavior(redBoxBehaviour)

        let blueBoxBehaviour = UIDynamicItemBehavior(items: [blueBox])
        blueBoxBehaviour.density = 2.0
        animator.addBehavior(blueBoxBehaviour)

        
        let purpleBoxBehaviour = UIDynamicItemBehavior(items: [purpleBox])
        purpleBoxBehaviour.density = 2.0
        animator.addBehavior(purpleBoxBehaviour)

        let cyanBoxBehaviour = UIDynamicItemBehavior(items: [cyanBox])
        cyanBoxBehaviour.density = 0.5
        animator.addBehavior(cyanBoxBehaviour)

        
        // Add a tap gesture recognizer to the blue box
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureLeftItem(_:)))
        blueBox.addGestureRecognizer(tapGesture)

        tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRightItem(_:)))
        purpleBox.addGestureRecognizer(tapGesture2)
        
    }

    @objc func handleTapGestureLeftItem(_ sender: UITapGestureRecognizer) {
        // Remove existing gravity and push behaviors
        animator.removeBehavior(gravityBehavior)
        animator.removeBehavior(pushBehavior)

        // Apply gravity in the downward direction
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        animator.addBehavior(gravityBehavior)

        // Calculate the velocity and apply it as a push
        let velocity = CGPoint(x: 2200.0, y: -500.0) // Adjust the values to control the velocity
        pushBehavior = UIPushBehavior(items: [blueBox], mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: velocity.x / 200, dy: velocity.y / 200)
        animator.addBehavior(pushBehavior)
    }

    @objc func handleTapGestureRightItem(_ sender: UITapGestureRecognizer) {
        // Remove existing gravity and push behaviors
        animator.removeBehavior(gravityBehavior)
        animator.removeBehavior(pushBehavior)

        // Apply gravity in the downward direction
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        animator.addBehavior(gravityBehavior)

        // Calculate the velocity and apply it as a push
        let velocity = CGPoint(x: -2200.0, y: -500.0) // Adjust the values to control the velocity
        pushBehavior = UIPushBehavior(items: [purpleBox], mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: velocity.x / 200, dy: velocity.y / 200)
        animator.addBehavior(pushBehavior)
    }

    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, with otherItem: UIDynamicItem, at point: CGPoint) {
        if let view = item as? UIView, let otherView = otherItem as? UIView {
            if (view == redBox && otherView == blueBox) || (view == blueBox && otherView == redBox) {
                // Change the background color of the red and blue boxes when they collide
                redBox.backgroundColor = UIColor.green
                blueBox.backgroundColor = UIColor.yellow
            }  else if (view == purpleBox && otherView == cyanBox) || ( view == cyanBox && otherView == purpleBox) {
                purpleBox.backgroundColor = UIColor.black
                cyanBox.backgroundColor = UIColor.orange

            }
        }
    }
}
