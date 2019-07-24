//
//  ViewController.swift
//  BOA Interview
//
//  Created by DLR on 7/19/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit
import MessageUI

struct ScreenScale {
    static let SCREEN_SCALE         = UIScreen.main.scale
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7_8      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P_8P   = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X_XS       = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR_XS_MAX  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_IPAD_PRO_1        = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 2048.0
    static let IS_IPAD_PRO_2        = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 2224.0
    static let IS_IPAD_PRO_3        = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 2732.0
}

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    static let lastUpdate = "LAST_UPDATE"
    
    var lastUpdateText = UILabel()
    let prefs = UserDefaults.standard
    let speechService = SpeechService()
    
    let menuTitles = ["URLSession", "Decodable", "Map"]
    var viewControllers = [OrangeViewController(), RedViewController(), YellowViewController()]
    let viewCellId = "viewCellId"
    
    let menuBarHeight: CGFloat = 48
    lazy var topMenuBar: TopMenuBar = {
        let menuBar = TopMenuBar(titles: menuTitles, highlightColor: .black, unhighlightColor: .lightGray)
        menuBar.delegate = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        return menuBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: viewCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "BOA Interview"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Add UINavigation Bar + UIBarButtons
        setupViewControllers()
        setupViewsLayout()
        
        self.navigationController?.navigationBar.barTintColor = _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:_ColorLiteralType(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print("Screensize (\(screenSize)) = ScreenWidth: (\(screenWidth)) * SscreenHeight: (\(screenHeight))")

        let helpButtonItem = UIBarButtonItem(title: "Help", style: .done, target: self, action: #selector(helpTapped(_:)))
        navigationItem.rightBarButtonItem = helpButtonItem
    }
    
    // MARK: - App Purpose
    
    /* This app is to meant to display my development skills for interview purposes. I will be tying a table view to an REST API call returning an array of items. I will need to make a GET API call, parse the returned JSON data (with URLSession), and set up a table view to display it. Since some/most API's return paginated data I will also implement loading the next page of results as the user scrolls downward.
     */
    
    func setupViewControllers() {
        for vc in viewControllers {
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            let height = view.frame.height
            let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            vc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height - menuBarHeight - navBarHeight - statusBarHeight)
        }
    }
    
    func setupViewsLayout() {
        view.addSubview(topMenuBar)
        topMenuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topMenuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topMenuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topMenuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topMenuBar.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Mail Methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { () -> Void in
        }
    }
    
    func saveTimestamp() {
        let timestamp = Date()
        prefs.set(timestamp, forKey: ViewController.lastUpdate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = .medium
        lastUpdateText.text = dateFormatter.string(from: timestamp)
    }
    
    func getTimestamp() {
        // Get the last time something was stored
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = .short
        if let lastUpdateStored = (prefs.object(forKey: ViewController.lastUpdate) as? Date) {
            lastUpdateText.text = dateFormatter.string(from: lastUpdateStored)
        } else {
            lastUpdateText.text = "Added: Nothing"
        }
    }
    
    // MARK: - Buttons
    
    @objc func helpTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Need Help?", message: "What would you like assistance with?", preferredStyle: .alert)
        alertController.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Subject:"
            textfield.keyboardAppearance = .default
            textfield.keyboardType = .default
            textfield.autocorrectionType = .default
            textfield.clearButtonMode = .whileEditing
        }
        alertController.addTextField { (textfield: UITextField) in
            self.saveTimestamp()
            self.getTimestamp()
            textfield.text = self.lastUpdateText.text
        }
        alertController.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Body:"
            textfield.keyboardAppearance = .default
            textfield.keyboardType = .default
            textfield.autocorrectionType = .default
            textfield.clearButtonMode = .whileEditing
        }
        let OKAction = UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction) in
            let subjectTextField = alertController.textFields?.first
            print(subjectTextField!.description)
            let dateTextField = self.lastUpdateText.text!
            print(dateTextField)
            let bodyTextField = alertController.textFields?.last
            print(bodyTextField!.description)
            
            let mailComposeController = MFMailComposeViewController()
            let systemVersion = UIDevice.current.systemVersion
            let textVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let modelName = UIDevice.current.model
            mailComposeController.mailComposeDelegate = self
            mailComposeController.setToRecipients([""])
            mailComposeController.setSubject("\(subjectTextField!.text!.description)")
            mailComposeController.setMessageBody("<p>Issue: </p><p>Comments: \(bodyTextField!.text!.description)</p><p>Ver. \(textVersion!)</p><p>Sent at: \(self.lastUpdateText.text!)<p>\(modelName), iOS Version: \(systemVersion)</p><p>Thanks for using this feature!</p>", isHTML: true)
            
            // First ask if we can send mail
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeController, animated: true, completion: { () -> Void in
                })
            }
            
            self.speechService.say("You have pressed the Send button.")
            print("You have pressed Send button")
        })
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action:UIAlertAction!) in
            print("you have pressed the Cancel button")
        })
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:nil)
        print("User clicked Help")
    }
    
    @objc func imgTapped(sender: UITapGestureRecognizer) {
        print("testing-testing")
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewCellId, for: indexPath)
        cell.contentView.addSubview(viewControllers[indexPath.item].view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / view.frame.width
        topMenuBar.scrollTo(offset: offset)
    }
}

extension ViewController: MenuBarDelegate {
    func menuDidTapped(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
