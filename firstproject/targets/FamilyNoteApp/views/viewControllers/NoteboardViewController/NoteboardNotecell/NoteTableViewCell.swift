//
//  NoteCell.swift
//  tempproject
//
//  Created by Jaspreet Kaur on 2019-02-15.
//  Copyright © 2019 kelci huang. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteBodyTextField: UITextView!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
