//
//  NotepadViewController.swift
//  tempproject
//
//  Created by kelci huang on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NotepadViewController: RootViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var senderName: UITextField!
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var fromLable: UILabel!
    @IBOutlet weak var toLable: UILabel!
    
    var noteSubmitObservation: NSKeyValueObservation?
    var familyMembersObservation: NSKeyValueObservation?
    var noteSubmitVM : NoteSubmit?
    var textFieldInOperation: UITextField?
    var pickerView: UIPickerView?
    
    let bodyNotePlaceholder = "Please enter a note here..."
    var jsonNoteCopy: NSMutableDictionary? = NSMutableDictionary()
    var familyMemberList : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteBodyTextView.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        senderName.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        receiverName.setBorder(borderWidth: 1, borderColor: .gray, cornerRadius: 5)
        submitButton.setBorder(borderWidth: 0, borderColor: .orange, cornerRadius: 5)
        
        senderName.delegate = self
        receiverName.delegate = self
        noteBodyTextView.delegate = self
        addKeyboardToolbar(for: noteBodyTextView)
        arrTextViewForElevation.append(noteBodyTextView)
        extraMarginBetweenFirstResponderAndKeyboard = 52
        
        noteSubmitVM = NoteSubmit()
        
        familyMemberList = FamilyMemberManager.shared.arrFamilyMembers
        
        // Do any additional setup after loading the view.
        setKVO()
        
    }

    @IBAction func submit() {
        if noteBodyTextView.text == nil {
            CommonUtil.showDialog(title: "The note is empty!", message: "Please enter your note.", viewController: self)
            return
        }
        
        let jsonNote: NSMutableDictionary? = NSMutableDictionary()
        let date = Date().toString(dateFormat: "yyyy-MM-d")
        
        jsonNote?.setValue(senderName.text, forKey: Constants.NoteKey.sender.rawValue)
        jsonNote?.setValue(receiverName.text, forKey: Constants.NoteKey.receiver.rawValue)
        jsonNote?.setValue(noteBodyTextView.text, forKey: Constants.NoteKey.notebody.rawValue)
        jsonNote?.setValue(date, forKey: Constants.NoteKey.createDate.rawValue)
        jsonNote?.setValue(UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.Userid_string.rawValue), forKey: Constants.NoteKey.userID.rawValue)
        
        noteSubmitVM?.submittedNote = jsonNote
        jsonNoteCopy = jsonNote
        
        noteBodyTextView.resignFirstResponder()
        self.baseView.isUserInteractionEnabled = false
        
        print("submittedNote: \(String(describing: jsonNote))")
    }
    
    // MARK: - KVO
    
    func setKVO() {
        noteSubmitObservation = noteSubmitVM?.observe(\NoteSubmit.submitResult, options: [.old, .new]) { [weak self] object, change in
            
            DispatchQueue.main.async { [weak self] in
                print(NoteSearch.shared.searchResult)
                
                self?.baseView.isUserInteractionEnabled = true
                
                let resultCode = self?.noteSubmitVM?.submitResult["resultCode"] as! Int
                if resultCode == 0 {
                    CommonUtil.showDialog(title: "Submitted!", message: "Your note was submitted.", viewController: self!)
                    
                    if (self?.senderName?.text == NoteSearch.shared.searchArray[0] || NoteSearch.shared.searchArray[0] == "All") && (self?.receiverName?.text == NoteSearch.shared.searchArray[1] || NoteSearch.shared.searchArray[1] == "All") && (Date().toString(dateFormat: "yyyy-MM-d") == NoteSearch.shared.searchArray[2] || NoteSearch.shared.searchArray[2] == "Today") {
                        var senderName = "All"
                        var receiverName = "All"
                        if self?.senderName?.text == NoteSearch.shared.searchArray[0]{
                            senderName = NoteSearch.shared.searchArray[0]
                        }
                        if self?.receiverName?.text == NoteSearch.shared.searchArray[1] {
                            receiverName = NoteSearch.shared.searchArray[1]
                        }
                        NoteSearch.shared.searchArray = [senderName, receiverName, Date().toString(dateFormat: "yyyy-MM-d")]
                    }
                    self?.senderName?.text = ""
                    self?.receiverName?.text = ""
                    self?.noteBodyTextView?.text = self?.bodyNotePlaceholder
                }
                else {
                    self?.showResultErrorAlert(resultCode: resultCode)
                    if resultCode == 16 {
                        self?.clearSessionToken(clearSession : true, clearToken : true)
                        self?.tabBarController?.dismiss(animated: true, completion: {
                            //
                        })
                    } else if resultCode == 21 {
                        self?.clearSessionToken(clearSession : false, clearToken : true)
                        self?.noteSubmitVM?.submittedNote = self?.jsonNoteCopy
                    }
                }
                
            }
            
        }
        
        familyMembersObservation = FamilyMemberManager.shared.observe(\FamilyMemberManager.arrFamilyMembers, options: [.old, .new]) { [weak self] object, change in
            DispatchQueue.main.async { [weak self] in
                self?.familyMemberList = FamilyMemberManager.shared.arrFamilyMembers
            }
        }
    }
    
    // MARK: - PickerView delegate
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return familyMemberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 21
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return familyMemberList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldInOperation?.text = familyMemberList[row]
        pickerView.removeFromSuperview()
        self.pickerView = nil
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let should = super.textFieldShouldBeginEditing(textField)
        if should {
            if (textFieldInOperation != nil) && (textFieldInOperation != textField) {
                pickerView?.removeFromSuperview()
                pickerView = nil
            }
            return true
        }
        else {
            return false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if pickerView == nil {
            self.createPickerView(for: textField)
        }
        textFieldInOperation = textField
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let should = super.textFieldShouldReturn(textField)
        if should {
            pickerView?.removeFromSuperview()
            pickerView = nil
            textField.resignFirstResponder()
            return true
        }
        else {
            return false
        }
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
        var listLength = familyMemberList.count 
        guard listLength > 0 else {
            return
        }
        if listLength > 3 {
            listLength = 3
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
    
    //MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == bodyNotePlaceholder {
            textView.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = bodyNotePlaceholder
        }
    }

}
