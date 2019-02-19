//
//  AllPurposeChooseViewController.swift
//  TemplateApp
//
//  Created by Zhengqian Kuang on 2018-11-12.
//  Copyright © 2018 JandJ. All rights reserved.
//

import UIKit

class AllPurposeChooseViewController: RootViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AllPurposeChooseViewControllerDelegate?
    var dataSource: AllPurposeChooseViewControllerDataSource?
    var context: Any?
    var bSectional = false
    var arrOptions: Array<String>? // [(sTitle, sDescription)]
    var arrSectionalOptions: Array<(String, Array<String>)>? // [(sSectionTitle, [(sTitle, sDescription)])]
    
    enum Action {
        case undefined, present, push, dismiss, stay
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if bSectional {
            if arrSectionalOptions == nil {
                return 0
            }
            else {
                return arrSectionalOptions!.count
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if bSectional {
            let (sectionTitle, _) = arrSectionalOptions![section]
            return sectionTitle
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bSectional {
            let (_, arrEntries) = arrSectionalOptions![section]
            return arrEntries.count
        }
        else {
            if arrOptions == nil {
                return 0
            }
            
            return arrOptions!.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCellReuseId = "tableViewCellReuseId"
        var cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: tableViewCellReuseId)
        }
        
        var title: String
        if bSectional {
            let (_, arrEntries) = arrSectionalOptions![indexPath.section]
            title = arrEntries[indexPath.row]
        }
        else {
            title = arrOptions![indexPath.row]
        }
        cell!.textLabel?.text = title
//        if description != "" {
//            cell!.detailTextLabel?.text = description
//        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var title : String
        if bSectional {
            let (_, arrEntries) = arrSectionalOptions![indexPath.section]
            title = arrEntries[indexPath.row]
        }
        else {
            title = arrOptions![indexPath.row]
        }
        
        delegate?.allPurposeChooseViewControllerDidSelect(section: indexPath.section, row: indexPath.row, title: title, context: context)
        
        let (action, target, home) = (dataSource?.allPurposeChooseViewControllerAction(section: indexPath.section, row: indexPath.row, title: title, context: context)) ?? (AllPurposeChooseViewController.Action.undefined, nil, nil)
        if action == .push {
            target!.navigationBackViewController = home
            self.navigationController?.pushViewController(target!, animated: true)
        }
        else if action == .present {
            self.present(target!, animated: true) {
                //
            }
        }
        else if action == .dismiss {
            self.dismiss(animated: true, forceDismissForNavigationRoot: true) { (finished) in
                self.delegate?.allPurposeChooseViewControllerDidDismiss(section: indexPath.section, row: indexPath.row, title: title, context: self.context)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


protocol AllPurposeChooseViewControllerDelegate {
    func allPurposeChooseViewControllerDidSelect(section: Int, row: Int, title: String, context: Any?)
    func allPurposeChooseViewControllerDidDismiss(section: Int, row: Int, title: String, context: Any?)
}

extension AllPurposeChooseViewControllerDelegate {
    func allPurposeChooseViewControllerDidDismiss(section: Int, row: Int, title: String, context: Any?) {
        
    }
}


protocol AllPurposeChooseViewControllerDataSource {
    func allPurposeChooseViewControllerAction(section: Int, row: Int, title: String, context: Any?) -> (action: AllPurposeChooseViewController.Action, target: RootViewController?, home: UIViewController?)
}
