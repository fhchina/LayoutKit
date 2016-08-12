// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

public protocol CollectionViewTableLayoutDelegate: class {

    func axisLength(forItemAtIndexPath indexPath: NSIndexPath, crossLength: CGFloat, layout: CollectionViewTableLayout) -> CGFloat
}

public class CollectionViewTableLayout: UICollectionViewLayout {

    public var axis: Axis = .vertical {
        didSet {
            if axis != oldValue {
                invalidateLayout()
            }
        }
    }

    public var itemSpacing: CGFloat = 5 {
        didSet {
            if itemSpacing != oldValue {
                invalidateLayout()
            }
        }
    }

    public weak var delegate: CollectionViewTableLayoutDelegate? = nil

    private var contentSize = CGSize.zero

    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var layoutAttributesByIndexPath = [NSIndexPath: UICollectionViewLayoutAttributes]()
    private var layoutAttributesIndexPaths = [NSIndexPath]()

    public override func collectionViewContentSize() -> CGSize {
        return contentSize
    }

    public override func prepareLayout() {
        super.prepareLayout()

        let width = collectionView?.bounds.width ?? 0
        let height = collectionView?.bounds.height ?? 0

        if width != contentSize.width {
            resetLayoutAttributes()
            contentSize.width = width
        }

        if width > 0 {
            // There are two reasons to precompute layout here:
            //     1. We need the size of a non-zero number of cells to be able to estimate content height.
            //     2. We want to compute cell layouts incrementally as scrolling happens, instead of
            //        in large batches as a result of `layoutAttributesForElementsInRect`.
            //
            // prepareAxisOffset is computed such that we prepare the minimum number of cells necessary
            // to avoid preparing cells in `layoutAttributesForElementsInRect`.
            let axisOffset = Swift.max(AxisPoint(axis: axis, point: collectionView?.contentOffset ?? .zero).axisOffset, 0)
            let (min, max) = width < height ? (width, height) : (height, width)
            let prepareAxisOffset = axisOffset + Swift.max(2 * max, 3 * min)
            prepareLayout(forAxisOffset: prepareAxisOffset, noop: false)
            contentSize.height = contentAxisLength()
        } else {
            contentSize.height = 0
        }
    }

    private func contentAxisLength() -> CGFloat {
        let preparedLength = preparedAxisLength()
        let estimatedAxisLengthPerItem = preparedLength / CGFloat(layoutAttributes.count)
        let unknownCount = layoutAttributesIndexPaths.count - layoutAttributes.count
        return preparedLength + ceil(CGFloat(unknownCount) * estimatedAxisLengthPerItem)
    }

    private func preparedAxisLength() -> CGFloat {
        return AxisRect(axis: axis, rect: layoutAttributes.last?.frame ?? .zero).axisMax
    }

    private func prepareLayout(forAxisOffset axisOffset: CGFloat, noop: Bool) {
        while true {
            let preparedAxisLength = self.preparedAxisLength()
            if preparedAxisLength >= axisOffset {
                return
            }
            guard let indexPath = layoutAttributesIndexPaths[safe: layoutAttributes.endIndex] else {
                return
            }

            let crossLength = AxisSize(axis: axis, size: contentSize).crossLength
            let axisLength = delegate?.axisLength(forItemAtIndexPath: indexPath, crossLength: crossLength, layout: self) ?? 0
            let size = AxisSize(axis: axis, axisLength: axisLength, crossLength: crossLength).size
            let axisOffset = preparedAxisLength + itemSpacing

            let origin = AxisPoint(axis: axis, axisOffset: axisOffset, crossOffset: 0).point

            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = CGRect(origin: origin, size: size)

            NSLog("prepare item \(indexPath.item) frame \(attributes.frame)")
            layoutAttributes.append(attributes)
            layoutAttributesByIndexPath[indexPath] = attributes

            if noop {
                assertionFailure("should have been noop")
            }
        }
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let axisOffset = AxisPoint(axis: axis, point: rect.origin).axisOffset
        let axisLength = AxisSize(axis: axis, size: rect.size).axisLength
        prepareLayout(forAxisOffset: axisOffset + axisLength, noop: true)

        guard let firstIndex = layoutAttributes.binarySearch(forFirstIndexMatchingPredicate: { (attributes: UICollectionViewLayoutAttributes) -> Bool in
            return attributes.frame.maxY >= rect.minY
        }) else {
            return nil
        }

        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for attributes in layoutAttributes.suffixFrom(firstIndex) {
            if !attributes.frame.intersects(rect) {
                break
            }
            attributesInRect.append(attributes)
        }
        return attributesInRect
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesByIndexPath[indexPath]
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayoutWithContext(context)
        if context.invalidateDataSourceCounts || context.invalidateEverything {
            resetLayoutAttributes()

            layoutAttributesIndexPaths.removeAll()
            for section in 0..<(collectionView?.numberOfSections() ?? 0) {
                for item in 0..<(collectionView?.numberOfItemsInSection(section) ?? 0) {
                    let indexPath = NSIndexPath(forItem: item, inSection: section)
                    layoutAttributesIndexPaths.append(indexPath)
                }
            }
        }
    }

    private func resetLayoutAttributes() {
        layoutAttributes.removeAll()
        layoutAttributesByIndexPath.removeAll()
    }
}

