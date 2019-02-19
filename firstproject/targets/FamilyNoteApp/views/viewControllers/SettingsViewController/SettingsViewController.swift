//
//  SettingsViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class SettingsViewController: RootViewController, UITableViewDataSource, UITableViewDelegate, AllPurposeChooseViewControllerDelegate, AllPurposeChooseViewControllerDataSource {
    

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrSections: Array<(sectionTitle: String, arrEntries: Array<(tag: Int, entry: String, detail: String, handler: Selector)>)> = []
    
    var senderObservation: NSKeyValueObservation? // MVVM KVO
    var receiverObservation: NSKeyValueObservation?
    var dateObservation: NSKeyValueObservation?
    var familyMemberObservation: NSKeyValueObservation?
    var logoutObservation: NSKeyValueObservation?
    var searchObservation: NSKeyValueObservation?
    
    var senderName = ""
    var receiverName = ""
    var date = Date().toString(dateFormat: "yyyy-MM-dd")
    
    
    fileprivate var logoutVM : Logout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        arrSections.append((sectionTitle: "SETTINGS", arrEntries: [(tag: 0, entry: "Check notes from", detail: "", handler: #selector(changeSender)), (tag: 1, entry: "Check notes to", detail: "", handler: #selector(changeReceiver)),(tag: 2, entry: "Check notes date", detail: "", handler: #selector(changeDate)),(tag: 3, entry: "Add family members", detail: "", handler: #selector(addFamilyMembers)), (tag: 4, entry: "Logout", detail: "", handler: #selector(logout))]))
        
        arrSections.append((sectionTitle: "ABOUT", arrEntries: [(tag: 100, entry: "Version", detail: "1.0", handler: #selector(showVersion))]))
       
        
        // MVVM KVO
        setKVO()
        
    }
    
    // MARK: - KVO
    
    func setKVO() {
        
        familyMemberObservation = AddFamilyMember.shared.observe(\AddFamilyMember.arrFamilyMembers, options: [.old, .new]) { [weak self] object, change in
            if (change.newValue != nil) && (change.newValue != change.oldValue) {
                DispatchQueue.main.async { [weak self] in
                    //the allpurposeview controller show be updated here
                    //self?.tableView.reloadData()
                }
            }
        }
        
        logoutObservation = logoutVM?.observe(\Logout.logoutResult, options: [.old, .new]) { [weak self] object, change in
            //check the logout result fail or success
                DispatchQueue.main.async { [weak self] in
                    let resultCode = self?.logoutVM?.logoutResult["resultCode"] as! Int
                    if resultCode == 0 {
                        self?.tabBarController?.dismiss(animated: true, completion: {
                            //
                        })
                    }
                    else {
                        self?.showResultErrorAlert(resultCode: resultCode)
                    }
                }
            
        }
        
        searchObservation = NoteSearch.shared.observe(\NoteSearch.searchResult, options: [.old, .new]) { [weak self] object, change in
            DispatchQueue.main.async { [weak self] in
                let resultCode = NoteSearch.shared.searchResult["resultCode"] as! Int
                if resultCode == 0 {
                    self?.tableView.reloadData()
                }
                else {
                    self?.showResultErrorAlert(resultCode: resultCode)
                }
            }
        }
    }
    // MARK: - Handlers
    
    @IBAction func changeSender() {
        let allPurposeChooseViewController = AllPurposeChooseViewController()
        allPurposeChooseViewController.delegate = self
        allPurposeChooseViewController.dataSource = self
        allPurposeChooseViewController.context = "sender"
        allPurposeChooseViewController.sTitle = "Senders"
        allPurposeChooseViewController.arrOptions = AddFamilyMember.shared.arrFamilyMembers
        self.navigationController?.pushViewController(allPurposeChooseViewController, animated: true)
    }
    
    @IBAction func changeReceiver() {
        let allPurposeChooseViewController = AllPurposeChooseViewController()
        allPurposeChooseViewController.delegate = self
        allPurposeChooseViewController.dataSource = self
        allPurposeChooseViewController.context = "receiver"
        allPurposeChooseViewController.sTitle = "Receivers"
        allPurposeChooseViewController.arrOptions = AddFamilyMember.shared.arrFamilyMembers
        self.navigationController?.pushViewController(allPurposeChooseViewController, animated: true)
    }
    
    @IBAction func changeDate() {
        
    }
    
    @IBAction func logout() {
        //set the logout true
        logoutVM?.loggedout = true;
    }
    
    @IBAction func addFamilyMembers() {
        let addFamilyMemberViewController = AddMemberViewController()
        self.navigationController?.pushViewController(addFamilyMemberViewController, animated: true)
    }
    
    @IBAction func showVersion() {
        //
    }
    
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrSections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSections[section].arrEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCellReuseId = "tableViewCellReuseId"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: tableViewCellReuseId)
        }
        
        cell?.tag = arrSections[indexPath.section].arrEntries[indexPath.row].tag
        cell?.textLabel?.text = arrSections[indexPath.section].arrEntries[indexPath.row].entry
        let detail = arrSections[indexPath.section].arrEntries[indexPath.row].detail
        if detail != "" {
            cell?.detailTextLabel?.text = detail
        }
        
        if cell?.tag == 0 {
            cell?.detailTextLabel?.text = NoteSearch.shared.searchArray[0]
        }
        
        if cell?.tag == 1 {
            cell?.detailTextLabel?.text = NoteSearch.shared.searchArray[1]
        }
        
        if cell?.tag == 2 {
            cell?.detailTextLabel?.text = NoteSearch.shared.searchArray[2]
        }
        
        //
    
        
        
        //
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        perform(arrSections[indexPath.section].arrEntries[indexPath.row].handler)
    }
    
    
    // MARK: - AllPurposeChooseViewControllerDelegate, AllPurposeChooseViewControllerDataSource
    
    func allPurposeChooseViewControllerDidSelect(section: Int, row: Int, title: String, context: Any?) {
        // print("allPurposeChooseViewControllerDidSelect: \(section):\(row), \(title)")
        let choice = context as? String
        if choice != nil {
            if choice == "sender" {
                senderName = title
                NoteSearch.shared.searchArray = [senderName, receiverName, date]
            }
            if choice == "receiver" {
                receiverName = title
               NoteSearch.shared.searchArray = [senderName, receiverName, date]
            }
        }
    }

    func allPurposeChooseViewControllerAction(section: Int, row: Int, title: String, context: Any?) -> (action: AllPurposeChooseViewController.Action, target: RootViewController?, home: UIViewController?) {
        return (AllPurposeChooseViewController.Action.dismiss, nil, nil)
    }
    
}
