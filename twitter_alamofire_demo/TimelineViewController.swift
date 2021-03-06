/// Copyright (c) 2018 Somi Singh
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

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  

  
  var tweets: [Tweet] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
    // add refresh control to table view
    tableView.insertSubview(refreshControl, at: 0)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.estimatedRowHeight = 80
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    APIManager.shared.getHomeTimeLine { (tweets, error) in
      if let tweets = tweets {
        self.tweets = tweets
        self.tableView.reloadData()
      } else if let error = error {
        print("Error getting home timeline: " + error.localizedDescription)
      }
    }
  }
  
  @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
    
    APIManager.shared.getHomeTimeLine { (tweets, error) in
      if let tweets = tweets {
        self.tweets = tweets
        self.tableView.reloadData()
      } else if let error = error {
        print("Error getting home timeline: " + error.localizedDescription)
      }
    }
    refreshControl.endRefreshing()
  }
  
  
  @IBAction func composeTweet(_ sender: Any) {
    self.performSegue(withIdentifier: "composeSegue", sender: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    cell.selectionStyle = .none
    cell.tweet = tweets[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func didTapLogout(_ sender: Any) {
    APIManager.shared.logout()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "detailSegue" {
      let detailViewController = segue.destination as! DetailViewController
      let cell = sender as! TweetCell
      if let indexPath = tableView.indexPath(for: cell) {
        let tweet = tweets[indexPath.row]
        detailViewController.tweet = tweet
      }
    }
  }
  
}
