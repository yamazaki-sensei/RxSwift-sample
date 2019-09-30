//
//  ViewController.swift
//  rxswift-sample
//
//  Created by Hiraku Ohno on 2019/09/08.
//  Copyright © 2019 hira. All rights reserved.
//

import UIKit

private let items = [
    "ボタンのタップ",
    "タイマー",
    "Validation",
    "APIコール"
]

private let storyboards = [
    UIStoryboard(name: "ButtonTap", bundle: .main),
    UIStoryboard(name: "Timer", bundle: .main),
    UIStoryboard(name: "Validation", bundle: .main),
    UIStoryboard(name: "APICall", bundle: .main)
]

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = items[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboards[indexPath.row].instantiateInitialViewController()!

        navigationController?.pushViewController(vc, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}
