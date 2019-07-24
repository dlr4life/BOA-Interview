//
//  YellowViewController.swift
//  BOA Interview
//
//  Created by DLR on 7/22/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit
import MapKit

class CountryObject: NSObject {
    var name = ""
    var capital = ""
    var latitude = "0.0"
    var longitude = "0.0"
    var flag = ""
    var isFavorite = false
}

class CustomAnnotation: NSObject, MKAnnotation {
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    var coordinate: CLLocationCoordinate2D
}

class Location: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var flag: String?
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude))
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class YellowViewController: UIViewController, MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var window: UIWindow?
    var countryMap: MKMapView!
    var countryView: UIPickerView = UIPickerView()
    var countryLbl: UILabel = UILabel()
    
    var rotationAngle: CGFloat!
    var selectedValue: String = ""
    var detailInfoObj: CountryObject!
    var annotation: MKAnnotation!
    var annotations = [Location]()
    var titleName = ""
    var titleCapital = ""
    var titleImage = UIImage()
    var flagImage: UIImage!
    var puzzleImage = UIImage()
    
    // Countries
    var countries = ["Afghanistan", "Albania", "Algeria", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bonaire", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Cook Islands", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "England", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Georgia", "Germany", "Ghana", "Greece", "Greenland", "Grenada", "Guam", "Guatemala", "Guinea-Bissau", "Guinea", "Guyana", "Haiti", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Ivorycoast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Mauritania", "Mauritius", "Mexico", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Republic of the Congo", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Scotland", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "theGambia", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Wales", "Yemen", "Zambia", "Zimbabwe"]
    
    // Country Images
    var countryImages: [UIImage] = [UIImage(named: "Afghanistan")!, UIImage(named: "Albania")!, UIImage(named: "Algeria")!, UIImage(named: "Angola")!, UIImage(named: "Antigua_and_Barbuda")!, UIImage(named: "Argentina")!, UIImage(named: "Armenia")!, UIImage(named: "Australia")!, UIImage(named: "Austria")!, UIImage(named: "Azerbaijan")!, UIImage(named: "Bahamas")!, UIImage(named: "Bahrain")!, UIImage(named: "Bangladesh")!, UIImage(named: "Barbados")!, UIImage(named: "Belarus")!, UIImage(named: "Belgium")!, UIImage(named: "Belize")!, UIImage(named: "Benin")!, UIImage(named: "Bermuda")!, UIImage(named: "Bhutan")!, UIImage(named: "Bolivia")!, UIImage(named: "Bonaire")!, UIImage(named: "Bosnia_and_Herzegovina")!, UIImage(named: "Botswana")!, UIImage(named: "Brazil")!, UIImage(named: "Brunei")!, UIImage(named: "Bulgaria")!, UIImage(named: "Burkina_Faso")!, UIImage(named: "Burundi")!, UIImage(named: "Cambodia")!, UIImage(named: "Cameroon")!, UIImage(named: "Canada")!, UIImage(named: "Cape_Verde")!, UIImage(named: "Cayman_Islands")!, UIImage(named: "Central_African_Republic")!, UIImage(named: "Chad")!, UIImage(named: "Chile")!, UIImage(named: "China")!, UIImage(named: "Colombia")!, UIImage(named: "Comoros")!, UIImage(named: "Cook_Islands")!, UIImage(named: "Costa_Rica")!, UIImage(named: "Croatia")!, UIImage(named: "Cuba")!, UIImage(named: "Cyprus")!, UIImage(named: "Czech_Republic")!, UIImage(named: "Democratic_Republic_of_the_Congo")!, UIImage(named: "Denmark")!, UIImage(named: "Djibouti")!, UIImage(named: "Dominica")!, UIImage(named: "Dominican_Republic")!, UIImage(named: "East_Timor")!, UIImage(named: "Ecuador")!, UIImage(named: "Egypt")!, UIImage(named: "El_Salvador")!, UIImage(named: "England")!, UIImage(named: "Equatorial_Guinea")!, UIImage(named: "Eritrea")!, UIImage(named: "Estonia")!, UIImage(named: "Ethiopia")!, UIImage(named: "Fiji")!, UIImage(named: "Finland")!, UIImage(named: "France")!, UIImage(named: "Gabon")!, UIImage(named: "Georgia")!, UIImage(named: "Germany")!, UIImage(named: "Ghana")!, UIImage(named: "Greece")!, UIImage(named: "Greenland")!, UIImage(named: "Grenada")!, UIImage(named: "Guam")!, UIImage(named: "Guatemala")!, UIImage(named: "Guinea-Bissau")!, UIImage(named: "Guinea")!, UIImage(named: "Guyana")!, UIImage(named: "Haiti")!, UIImage(named: "Honduras")!, UIImage(named: "Hong_Kong")!, UIImage(named: "Hungary")!, UIImage(named: "Iceland")!, UIImage(named: "India")!, UIImage(named: "Indonesia")!, UIImage(named: "Iran")!, UIImage(named: "Iraq")!, UIImage(named: "Ireland")!, UIImage(named: "Israel")!, UIImage(named: "Italy")!, UIImage(named: "Ivorycoast")!, UIImage(named: "Jamaica")!, UIImage(named: "Japan")!, UIImage(named: "Jordan")!, UIImage(named: "Kazakhstan")!, UIImage(named: "Kenya")!, UIImage(named: "Kiribati")!, UIImage(named: "Kuwait")!, UIImage(named: "Kyrgyzstan")!, UIImage(named: "Laos")!, UIImage(named: "Latvia")!, UIImage(named: "Lebanon")!, UIImage(named: "Lesotho")!, UIImage(named: "Liberia")!, UIImage(named: "Libya")!, UIImage(named: "Liechtenstein")!, UIImage(named: "Lithuania")!, UIImage(named: "Luxembourg")!, UIImage(named: "Macedonia")!, UIImage(named: "Madagascar")!, UIImage(named: "Malawi")!, UIImage(named: "Malaysia")!, UIImage(named: "Maldives")!, UIImage(named: "Mali")!, UIImage(named: "Malta")!, UIImage(named: "Mauritania")!, UIImage(named: "Mauritius")!, UIImage(named: "Mexico")!, UIImage(named: "Moldova")!, UIImage(named: "Monaco")!, UIImage(named: "Mongolia")!, UIImage(named: "Montenegro")!, UIImage(named: "Montserrat")!, UIImage(named: "Morocco")!, UIImage(named: "Mozambique")!, UIImage(named: "Myanmar")!, UIImage(named: "Namibia")!, UIImage(named: "Nauru")!, UIImage(named: "Nepal")!, UIImage(named: "Netherlands")!, UIImage(named: "New_Caledonia")!, UIImage(named: "New_Zealand")!, UIImage(named: "Nicaragua")!, UIImage(named: "Niger")!, UIImage(named: "Nigeria")!, UIImage(named: "North_Korea")!, UIImage(named: "Norway")!, UIImage(named: "Oman")!, UIImage(named: "Pakistan")!, UIImage(named: "Palau")!, UIImage(named: "Palestine")!, UIImage(named: "Panama")!, UIImage(named: "Papua_New_Guinea")!, UIImage(named: "Paraguay")!, UIImage(named: "Peru")!, UIImage(named: "Philippines")!, UIImage(named: "Poland")!, UIImage(named: "Portugal")!, UIImage(named: "Puerto_Rico")!, UIImage(named: "Qatar")!, UIImage(named: "Republic_of_the_Congo")!, UIImage(named: "Romania")!, UIImage(named: "Russia")!, UIImage(named: "Rwanda")!, UIImage(named: "Saint_Kitts_and_Nevis")!, UIImage(named: "Saint_Lucia")!, UIImage(named: "Saint_Vincent_and_the_Grenadines")!, UIImage(named: "Samoa")!, UIImage(named: "San_Marino")!, UIImage(named: "Sao_Tome_and_Principe")!, UIImage(named: "Saudi_Arabia")!, UIImage(named: "Scotland")!, UIImage(named: "Senegal")!, UIImage(named: "Serbia")!, UIImage(named: "Seychelles")!, UIImage(named: "Sierra_Leone")!, UIImage(named: "Singapore")!, UIImage(named: "Slovakia")!, UIImage(named: "Slovenia")!, UIImage(named: "Solomon_Islands")!, UIImage(named: "Somalia")!, UIImage(named: "South_Africa")!, UIImage(named: "South_Korea")!, UIImage(named: "South_Sudan")!, UIImage(named: "Spain")!, UIImage(named: "Sri_Lanka")!, UIImage(named: "Sudan")!, UIImage(named: "Suriname")!, UIImage(named: "Swaziland")!, UIImage(named: "Sweden")!, UIImage(named: "Switzerland")!, UIImage(named: "Syria")!, UIImage(named: "Taiwan")!, UIImage(named: "Tajikistan")!, UIImage(named: "Tanzania")!, UIImage(named: "Thailand")!, UIImage(named: "theGambia")!, UIImage(named: "Togo")!, UIImage(named: "Tonga")!, UIImage(named: "Trinidad_and_Tobago")!, UIImage(named: "Tunisia")!, UIImage(named: "Turkey")!, UIImage(named: "Turkmenistan")!, UIImage(named: "Tuvalu")!, UIImage(named: "Uganda")!, UIImage(named: "Ukraine")!, UIImage(named: "United_Arab_Emirates")!, UIImage(named: "United_Kingdom")!, UIImage(named: "United_States")!, UIImage(named: "Uruguay")!, UIImage(named: "Uzbekistan")!, UIImage(named: "Vanuatu")!, UIImage(named: "Venezuela")!, UIImage(named: "Vietnam")!, UIImage(named: "Wales")!, UIImage(named: "Yemen")!, UIImage(named: "Zambia")!, UIImage(named: "Zimbabwe")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        
        self.countryMap = MKMapView(frame: CGRect(x:0, y:0, width:(self.window?.frame.width)!, height:300))
        self.countryMap?.delegate = self
        self.countryMap?.showsScale = true
        self.countryMap?.showsPointsOfInterest = true
        self.view.addSubview(self.countryMap)
        
        // Add all annotations
        let annotations = getMapAnnotations()
        countryMap?.addAnnotations(annotations)

        rotationAngle = -90 * (.pi/180)
        
        self.countryView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        self.countryView.layer.cornerRadius = 8
        self.countryView.layer.masksToBounds = true
        self.countryView.backgroundColor = UIColor.white
        self.countryView.dataSource = self
        self.countryView.delegate = self
        self.view.addSubview(self.countryView)
        
        countryView.translatesAutoresizingMaskIntoConstraints = false
        countryView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        countryView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countryView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        countryView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.countryLbl.textAlignment = NSTextAlignment.center
        self.countryLbl.text = "Swipe Left/Right to Select A Country"
        self.countryLbl.backgroundColor = UIColor.white
        self.countryLbl.layer.cornerRadius = 8
        self.countryLbl.layer.masksToBounds = true
        self.view.addSubview(countryLbl)
        
        countryLbl.translatesAutoresizingMaskIntoConstraints = false
        countryLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 430).isActive = true
        countryLbl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        countryLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        countryLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countryView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true
    }
    
    // MARK: - MapView Methods
    
    func addPinToMapView(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let _ = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = Location(latitude: latitude, longitude: longitude)
        countryMap?.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        titleName = (view.annotation?.title ?? "")!
        titleCapital = (view.annotation?.subtitle ?? "")!
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let annotationView = views.first!
        
        if let annotation = annotationView.annotation {
            if annotation is MKUserLocation {
                var region = MKCoordinateRegion()
                region.center = (self.countryMap!.userLocation.coordinate)
                region.span.latitudeDelta = 0.025
                region.span.longitudeDelta = 0.025
                self.countryMap!.setRegion(region, animated: true)
            }
        }
    }
    
    // Show custom annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "MyCustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.isEnabled = true
            annotationView!.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        // Left Accessory
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        let customLocation = annotation as! Location
        leftImage.image = UIImage(named: "\(customLocation.flag ?? "")")
        flagImage = leftImage.image
        annotationView?.leftCalloutAccessoryView = leftImage
        
        // Right accessory view
        let imageRight = UIImage(named: "puzzle")
        let buttonRight = UIButton(type: .custom)
        buttonRight.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonRight.setImage(imageRight, for: UIControl.State())
        buttonRight.layer.cornerRadius = buttonRight.frame.height / 2
        buttonRight.layer.masksToBounds = true
        annotationView?.rightCalloutAccessoryView = buttonRight
        
        return annotationView
    }
    
    // MARK: - Zoom to region
    
    func zoomToRegion() {
        let latitude = Double(detailInfoObj.latitude) ?? nil
        let longitude = Double(detailInfoObj.longitude) ?? nil
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.countryMap?.selectAnnotation(annotation, animated: true)
        self.countryMap?.setRegion(region, animated: true)
    }
    
    // MARK: - Annotations
    
    func findAnnotations(from: [Location]) -> [Location] {
        for item in from {
            let lat = item.latitude
            let long = item.longitude
            let annotation = Location(latitude: lat, longitude: long)
            annotation.title = item.title
            annotation.subtitle = item.subtitle
            annotation.flag = item.flag
            annotations.append(annotation)
        }
        return annotations
    }
    
    func getMapAnnotations() -> [Location] {
        // Load plist file
        var locations: NSDictionary?
        
        if let plistPath = Bundle.main.path(forResource: "worldwide", ofType: "plist") {
            locations = NSDictionary(contentsOfFile: plistPath)
        }
        let dict = locations?["global"] as! [AnyObject]
        
        for item in dict {
            let obj = CountryObject()
            obj.name = (item["name"] as? String ?? "")
            obj.capital = (item["capital"] as? String ?? "")
            obj.flag =  (item["flag"] as? String ?? "")
            let latitude = Double((item as AnyObject).value(forKey: "latitude") as! String)
            let longitude = Double((item as AnyObject).value(forKey: "longitude")as! String)
            
            let nameWithoutSpace = obj.name.replacingOccurrences(of: " ", with: "")
            
            let isFavorite = UserDefaults.standard.bool(forKey: nameWithoutSpace)
            obj.isFavorite = isFavorite
            
            if latitude != nil && longitude != nil {
                let annotation = Location(latitude: latitude!, longitude: longitude!)
                annotation.title = ((item as AnyObject).value(forKey: "name") as? String)
                annotation.subtitle = ((item as AnyObject).value(forKey: "capital")  as? String)
                annotation.flag = ((item as AnyObject).value(forKey: "flag")  as? String)
                annotations.append(annotation)
            }
        }
        return annotations
    }

    func setRandomBackgroundColor() {
        let colors = [
            UIColor(red: 233.6/255, green: 203.4/255, blue: 198.1/255, alpha: 1),
            UIColor(red: 87.8/255, green: 141.9/255, blue: 155.3/255, alpha: 1),
            UIColor(red: 200.0/255.0, green: 16.0/255.0, blue: 46.0/255.0, alpha: 1.0),
            UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0),
            UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0),
            UIColor(red: 19.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0),
            UIColor(red: 26.7/255.0, green: 188.4/255.0, blue: 156.5/255.0, alpha: 1.0),
            UIColor(red: 155/255.0, green: 89/255.0, blue: 182/255.0, alpha: 1.0),
            UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0),
            UIColor(red:0.24, green:0.64, blue:0.82, alpha:1.0),
            UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0),
            UIColor(red:0.02, green:0.66, blue:0.05, alpha:1.0),
            UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0),
            UIColor(red:0.96, green:0.65, blue:0.14, alpha:1.0),
            UIColor(red:0.82, green:0.01, blue:0.11, alpha:1.0),
            UIColor(red:0.55, green:0.34, blue:0.16, alpha:1.0),
            UIColor(red:0.74, green:0.06, blue:0.88, alpha:1.0),
            UIColor(red:0.74, green:0.74, blue:0.13, alpha:1.0),
            UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.0),
            UIColor(red: 0.79, green: 0.24, blue: 0.27, alpha: 1)]
        let randomColor = Int(arc4random_uniform(UInt32 (colors.count)))
        self.view.backgroundColor = colors[randomColor]
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 204
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let customview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        let customuiLabel = UILabel(frame: CGRect(x: -40, y: 50, width: 100, height: 40))
        let customuiimage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 100))
//        customuiLabel.text = countries[row]
        
        customuiimage.image = self.countryImages[row]
        customuiimage.contentMode = .scaleAspectFit
        customuiimage.layer.cornerRadius = 8
        customuiimage.layer.masksToBounds = true
        
        customuiimage.transform = CGAffineTransform(rotationAngle: -self.rotationAngle)
//        customuiLabel.transform = CGAffineTransform(rotationAngle: -self.rotationAngle)
        
        customview.addSubview(customuiimage)
        return customview
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = "\(row + 1)) \(countries[row])"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Bernard MT Condensed", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = countries[row]
        
        self.countryMap.selectAnnotation(self.annotations[row], animated: true)
        self.countryMap?.centerCoordinate = self.annotations[row].coordinate
        
        self.setRandomBackgroundColor()
        
        // Delay the label update and background color change for one second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change # to desired number of seconds
            // Your code with delay
            self.countryLbl.text = self.selectedValue.description
        }
        self.countryView.resignFirstResponder()
    }
}
