//
//  ButtonTapViewController.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/08.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ButtonTapViewController: UIViewController {

    private let disposeBag = DisposeBag()
    @IBOutlet private weak var label: UILabel!

    // Signalをemitする例のために作っておく
    private var incrementBinder: Binder<Void> {
        return Binder(self) { vc, _ in
            vc.increment()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareLegacy()
        prepareRx()

    }

    private func prepareLegacy() {
        // delegateの実装
        let legacyButton = LegacyButtonView(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
        view.addSubview(legacyButton)
        legacyButton.delegate = self

    }

    private func prepareRx() {
        // Rxの実装
        let rxButton = RxButtonView(frame: CGRect(x: 20, y: 300, width: 100, height: 50))
        view.addSubview(rxButton)

        // イベント発火時に好きなコードを実行できる
        rxButton.didTapButton.emit(onNext: {[weak self] _ in
            self?.increment()
        }).disposed(by: disposeBag)

        // rxのコンテキストに乗っかるならこういう書き方もできる
        rxButton.didTapButton.emit(to: incrementBinder).disposed(by: disposeBag)
    }

    private func increment() {
        let current = Int(label.text!)!
        label.text = "\(current + 1)"
    }
}

extension ButtonTapViewController: LegacyButtonViewDelegate {
    func didTapButton(view: LegacyButtonView) {
        increment()
    }
}
