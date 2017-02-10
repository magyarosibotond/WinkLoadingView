//
//  ViewController.swift
//  WinkLoadingView
//
//  Created by magyarosibotond on 02/11/2017.
//  Copyright (c) 2017 magyarosibotond. All rights reserved.
//

import UIKit
import WinkLoadingView

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: WinkLoadingView!

    fileprivate var data: [String] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.dataSource = self

        loadingView.animationCompletionHandler = {
            self.tableView.reloadData()
            self.loadingView.isHidden = true
        }

        loadData()
    }

    // MARK: - Data

    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.loadingView.startLoading()
        }


        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.data = ["merise", "prythee", "sharecropper", "gogetting", "saponite", "microtherm", "kohlrabi", "splenetic", "alabastos", "cobalt"]
            self.loadingView.finishLoading()
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
