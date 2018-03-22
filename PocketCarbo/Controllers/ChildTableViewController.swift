//
//  ChildTableViewController.swift
//  
//
//  Created by Sakura on 2018/01/27.
//

import UIKit
import XLPagerTabStrip

struct CellData {
  let label1: String!
  let label2: String!
}

class ChildTableViewController: UITableViewController, IndicatorInfoProvider {
  let cellIdentifier = "childCell"

  var itemInfo = IndicatorInfo(title: "View")
  var cellArray: [CellData] = {
    return [CellData(label1: "label1[1]", label2: "label2[1]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[2]", label2: "label2[2]"),
            CellData(label1: "label1[3]", label2: "label2[3]")]
  }()

  init(itemInfo: IndicatorInfo) {
    self.itemInfo = itemInfo
    super.init(style: .plain)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.register(UINib(nibName: "ChildTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
      tableView.estimatedRowHeight = 90.0
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      guard let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChildTableViewCell else {
        fatalError("The dequeued cell is not an instance of ChildTableViewCell.")
      }
      cell.configureWithData(cellArray[indexPath.row])

        return cell
    }

  // MARK: - IndicatorInfoProvider

  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return itemInfo
  }

}
