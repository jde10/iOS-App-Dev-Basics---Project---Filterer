//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    var originalImage: UIImage? = UIImage(named: "scenery")
    var Imagefiltered: Bool = false
    var ImageTab: UIGestureRecognizer?
    var filterType: String?
    var filterModifier: Double = 1

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterView: UIImageView!
    @IBOutlet var editmenu: UIView!
        @IBOutlet weak var slider: UISlider!
    @IBOutlet var bottomMenu: UIView!
        @IBOutlet weak var compareButton: UIButton!
        @IBOutlet weak var edit: UIButton!
        @IBOutlet weak var imageButton: UIButton!
        @IBOutlet var filterButton: UIButton!
        @IBOutlet var secondaryMenu: UIView!
            @IBOutlet weak var Contrast: UIButton!
            @IBOutlet weak var Brightness: UIButton!
            @IBOutlet weak var Black: UIButton!
            @IBOutlet weak var Inversion: UIButton!
    @IBOutlet weak var Overlay: UIView!
        @IBOutlet weak var OriginalImageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        editmenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        editmenu.translatesAutoresizingMaskIntoConstraints = false
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: "compareSwitchImage:")
        pressGesture.minimumPressDuration = 0.01
        imageView.addGestureRecognizer(pressGesture)
        filterView.addGestureRecognizer(pressGesture)
        
        self.filterView.alpha = 0.0
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", filterView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            filterView.image = image
            originalImage = image
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            edit.selected = false
            hideSliderMenu()
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    @IBAction func slidermenu(sender: UIButton) {
        if (sender.selected) {
            hideSliderMenu()
            sender.selected = false
        } else {
            filterButton.selected = false
            hideSecondaryMenu()
            showSliderMenu()
            sender.selected = true
        }
    }
    
    func showSliderMenu() {
        view.addSubview(editmenu)
        
        let bottomConstraint = editmenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = editmenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = editmenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = editmenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        self.slider.value = Float(filterModifier)
        self.editmenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.editmenu.alpha = 1.0
        }
    }
    func hideSliderMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.editmenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.editmenu.removeFromSuperview()
                }
        }
    }
    
    func filter(type: String, modifier: Double){
        //let type: String = "contrast"
        var rgbaImage: RGBAImage?
        //let modifier: Double = 1
        rgbaImage = RGBAImage(image: originalImage!)!
        switch type {
        case "brightness":
            for index in 0..<rgbaImage!.height*rgbaImage!.width {
                var pixel = rgbaImage!.pixels[index]
                pixel.red = UInt8(max(min(255,(Double(pixel.red)*modifier)),0))
                pixel.green = UInt8(max(min(255,(Double(pixel.green)*modifier)),0))
                pixel.blue = UInt8(max(min(255,(Double(pixel.blue)*modifier)),0))
                rgbaImage!.pixels[index] = pixel
            }
        case "contrast":
            var averagered: Double = 1
            var averagegreen: Double = 1
            var averageblue: Double = 1
            for index in 0..<rgbaImage!.height*rgbaImage!.width {
                var pixel = rgbaImage!.pixels[index]
                averagered = Double((averagered*(Double(index))+Double(pixel.red))/(Double(index+1)))
                averagegreen = Double((averagegreen*(Double(index))+Double(pixel.green))/(Double(index+1)))
                averageblue = Double((averageblue*(Double(index))+Double(pixel.blue))/(Double(index+1)))
            }
            for index in 0..<rgbaImage!.height*rgbaImage!.width {
                var pixel = rgbaImage!.pixels[index]
                pixel.red = UInt8(max(min(255, Double(averagered) + modifier * (Double(pixel.red) - Double(averagered))),0))
                pixel.green = UInt8(max(min(255, Double(averagegreen) + modifier * (Double(pixel.green) - Double(averagegreen))),0))
                pixel.blue = UInt8(max(min(255, Double(averageblue) + modifier * (Double(pixel.blue) - Double(averageblue))),0))
                rgbaImage!.pixels[index] = pixel
            }
        case "b/w":
            var grey: UInt8 = 0
            for index in 0..<rgbaImage!.height*rgbaImage!.width {
                var pixel = rgbaImage!.pixels[index]
                grey = UInt8(max(min(255, (Double(pixel.red) + Double(pixel.green) + Double(pixel.blue))/3),0))
                pixel.red = grey
                pixel.green = grey
                pixel.blue = grey
                rgbaImage!.pixels[index] = pixel
            }
        case "invert":
            for index in 0..<rgbaImage!.height*rgbaImage!.width {
                var pixel = rgbaImage!.pixels[index]
                pixel.red = 255-pixel.red
                pixel.green = 255-pixel.green
                pixel.blue = 255-pixel.blue
                rgbaImage!.pixels[index] = pixel
            }
        default: break
        }
        filteredImage = rgbaImage!.toUIImage()!
        compareButton.enabled = true

    }
    @IBAction func Contrast(sender: UIButton) {
        filterType = "contrast"
        filterModifier = 1.5
        edit.enabled = true
        transitiontofilter()
    }
    
    @IBAction func Brightness(sender: UIButton) {
        filterType = "brightness"
        filterModifier = 1.2
        edit.enabled = true
        transitiontofilter()
    }
    
    @IBAction func Black(sender: UIButton) {
        filterType = "b/w"
        filterModifier = 0
        edit.enabled = false
        transitiontofilter()
    }
    
    @IBAction func Inversion(sender: UIButton) {
        filterType = "invert"
        filterModifier = 0
        edit.enabled = false
        transitiontofilter()
    }
    
    @IBAction func compareImage(sender: UIButton) {
        if Imagefiltered == true {
            transitiontooriginal()
        } else {
            transitiontofilter()
        }
    }
    @IBAction func Slider(sender: UISlider) {
        filterModifier = Double(slider.value)
        transitiontofilter()
        
    }
    @IBAction func compareSwitchImage(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            transitiontooriginal()

        } else {
            transitiontofilter()
        }
    }
    
    func transitiontofilter() {
        filter(filterType!, modifier: filterModifier)
        Imagefiltered = true
        if self.filterView.alpha == 1.0 {
            self.imageView.image = filteredImage
            UIView.animateWithDuration(0.4, animations: {
                self.filterView.alpha = 0}) {completed in if completed == true {
                    
            self.filterView.image = self.filteredImage
            self.filterView.alpha = 1.0
                    }}
        } else {
        
            self.filterView.image = filteredImage
        
            UIView.animateWithDuration(0.4, animations: {
                self.filterView.alpha = 1.0
                self.Overlay.alpha = 0
                }) { completed in
                    if completed == true {
                        self.Overlay.removeFromSuperview()
                    }
                }}
    }
    func transitiontooriginal() {
        Imagefiltered = false
        imageView.image = originalImage
        view.addSubview(Overlay)
        Overlay.center = view.center
        view.layoutIfNeeded()
        self.Overlay.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.filterView.alpha = 0
            self.Overlay.alpha = 1.0
        }
    }
}



