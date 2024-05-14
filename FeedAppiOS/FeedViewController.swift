//
//  FeedViewController.swift
//  FeedAppiOS
//
//  Created by Aram Ispiryan on 13.05.24.
//

import UIKit
import FeedApp

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var isViewIsAppeared = false

    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        if !isViewIsAppeared {
            load()
        }
        isViewIsAppeared = true
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
    }

    @objc private func load() {
        refreshControl?.beginRefreshing()

        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}