//
//  SettingsViewController.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-07.
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
    var logoutObservation: NSKeyValueObservation?
    var searchObservation: NSKeyValueObservation?
    var searchResultObservation: NSKeyValueObservation?
    
    var senderName = "All"
    var receiverName = "All"
    var selectedDate = Date().toString(dateFormat: "yyyy-MM-d")
    var indexPathOpened: IndexPath? = nil
    
    var checkNotesDate: String = "Today"
    
    
    fileprivate var logoutVM : Logout?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        logoutVM = Logout()
        
        arrSections.append((sectionTitle: "SETTINGS", arrEntries: [(tag: 0, entry: "Check notes from", detail: "", handler: #selector(changeSender)), (tag: 1, entry: "Check notes to", detail: "", handler: #selector(changeReceiver)),(tag: 2, entry: "Check notes date", detail: "", handler: #selector(changeDate)),(tag: 3, entry: "Add family members", detail: "", handler: #selector(addFamilyMembers)), (tag: 4, entry: "Logout", detail: "", handler: #selector(logout))]))
        
        arrSections.append((sectionTitle: "ABOUT", arrEntries: [(tag: 100, entry: "Version", detail: "1.0", handler: #selector(showVersion))]))
        
        tableView.register(UINib(nibName: "SettingsChooseDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsChooseDateTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
       
        
        // MVVM KVO
        setKVO()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.baseView.isUserInteractionEnabled = true
    }
    
    // MARK: - KVO
    
    func setKVO() {
        
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
                        if resultCode == 16 {
                            self?.clearSessionToken(clearSession : true, clearToken : true)
                            self?.tabBarController?.dismiss(animated: true, completion: {
                                //
                            })
                        } else if resultCode == 21 {
                            self?.clearSessionToken(clearSession : false, clearToken : true)
                            self?.logoutVM?.loggedout = true
                        }
                        self?.showResultErrorAlert(resultCode: resultCode)
                    }
                }
            
        }
        
        searchResultObservation = NoteSearch.shared.observe(\NoteSearch.searchResult, options: [.old, .new]) { [weak self] object, change in
            DispatchQueue.main.async { [weak self] in
                self?.baseView.isUserInteractionEnabled = true
                let resultCode = NoteSearch.shared.searchResult["resultCode"] as! Int
                if resultCode != 0 {
                    self?.showResultErrorAlert(resultCode: resultCode)
                    if resultCode == 16 {
                        self?.clearSessionToken(clearSession : true, clearToken : true)
                        self?.tabBarController?.dismiss(animated: true, completion: {
                            //
                        })
                    } else if resultCode == 21 {
                        self?.clearSessionToken(clearSession : false, clearToken : true)
                        NoteSearch.shared.searchArray = [self?.senderName, self?.receiverName, self?.selectedDate] as! [String]
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
        allPurposeChooseViewController.arrOptions = FamilyMemberManager.shared.arrFamilyMembers
        self.navigationController?.pushViewController(allPurposeChooseViewController, animated: true)
        baseView.isUserInteractionEnabled = false
    }
    
    @IBAction func changeReceiver() {
        let allPurposeChooseViewController = AllPurposeChooseViewController()
        allPurposeChooseViewController.delegate = self
        allPurposeChooseViewController.dataSource = self
        allPurposeChooseViewController.context = "receiver"
        allPurposeChooseViewController.sTitle = "Receivers"
        allPurposeChooseViewController.arrOptions = FamilyMemberManager.shared.arrFamilyMembers
        self.navigationController?.pushViewController(allPurposeChooseViewController, animated: true)
        baseView.isUserInteractionEnabled = false
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
        cell.dateLabel.text = arrSections[indexPath.section].arrEntries[indexPath.row].entry
        let detail = arrSections[indexPath.section].arrEntries[indexPath.row].detail
        if detail != "" {
            cell.dateSubLabel.text = detail
        }
        if cell.tag != 2 {
            cell.alDateListTopPaddingViewHeight.constant = 0
            cell.alDateHeight.constant = 0
        }
        if cell.tag == 3 || cell.tag == 4 {
            cell.dateSubLabel.text = ""
        }
        if cell.tag == 0 {
            cell.dateSubLabel.text = NoteSearch.shared.searchArray[0]
        }
        
        if cell.tag == 1 {
            cell.dateSubLabel.text = NoteSearch.shared.searchArray[1]
        }
        
        if cell.tag == 2 {
            cell.dateSubLabel.text = checkNotesDate
            
            cell.dateLabel.gestureRecognizers?.removeAll()
            cell.dateSubLabel.gestureRecognizers?.removeAll()
        
            let bookNameLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(gestureRecognizer:)))
            cell.dateLabel.addGestureRecognizer(bookNameLabelTapGestureRecognizer)
            cell.dateLabel.isUserInteractionEnabled = true
            
            let bookFullNameLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(gestureRecognizer:)))
            cell.dateSubLabel.addGestureRecognizer(bookFullNameLabelTapGestureRecognizer)
            cell.dateSubLabel.isUserInteractionEnabled = true

        
        
        cell.dateListView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        
        let daysCount = CommonUtil.getCurrentMonthDays()
        
        var bOpend = false
        if indexPathOpened != nil {
            if (indexPathOpened!.section == indexPath.section) && (indexPathOpened!.row == indexPath.row) {
                bOpend = true
            }
        }
        if bOpend {
            let labelWidth: CGFloat = 40
            let spaceBetween: CGFloat = 8
            var daysPerRow: Int = Int(cell.dateListView.frame.width / (labelWidth + spaceBetween))
            var remainingWidth: CGFloat = cell.dateListView.frame.width - (CGFloat(Float(daysPerRow)) * (labelWidth + spaceBetween))
            if remainingWidth >= labelWidth {
                daysPerRow += 1
            }
            remainingWidth = cell.dateListView.frame.width - (CGFloat(Float(daysPerRow)) * (labelWidth + spaceBetween))
            var rowsOfChapter: Int = daysCount / daysPerRow
            if daysCount % daysPerRow != 0 {
                rowsOfChapter += 1
            }
            
            cell.alDateListTopPaddingViewHeight.constant = 8
            cell.alDateHeight.constant = CGFloat(Float(rowsOfChapter)) * labelWidth + CGFloat(Float((rowsOfChapter - 1))) * spaceBetween
            
            for i in 1...daysCount {
                let subview = cell.dateListView.viewWithTag(i)
                if subview == nil {
                    let myRow = (i - 1) / daysPerRow
                    let myColumn = (i - 1) % daysPerRow
                    let label = UILabel(frame: CGRect(x: CGFloat(Float(myColumn)) * (labelWidth + spaceBetween), y: CGFloat(Float(myRow)) * (labelWidth + spaceBetween), width: labelWidth, height: labelWidth))
                    label.tag = i
                    label.text = "\(i)"
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeGesture(gestureRecognizer:)))
                    label.addGestureRecognizer(tapGestureRecognizer)
                    label.isUserInteractionEnabled = true
                    cell.dateListView.addSubview(label)
                }
            }
            
            if (!(tableView.isDragging)) && (!(tableView.isDecelerating)) {
                DispatchQueue.main.async {
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        else {
            cell.alDateListTopPaddingViewHeight.constant = 0
            cell.alDateHeight.constant = 0
            for i in 1...daysCount {
                if let subview = cell.dateListView.viewWithTag(i) {
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
                            let newDate = Date()
                            let calendar = Calendar.current
                            
                            let year = calendar.component(.year, from: newDate)
                            let month = calendar.component(.month, from: newDate)

                            checkNotesDate = CommonUtil.generateDate(year: year, month: month, day:label.tag).toString(dateFormat: "yyyy-MM-d")
                            selectedDate = checkNotesDate
                            cell.alDateListTopPaddingViewHeight.constant = 0
                            cell.alDateHeight.constant = 0
                            for i in 1...date {
                                if let subview = cell.dateListView.viewWithTag(i) {
                                    subview.removeFromSuperview()
                                }
                            }
                            NoteSearch.shared.searchArray = [senderName, receiverName, selectedDate]
                            baseView.isUserInteractionEnabled = false
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
