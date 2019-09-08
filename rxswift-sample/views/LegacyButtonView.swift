//
//  LegacyButtonView.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/08.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit

protocol LegacyButtonViewDelegate: class {
    func didTapButton(view: LegacyButtonView)
}

class LegacyButtonView: UIView {

    weak var delegate: LegacyButtonViewDelegate?
    private var button: UIButton!

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
        button.setTitle("Legacyボタン", for: .normal)
        addSubview(button)
        button.setTitleColor(.red, for: .normal)

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton() {
        delegate?.didTapButton(view: self)
    }
}
