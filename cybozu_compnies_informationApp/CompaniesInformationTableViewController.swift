//
//  CompaniesInformationTableViewController.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/08.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CompaniesInformationTableViewController: UITableViewController {

    @IBOutlet var mainTableView: UITableView!
    
    let db = Firestore.firestore()  // firestoreをインスタンス化
    var items = [NSDictionary]()    // firebaseから取ってくる情報を格納
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // 高さを自動調節する
//        mainTableView.estimatedRowHeight = 5
//        mainTableView.rowHeight = UITableView.automaticDimension
        
        fetch()
        print(items[0]["companyName"] as? String as Any)
    }
    
    // firebaseから情報を取ってくる
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
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell

        cell.comapanyNameLabel.text = "NTT"
        
//        let label = cell.viewWithTag(1) as! UILabel
//        label.text = "NTT"

        return cell
    }

    // セルの高さを動的にする
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension //自動設定
        return 500
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class Cell: UITableViewCell {
    
    @IBOutlet weak var comapanyNameLabel: UILabel!  // 企業名
    @IBOutlet weak var industryLabel: UILabel!      // 業界
    @IBOutlet weak var capitalLabel: UILabel!       // 資本金
    @IBOutlet weak var numberOfMembersLabel: UILabel!   // 従業員数
    
    
    
}
