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

    // Google認証ボタン
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
        
        // google認証用のメソッド
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        // Googleログインボタンを丸くする
        googleLoginButton.layer.masksToBounds = true
        googleLoginButton.layer.cornerRadius = 25

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
    
    
//    // タイムラインへ遷移するメソッド。認証成功時に組み込む
//    func toTimeLine(){
//        // storyboardのfileの特定
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        // 移動先のNavigationControllerをインスタンス化。
//        let nc = storyboard.instantiateViewController(withIdentifier: "NavigationBar") as! UINavigationController
//        nc.modalPresentationStyle = .fullScreen // 全面表示
//        self.present(nc, animated: true)
//    }
//
    
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
    
    
    // Google認証ボタン
    @IBAction func googleLoginButton(_ sender: Any) {
    }
    


}

