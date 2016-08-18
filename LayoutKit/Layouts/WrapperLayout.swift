// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that wraps another layout.
 */
public class WrapperLayout<V: View>: ConfigurableLayout {
    
    public let layout: Layout
    public let needsView: Bool
    public let viewReuseId: String? = nil
    public let config: ((V) -> Void)?

    public var flexibility: Flexibility {
        return layout.flexibility
    }

    public init(layout: Layout, config: ((V) -> Void)? = nil) {
        self.layout = layout
        self.config = config
        needsView = config != nil
    }

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let sublayout = layout.measurement(within: maxSize)
        return LayoutMeasurement(layout: self, size: sublayout.size, maxSize: maxSize, sublayouts: [sublayout])
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = Alignment.fill.position(size: measurement.size, in: rect)
        let sublayoutRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let sublayouts = measurement.sublayouts.map { (measurement) in
            return measurement.arrangement(within: sublayoutRect)
        }
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayouts ?? [])
    }

    public func configure(view view: V) {
        config?(view)
    }
}
