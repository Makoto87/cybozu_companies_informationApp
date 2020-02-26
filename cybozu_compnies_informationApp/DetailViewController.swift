//
//  DetailViewController.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/13.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    // ラベル紐付け
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    @IBOutlet weak var jobhuntingFlowTextLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    // アラート
    var alertController: UIAlertController!
    
    let db = Firestore.firestore()
    
    // 画面遷移前の情報を持ってくる
    var companyName = ""
    var capital = ""
    var numberOfMembers = ""
    var jobHuntingFlow = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 前画面の情報を入れる
        companyNameLabel.text = "会社名 ： " + companyName
        capitalLabel.text = "資本金　：　" + capital
        numberOfMembersLabel.text = "従業員数　：　" + numberOfMembers
        jobhuntingFlowTextLabel.text = "選考フロー　" + jobHuntingFlow
        // ボタンを使えなくする
        postCommentButton.isEnabled = false
    }

    // 次の画面に値を渡す。コメントリストへ。
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           if segue.identifier == "toList" {
                
                let nextView = segue.destination as! CommentTableViewController
                nextView.companyName = companyName
           }
       }
    
    // コメントを入力した後に出すアラート
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }
    
    
    @IBAction func toCommentList(_ sender: Any) {
        
        // 画面遷移時
        performSegue(withIdentifier: "toList", sender: nil)
    }
    
    //テキストフィールドの有無でボタンが使えるか判断
    @IBAction func commentTextField(_ sender: Any) {
        if commentTextField.text == "" {
            postCommentButton.isEnabled = false
        } else {
            postCommentButton.isEnabled = true
        }
    }
    
    // 投稿ボタン
    @IBAction func postCommentButton(_ sender: Any) {
        // テキストフィールドのコメントを格納
        let comment = ["comment" : commentTextField!.text!]
        db.collection("companies").document(companyName).collection("comments").addDocument(data: comment)
        // 文字を消す
        commentTextField.text = ""
        // アラートを出す
        alert(title: "コメントしました",
        message: "")
        postCommentButton.isEnabled = false
    }
    

}
