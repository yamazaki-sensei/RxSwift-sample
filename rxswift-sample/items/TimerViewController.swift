//
//  TimerViewController.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/08.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TimerViewController: UIViewController {

    @IBOutlet private weak var legacyButton: UIButton!
    @IBOutlet private weak var rxButton: UIButton!

    @IBOutlet private weak var legacyValueLabel: UILabel!
    @IBOutlet private weak var rxValueLabel: UILabel!

    private var legacyTimer: Timer!
    private var legacyValue = 0 {
        didSet {
            legacyValueLabel.text = "\(legacyValue)"
        }
    }

    private var rxTimer: Timer!
    private let countBehavior = BehaviorSubject(value: 10)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareLagacy()
        prepareRx()
    }

    // Legacy周りのセットアップ
    private func prepareLagacy() {
        legacyTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {[weak self] (timer) in
            self?.incrementLegacy()
        })
        // 初期値設定
        legacyValue = 7
        legacyButton.addTarget(self, action: #selector(didTapLegacyButton), for: .touchUpInside)
    }

    @objc private func didTapLegacyButton() {
        incrementLegacy()
    }

    private func incrementLegacy() {
        legacyValue += 1
    }

    // Rx周りのセットアップ
    private func prepareRx() {
        // countBehaviorの値とテキストの中身を同期
        countBehavior.asDriver(onErrorJustReturn: 0)
            .map { "\($0)" }
            .drive(rxValueLabel.rx.text)
            .disposed(by: disposeBag)

        let timer: Signal<Void> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).asSignal(onErrorJustReturn: 0).map { _ in }

        // タイマー発火時かボタンタップ時にインクリメントする
        Signal.merge(timer, rxButton.rx.tap.asSignal())
            .emit(onNext: {[weak self] (_) in
                guard let self = self else { return }
                let current = try! self.countBehavior.value()
                self.countBehavior.onNext(current + 1)
            }).disposed(by: disposeBag)
    }
}
