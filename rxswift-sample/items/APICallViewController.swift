//
//  APICallViewController.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/30.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol APIMockDelegate: class {
    func api(api: APIMock, didReceiveData data: String)
}

final class APIMock {
    weak var delegate: APIMockDelegate?
    func call() {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.delegate?.api(api: self, didReceiveData: "hogehoge")
            }
        }
    }
}

final class RxAPIMock {
    func call() -> Single<String> {
        return Single.create { single in
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 1)
                
                DispatchQueue.main.async {
                    single(.success("rx hogehoge"))
                }
            }
            return Disposables.create()
        }
    }
}

class APICallViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let apiMock = APIMock()
    private let rxApiMock = RxAPIMock()

    @IBOutlet weak var legacyButton: UIButton!
    @IBOutlet weak var rxButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLegacy()
        prepareRx()
    }
    
    private func prepareLegacy() {
        apiMock.delegate = self
        legacyButton.addTarget(self, action: #selector(didTapLegacyButton(_:)), for: .touchUpInside)
        
    }
    
    @objc func didTapLegacyButton(_ sender: UIButton) {
        apiMock.call()
    }
    
    private func prepareRx() {
        rxButton.rx.tap
            .flatMap { RxAPIMock().call().asSignal(onErrorJustReturn: "" )}
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
}

extension APICallViewController: APIMockDelegate {
    func api(api: APIMock, didReceiveData data: String) {
        print(data)
    }
}
