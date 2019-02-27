//
//  AddMemberViewController.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-11.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class AddMemberViewController: RootViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var member1Name: UITextField!
    @IBOutlet weak var member2Name: UITextField!
    @IBOutlet weak var member3Name: UITextField!
    @IBOutlet weak var member4Name: UITextField!
    @IBOutlet weak var member5Name: UITextField!
    @IBOutlet weak var member6Name: UITextField!
    @IBOutlet weak var member7Name: UITextField!
    @IBOutlet weak var member8Name: UITextField!
    @IBOutlet weak var member9Name: UITextField!
   
    var addFamilyMemberObservation: NSKeyValueObservation?
    var familyMembersObservation: NSKeyValueObservation?
    var arrFamilyMembers : Array<String> = []
    var arrSavedFamilyMembers : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue)
        addButton.setBorder(borderWidth: 0, borderColor: .orange, cornerRadius: 5)
        
        arrSavedFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as? Array<String> ?? []
        
        familyMembersObservation = FamilyMemberManager.shared.observe(\FamilyMemberManager.postFamilyMembersResult, options: [.old, .new]) { [weak self] object, change in
            DispatchQueue.main.async { [weak self] in
                if let resultCode = FamilyMemberManager.shared.postFamilyMembersResult["resultCode"] as? Int {
                    //self?.baseView.isUserInteractionEnabled = true
                    if resultCode != 0 {
                        self?.showResultErrorAlert(resultCode: resultCode)
                        if resultCode == 16 {
                            self?.clearSessionToken(clearSession : true, clearToken : true)
                            self?.tabBarController?.dismiss(animated: true, completion: {
                                //
                            })
                        } else if resultCode == 21 {
                            self?.clearSessionToken(clearSession : false, clearToken : true)
                            if self?.arrFamilyMembers.count ?? 0 > 0 {
                                FamilyMemberManager.shared.arrFamilyMembers = self?.arrFamilyMembers ?? []
                            }
                            return
                        }
                    }
                    self?.dismiss(animated: true, forceDismissForNavigationRoot: false) { (finished) in
                        //
                    }
            }
        }
    }
    }
    
    @IBAction func add() {
        
        addFamilyMember(name: member1Name.text)
        addFamilyMember(name: member2Name.text)
        addFamilyMember(name: member3Name.text)
        addFamilyMember(name: member4Name.text)
        addFamilyMember(name: member5Name.text)
        addFamilyMember(name: member6Name.text)
        addFamilyMember(name: member7Name.text)
        addFamilyMember(name: member8Name.text)
        addFamilyMember(name: member9Name.text)
        
        if arrFamilyMembers.count > 0 {
            FamilyMemberManager.shared.postFamilyMembers = true
            FamilyMemberManager.shared.arrFamilyMembers = arrFamilyMembers
        }
        
//        dismiss(animated: true, forceDismissForNavigationRoot: false) { (finished) in
//            //
//        }
        
    }
    
    func addFamilyMember(name: String?) {
        guard name != nil else {
            return
        }
        
        let name = name!.trimmingCharacters(in: .whitespaces)
        if name == "" {
            return
        }
        
        if arrSavedFamilyMembers.contains(name) {
            return
        }
        
        arrFamilyMembers.append(name)
    }


}
