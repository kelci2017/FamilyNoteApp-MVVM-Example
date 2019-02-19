//
//  AddMemberViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-11.
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
    var arrFamilyMembers : Array<String> = []
    var arrSavedFamilyMembers : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // UserDefaults.standard.set(nil, forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue)
        
        arrSavedFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as? Array<String> ?? []
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
            AddFamilyMember.shared.arrFamilyMembers = arrFamilyMembers
        }
        
        dismiss(animated: true, forceDismissForNavigationRoot: false) { (finished) in
            //
        }
        
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
