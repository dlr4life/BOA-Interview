//
//  OrangeViewController.swift
//  BOA Interview
//
//  Created by DLR on 7/19/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit

class OrangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    static let lastUpdate = "LAST_UPDATE"
    
    var tableview = UITableView()
    var searchActive: Bool = false
    var myLinkA: String = "https://restcountries.eu/rest/v1/all" // Countries & Capitals + Info
    var countries = [Country]() // An array of type Country
    
    let prefs = UserDefaults.standard
    let speechService = SpeechService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchData()
        addSearchBar()
        animateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print("Screensize (\(screenSize)) = ScreenWidth: (\(screenWidth)) * SscreenHeight: (\(screenHeight))")

        tableview.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 164)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(tableview)
    }

    // MARK: - SearchBar Methods
    
    func addSearchBar()  {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.black
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Countries/Capitals"
        searchBar.scopeButtonTitles = ["Country", "Capital", "Region"]
        self.definesPresentationContext = true
        self.tableview.tableHeaderView = searchBar
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        if (searchBar.text != "") {
            searchActive = true
        } else {
            searchActive = false
            self.tableview.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {// called when keyboard search button pressed
        searchActive = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {// called when cancel button pressed
        searchBar.showsCancelButton = false
        searchActive = false
        searchBar.resignFirstResponder()
        self.tableview.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            fetchData()
        } else {
            if searchBar.selectedScopeButtonIndex == 0 {
                countries = countries.filter({ (country) -> Bool in
                    return country.country.lowercased().contains(searchText.lowercased() )
                })
            } else if searchBar.selectedScopeButtonIndex == 1 {
                countries = countries.filter({ (country) -> Bool in
                    return country.capital.lowercased().contains(searchText.lowercased() )
                })
            } else if searchBar.selectedScopeButtonIndex == 2 {
                countries = countries.filter({ (country) -> Bool in
                    return country.region.lowercased().contains(searchText.lowercased() )
                })
            }
        }
        self.tableview.reloadData()
    }
    
    // MARK: - URLSession Methods
    
    func fetchData() {
        
        countries = [] // Empty the array (if it isn't)
        
        let url = URL(string: myLinkA) // The constant url
        let request = URLRequest(url: url!) // The constant request
        
        let configuration = URLSessionConfiguration.default // The constant configuration session
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main) // The constant session
        
        // The task that retrieves the contents of a URLL based on the specified URL request object, with error handling
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) { // If error exists, print it
                print("Error")
            } else { // If no error exists, get the data
                do {
//                    print(self.myLinkA)

                    // Get the data & multiple leaves, and downcast it as an NSArray
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
//                    print(fetchedData) // Print the data
                    
                    // Loop through the elements of the array (which are Dictionary types)
                    for eachFetchedCountry in fetchedData {
                        let eachCountry = eachFetchedCountry as! [String : Any]
                        let country = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as? String
                        let region = eachCountry["region"] as? String
                        let subregion = eachCountry["subregion"] as? String
                        let population = eachCountry["population"] as? Int

                        // Add the data to the array of fetched countries
                        self.countries.append(Country(country: country, capital: capital!, region: region!, subregion: subregion ?? "", population: population ?? 0))
                    }
//                    print(self.countries) // Print the fetcheed country array
                    self.tableview.reloadData()
                } catch {
                    print("Error in retriving data")
                }
            }
        }
        task.resume() // Resume the task, if suspended
    }
    
    func animateTable() {
        tableview.reloadData()
        
        let cells = tableview.visibleCells
        let tableHeight: CGFloat = tableview.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    // MARK: - UITableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // To get the number of sections in the UITableview.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // To get the number of rows per section in the UITableview.
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return countries.count == 0 ? CGFloat(Float.ulpOfOne) : 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = "Entries: \(countries.count)"
        if section < headerTitles.count {
            return headerTitles
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
            headerView.textLabel?.font = UIFont(name: "FuturaPT-Medium", size: 17)
            headerView.contentView.backgroundColor = UIColor.gray
            headerView.clipsToBounds = true
            headerView.tintColor = UIColor.orange
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.text = "Entries: \(countries.count)"
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell and configure the data for reusability.
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: CustomTableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = "\(indexPath.row + 1). \(countries[indexPath.row].country)"
        cell?.textLabel?.attributedText = NSAttributedString(string: (cell?.textLabel!.text)!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.backgroundColor = UIColor.white
        cell?.textLabel?.font = UIFont(name:"Veranda", size: 16)
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell?.detailTextLabel?.text = String("Capital: \(countries[indexPath.row].capital)", "SubRegion: \(countries[indexPath.row].subregion)", "Region: \(countries[indexPath.row].region)", "Population: \(countries[indexPath.row].population.withCommas())")

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (cell?.detailTextLabel?.text!)!)
        attributedString.setColorForText(textForAttribute: "Capital: \(countries[indexPath.row].capital)", withColor: UIColor.purple)
        attributedString.setColorForText(textForAttribute: "SubRegion: \(countries[indexPath.row].subregion)", withColor: UIColor(red:0.09, green:0.30, blue:0.33, alpha:1.0))
        attributedString.setColorForText(textForAttribute: "Region: \(countries[indexPath.row].region)", withColor: UIColor.orange)
        attributedString.setColorForText(textForAttribute: "Population: \(countries[indexPath.row].region)", withColor: UIColor(red:0.13, green:0.06, blue:0.05, alpha:1.0))
        cell?.detailTextLabel?.attributedText = attributedString
        cell?.detailTextLabel?.layer.cornerRadius = 8
        cell?.detailTextLabel?.textAlignment = .left
        cell?.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.backgroundColor = UIColor.white
        cell?.detailTextLabel?.layer.masksToBounds = true
        cell?.detailTextLabel?.font = UIFont(name:"Helvetica", size: 16)
        
        cell?.accessoryType = UITableViewCell.AccessoryType.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let item = countries[indexPath.row].country
        self.speechService.say("You have selected item \(indexPath.row + 1). \(item), with \(countries[indexPath.row].capital) as the capital, in the \(countries[indexPath.row].subregion) region of \(countries[indexPath.row].region), with a population of, \(countries[indexPath.row].population.withCommas())")
    }
}

// Splitting a string in Swift that receives a regular expression
extension String {
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }
    
    init(_ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
}

// Directly set a color attribute to an attributed string and apply the same on your label.
extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

// Add commas to the population count for countries
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
