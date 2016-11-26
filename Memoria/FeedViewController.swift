//
//  FeedViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 25/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit
import DZNEmptyDataSet

class FeedViewController: ViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    let tableView = TableView()
    let taskServices: TasksServices
    var tasksDisplays = [TaskDisplay]()
    var taskChangedListener: EventListener<Any>?
    
    init(taskServices: TasksServices) {
        self.taskServices = taskServices
        super.init(nibName: nil, bundle: nil)
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Content.getContent(ContentType.labelTxt, name: "FeedTitle")
        self.setupView()
        self.reloadTable()
        self.bindView()
    }
    
    //MARK: Setup
    
    func setupView() {
        view.addSubview(tableView)
        tableView.leadingToSuperView(false)
        tableView.trailingToSuperView(false)
        tableView.topToSuperView(false)
        tableView.bottomAlighnToViewBottom(self.view, offset: -50)
        tableView.register(FeedCell.self, forCellReuseIdentifier: String(describing: FeedCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, -34, 0);
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear
    }
    
    //MARK: Reload
    
    func reloadTable() {
        self.tasksDisplays = self.taskServices.getUpcomingTasksDisplays()
        self.tableView.reloadData()
    }
    
    //MARK: Bind
    
    func bindView() {
        self.taskChangedListener = Events.shared.tasksChanged.on { task in
            self.reloadTable()
        }
    }

    //MARK: TableView data sourcr and delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskDisplay = self.tasksDisplays[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedCell.self))! as! FeedCell
        cell.setModel(taskDispaly: taskDisplay)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksDisplays.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FeedCell.height()
    }
    
    //MARK: Exmpty state delegate
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No tasks schedules for today"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You can schedule more tasks from your Family web client."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "NoResults")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return self.defaultBackgroundColor
    }
    
    
}
