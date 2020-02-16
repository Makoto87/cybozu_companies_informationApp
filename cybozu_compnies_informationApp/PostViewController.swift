//
//  PostViewController.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/16.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PostViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var comapnyTextField: UITextField!
    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var numberOfMembersTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    
    // firestoreをインスタンス化
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンを使えなくする
        postButton.isEnabled = false
        
        // 全画面表示
        self.modalPresentationStyle = .fullScreen
        
    }
    
    // テキストフィールドを埋めたらボタンが使えるようにするメソッド
    func buttonisEnabled() {
        if comapnyTextField.text == "" || capitalTextField.text == "" || numberOfMembersTextField.text == "" {
            postButton.isEnabled = false
        } else {
            postButton.isEnabled = true
        }
    }
    
//    @IBAction func companyNameTextField(_ sender: Any) {
//        buttonisEnabled()
//
//    }
//
    
    @IBAction func companyNameTextField(_ sender: Any) {
        buttonisEnabled()
    }
    
   
    @IBAction func CapitalTextField(_ sender: Any) {
        buttonisEnabled()
    }
    
    
    @IBAction func numberOfNumbersTextField(_ sender: Any) {
        buttonisEnabled()
    }
    

    @IBAction func postButton(_ sender: Any) {
        
        let companyName = comapnyTextField.text
        let capital = capitalTextField.text
        let numberOfMembers = numberOfMembersTextField.text
        // Firestoreに飛ばす箱を用意
        let companies: NSDictionary = ["companyName": companyName ?? "", "capital": capital!, "numberOfMembers": numberOfMembers as Any]
        // firebaseに送る
        db.collection("companies").addDocument(data: companies as! [String : Any])

        // 画面を消す
//        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
}
