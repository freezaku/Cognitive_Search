//
//  ViewController.swift
//  MineFBSearch
//
//  Created by 徐鸿力 on 17/4/19.
//  Copyright © 2017年 CSCI571. All rights reserved.
//

import UIKit
import CoreLocation
import EasyToast

import SpeechToTextV1

import VisualRecognitionV3
import AlamofireImage
import Firebase

import TagListView

class ViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TagListViewDelegate {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var speechToText: SpeechToText!
    var speechToTextSession: SpeechToTextSession!
    var isStreaming = false
    
    let api_Key = YOUR_API_KEY
    let version = YOUR_VERSION
    
    @IBAction func importImage(_ sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            image.sourceType = .camera
            self.present(image, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            image.sourceType = .photoLibrary
            self.present(image, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBAction func didPressMicrophoneButton(_ sender: AnyObject) {
        streamMicrophoneBasic()
    }
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func clearSearchButton(_ sender: AnyObject) {
        if searchTextField.text != "" {
            print("the keyword in search text field is \(searchTextField.text)")
            searchTextField.text = ""
        }
    }
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchActionButton(_ sender: AnyObject) {
        if searchTextField.text == nil || searchTextField.text == "" {
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: 2, dismissOnTap: false)
        }
    }
    
    @IBOutlet weak var ibmImageView: UIImageView!
    
    @IBOutlet weak var fbImageView: UIImageView!
    
    @IBOutlet weak var tagListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagListView.delegate = self
        tagListView.textFont = UIFont.systemFont(ofSize: 24)
        tagListView.alignment = .left
        //tagListView.addTag("usc")
        
        ibmImageView.layer.cornerRadius = ibmImageView.frame.width / 5
        
        fbImageView.layer.cornerRadius = fbImageView.frame.width / 2
        
        speechToText = SpeechToText(
            username: YOUR_USER_NAME,
            password: YOUR_PASSWORD
        )
        speechToTextSession = SpeechToTextSession(
            username: YOUR_USER_NAME,
            password: YOUR_PASSWORD
        )
        
        // Do any additional setup after loading the view, typically from a nib.
        if revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentLocation = locationManager.location
        
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        center = String(latitude) + "," + String(longitude)
        print("The location is \(center)")

    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        searchTextField.text = title
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        tagListView.removeAllTags()
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let storage = Storage.storage().reference()
            let tempRef = storage.child("Search/picLibrary.png")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            tempRef.putData(UIImagePNGRepresentation(image)!, metadata: metaData) { (data, error) in
                if error == nil {
                    print("upload")
                } else {
                    print(error?.localizedDescription)
                }
            }
            
            tempRef.downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    // Handle any errors
                } else {
                    print("the firebaseurl is \(URL)")
                    let visualRecognition = VisualRecognition(apiKey: self.api_Key, version: "2017-07-09")
                    
                    let failure = { (error: Error) in
                        DispatchQueue.main.async {
                            self.searchTextField.text = "Image could not be processed"
                        }
                        print(error)
                    }
                    
                    visualRecognition.classify(image: (URL?.absoluteString)!, failure: failure) { classifiedImages in
                        if let classifiedImage = classifiedImages.images.first {
                            print("the result is \(classifiedImage.classifiers)")
                            
                            if let classification = classifiedImage.classifiers.first?.classes.first?.classification {
                                DispatchQueue.main.sync {
                                    self.searchTextField.text = classification
                                }
                            }
                            
                            if let manyClasses = classifiedImage.classifiers.first?.classes {
                                for oneClass in manyClasses {
                                    let category = oneClass.classification
                                    print("category is \(category)")
                                    self.tagListView.addTag(category)
                                }
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                self.searchTextField.text = "Could not be dertermined"
                            }
                        }
                    }
                    
                }
            }

            
        } else {
            print("error message")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     This function demonstrates how to use the basic
     `SpeechToText` class to transcribe microphone audio.
     */
    public func streamMicrophoneBasic() {
        if !isStreaming {
            
            // update state
            let stopImg = UIImage(named: "stop2.png")
            
            //microphoneButton.setTitle("Stop", for: .normal)
            
            microphoneButton.setImage(stopImg, for: .normal)
            isStreaming = true
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // define error function
            let failure = { (error: Error) in print(error) }
            
            // start recognizing microphone audio
            speechToText.recognizeMicrophone(settings: settings, failure: failure) {
                results in
                self.searchTextField.text = results.bestTranscript.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
        } else {
            
            // update state
            let startImg = UIImage(named: "start.png")
            
            //microphoneButton.setTitle("Record", for: .normal)
            microphoneButton.setImage(startImg, for: .normal)
            
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToText.stopRecognizeMicrophone()
        }
    }
    
    /**
     This function demonstrates how to use the more advanced
     `SpeechToTextSession` class to transcribe microphone audio.
     */
    public func streamMicrophoneAdvanced() {
        if !isStreaming {
            
            // update state
            microphoneButton.setTitle("Stop Microphone", for: .normal)
            isStreaming = true
            
            // define callbacks
            speechToTextSession.onConnect = { print("connected") }
            speechToTextSession.onDisconnect = { print("disconnected") }
            speechToTextSession.onError = { error in print(error) }
            speechToTextSession.onPowerData = { decibels in print(decibels) }
            speechToTextSession.onMicrophoneData = { data in print("received data") }
            speechToTextSession.onResults = { results in self.searchTextField.text = results.bestTranscript.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            // define recognition settings
            var settings = RecognitionSettings(contentType: .opus)
            settings.continuous = true
            settings.interimResults = true
            
            // start recognizing microphone audio
            speechToTextSession.connect()
            speechToTextSession.startRequest(settings: settings)
            speechToTextSession.startMicrophone()
            
        } else {
            
            // update state
            microphoneButton.setTitle("Start Microphone", for: .normal)
            isStreaming = false
            
            // stop recognizing microphone audio
            speechToTextSession.stopMicrophone()
            speechToTextSession.stopRequest()
            speechToTextSession.disconnect()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if searchTextField.text != nil && searchTextField.text != "" {
            if segue.identifier == "getSearchResult" {
                print("use swviewcontroller1")
                if let detailTab = segue.destination as? UITabBarController {
                    print("use swviewcontroller2")
                    if let userDetailNavVC = detailTab.viewControllers?[0] as?
                        UINavigationController {
                        print("use swviewcontroller3")
                        if let userDetailVC = userDetailNavVC.childViewControllers[0] as? UserResultViewController {
                            print("use swviewcontroller4")
                            userDetailVC.keyword = searchTextField.text
                            userDetailVC.favMode = false
                        }
                    }
                    if let pageDetailNavVC = detailTab.viewControllers?[1] as? UINavigationController {
                        if let pageDetailVC = pageDetailNavVC.childViewControllers[0] as? PageResultViewController {
                            pageDetailVC.keyword = searchTextField.text
                            pageDetailVC.favMode = false
                        }
                    }
                    if let eventDetailNavVC = detailTab.viewControllers?[2] as? UINavigationController {
                        if let eventDetailVC = eventDetailNavVC.childViewControllers[0] as? EventResultViewController {
                            eventDetailVC.keyword = searchTextField.text
                            eventDetailVC.favMode = false
                        }
                    }
                    if let placeDetailNavVC = detailTab.viewControllers?[3] as? UINavigationController {
                        if let placeDetailVC = placeDetailNavVC.childViewControllers[0] as? PlaceResultViewController {
                            placeDetailVC.keyword = searchTextField.text
                            placeDetailVC.favMode = false
                        }
                    }
                    if let groupDetailNavVC = detailTab.viewControllers?[4] as? UINavigationController {
                        if let groupDetailVC = groupDetailNavVC.childViewControllers[0] as? GroupResultViewController {
                            groupDetailVC.keyword = searchTextField.text
                            groupDetailVC.favMode = false
                        }
                    }
                }
            }
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if searchTextField.text == nil || searchTextField.text == "" {
            print("no keyword")
            return false
        } else {
            return true
        }
    }
}

