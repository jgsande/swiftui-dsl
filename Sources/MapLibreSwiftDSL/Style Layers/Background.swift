import Foundation
import InternalUtils
import MapLibre

public struct BackgroundLayer: StyleLayer {
    public let identifier: String
    public var insertionPosition: LayerInsertionPosition = .below(.all)
    public var isVisible: Bool = true
    public var maximumZoomLevel: Float?
    public var minimumZoomLevel: Float?

    public init(identifier: String) {
        self.identifier = identifier
    }

    public func makeMLNStyleLayer() -> MLNStyleLayer {
        let result = MLNBackgroundStyleLayer(identifier: identifier)

        result.backgroundColor = backgroundColor
        result.backgroundOpacity = backgroundOpacity

        return result
    }

    fileprivate var backgroundColor: NSExpression? = nil

    public func backgroundColor(_ value: UIColor) -> Self {
        var copy = self
        copy.backgroundColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func backgroundColor(expression: NSExpression) -> Self {
        var copy = self
        copy.backgroundColor = expression
        return copy
    }

    public func backgroundColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.backgroundColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func backgroundColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.backgroundColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var backgroundOpacity: NSExpression? = nil

    public func backgroundOpacity(_ value: Float) -> Self {
        var copy = self
        copy.backgroundOpacity = NSExpression(forConstantValue: value)
        return copy
    }

    public func backgroundOpacity(expression: NSExpression) -> Self {
        var copy = self
        copy.backgroundOpacity = expression
        return copy
    }

    public func backgroundOpacity(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.backgroundOpacity = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func backgroundOpacity(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.backgroundOpacity = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }
}
