//
//  ViewController.swift
//  NonStoryboard-TableView
//
//  Created by 渡邊魁優 on 2023/04/11.
//

import UIKit

class ViewController: UIViewController {
    
    private var articlesList: [Article] = []
    
    //CellのId作成
    private let cellId = "Cell"
    
    //TableView作成
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ViewをTableViewにする
        view.addSubview(tableView)
        //サイズを全画面
        tableView.frame.size = view.frame.size
        
        //データソースの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        Task {
            await loadArticles()
        }
    }
    
    private func loadArticles() async {
        do {
            let articles = try await APIClient().fetch()
            DispatchQueue.main.async {
                self.articlesList = articles
                self.tableView.reloadData()
            }
        } catch {
            let error = error as? APIError ?? APIError.unknown
            print(error.title)
        }
    }
}

//ectensionはプロトコル適応させる時によく使う
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = articlesList[indexPath.row].title
        cell.contentConfiguration = content

        return cell
    }
}

