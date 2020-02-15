//
//  ViewController.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/06.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, FUIAuthDelegate {

    // テキストフィールド
    @IBOutlet weak var emailTextFIeld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    var db: Firestore!
    
    // firebaseUIのコピペ
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // FBUI。authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        googleLoginButton.addTarget(self,action: #selector(self.AuthButtonTapped(sender:)),for: .touchUpInside)
        
        db = Firestore.firestore()
        
//        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        // google認証用のメソッド
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        createGoogleSigninButton()
        
    }
    
    // FBUI
    @objc func AuthButtonTapped(sender : AnyObject) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
    }
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextvc = storyboard.instantiateViewController(withIdentifier: "NavigationBar")
            nextvc.modalPresentationStyle = .fullScreen // 全面表示
            self.present(nextvc, animated: true, completion: nil)
        }
        // エラー時の処理をここに書く
    }
    
    // Googleボタン
    func createGoogleSigninButton(){
        let googleButton = GIDSignInButton ()
        googleButton.frame = CGRect(x: 20, y: self.view.frame.height/2-30, width: self.view.frame.width-40, height: 60)
        self.view.addSubview(googleButton)
    }
    
    // タイムラインへ遷移するメソッド。認証成功時に組み込む
    func toTimeLine(){
        // storyboardのfileの特定
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // 移動先のNavigationControllerをインスタンス化。
        let nc = storyboard.instantiateViewController(withIdentifier: "NavigationBar") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen // 全面表示
        self.present(nc, animated: true)
    }
    
    
    // エラーが返ってきた場合のアラート。Error型が使われている
    func showErrorAlert(error: Error?) {
        // 表示される文字
        // error?.localizedDescription は firebaseが用意してくれているエラーメッセージ機能
        let alert = UIAlertController(title: "入力エラー", message: error?.localizedDescription, preferredStyle: .alert)
        // OKボタン
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        // アラートにOKボタンを加える
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    // 新規作成ボタン
    @IBAction func newAccountButton(_ sender: Any) {
        // emailとpasswordが入っているか確認する
        guard let email = emailTextFIeld.text, let password = passwordTextField.text else {
            return
        }
        // アカできるか判断する
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            // エラーだった場合。errorは Error型。これはnilもあるのでoptional型となっている。nilが入ったらエラー
            if let error = error {
                print("認証失敗")
                // アラートで通知
                self.showErrorAlert(error: error)
            // 成功した場合
            } else {
                print("新規作成成功")

                // firestoreをインスタンス化
                let db = Firestore.firestore()
                // 生成したIDのoptional型を外す
                guard let createId = Auth.auth().currentUser?.uid else { return }
                // コレクションを指定して、ユーザーごとにドキュメントを作る
                let users = db.collection("users").document("\(String(createId))")

                // ドキュメントにメアドとパスワードを入れる
                let userData: NSDictionary = ["email": email, "password": password, "userID": createId]
                users.setData(userData as! [String : Any])

                // タイムラインに遷移する
                self.toTimeLine()
            }
        })
    }
    
    // ログインボタン
    @IBAction func loginButton(_ sender: Any) {
        
        guard let email = emailTextFIeld.text, let password = passwordTextField.text else {
            return
        }
        // ログイン処理。サインインのメソッド
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(error: error)
                print("ログイン失敗")
            } else {
                print("ログイン成功")
                // firestoreをインスタンス化
                let db = Firestore.firestore()
                // コレクションとドキュメントを指定
                let users = db.collection("users").document("\(String(describing: Auth.auth().currentUser?.uid))")
                // UserDefaultにfirestoreのIdを格納
                UserDefaults.standard.set(users.documentID, forKey: "Id")
                self.toTimeLine()
            }
        })
        
    }
    
    // Google認証ボタン
    @IBAction func googleLoginButton(_ sender: Any) {
    }
    


}

