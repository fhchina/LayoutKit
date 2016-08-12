// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

extension CollectionType where Self.Index: RandomAccessIndexType {

    /// Returns the index N such that the predicate is false for all elements before index N
    /// and true for all other elements.
    /// It returns nil if the predicate is false for all elements in the collection.
    func binarySearch(forFirstIndexMatchingPredicate predicate: Generator.Element -> Bool) -> Self.Index? {
        var low = startIndex
        var high = endIndex
        var index: Self.Index? = nil
        while low <= high {
            let mid = low.advancedBy(low.distanceTo(high) / 2)
            if !indices.contains(mid) {
                break;
            }
            if predicate(self[mid]) {
                index = mid
                high = mid.predecessor()
            } else {
                low = mid.successor()
            }
        }
        return index
    }
}

extension CollectionType {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
