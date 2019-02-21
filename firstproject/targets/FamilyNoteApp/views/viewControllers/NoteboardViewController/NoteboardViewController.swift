//
//  NoteboardViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteboardViewController: RootViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var tableUIView: UIView!
    
    var noteSearchObservation : NSKeyValueObservation?
    var noteGlobalSearchObservation : NSKeyValueObservation?
    
    var noteGlobalSearchVM : NoteGlobalSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setBorder(borderWidth: 3, borderColor: .orange, cornerRadius: 10)
        //searchField.setBorder(borderWidth: 1, borderColor: .orange, cornerRadius: 5)
        
        
        noteGlobalSearchVM = NoteGlobalSearch(networkFascilities: networkFascilities!)
        
        tableView.register(UINib(nibName: "NoteboardNoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteboardNoteTableViewCell")
        
        // MVVM KVO
        setKVO()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NoteSearch.shared.searchArray = ["All", "All", Date().toString(dateFormat: "yyyy-MM-dd")]
    }

    // MARK: KVO
    
   func setKVO() {
    
    noteSearchObservation = NoteSearch.shared.observe(\NoteSearch.searchResult, options: [.old, .new]) { [weak self] object, change in
        DispatchQueue.main.async { [weak self] in
            if let resultCode = NoteSearch.shared.searchResult["resultCode"] as? Int {
                if resultCode == 0 {
                    self?.tableView.reloadData()
                } else {
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
    }
    }
    
    
    // MARK: tableView datasource and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arrContents: Array<Dictionary<String, Any>> = NoteSearch.shared.searchResult["resultDesc"] as? Array<Dictionary<String, Any>> {
            return arrContents.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteboardNoteTableViewCell") as! NoteboardNoteTableViewCell
        
        if let arrContents: Array<Dictionary<String, Any>> = NoteSearch.shared.searchResult["resultDesc"] as? Array<Dictionary<String, Any>> {
            let content = arrContents[indexPath.row]
            let fromWhom: String? = content["fromWhom"] as? String
            let toWhom: String? = content["toWhom"] as? String
            let created: String? = content["created"] as? String
            let noteBody: String? = content["noteBody"] as? String
            
            //let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            //let date = dateFormatter.date(from:created ?? "")!
            
            cell.fromLabel.text = fromWhom
            cell.toLabel.text = toWhom
            cell.dateLabel.text = created
            cell.noteBodyLabel.text = noteBody
        }
        else {
            print("*** resultCode: \(String(describing: NoteSearch.shared.searchResult["resultCode"])), resultDesc: \(String(describing: NoteSearch.shared.searchResult["resultDesc"]))")
        }
        
        return cell
    }
    
    // MARK: global search actions
    
    @IBAction func globalSearch() {
        if searchField.text != nil {
            noteGlobalSearchVM?.sCurrentSearch = searchField.text!
        }
    }
    
}
