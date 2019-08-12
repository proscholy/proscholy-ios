//
//  ViewController.swift
//  Zpevnik
//
//  Created by Patrik Dobiáš on 23/07/2019.
//  Copyright © 2019 Patrik Dobiáš. All rights reserved.
//

import UIKit
import CoreData

class ListVC<T: DataSource>: ViewController, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate {
    
    lazy var searchView: SearchView = {
        let searchView = SearchView()
        
        searchView.searchField.addTarget(self, action: #selector(updateData(sender:)), for: .editingChanged)
        
        return searchView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var dataSource: T!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        
        dataSource.registerCell(tableView, forCellReuseIdentifier: "cellId")
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchView.searchField.updateFontSize()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setTitle("")
        searchView.searchField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
    // MARK: - View Settings
    
    internal func setViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", metrics: nil, views: ["tableView": tableView]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[tableView]|", metrics: nil, views: ["tableView": tableView]))
    }
    
    func showSearchView(placeholder: String) {
        navigationItem.titleView = searchView
        searchView.searchField.placeholder = placeholder
        searchView.searchField.updateFontSize()
    }
    
    // MARK: - Data Handlers
    
    func loadData() {
        dataSource.loadData()
//        if let data: [T] = CoreDataService.fetchData(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], context: PersistenceService.context) {
//            dataSource.data = data
//
//            updateData(sender: searchView.searchField)
//        }
//
//        dataSource.dataSource.showingData = dataSource.data
        showData()
    }
    
    func showData() {
        tableView.reloadData()
    }
    
    func search(predicates: [NSPredicate]) {
        dataSource.dataSource.showingData = []
        
        for predicate in predicates {
            dataSource.dataSource.showingData.append(contentsOf: dataSource.data.filter {
                predicate.evaluate(with: $0) && !dataSource.dataSource.showingData.contains($0)
            })
        }
    }
    
    @objc func updateData(sender: UITextField) {
        if let searchText = sender.text, searchText.count > 0 {
            search(predicates: dataSource.getPredicates(forSearchText: searchText))
        } else {
            dataSource.dataSource.showingData = dataSource.data
        }
        
        showData()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchView.searchField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.dataSource.showingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        dataSource.setCell(cell, dataSource.dataSource.showingData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { }
}
