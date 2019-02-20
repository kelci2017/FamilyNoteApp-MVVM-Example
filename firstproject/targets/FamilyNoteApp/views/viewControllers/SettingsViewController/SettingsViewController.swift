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
    
    var senderName = "All"
    var receiverName = "All"
    // date = Date().toString(dateFormat: "yyyy-MM-dd")
    var selectedDate = ""
    var indexPathOpened: IndexPath? = nil
    
    var checkNotesDate: String = "Today"
    
    
    fileprivate var logoutVM : Logout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        logoutVM = Logout(networkFascilities: networkFascilities!)
        
        arrSections.append((sectionTitle: "SETTINGS", arrEntries: [(tag: 0, entry: "Check notes from", detail: "", handler: #selector(changeSender)), (tag: 1, entry: "Check notes to", detail: "", handler: #selector(changeReceiver)),(tag: 2, entry: "Check notes date", detail: "", handler: #selector(changeDate)),(tag: 3, entry: "Add family members", detail: "", handler: #selector(addFamilyMembers)), (tag: 4, entry: "Logout", detail: "", handler: #selector(logout))]))
        
        arrSections.append((sectionTitle: "ABOUT", arrEntries: [(tag: 100, entry: "Version", detail: "1.0", handler: #selector(showVersion))]))
        
        tableView.register(UINib(nibName: "SettingsChooseDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsChooseDateTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
       
        
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
                if resultCode != 0 {
                    self?.showResultErrorAlert(resultCode: resultCode)
                    if resultCode == 16 {
                        UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                        UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                        self?.tabBarController?.dismiss(animated: true, completion: {
                            //
                        })
                    }
                }
            }
        }
        
        searchObservation = NoteSearch.shared.observe(\NoteSearch.searchArray, options: [.old, .new]) { [weak self] object, change in
            DispatchQueue.main.async { [weak self] in
                if (change.newValue != nil) && (change.newValue != change.oldValue) {
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsChooseDateTableViewCell") as! SettingsChooseDateTableViewCell
        
        cell.tag = arrSections[indexPath.section].arrEntries[indexPath.row].tag
        cell.bookNameLabel.text = arrSections[indexPath.section].arrEntries[indexPath.row].entry
        let detail = arrSections[indexPath.section].arrEntries[indexPath.row].detail
        if detail != "" {
            cell.bookFullNameLabel.text = detail
        }
        if cell.tag != 2 {
            cell.alChapterListTopPaddingViewHeight.constant = 0
            cell.alChapterListViewHeight.constant = 0
        }
        if cell.tag == 3 || cell.tag == 4 {
            cell.bookFullNameLabel.text = ""
        }
        if cell.tag == 0 {
            cell.bookFullNameLabel.text = NoteSearch.shared.searchArray[0]
        }
        
        if cell.tag == 1 {
            cell.bookFullNameLabel.text = NoteSearch.shared.searchArray[1]
        }
        
        if cell.tag == 2 {
            cell.bookFullNameLabel.text = checkNotesDate
            
            cell.bookNameLabel.gestureRecognizers?.removeAll()
            cell.bookFullNameLabel.gestureRecognizers?.removeAll()
        
            let bookNameLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(gestureRecognizer:)))
            cell.bookNameLabel.addGestureRecognizer(bookNameLabelTapGestureRecognizer)
            cell.bookNameLabel.isUserInteractionEnabled = true
            
            let bookFullNameLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(gestureRecognizer:)))
            cell.bookFullNameLabel.addGestureRecognizer(bookFullNameLabelTapGestureRecognizer)
            cell.bookFullNameLabel.isUserInteractionEnabled = true

        
        
        cell.chapterListView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        
        let chapterCount = CommonUtil.getCurrentMonthDays()
        
        var bOpend = false
        if indexPathOpened != nil {
            if (indexPathOpened!.section == indexPath.section) && (indexPathOpened!.row == indexPath.row) {
                bOpend = true
            }
        }
        if bOpend {
            let labelWidth: CGFloat = 40
            let spaceBetween: CGFloat = 8
            var chaptersPerRow: Int = Int(cell.chapterListView.frame.width / (labelWidth + spaceBetween))
            var remainingWidth: CGFloat = cell.chapterListView.frame.width - (CGFloat(Float(chaptersPerRow)) * (labelWidth + spaceBetween))
            if remainingWidth >= labelWidth {
                chaptersPerRow += 1
            }
            remainingWidth = cell.chapterListView.frame.width - (CGFloat(Float(chaptersPerRow)) * (labelWidth + spaceBetween))
            var rowsOfChapter: Int = chapterCount / chaptersPerRow
            if chapterCount % chaptersPerRow != 0 {
                rowsOfChapter += 1
            }
            
            cell.alChapterListTopPaddingViewHeight.constant = 8
            cell.alChapterListViewHeight.constant = CGFloat(Float(rowsOfChapter)) * labelWidth + CGFloat(Float((rowsOfChapter - 1))) * spaceBetween
            
            for i in 1...chapterCount {
                let subview = cell.chapterListView.viewWithTag(i)
                if subview == nil {
                    let myRow = (i - 1) / chaptersPerRow
                    let myColumn = (i - 1) % chaptersPerRow
                    let label = UILabel(frame: CGRect(x: CGFloat(Float(myColumn)) * (labelWidth + spaceBetween), y: CGFloat(Float(myRow)) * (labelWidth + spaceBetween), width: labelWidth, height: labelWidth))
                    label.tag = i
                    label.text = "\(i)"
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(gestureRecognizer:)))
                    label.addGestureRecognizer(tapGestureRecognizer)
                    label.isUserInteractionEnabled = true
                    cell.chapterListView.addSubview(label)
                }
            }
            
            if (!(tableView.isDragging)) && (!(tableView.isDecelerating)) {
                DispatchQueue.main.async {
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        else {
            cell.alChapterListTopPaddingViewHeight.constant = 0
            cell.alChapterListViewHeight.constant = 0
            for i in 1...chapterCount {
                if let subview = cell.chapterListView.viewWithTag(i) {
                    subview.removeFromSuperview()
                }
            }
        }
    }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        perform(arrSections[indexPath.section].arrEntries[indexPath.row].handler)
    }
    
    @IBAction func didRecognizeGesture(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer is UITapGestureRecognizer {
            var view = gestureRecognizer.view
            let date = CommonUtil.getCurrentMonthDays()
            while (view != nil) && !(view is SettingsChooseDateTableViewCell) {
                view = view?.superview
            }
            if view is SettingsChooseDateTableViewCell {
                let cell = view as! SettingsChooseDateTableViewCell
                if let indexPath = tableView.indexPath(for: cell) {
                    
                    if gestureRecognizer.view is UILabel {
                        let label = gestureRecognizer.view as! UILabel
                        if (label.tag == 2001) || (label.tag == 2002) {
                            if indexPath == indexPathOpened {
                                indexPathOpened = nil
                            }
                            else {
                                indexPathOpened = indexPath
                            }
                            if indexPathOpened != nil {
                                UIFascilities.lockUpOrientation()
                            }
                            else {
                                UIFascilities.unlockOrientation()
                            }
                            tableView.reloadData()
                        } else if (label.tag >= 1) && (label.tag <= date) {
                            // print("*** chapter \(label.tag)")
                            let newDate = Date()
                            let calendar = Calendar.current
                            
                            let year = calendar.component(.year, from: newDate)
                            let month = calendar.component(.month, from: newDate)

                            checkNotesDate = CommonUtil.generateDate(year: year, month: month, day:label.tag).toString(dateFormat: "yyyy-MM-dd")
                            selectedDate = checkNotesDate
                            cell.alChapterListTopPaddingViewHeight.constant = 0
                            cell.alChapterListViewHeight.constant = 0
                            for i in 1...date {
                                if let subview = cell.chapterListView.viewWithTag(i) {
                                    subview.removeFromSuperview()
                                }
                            }
                            NoteSearch.shared.searchArray = [senderName, receiverName, selectedDate]
                            
                            indexPathOpened = nil
                            tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    // MARK: - AllPurposeChooseViewControllerDelegate, AllPurposeChooseViewControllerDataSource
    
    func allPurposeChooseViewControllerDidSelect(section: Int, row: Int, title: String, context: Any?) {
        // print("allPurposeChooseViewControllerDidSelect: \(section):\(row), \(title)")
        let choice = context as? String
        if choice != nil {
            if choice == "sender" {
                senderName = title
                NoteSearch.shared.searchArray = [senderName, receiverName, selectedDate]
            }
            if choice == "receiver" {
                receiverName = title
               NoteSearch.shared.searchArray = [senderName, receiverName, selectedDate]
            }
        }
    }

    func allPurposeChooseViewControllerAction(section: Int, row: Int, title: String, context: Any?) -> (action: AllPurposeChooseViewController.Action, target: RootViewController?, home: UIViewController?) {
        return (AllPurposeChooseViewController.Action.dismiss, nil, nil)
    }
    
}
