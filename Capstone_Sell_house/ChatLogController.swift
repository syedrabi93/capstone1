//
//  ChatLogController.swift
//  Capstone_Sell_house
//
//  Created by Syed Rabiyama on 2021-04-11.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
    }
    let cellId = "cellId"
    
    var user: UserList? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
            
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        setupCell(cell, message: message)
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        
        return cell
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        
        let userid = Auth.auth().currentUser?.email?.components(separatedBy: "@")
        
        if message.fromId == userid![0] {
            //outgoing blue
            cell.bubbleView.backgroundColor = UIColor.systemBlue
            cell.textView.textColor = UIColor.white
            //cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            

        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            //cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height somehow????
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        
        let uid = email.components(separatedBy: "@")
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid[0])
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("Messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                let chatuser = self.user?.email.components(separatedBy: "@")
                if message.chatPartnerId() == chatuser?[0] {
                    self.messages.append(message)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    lazy var textView: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Message ..."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self
        return textfield
    }()

    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
       
        containerView.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:  10).isActive = true
        textView.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor.gray
        seperatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLine)
        
        seperatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    @objc func handleSend(){
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toid = user?.email.components(separatedBy: "@")
        let fromid = Auth.auth().currentUser?.email!.components(separatedBy: "@")
        let timestamp : NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        let value = ["text" : textView.text! , "toId" : toid![0] , "fromId" : fromid![0] , "timeStamp" : timestamp] as [String : Any]
        //childRef.updateChildValues(value)
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromid![0]).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toid![0]).child(messageId)
            recipientUserMessagesRef.setValue(1)
        }
        textView.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
