//
//  RedViewController.swift
//  BOA Interview
//
//  Created by DLR on 7/22/19.
//  Copyright © 2019 DLR. All rights reserved.
//

import UIKit

class RedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myTableView: UITableView = UITableView()
    var searchActive: Bool = false
    var myLinkB: String = "https://api.opendota.com/api/herostats" // Hero Stats + Info
    var heroes = [HeroStats]()

    let speechService = SpeechService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = _ColorLiteralType(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        
        // Reload the table "Uniquely"
        animateTable()
        
        downloadJson { self.myTableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        print("Screensize (\(screenSize)) = ScreenWidth: (\(screenWidth)) * SscreenHeight: (\(screenHeight))")
        
        myTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 164)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(RedTableViewCell.self, forCellReuseIdentifier: "redCell")
        myTableView.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(myTableView)
    }
    
    func downloadJson(completed: @escaping () -> ()) {
        let url = URL(string: myLinkB) // The constant url
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.heroes = try JSONDecoder().decode([HeroStats].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON Error")
                }
            }
            }.resume()
    }
    
    // MARK: - Functions
    
    // MARK: - Reload the tableview "Uniquely"
    func animateTable() {
        myTableView.reloadData()
        
        let cells = myTableView.visibleCells
        let tableHeight: CGFloat = myTableView.bounds.size.height
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heroes.count == 0 ? CGFloat(Float.ulpOfOne) : 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = "Rows: \(heroes.count)"
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
            headerView.textLabel?.text = "Rows: \(heroes.count)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "redCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: RedTableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let urlString = "https://api.opendota.com" + (heroes[indexPath.row].img)
        let url = URL(string: urlString)
        
        cell?.imageView?.image = UIImage(named: "placeholder") // Add a placeholder image
        cell?.imageView?.downloadedFrom(url: url!) // Replace the placeholder image with the image from the url
        cell?.imageView?.contentMode = .scaleAspectFit
        cell?.imageView?.layer.cornerRadius = 8
        cell?.imageView?.clipsToBounds = true
        cell?.imageView?.layer.masksToBounds = true
        cell?.imageView?.layer.borderColor = UIColor.black.cgColor
        cell?.imageView?.layer.borderWidth = 0.7
        
        if cell?.imageView?.gestureRecognizers?.count ?? 0 == 0 {
            // if the image currently has no gestureRecognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped(sender:)))
            cell?.imageView?.addGestureRecognizer(tapGesture)
            cell?.imageView?.isUserInteractionEnabled = true
        }
        
        cell?.textLabel?.text = "\(indexPath.row + 1). \(heroes[indexPath.row].localized_name.capitalized)"
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.textLabel?.textAlignment = .right
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.textLabel?.textColor = UIColor.black
        
        cell?.detailTextLabel?.text = String("Attributes: \(heroes[indexPath.row].primary_attr)", "Attack Type: \(heroes[indexPath.row].attack_type.capitalized)", "Legs: \(heroes[indexPath.row].legs)")
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (cell?.detailTextLabel?.text!)!)
        attributedString.setColorForText(textForAttribute: "Attributes: \(heroes[indexPath.row].primary_attr)", withColor: UIColor.purple)
        attributedString.setColorForText(textForAttribute: "Attack Type: \(heroes[indexPath.row].attack_type.capitalized)", withColor: UIColor(red:0.09, green:0.30, blue:0.33, alpha:1.0))
        attributedString.setColorForText(textForAttribute: "Legs: \(heroes[indexPath.row].legs)", withColor: UIColor.orange)
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
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func imgTapped(sender: UITapGestureRecognizer) {
        print("Image Tapped")
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
