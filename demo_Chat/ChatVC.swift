//
//  ChatVC.swift
//  demo_Chat
//
//  Created by DUY on 6/21/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import MobileCoreServices
import Kingfisher
import JSQMessagesViewController


class ChatVC: JSQMessagesViewController {
    
    @IBOutlet weak var imgHinh: UIImageView!
    @IBOutlet weak var txtNhapTN: UITextField!
    @IBOutlet weak var imgChonHinh: UIImageView!
    let picker:UIImagePickerController = UIImagePickerController()
    var arrayChat:Array<String> = Array<String>()
    var CurrentUser:User?
    var storage = Storage.storage().reference(forURL: "gs://chat-650c7.appspot.com/")
    var messenges = [JSQMessage]()
    var uidMessage:String? = nil
    var ref = Database.database().reference(fromURL: "https://chat-650c7.firebaseio.com/")
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let aut = Auth.auth()
        self.senderId = aut.currentUser?.uid
        CurrentUser = User()
        CurrentUser?.uid = aut.currentUser?.uid
        self.senderDisplayName = "Duy"
        self.messenges = getMessenges()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSend(_ sender: Any) {
        
    }
    @IBAction func tapCamera(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Thong Bao", message: "vui long chon", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] (Photo) in
            self?.showCameraAndLibrary(picker: (self?.picker)!, viewcontroller: self!, soureType: .photoLibrary, allowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (Camera) in
            self?.showCameraAndLibrary(picker: (self?.picker)!, viewcontroller: self!, soureType: .camera, allowEditing: false)
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self] (Video) in
            self?.showCameraAndLibrary(picker: (self?.picker)!, viewcontroller: self!, soureType: .camera, allowEditing: false)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func showCameraAndLibrary(picker: UIImagePickerController, viewcontroller: UIViewController, soureType: UIImagePickerControllerSourceType, allowEditing:Bool) {
        
        picker.sourceType = soureType
        picker.allowsEditing = allowEditing
        viewcontroller.present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
extension ChatVC {
    func getMessenges() -> [JSQMessage]{
        var messenges = [JSQMessage]()
        
//        let messenges1 = JSQMessage(senderId: self.senderId, displayName: "Duy", text: "hello DogHung")
//        let messenges2 = JSQMessage(senderId: self.senderDisplayName, displayName: "Dog", text: "hello DuyHandSome")
//        messenges.append(messenges1!)
//        messenges.append(messenges2!)
        
        return messenges
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messenges.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messenges[indexPath.item]
    }
    
    // Tao messenger
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let messenge = messenges[indexPath.row]
        let messengeUserName = messenge.senderDisplayName
        
        return NSAttributedString(string: messengeUserName!)
        
    }
    
    // Khoang cach cac Messenges
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    // Chen Image
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "Profile_Selected"), diameter: 30)
    }
    
    // Mau` Messenger
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let messenge = messenges[indexPath.row]
        if CurrentUser?.uid == messenge.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .red)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .green)
            
        }
        
    }
    
    // tao table Chat
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    // Send Button
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let TotalMess = ref.child("ToTalMessages")
        let id1 = TotalMess.child((CurrentUser?.uid)!)
        let id2 = TotalMess.child(uidMessage!)
        
        let messageTb = ref.child("Message")
        let messageID = messageTb.childByAutoId()
        let timestamp = Int((NSDate().timeIntervalSince1970))
        let value = ["message":text,"sendID":uidMessage!,"fromID":CurrentUser?.uid! as Any, "timestamp": timestamp] as [String : Any]
        messageID.setValue(value)
        messageID.observeSingleEvent(of: .value, with: { (snapshot) in
            var mess = Message()
            guard let dictionary = snapshot.value as? [String:AnyObject] else  {
                return
            }
            
            mess.messages = dictionary["message"] as? String
            let valueMessForUser = ["message":mess.messages]
            id1.child(snapshot.key).setValue(valueMessForUser)
            id2.child(snapshot.key).setValue(valueMessForUser)
        })
        messenges.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        collectionView.reloadData()
        
        finishSendingMessage()
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messenges[indexPath.item]
        if msg.isMediaMessage{
            if let mediaItem = msg.media as? JSQVideoMediaItem{
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true, completion: nil)
            }
        }
    }
    
    // Chon Image Messenger
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert:UIAlertController = UIAlertController(title: "Media Messages", message: "Select a media", preferredStyle: .actionSheet)
        let cancel:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photo:UIAlertAction = UIAlertAction(title: "Photo", style: .default) { (alert:UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        }
        let videos:UIAlertAction = UIAlertAction(title: "Videos", style: .default) { (alert:UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie)
        }
        alert.addAction(cancel)
        alert.addAction(photo)
        alert.addAction(videos)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func chooseMedia(type: CFString){
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    
}
extension ChatVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            let img = JSQPhotoMediaItem(image: pic)

            self.messenges.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: img))
//            let messageImage = ref.child("MessageImage")
//            let message = messageImage.childByAutoId()
//            let timestamp = Int((NSDate().timeIntervalSince1970))
//            let value = ["messageImage":img as Any,"sendID":uidMessage!,"fromID":CurrentUser?.uid! as Any, "timestamp": timestamp] as [String : Any]
//            message.setValue(value, withCompletionBlock: { (error, data) in
//                if error != nil {
//                    ProgressHUD.showError(error?.localizedDescription)
//                }else{
//                    ProgressHUD.showSuccess("Success")
//                    ProgressHUD.dismiss()
//                }
//            })
//            
            
        }else if let url = info[UIImagePickerControllerMediaURL] as? URL{
            let video = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
            messenges.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
            
        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}

