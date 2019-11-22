//
//  ViewController.swift
//  IncrementalSearch-Sampler
//
//  Created by Muramatsu Ryunosuke on 2019/11/22.
//  Copyright © 2019 Muramatsu Ryunosuke. All rights reserved.
//

import UIKit

let sampleItems = ["Albemarle", "Brandywine", "Chesapeake", "Ben", "Ivy", "Jordell", "Liam", "Maxime", "Shakia", "William", "Swift", "Java", "C#", "Go"]

final class ViewController: UIViewController {

    // MARK: IBOutlet properties
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: Properties
    // All items
    var items = [String]()
    
    // Search result items
    var resultItems = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "IncrementalSearch-Sampler"
        
        items = sampleItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 確定前の文字入力を検知
        // return trueして文字入力が確定した後にsearchBarの文字を取得する処理を遅延実行
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 検索バーから検索ワードを取り出す
            if let searchText = searchBar.text {
                // 全てのアイテムから、入力された文字列で絞り込む
                self.resultItems = self.items.filter { $0.localizedStandardContains(searchText) }
            }
        }
        return true
    }
    
    // 検索テキストが変更された時に実行されるDelegateメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // クリアボタンが押された時に結果を空にする
        if searchText.isEmpty {
            resultItems.removeAll()
        }
    }
    
    // キーボードのSearchボタンが押された時に実行されるDelegateメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    // 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultItems.count
    }
    
    // 行ごとのセル内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 検索結果の製品
        let item = resultItems[indexPath.row]
        // Ptorotype Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = item
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    // 行が選択されたとき
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 詳細画面のインスタンスに選択したアイテムの文字列を渡して遷移する
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detail")
            as! DetailViewController
        
        detailVC.item = resultItems[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
