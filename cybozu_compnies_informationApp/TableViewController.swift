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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
   
}

class TableCell: UITableViewCell {
    
    @IBOutlet weak var companyName: UILabel!
}
