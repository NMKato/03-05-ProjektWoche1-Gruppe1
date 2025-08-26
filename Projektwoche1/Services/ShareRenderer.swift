//
//  ShareRenderer.swift
//  Projektwoche1
//
//  Created by 4Gi .tv on 24.08.25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum ShareRenderer {
    /// Rendert eine SwiftUI-View als UIImage (iOS 16+).
    @MainActor
    static func render<V: View>(
        view: V,
        size: CGSize = CGSize(width: 1024, height: 1024),
        scale: CGFloat = 2.0
    ) -> UIImage? {
        #if canImport(UIKit)
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = scale
        return renderer.uiImage
        #else
        return nil
        #endif
    }
}
