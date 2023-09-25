//
//  ViewController.swift
//  CollisionTest
//
//  Created by Garik Hovsepian on 25.09.23.
//

import UIKit

class ViewController: UIViewController {

    var animator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    var gravityBehavior: UIGravityBehavior!
    var blueBox: UIView!
    var pushBehavior: UIPushBehavior?
    var panGesture: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a container view to hold the animated views
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        containerView.backgroundColor = UIColor.lightGray
        self.view.addSubview(containerView)

        // Create a red box
        let redBox = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        redBox.backgroundColor = UIColor.red
        containerView.addSubview(redBox)

        // Create a blue box
        blueBox = UIView(frame: CGRect(x: 200, y: 200, width: 50, height: 50))
        blueBox.backgroundColor = UIColor.blue
        containerView.addSubview(blueBox)

        // Initialize the animator
        animator = UIDynamicAnimator(referenceView: containerView)

        // Initialize the collision behavior
        collisionBehavior = UICollisionBehavior(items: [redBox, blueBox])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)

        // Initialize the gravity behavior
        gravityBehavior = UIGravityBehavior(items: [blueBox])
        animator.addBehavior(gravityBehavior)

        // Add a pan gesture recognizer to the blue box
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        blueBox.addGestureRecognizer(panGesture)
    }

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            // Remove existing gravity and push behaviors
            animator.removeBehavior(gravityBehavior)
            if let pushBehavior = pushBehavior {
                animator.removeBehavior(pushBehavior)
            }

        case .changed:
            // Move the blue box with the pan gesture
            let translation = sender.translation(in: view)
            blueBox.center.x += translation.x
            blueBox.center.y += translation.y
            sender.setTranslation(CGPoint.zero, in: view)

        case .ended:
            // Add gravity back
            animator.addBehavior(gravityBehavior)

            // Calculate the velocity of the pan gesture and apply it as a push
            let velocity = sender.velocity(in: view)
            let push = UIPushBehavior(items: [blueBox], mode: .instantaneous)
            push.pushDirection = CGVector(dx: velocity.x / 200, dy: velocity.y / 200)
            animator.addBehavior(push)

            // Store the push behavior
            pushBehavior = push

        default:
            break
        }
    }
}
