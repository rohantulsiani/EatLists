//
//  AddListViewController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, ImageFilterViewControllerDelegate
{
    var tableView:UITableView!
    var image:UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func createListPressed(_ sender: AnyObject)
    {
        if textField.text != ""
        {
            //set arrays to reflect new list
            User.sharedInstance.listArray.append(textField.text!)
            User.sharedInstance.listImageData.append(UIImageJPEGRepresentation(imageView.image!, 0.1)!)
            
            let data = User.sharedInstance.listImageData[User.sharedInstance.listImageData.count - 1]
            User.sharedInstance.listImageArray.append(UIImage(data: data)!)
            
            User.sharedInstance.listElements.append([String]())
            User.sharedInstance.imageURL.append([String]())
            User.sharedInstance.listNotes.append([String]())
            
            //write new arrays to user defaults
            User.sharedInstance.writeToFile()

            textField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
            
            //reload table
            tableView.reloadData()
        }
    }
    
    //back to prev view controller
    @IBAction func cancelButtonPressed(_ sender: AnyObject)
    {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func chooseImagePressed(_ sender: AnyObject)
    {
        //Image Picker
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //AFTER COMPLETE
        }
    }
    
    //wont work on simulator
    @IBAction func takePicturePressed(_ sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
    
            self.present(image, animated: true)
            {
                //AFTER COMPLETE
            }
        }
    }
    
    //when picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //set image view
            imageView.image = image
            self.image = image
        }
       
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageFilterViewController(_ imageFilterViewController: ImageFilterViewController, didUpdateFilters filters: [String])
    {
        DispatchQueue.global().sync
        {
            //set values of filters
            let context = CIContext(options: nil)
            var output : CIImage? = nil
        
            for i in filters
            {
                if(i == "Sepia")
                {
                    let filter : CIFilter! = CIFilter(name: "CISepiaTone")
                    filter.setValue(0.9, forKey: kCIInputIntensityKey)

                    if(output == nil)
                    {
                        let beginImage = CIImage(image: self.imageView.image!)
                        filter.setValue(beginImage, forKey: kCIInputImageKey)
                        output = filter.outputImage!
                    }
                    else
                    {
                        filter.setValue(output, forKey: kCIInputImageKey)
                        output = filter.outputImage!
                    }
                }
            }
        
            let cgimg : CGImage! = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage:cgimg)
        
            DispatchQueue.main.async
            {
                self.image = processedImage
                self.imageView.image = processedImage
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let navigationController = segue.destination as! UINavigationController //get parent nav controller
        
        //if segue to filters
        if let filtersViewController = navigationController.topViewController as? ImageFilterViewController
        {
            filtersViewController.delegate = self
        }
    }
}
