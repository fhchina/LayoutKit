// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

class LabelCell: UICollectionViewCell {

    static let reuseIdentifier = "LabelCell"

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var size: CGSize = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        let views = ["label": label]
        var constraints = [NSLayoutConstraint]()
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-|", options: [], metrics: nil, views: views))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[label]-0-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(constraints)
        contentView.backgroundColor = UIColor.redColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(text text: String, size: CGSize) {
        self.label.text = "\(text) \(size.width)x\(size.height)"
        self.size = size
    }
}
