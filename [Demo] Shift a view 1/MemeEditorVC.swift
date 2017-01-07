//
//  MemeEditorVC.swift
//  [Demo] Shift a view 1
//
//  Created by admin on 12/5/16.
//  Copyright © 2016 LEVUANHUYEN. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    //MARK: KHAI BIEN AND ANH XA
    
    @IBOutlet var imagePickerView: UIImageView!
    
    @IBOutlet var topTextField: UITextField!
    
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBOutlet var toolBar: UIToolbar!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var meme: Meme?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let existingMeme = meme {
            // Existing meme. Use self.meme
            setupTextField(string: existingMeme.top, textField: topTextField)
            setupTextField(string: existingMeme.bottom, textField: topTextField)
            imagePickerView.image = existingMeme.image
            shareButton.isEnabled = true
        } else {
            
            // New meme. self.meme is not used
            setupTextField(string: "TOP", textField: topTextField)
            setupTextField(string: "BOTTOM", textField: bottomTextField)
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Enable the camera button if is supported by the device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: MOVE VIEW SLIDE UP NOTIFICATION
    
    
    func keyboardWillShow(notification: Notification){
        
        if bottomTextField.isFirstResponder{
            
            self.view.frame.origin.y = -getKeyboardHeight(notification as Notification)
        }
    } //move the view when keyboard cover textfield (Show KB)
    
    
    func  keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
        
        
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    } //get keyboard height
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    } //know when keyboard is about to slide up
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: UITextFieldDelegate
    
    // Erase the default text when editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Use the return key to escape keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIImage Pick Controller Delegate
    
    //Pass the selected image to the imageVC
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePick = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = imagePick // pick original image from Photo Library
            shareButton.isEnabled = true //got image from Photo Library and enable share
            cancelButton.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //  CANCEL


    @IBAction func cancelButton(_ picker: UIImagePickerController) {
        
        
        func imagePickerControllerDidCancel() {
            self.dismiss(animated: true, completion: nil)
            
        }
        
        imagePickerView.image = UIImage()
        setupTextField(string: "TOP", textField: topTextField)
        setupTextField(string: "BOTTOM", textField: bottomTextField)
 
    }
    // SHARE
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()//generate memed Image
        
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil) //define an activity in ActivityViewController
        
        
        activity.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> Void in
            
            if completed {
                self.save() //save the image
//                activity.dismiss(animated: true, completion: nil) //dismiss Activity View Controller
                self.dismiss(animated: true, completion: nil)
            }//pass memedImage in ActivityViewController
        }
        present(activity,animated: true, completion: nil) // present the ActivityViewController
    }
    // SAVE
    func save(){
        // Create new meme.
        let memedImage = generateMemedImage()
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image : imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        // Add the saved meme to the shared model
        var sharedIntance:MemeManager = MemeManager()
        sharedIntance.appendMeme(meme: meme)
    }
    
    
    //PICK IMAGE
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        pickAnImage(sourceType: .photoLibrary)}
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickAnImage(sourceType: .camera)
    }
    
    
    //MARK: OTHER FUNCTIONS
    
    // Setup Textfield (Text Style)
    func setupTextField(string: String, textField: UITextField) {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0]
        
        // Set Textfield Atributes
        let attributedString = NSAttributedString(string: string, attributes: nil)
        textField.attributedText = attributedString
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        
    }
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePick = UIImagePickerController()
        imagePick.delegate = self
        imagePick.sourceType = sourceType
        present(imagePick, animated: true, completion: nil)
    }
    
    
    
    //MARK: Meme method
    // Hide toolbar
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolBar.isHidden = false
        navigationBar.isHidden = false
        return memedImage
    }
    
    func saveMeme(_ memedImage: UIImage) {
        
        if var existingMeme = meme {
            // Meme exists. Just change its existing properties
            existingMeme.top = topTextField.text!
            existingMeme.bottom = bottomTextField.text!
            existingMeme.image = imagePickerView.image!
            existingMeme.memedImage = generateMemedImage()
        }
        
    }
    
    
    
}


