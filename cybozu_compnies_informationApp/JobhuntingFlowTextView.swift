//
//  JobhuntingFlowTextView.swift
//  cybozu_compnies_informationApp
//
//  Created by 堀田真 on 2020/02/24.
//  Copyright © 2020 堀田真. All rights reserved.
//

import UIKit

@IBDesignable class JobhuntingFlowTextView: UITextView {

    @IBInspectable private var placeHolder: String = "かかかかっかかか閣下" {
        willSet {
            self.placeHolderLabel.text = newValue
            self.placeHolderLabel.sizeToFit()
        }
    }

    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x:0, y: 0, width: 100, height: 50))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = self.font
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
        label.backgroundColor = .clear
        self.addSubview(label)
        return label
    }()

    // MARK: Initializers

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: View Life-Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        changeVisiblePlaceHolder()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged),
                                               name: UITextField.textDidChangeNotification, object: nil)
    }

    // MARK: Other Private Methods

    private func changeVisiblePlaceHolder() {
        self.placeHolderLabel.alpha = (self.placeHolder.isEmpty || !self.text.isEmpty) ? 0.0 : 1.0
    }

    @objc private func textChanged(notification: NSNotification?) {
        changeVisiblePlaceHolder()
    }

}
