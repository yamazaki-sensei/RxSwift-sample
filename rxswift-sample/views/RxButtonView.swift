//
//  RxButtonView.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/08.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxButtonView: UIView {
    private var button: UIButton!

    var didTapButton: Signal<Void> {
        return button.rx.tap.asSignal()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func addButton() {
        button = UIButton()
        button.setTitle("Rxボタン", for: .normal)
        button.setTitleColor(.red, for: .normal)
        addSubview(button)
    }
}
