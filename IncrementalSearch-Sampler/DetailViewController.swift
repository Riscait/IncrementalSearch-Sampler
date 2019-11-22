//
//  DetailViewController.swift
//  IncrementalSearch-Sampler
//
//  Created by Muramatsu Ryunosuke on 2019/11/22.
//  Copyright © 2019 Muramatsu Ryunosuke. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: IBOutlet properties
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties
    var item: String?
    
    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail View"
        
        titleLabel.text = item
    }
}
