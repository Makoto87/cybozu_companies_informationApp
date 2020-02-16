//
//  TableViewController.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/12.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    // firestoreのインスタンス化
    let db = Firestore.firestore()
    // 投稿のデータベースから取ってくる情報をすべて格納
    var items = [NSDictionary]()
    // 次の画面へ持っていくテキスト
    var nvcCompanyName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
//        // データを取ってくるメソッド
//        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // データを取ってくるメソッド
        fetch()
    }
    
    // firestoreから投稿データを取得
    func fetch() {
        // 取得データを格納する場所
        var tempItems = [NSDictionary]()
        // postドキュメントからデータをもらう
        db.collection("companies").getDocuments() {(querysnapshot, err) in
            // アイテムを全部取ってくる。
            for item in querysnapshot!.documents {
                let dict = item.data()
                tempItems.append(dict as NSDictionary)      // tempItemsに追加
            }
            self.items = tempItems                          // 最初に作った配列に格納
            // 順番を入れ替え
            self.items = self.items.reversed()
            // リロード
            self.mainTableView.reloadData()
        }
    }
    
    // セルの設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableCell = self.mainTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableCell
        
        // itemsの中からindexpathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        
        
        cell.companyName.text = dict["companyName"] as? String
        
        return cell
        
    }
    
    // セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = items[(indexPath as NSIndexPath).row]
        nvcCompanyName = (dict["companyName"] as? String)!
        
        // 別の画面に遷移
        performSegue(withIdentifier: "detailSegue", sender: nil)
        
    }
    
    // 画面遷移時のメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "detailSegue", let secondVC = segue.destination as? DetailViewController  else{
            return
        }
        // 情報を渡す
        secondVC.companyName = nvcCompanyName
        
    }
    
    // ログアウトボタン
    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func toPostButton(_ sender: Any) {
        performSegue(withIdentifier: "toPostViewController", sender: nil)
    }
    
}

class TableCell: UITableViewCell {
    
    @IBOutlet weak var companyName: UILabel!
}
