//
//  DetailViewController.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/13.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // ラベル紐付け
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    // 画面遷移前の情報を持ってくる
    var companyName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        companyNameLabel.text = companyName
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
