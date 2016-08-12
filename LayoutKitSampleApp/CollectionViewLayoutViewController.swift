// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

class CollectionViewLayoutViewController: UICollectionViewController {

    let cellSizes: [CGSize] = {
        let heights = (1...1000)

        var sizes = [CGSize]()
        for height in heights {
            sizes.append(CGSize(width: 24, height: 50))
        }

        return sizes
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(LabelCell.self, forCellWithReuseIdentifier: LabelCell.reuseIdentifier)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LabelCell.reuseIdentifier, forIndexPath: indexPath) as! LabelCell
        cell.set(text: "\(indexPath.item)", size: cellSizes[indexPath.row])
        return cell
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
}
