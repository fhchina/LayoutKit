// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

class CollectionViewLoggingFlowLayout: UICollectionViewFlowLayout {

    override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext) {
        print("invalidateLayoutWithContext \(context)")
        super.invalidateLayoutWithContext(context)
    }

    override func prepareLayout() {
        print("prepareLayout \(collectionView?.bounds) \(collectionView?.contentOffset)")
        super.prepareLayout()
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let la = super.layoutAttributesForElementsInRect(rect)
        print("layoutAttributesForElementesInRect(\(rect) \(la?.first?.frame)")
        return la
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        print("layoutAttributesForItemAtIndexPath(\(indexPath))")
        return super.layoutAttributesForItemAtIndexPath(indexPath)
    }

    override func collectionViewContentSize() -> CGSize {
        print("collectionViewContentSize")
        return super.collectionViewContentSize()
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
