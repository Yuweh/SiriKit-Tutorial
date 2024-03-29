/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import ArticleKit
import Intents
import CoreSpotlight
import MobileCoreServices

class ArticleFeedViewController: UIViewController {
  let tableView = UITableView(frame: .zero, style: .plain)
  let cellReuseIdentifier = "kArticleCellReuse"
  
  var articles: [Article] = []
  
  @objc func newArticleWasTapped() {
    let vc = NewArticleViewController()
    
    // Create and donate an activity-based Shortcut
    let activity = Article.newArticleShortcut(with: UIImage(named: "notePad.jpg"))
    vc.userActivity = activity
    activity.becomeCurrent()
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Initialization
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ArticleTableViewCell.classForCoder(), forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ArticleFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = EditDraftViewController(article: articles[indexPath.row])
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func remove(article: Article, at indexPath: IndexPath) {
    ArticleManager.remove(article: article)
    articles = ArticleManager.allArticles()
    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    
    INInteraction.delete(with: article.title) { _ in
    }
  }
}
