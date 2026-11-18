import MapLibre
import XCTest
@testable import MapLibreSwiftUI

final class MapViewCoordinatorRenderingFrameTests: XCTestCase {
    @MainActor func testEveryRenderedFrameReachesTheHandlerWithItsFlag() {
        let coordinator = MapView<MLNMapViewController>.Coordinator(
            parent: MapView(styleURL: URL(string: "https://maplibre.org")!),
            onGesture: { _, _ in
                // No action
            },
            onViewProxyChanged: { _ in
                // No action
            }, proxyUpdateMode: .onFinish
        )
        var received: [Bool] = []
        coordinator.onMapDidFinishRenderingFrame = { received.append($0) }
        let mapView = MLNMapView(frame: .zero)

        coordinator.mapViewDidFinishRenderingFrame(mapView, fullyRendered: false)
        coordinator.mapViewDidFinishRenderingFrame(mapView, fullyRendered: true)
        let drained = expectation(description: "the main queue ran what was queued before it")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 2)

        XCTAssertEqual(received, [false, true])
    }
}
