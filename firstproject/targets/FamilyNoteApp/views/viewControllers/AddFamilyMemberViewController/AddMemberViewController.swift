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
    var familyMembersArary : Array<String>?
    var arrFamilyMembers : Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func add() {
        
        arrFamilyMembers = UserDefaults.standard.array(forKey: Constants.UserDefaultsKey.FamilyMember_string.rawValue) as! Array<String>
        
        if member1Name!.text != nil && !(arrFamilyMembers?.contains(member1Name.text!))! {
            familyMembersArary?.append(member1Name.text!)
        }
        if member2Name!.text != nil && !(arrFamilyMembers?.contains(member2Name.text!))!{
            familyMembersArary?.append(member2Name.text!)
        }
        if member3Name!.text != nil && !(arrFamilyMembers?.contains(member3Name.text!))!{
            familyMembersArary?.append(member3Name.text!)
        }
        if member4Name!.text != nil && !(arrFamilyMembers?.contains(member4Name.text!))!{
            familyMembersArary?.append(member4Name.text!)
        }
        if member5Name!.text != nil && !(arrFamilyMembers?.contains(member5Name.text!))!{
            familyMembersArary?.append(member5Name.text!)
        }
        if member6Name!.text != nil && !(arrFamilyMembers?.contains(member6Name.text!))!{
            familyMembersArary?.append(member6Name.text!)
        }
        if member7Name!.text != nil && !(arrFamilyMembers?.contains(member7Name.text!))!{
            familyMembersArary?.append(member7Name.text!)
        }
        if member8Name!.text != nil && !(arrFamilyMembers?.contains(member8Name.text!))!{
            familyMembersArary?.append(member8Name.text!)
        }
        if member9Name!.text != nil && !(arrFamilyMembers?.contains(member9Name.text!))!{
            familyMembersArary?.append(member9Name.text!)
        }
        
        if familyMembersArary != nil {
            AddFamilyMember.shared.arrFamilyMembers = familyMembersArary!
            self.dismiss(animated: true, completion: {
                //
            })
            
        }
        
    }


}
