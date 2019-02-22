//
//  NotepadViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NotepadViewController: RootViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var senderName: UITextField!
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var fromLable: UILabel!
    @IBOutlet weak var toLable: UILabel!
    
    var noteSubmitObservation: NSKeyValueObservation?
    var noteSubmitVM : NoteSubmit?
    var textFieldInOperation: UITextField?
    var pickerView: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteBodyTextView.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        senderName.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        receiverName.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        submitButton.setBorder(borderWidth: 0, borderColor: .orange, cornerRadius: 5)
        
        senderName.delegate = self
        receiverName.delegate = self
        
        //self.noteBodyTextView.backgroundColor = UIColor(patternImage: UIImage(named: "notes.jpeg")!)
        
        noteSubmitVM = NoteSubmit(networkFascilities: networkFascilities!)
        
        // Do any additional setup after loading the view.
        noteSubmitObservation = noteSubmitVM?.observe(\NoteSubmit.submitResult, options: [.old, .new]) { [weak self] object, change in
           
            DispatchQueue.main.async { [weak self] in
                print(NoteSearch.shared.searchResult)
                
                let resultCode = self?.noteSubmitVM?.submitResult["resultCode"] as! Int
                if resultCode == 0 {
                    CommonUtil.showDialog(title: "Submitted!", message: "Your note was submitted.", viewController: self!)
                    self?.senderName?.text = ""
                    self?.receiverName?.text = ""
                    self?.noteBodyTextView?.text = ""
                }
                else {
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

    @IBAction func submit() {
        if noteBodyTextView.text == nil {
            CommonUtil.showDialog(title: "The note is empty!", message: "Please enter your note.", viewController: self)
            return
        }
        
        let jsonNote: NSMutableDictionary? = NSMutableDictionary()
        let date = Date().toString(dateFormat: "yyyy-MM-dd")
        
        jsonNote?.setValue(senderName.text, forKey: Constants.NoteKey.sender.rawValue)
        jsonNote?.setValue(receiverName.text, forKey: Constants.NoteKey.receiver.rawValue)
        jsonNote?.setValue(noteBodyTextView.text, forKey: Constants.NoteKey.notebody.rawValue)
        jsonNote?.setValue(date, forKey: Constants.NoteKey.createDate.rawValue)
        jsonNote?.setValue(UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Userid_string.rawValue), forKey: Constants.NoteKey.userID.rawValue)
        
        noteSubmitVM?.submittedNote = jsonNote
        
        print("submittedNote: \(String(describing: jsonNote))")
    }
    
    // MARK: - PickerView delegate
    
    var familyMemberList = AddFamilyMember.shared.arrFamilyMembers
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return familyMemberList?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 21
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return familyMemberList?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldInOperation?.text = familyMemberList?[row]
        pickerView.removeFromSuperview()
        self.pickerView = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textFieldInOperation != nil) && (textFieldInOperation != textField) {
            pickerView?.removeFromSuperview()
            pickerView = nil
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if pickerView == nil {
            self.createPickerView(for: textField)
        }
        textFieldInOperation = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pickerView?.removeFromSuperview()
        pickerView = nil
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if pickerView != nil {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textFieldInOperation = nil
    }
    
    func createPickerView(for textField: UITextField) {
        var listLength = familyMemberList?.count ?? 0
        guard listLength > 0 else {
            return
        }
        if listLength > 10 {
            listLength = 10
        }
        
        pickerView?.removeFromSuperview()
        
        pickerView = UIPickerView()
        guard pickerView != nil else {
            return
        }
        pickerView!.delegate = self
        
        let position = textField.absolutePosition(to: baseView)
        var frame = textField.frame
        frame.origin.x = position.x - 40
        frame.origin.y = position.y - 10
        frame.size.width = frame.width / 2
        frame.size.height = CGFloat(listLength * 21 * 2)
        pickerView!.frame = frame
        
        baseView.addSubview(pickerView!)
    }

}
