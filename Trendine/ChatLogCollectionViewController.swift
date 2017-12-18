//
//  ChatLogCollectionViewController.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class Message: NSObject {
    
    var senderId: String?
    var text: String?
    
    
}


class ChatLogCollectionViewController:  UICollectionViewController , UICollectionViewDelegateFlowLayout , UITextViewDelegate , AVAudioRecorderDelegate, AVAudioPlayerDelegate, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate  {
    
    var messages = [[Message]]()
    
    private let reuseIdentifier = "Cell"
    private let withReuseIdentifier = "withReuseIdentifier"
    
    
    let inputAccessoryContainerView: UIView = {
        let containerV = UIView()
        containerV.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        containerV.translatesAutoresizingMaskIntoConstraints = false
        return containerV
        
    }()
    
    let inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.clipsToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(white: 0.8, alpha: 0.8).cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .black
        textView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return textView
        
    }()
    
    lazy var  sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.setTitleColor(MessagesCollectionViewCell.blueColor, for: .normal)
        button.addTarget(self, action: #selector(handleSendButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    lazy var attachmentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "AddIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleStickerButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    
    let stickersPreviewViewContainer: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 1
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.isHidden = false
        //        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    var bottomConstraints: NSLayoutConstraint?
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        
        self.inputTextView.delegate = self
        
        // Register cell classes
        self.collectionView!.register(ChatLogCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(TimeStampHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: withReuseIdentifier)
        
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 60, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 60, 0)
        
        collectionView?.backgroundColor = .lightGray
        self.collectionView?.alwaysBounceVertical = true
        
        navigationItem.title = "Rockson"
        
        let m = Message()
        m.senderId = "Rockson"
        m.text = "Pleasure to meet y'all."
        messages.append([m])
        
        
        let me = Message()
        me.senderId = "lol"
        me.text = "Cheers!!"
        messages.append([me])
        
        
        let mes = Message()
        mes.senderId = "lol"
        mes.text = "Cheers!! boys thebparty just begun!. Thank God for life and for everything. Jesus my Lord and savior "
        messages.append([mes])
        
        let mess = Message()
        mess.senderId = "lol"
        mess.text = "Hello, everyone"
        messages.append([mess])
        
        self.collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDismiss)))
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let addAttachmentView = AttachmentItemsView()
        addAttachmentView.incomingVC = self
        addAttachmentView.translatesAutoresizingMaskIntoConstraints = false
        self.stickersPreviewViewContainer.addSubview(addAttachmentView)
        
        addAttachmentView.rightAnchor.constraint(equalTo: stickersPreviewViewContainer.rightAnchor).isActive = true
        addAttachmentView.leftAnchor.constraint(equalTo: stickersPreviewViewContainer.leftAnchor).isActive = true
        addAttachmentView.heightAnchor.constraint(equalTo: stickersPreviewViewContainer.heightAnchor).isActive = true
        addAttachmentView.centerYAnchor.constraint(equalTo: stickersPreviewViewContainer.centerYAnchor).isActive = true
        
        stickersPreviewViewContainer.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        addAttachmentView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    
    
    func handleSendButtonTapped(){
        
        
        if self.inputTextView.text.isEmpty == false {
            
            if let text = inputTextView.text {
                
                let m = Message()
                m.senderId = "Rockson"
                m.text = text
                messages.append([m])
                collectionView?.reloadData()
                
                let indexPath = IndexPath(item: 0 , section: messages.count - 1)
                collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
                
                inputTextView.text = ""
                self.inputContainerViewHeightConstraint?.constant = 56
                
                
            }
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            collectionView?.backgroundView = UIImageView(image: image)
            collectionView?.backgroundView?.contentMode = .scaleAspectFill
            collectionView?.layer.masksToBounds = true
            
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let indexPath = IndexPath(item: 0 , section: messages.count - 1)
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        
    }
    
    
    
    
    var slideUpAndDown = false
    
    func handleStickerButtonTapped(){
        
        
        if slideUpAndDown == false {
            
            let indexPath = IndexPath(item: 0 , section: messages.count - 1)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            
            handleSlideShowAttachmentItems()
            
            
        }else if slideUpAndDown == true {
            
            handleSlideDismissAttachmentItems()
            
            
        }
        
        
        
        
        
    }
    
    func handleSlideShowAttachmentItems(){
        
        //        self.scrollCollectionVToTheTop()
        //
        //
        self.slideUpAndDown = true
        self.inputTextView.endEditing(true)
        self.bottomConstraints?.constant = 0
        
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
        self.view.addSubview(stickersPreviewViewContainer)
        self.stickersPreviewViewContainer.frame = CGRect(x: 0, y: view.frame.height - 8, width: view.frame.width, height: 200)
        
        //        handleKeyboardDismiss()
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.stickersPreviewViewContainer.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
            
            self.bottomConstraints?.constant = -(200)
            self.view.layoutIfNeeded()
            
            
            
        }) { (completed) in
            
            
            
        }
        
        
        
        
    }
    
    
    
    func handleSlideDismissAttachmentItems(){
        
        
        self.slideUpAndDown = false
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.stickersPreviewViewContainer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 240)
            
            self.bottomConstraints?.constant = 0
            self.view.layoutIfNeeded()
            
            
        }, completion: nil)
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let height = estimatedRect(statusText: textView.text, fontSize: 17).height
        
        if height > 56 && height <= 150 {
            
            self.inputContainerViewHeightConstraint?.constant = height
            
            
        }
        
        if textView.text.isEmpty {
            
            self.inputContainerViewHeightConstraint?.constant = 56
            
            
        }
        
        
        return  true
    }
    
    
    
    func handleKeyboardDismiss(){
        
        self.handleSlideDismissAttachmentItems()
        
        self.inputTextView.endEditing(true)
        self.bottomConstraints?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification){
        
        if let keyboardInfo = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.handleSlideDismissAttachmentItems()
            
            
            self.bottomConstraints?.constant = -(keyboardInfo.height)
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
        
        
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification){
        
        
        self.bottomConstraints?.constant = 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
    }
    
    func setUpViews(){
        
        self.view.addSubview(inputAccessoryContainerView)
        inputAccessoryContainerView.addSubview(sendButton)
        inputAccessoryContainerView.addSubview(attachmentButton)
        inputAccessoryContainerView.addSubview(inputTextView)
        
        inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 8).isActive = true
        inputTextView.topAnchor.constraint(equalTo: inputAccessoryContainerView.topAnchor, constant: 8).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: inputAccessoryContainerView.bottomAnchor, constant: -8).isActive = true
        
        attachmentButton.leftAnchor.constraint(equalTo: inputAccessoryContainerView.leftAnchor, constant: 5).isActive = true
        attachmentButton.bottomAnchor.constraint(equalTo: inputAccessoryContainerView.bottomAnchor, constant: -15).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: inputAccessoryContainerView.rightAnchor,constant: -5).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: inputAccessoryContainerView.bottomAnchor, constant: -15).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputAccessoryContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        inputAccessoryContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomConstraints = inputAccessoryContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraints?.isActive = true
        inputContainerViewHeightConstraint = inputAccessoryContainerView.heightAnchor.constraint(equalToConstant: 56)
        inputContainerViewHeightConstraint?.isActive = true
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatLogCollectionViewCell
        
        let message = messages[indexPath.section][indexPath.item]
        cell.messageTextView.text = message.text
        
        
        cell.messageWidthConstraint?.constant = estimatedRect(statusText: message.text!, fontSize: 16).width + 34
        
        
        
        
        if message.senderId == "Rockson" {
            
            cell.incomingProfileImage.isHidden = true
            cell.outgoingProfileImage.isHidden = false
            
            cell.leftConstraint?.isActive = false
            cell.rightConstraint?.isActive = true
            
            cell.messageTextView.textColor = .white
            cell.messageContainerView.backgroundColor = .clear
            cell.bubbleImageView.tintColor = UIColor(white: 0.1, alpha: 0.8)
            
            cell.bubbleImageView.image = #imageLiteral(resourceName: "bubble_blue").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
            
            
        }else{
            
            cell.bubbleImageView.tintColor = .white
            cell.incomingProfileImage.isHidden = false
            cell.outgoingProfileImage.isHidden = true
            
            cell.leftConstraint?.isActive = true
            cell.rightConstraint?.isActive = false
            cell.messageContainerView.backgroundColor = .clear
            cell.messageTextView.textColor = .black
            
            cell.bubbleImageView.image = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
            
            
            
        }
        
        
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 0
        
        let message = messages[indexPath.section][indexPath.item]
        
        height = estimatedRect(statusText: message.text!, fontSize: 16).height + 32
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var headerView: TimeStampHeaderReusableView?
        headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: withReuseIdentifier, for: indexPath) as? TimeStampHeaderReusableView
        headerView?.backgroundColor = .clear
        
        return headerView!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var headerHeight: CGFloat = 0
        
        if (section % 3) == 0 {
            
            headerHeight = 30
            
        }else{
            
            headerHeight = 0
            
        }
        
        return CGSize(width: view.frame.width, height: headerHeight)
    }
    
    func estimatedRect(statusText: String, fontSize: CGFloat) -> CGRect {
        
        return NSString(string: statusText).boundingRect(with: CGSize(width: self.view.frame.width - 100, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        
    }



    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
