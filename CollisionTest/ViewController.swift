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
    var slider1: UISlider!
    var slider2: UISlider!
    var slider3: UISlider!
    var valueLabel1: UILabel!
    var valueLabel2: UILabel!
    var valueLabel3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Declare two sliders
        slider1 = UISlider()
        slider2 = UISlider()
        slider3 = UISlider()

       
        
        
        // Create a container view to hold the animated views
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 350))
        containerView.backgroundColor = UIColor.lightGray
        self.view.addSubview(containerView)

        // Create a blue box
        blueBox = UIView(frame: CGRect(x: 200, y: 200, width: 50, height: 50))
        blueBox.backgroundColor = UIColor.blue
        blueBox.layer.cornerRadius = 25
        containerView.addSubview(blueBox)

        // Create a cyan box
        cyanBox = UIView(frame: CGRect(x: 140, y: 200, width: 50, height: 200))
        cyanBox.backgroundColor = UIColor.cyan
        containerView.addSubview(cyanBox)

        
        // Create a purple box
        purpleBox = UIView(frame: CGRect(x: 590, y: 200, width: 50, height: 50))
        purpleBox.backgroundColor = UIColor.purple
        purpleBox.layer.cornerRadius = 25
        containerView.addSubview(purpleBox)

        // Create a red box
        redBox = UIView(frame: CGRect(x: 650, y: 200, width: 50, height: 200))
        redBox.backgroundColor = UIColor.red
        containerView.addSubview(redBox)

        
        
        var currentScale: CGFloat = 1.0 // Initial scale factor
            
        func zoomInButtonTapped() {
            currentScale += 0.2 // Increase the scale factor by 0.2 for zooming in
            
            UIView.animate(withDuration: 2) {
                containerView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            }
        }
        
        func zoomOutButtonTapped() {
            currentScale -= 0.2 // Decrease the scale factor by 0.2 for zooming out
            
            UIView.animate(withDuration: 4) {
                containerView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            }
        }
        
        
        
        
        
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
        
        
        
        view.addSubview(slider1)
        view.addSubview(slider2)
        view.addSubview(slider3)
        
        // Configure slider1
        slider1.translatesAutoresizingMaskIntoConstraints = false
        slider1.minimumValue = -1000
        slider1.maximumValue = 1000
        slider1.value = 1000
        slider1.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        
        slider2.translatesAutoresizingMaskIntoConstraints = false
        slider2.minimumValue = -1000
        slider2.maximumValue = 1000
        slider2.value = -500
        slider2.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        
        slider3.translatesAutoresizingMaskIntoConstraints = false
        slider3.minimumValue = 0.5
        slider3.maximumValue = 20.0
        slider3.value = 2.0
        slider3.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        
        // Create constraints for slider1
        NSLayoutConstraint.activate([
           slider1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           slider1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
           slider1.widthAnchor.constraint(equalToConstant: 200)
        ])
       
        // Create constraints for slider2
        NSLayoutConstraint.activate([
           slider2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           slider2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
           slider2.widthAnchor.constraint(equalToConstant: 200)
        ])

        // Create constraints for slider2
        NSLayoutConstraint.activate([
           slider3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           slider3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
           slider3.widthAnchor.constraint(equalToConstant: 200)
        ])

        
        valueLabel1 = UILabel()
        valueLabel1.translatesAutoresizingMaskIntoConstraints = false
        valueLabel1.text = "\(slider1.value)"
        view.addSubview(valueLabel1)

        valueLabel2 = UILabel()
        valueLabel2.translatesAutoresizingMaskIntoConstraints = false
        valueLabel2.text = "\(slider2.value)"
        view.addSubview(valueLabel2)

        
        valueLabel3 = UILabel()
        valueLabel3.translatesAutoresizingMaskIntoConstraints = false
        valueLabel3.text = "\(slider3.value)"
        view.addSubview(valueLabel3)

        
       // Create constraints for valueLabel1
       NSLayoutConstraint.activate([
           valueLabel1.centerXAnchor.constraint(equalTo: slider1.centerXAnchor),
           valueLabel1.topAnchor.constraint(equalTo: slider1.bottomAnchor, constant: 10)
       ])

       // Create constraints for valueLabel2
       NSLayoutConstraint.activate([
           valueLabel2.centerXAnchor.constraint(equalTo: slider2.centerXAnchor),
           valueLabel2.topAnchor.constraint(equalTo: slider2.bottomAnchor, constant: 10)
       ])

        // Create constraints for valueLabel2
        NSLayoutConstraint.activate([
            valueLabel3.centerXAnchor.constraint(equalTo: slider3.centerXAnchor),
            valueLabel3.topAnchor.constraint(equalTo: slider3.bottomAnchor, constant: 10)
        ])
        zoomInButtonTapped()
//        zoomOutButtonTapped()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
            if sender == slider1 {
                valueLabel1.text = "\(slider1.value)"
                print("Slider 1 Value: \(slider1.value)")
            } else if sender == slider2 {
                valueLabel2.text = "\(slider2.value)"
                print("Slider 2 Value: \(slider2.value)")
            } else if sender == slider3 {
                valueLabel3.text = "\(slider3.value)"
                print("Slider 3 Value: \(slider3.value)")
            }

        }
    
    @objc func handleTapGestureLeftItem(_ sender: UITapGestureRecognizer) {
        // Remove existing gravity and push behaviors
        animator.removeBehavior(gravityBehavior)
        animator.removeBehavior(pushBehavior)

        // Apply gravity in the downward direction
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        animator.addBehavior(gravityBehavior)

        // Calculate the velocity and apply it as a push
        let velocity = CGPoint(x: Double(slider1.value), y: Double(slider2.value)) // Adjust the values to control the velocity
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
