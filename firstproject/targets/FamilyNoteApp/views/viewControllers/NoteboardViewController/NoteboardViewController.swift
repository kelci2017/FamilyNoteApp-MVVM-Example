//
//  NoteboardViewController.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteboardViewController: RootViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var tableUIView: UIView!
    @IBOutlet weak var boardFrameUIView: UIView!
    @IBOutlet weak var globalSearchSwitch: UISwitch!
    @IBOutlet weak var localSearchSwitch: UISwitch!
    
    var noteSearchObservation : NSKeyValueObservation?
    var noteGlobalSearchObservation : NSKeyValueObservation?
    
    var noteGlobalSearchVM : NoteGlobalSearch?
    
    var localSwitchValue = false
    var globalSwitchValue = false
    
    var arrFilteredContents: Array<Dictionary<String, Any>> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boardFrameUIView.setBorder(borderWidth: 3, borderColor: .gray, cornerRadius: 10)
        searchField.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        
        let searchImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(globalSearch))
        searchImage.addGestureRecognizer(searchImageViewTapGestureRecognizer)
        searchImage.isUserInteractionEnabled = true
        
        noteGlobalSearchVM = NoteGlobalSearch(networkFascilities: networkFascilities!)
        
        tableView.register(UINib(nibName: "NoteboardNoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteboardNoteTableViewCell")
        
        NoteSearch.shared.searchArray = ["All", "All", Date().toString(dateFormat: "yyyy-MM-dd")]
        // MVVM KVO
        setKVO()
        
        globalSearchSwitch?.setOn(false, animated: false)
        localSearchSwitch?.setOn(false, animated: false)
        
        searchField.delegate = self
        
        if localSearchSwitch.isOn {
            filterContents()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchField.resignFirstResponder()
        
    }
    
    @IBAction func localSearchSwitchValueChanged(_ sender: UISwitch!) {
        if sender.isOn {
            localSwitchValue = true
            globalSearchSwitch?.setOn(false, animated: true)
            globalSwitchValue = false
        } else {
            localSwitchValue = false
        }
    }
    
    @IBAction func globalSearchSwitchValueChanged(_ sender: UISwitch!) {
        
        if sender.isOn {
            
            globalSwitchValue = true
            localSearchSwitch?.setOn(false, animated: true)
            localSwitchValue = false
            
        } else {
            globalSwitchValue = false
        }
        
    }
    
    // MARK: KVO
    
   func setKVO() {
    
    noteSearchObservation = NoteSearch.shared.observe(\NoteSearch.searchResult, options: [.old, .new]) { [weak self] object, change in
        DispatchQueue.main.async { [weak self] in
            if let resultCode = NoteSearch.shared.searchResult["resultCode"] as? Int {
                self?.baseView.isUserInteractionEnabled = true
                if resultCode != 0 {
                    self?.showResultErrorAlert(resultCode: resultCode)
                    if resultCode == 16 {
                        UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                        UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Sessionid_string.rawValue)
                        self?.tabBarController?.dismiss(animated: true, completion: {
                            //
                        })
                    } else if resultCode == 21 {
                        UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.Token_string.rawValue)
                        NoteSearch.shared.searchArray = ["All", "All", Date().toString(dateFormat: "yyyy-MM-dd")]
                        if let keyword = self?.searchField.text {
                            NoteSearch.shared.sCurrentSearch = keyword
                        }
                        return
                    }
                }
                
                self?.filterContents()
                self?.tableView.reloadData()
            }
        }
    }
    }
    
    func filterContents(keywords: String? = nil) {
        arrFilteredContents = NoteSearch.shared.searchResult["resultDesc"] as? Array<Dictionary<String, Any>> ?? []
        if let keywords = keywords?.trimmingCharacters(in: .whitespaces) {
            if keywords != "" {
                arrFilteredContents = []
                let arrKeywords = keywords.components(separatedBy: .whitespaces)
                let arrContents = NoteSearch.shared.searchResult["resultDesc"] as? Array<Dictionary<String, Any>> ?? []
                for content in arrContents {
                    var containsAll = false
                    if let noteBody = content["noteBody"] as? String {
                        containsAll = true
                        for keyword in arrKeywords {
                            if !(noteBody.containsIgnoringCase(find: keyword)) {
                                containsAll = false
                                break
                            }
                        }
                    }
                    if containsAll {
                        arrFilteredContents.append(content)
                    }
                }
            }
        }
    }
    
    
    // MARK: tableView datasource and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilteredContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteboardNoteTableViewCell") as! NoteboardNoteTableViewCell
        
        let content = arrFilteredContents[indexPath.row]
        let fromWhom: String? = content["fromWhom"] as? String
        let toWhom: String? = content["toWhom"] as? String
        let created: String? = content["created"] as? String
        let noteBody: String? = content["noteBody"] as? String
        
        if let indexOfEnd = created?.index((created?.endIndex)!, offsetBy: -14) {
            cell.dateLabel.text = String((created?[..<indexOfEnd])!)
        }
        cell.fromLabel.text = fromWhom
        cell.toLabel.text = toWhom
        cell.noteBodyLabel.text = noteBody
        
        return cell
    }
    
    // MARK: global search actions
    
    @IBAction func globalSearch() {
        if searchField.text != nil && globalSwitchValue {
            self.baseView.isUserInteractionEnabled = false
            NoteSearch.shared.sCurrentSearch = searchField.text!
        }
        
        if searchField.text != nil && localSwitchValue {
            self.tableView.reloadData()
        }
    }
    
    // MARK: TEXTFIELD delegate
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let should = super.textFieldShouldBeginEditing(textField)
        if should {
            if !globalSwitchValue && !localSwitchValue {
                return false
            } else {
                return true
            }
        }
        else {
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if localSearchSwitch.isOn {
            var text = textField.text ?? ""
            if let swiftRange = Range(range, in: text) {
                text = text.replacingCharacters(in: swiftRange, with: string)
            }
            filterContents(keywords: text)
            tableView.reloadData()
        }
        
        return true
    }
}
