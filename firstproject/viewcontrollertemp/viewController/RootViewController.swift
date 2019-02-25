//
//  RootViewController.swift
//  firstproject
//
//  Created by kelci huang on 2018-12-17.
//  Copyright © 2018 kelci huang. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, AppL2DelegateProtocol, UITextFieldDelegate, UITextViewDelegate {
    
    var sTitle: String?
    var navigationTitleLabel: UILabel?
    var navigationTitleView: UIView?
    let navigationBackImage = UIImage.navigationBackImage()
    var navigationBackViewController: UIViewController?
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var networkFascilities: NetworkUtil?
    var wasActive: Bool?
    
    var arrTextViewForElevation: [UITextView] = []
    var keyboardHeight: CGFloat = 0
    var firstResponderView: UIView? = nil
    let marginBetweenFirstResponderAndKeyboard: CGFloat = 4
    var extraMarginBetweenFirstResponderAndKeyboard: CGFloat = 0
    var viewLiftedHeightForKeyboard: CGFloat = 0
    
    // MARK: life cycle
    
    // <custom init https://theswiftdev.com/2017/10/11/uikit-init-patterns/>
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.initialize()
    }
    
    func initialize() {
        //do your stuff here
    }
    // </custom init https://theswiftdev.com/2017/10/11/uikit-init-patterns/>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if sTitle == nil {
            sTitle = "\(CommonUtil.getTargetName() ?? "Untitled")"
        }
        
        // <Prevent the bottom of view from being behind tab bar>
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false

        
        if self.navigationController != nil {
            if let backgroundColor = UIColor.color(withHexColorCode: CommonUtil.getNavigationBarBackgroundColorCode()) {
                self.navigationController!.navigationBar.barTintColor = backgroundColor
            }
            
            setNavigationTitleLabel(title: nil, textColor: nil, fontSize: 0)
        }
        
        networkFascilities = NetworkUtil(sessionOwner: self)
        wasActive = (networkFascilities!.sessionOwnerState == NetworkUtil.NetworkSessionOwnerState.active)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        
        // will be called before viewWillAppear and viewWillDisappear
        
        if parent == nil {
            appDelegate.deregisterAppL2ViewControllerDelegate(delegate: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //
        networkFascilities?.sessionOwnerState = .active
        wasActive = true
        
        if isBeingPresented {
            appDelegate.registerAppL2ViewControllerDelegate(delegate: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //
        networkFascilities?.sessionOwnerState = .inactive
        wasActive = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            appDelegate.deregisterAppL2ViewControllerDelegate(delegate: self)
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        // will be called after viewDidAppear and viewDidDisappear
        if parent != nil {
            appDelegate.registerAppL2ViewControllerDelegate(delegate: self)
        }
    }
    
    
    // MARK: - Common Fascilities
    
    func showDialog(title: String, message: String) {
        CommonUtil.showDialog(title: "Oops!", message: message, viewController: self)
    }
    
    func setNavigationTitleLabel(title: String?, textColor: UIColor?, fontSize: CGFloat) {
        if navigationTitleLabel == nil {
            navigationTitleLabel = UILabel()
        }
        guard navigationTitleLabel != nil else {
            return
        }
        navigationTitleLabel!.textColor = textColor ?? UIColor.color(withHexColorCode: CommonUtil.getNavigationBarForegroundColorCode()) ?? UIColor.black
        if fontSize > 0.1 {
            navigationTitleLabel!.font = navigationTitleLabel!.font.withSize(fontSize)
        }
        navigationTitleLabel!.text = title ?? sTitle
        navigationTitleLabel!.sizeToFit()
        
        if navigationTitleView == nil {
            navigationTitleView = UIView()
            navigationTitleView?.addSubview(navigationTitleLabel!)
        }
        navigationTitleView?.frame = navigationTitleLabel!.frame
        self.navigationItem.titleView = navigationTitleView
    }
    
    
    // forceDismissForNavigationRoot: If self is the root viewController of a naviagtionController, forceDismissForNavigationRoot will decide whether to dismiss the naviagtionController or not
    func dismiss(animated: Bool, forceDismissForNavigationRoot: Bool, completion: @escaping (_ success: Bool) -> Void) {
        if self.navigationController != nil {
            var popToViewController: UIViewController? = navigationBackViewController
            if popToViewController == nil {
                let count = self.navigationController!.viewControllers.count
                for i in 0..<count {
                    let viewController = self.navigationController!.viewControllers[i]
                    if (viewController === self) && (i > 0) {
                        popToViewController = self.navigationController!.viewControllers[i - 1]
                        break
                    }
                }
            }
            if popToViewController != nil {
                self.navigationController!.popToViewController(popToViewController!, animated: animated)
                completion(true)
            }
            else if forceDismissForNavigationRoot {
                self.navigationController!.dismiss(animated: animated) {
                    completion(true)
                }
            }
            else {
                completion(false)
            }
        }
        else {
            self.dismiss(animated: animated) {
                completion(true)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func navigationBack(sender: AnyObject) {
        if navigationBackViewController != nil {
            self.navigationController?.popToViewController(navigationBackViewController!, animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - AppL2Delegate
    
    func applicationWillResignActive(_ application: AppDelegate){
        // print("TemplateViewController applicationWillResignActive")
        wasActive = (networkFascilities?.sessionOwnerState == NetworkUtil.NetworkSessionOwnerState.active)
    }
    
    func applicationDidEnterBackground(_ application: AppDelegate) {
        // print("TemplateViewController applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: AppDelegate) {
        // print("TemplateViewController applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: AppDelegate) {
        // print("TemplateViewController applicationDidBecomeActive")
        if wasActive! {
            networkFascilities?.sessionOwnerState = .active
        }
    }
    
    func applicationWillTerminate(_ application: AppDelegate) {
        // print("TemplateViewController applicationWillTerminate")
    }
    
    // MARK: - webservice call result processing
    
    func showResultErrorAlert(resultCode : Int?) {
        switch resultCode {
        case 1:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.unknownError.rawValue)
        case 2:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.networkError.rawValue)
        case 100:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.resultNull.rawValue)
        case 12:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.wrongPassword.rawValue)
        case 13:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.userNotFound.rawValue)
        case 14:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.userHasRegistered.rawValue)
        case 15:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.accessDenied.rawValue)
        case 17:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.emailNotFound.rawValue)
        case 22:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.signatureFailed.rawValue)
        case 23:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.tokenNotFound.rawValue)
        case 24:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.keyInvalid.rawValue)
        case 25:
            self.showDialog(title: "Oops!", message: Constants.ResultCode.wrongTokenScheme.rawValue)
        default:
            break
        }
        
    }
    // MARK: - Keyboard observation
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        
        if firstResponderView is UITextField {
            liftViewForKeyboardIfNecessary()
        }
        else if firstResponderView is UITextView {
            liftViewForKeyboardIfNecessary()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        declineViewIfLifted()
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        keyboardHeight = 0
    }
    
    func liftViewForKeyboardIfNecessary() {
        declineViewIfLifted()
        
        if (firstResponderView is UITextView) && (!(arrTextViewForElevation.contains(firstResponderView as! UITextView))) {
            return
        }
        
        if let absolutePosition = self.firstResponderView?.absolutePosition(to: nil) {
            let screenHeight = UIScreen.main.bounds.size.height
            let liftup = absolutePosition.y + self.firstResponderView!.frame.height + self.marginBetweenFirstResponderAndKeyboard + self.extraMarginBetweenFirstResponderAndKeyboard + self.keyboardHeight - screenHeight
            if liftup > 0.1 {
                var frame = self.view.frame
                frame.origin.y -= liftup
                self.view.frame = frame
                
                self.viewLiftedHeightForKeyboard = liftup
                UIFascilities.lockUpOrientation()
            }
        }
    }
    
    func declineViewIfLifted() {
        if (viewLiftedHeightForKeyboard < 0.01) {
            return
        }
        
        var frame = self.view.frame
        frame.origin.y += self.viewLiftedHeightForKeyboard
        self.view.frame = frame
        self.viewLiftedHeightForKeyboard = 0
        UIFascilities.unlockOrientation()
    }
    
    
    // MARK: - Keyboard Toolbar
    
    func prepareKeyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(keyboardToolbarDoneButtonAction))
        toolbar.items = [flexBarButton, doneBarButton]
        return toolbar
    }
    
    func addKeyboardToolbar(for textField: UITextField) {
        textField.inputAccessoryView = prepareKeyboardToolbar()
    }
    
    func addKeyboardToolbar(for textView: UITextView) {
        textView.inputAccessoryView = prepareKeyboardToolbar()
    }
    
    @objc func keyboardToolbarDoneButtonAction() {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        if firstResponderView is UITextField {
            let textField = firstResponderView as! UITextField
            textField.resignFirstResponder()
        }
        else if firstResponderView is UITextView {
            let textView = firstResponderView as! UITextView
            textView.resignFirstResponder()
        }
        firstResponderView = nil
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponderView = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = text.trimmingCharacters(in: .whitespaces)
        }
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        firstResponderView = textView
        return true
    }
    
    
}
