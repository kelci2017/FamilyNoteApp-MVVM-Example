//
//  NotepadViewController.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-07.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NotepadViewController: RootViewController {

    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var senderName: UITextField!
    @IBOutlet weak var receiverName: UITextField!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var fromLable: UILabel!
    @IBOutlet weak var toLable: UILabel!
    
    var noteSubmitObservation: NSKeyValueObservation?
    var noteSubmitVM : NoteSubmit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteBodyTextView.setBorder(borderWidth: 1, borderColor: .orange, cornerRadius: 5)
        senderName.setBorder(borderWidth: 1, borderColor: .orange, cornerRadius: 5)
        receiverName.setBorder(borderWidth: 1, borderColor: .orange, cornerRadius: 5)
        submitButton.setBorder(borderWidth: 0, borderColor: .orange, cornerRadius: 5)
        
        noteBodyTextView.font = noteBodyTextView.font?.boldItalic
        receiverName.font = receiverName.font?.boldItalic
        senderName.font = senderName.font?.boldItalic
        fromLable.font = fromLable.font?.boldItalic
        toLable.font = toLable.font?.boldItalic
        
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

}
