//
//  ValidationViewController.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/09.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private func isValidName(name: String?) -> Bool {
    return (name ?? "").count > 3
}

private func isValidPassword(pass: String?) -> Bool {
    return (pass ?? "").count > 5
}

class ValidationViewController: UIViewController {

    @IBOutlet private weak var legacyName: UITextField!
    @IBOutlet private weak var legacyPass: UITextField!

    @IBOutlet private weak var rxName: UITextField!
    @IBOutlet private weak var rxPass: UITextField!

    private let disposeBag = DisposeBag()
    @IBOutlet private weak var legacySubmitButton: UIButton!
    @IBOutlet private weak var rxSubmitButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        prepareLegacy()
        prepareRx()
    }

    private func prepareLegacy() {
        updateLegacyButtonStatus()
    }

    @IBAction func legacyNameDidChange(_ sender: Any) {
        updateLegacyButtonStatus()
    }
    @IBAction func legacyPassDidChange(_ sender: Any) {
        updateLegacyButtonStatus()
    }

    private func updateLegacyButtonStatus() {
        legacySubmitButton.isEnabled =
            isValidName(name: legacyName.text) &&
            isValidPassword(pass: legacyPass.text)
    }

    private func prepareRx() {
        Driver.merge(
            rxName.rx.text.asDriver(), rxPass.rx.text.asDriver()
        ).withLatestFrom(
            Driver.combineLatest(
                rxName.rx.text.asDriver(),
                rxPass.rx.text.asDriver()
        )).map { (name, pass) -> Bool in
            isValidName(name: name) && isValidPassword(pass: pass)
        }.drive(rxSubmitButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}
