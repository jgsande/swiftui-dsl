import Foundation
import InternalUtils
import MapLibre

// TODO: Other properties and their modifiers
public struct LineStyleLayer: SourceBoundVectorStyleLayerDefinition {
    public let identifier: String
    public let sourceLayerIdentifier: String?
    public var insertionPosition: LayerInsertionPosition = .above(.all)
    public var isVisible: Bool = true
    public var maximumZoomLevel: Float?
    public var minimumZoomLevel: Float?

    public var source: StyleLayerSource
    public var predicate: NSPredicate?

    public init(identifier: String, source: Source) {
        self.identifier = identifier
        self.source = .source(source)
        sourceLayerIdentifier = nil
    }

    public init(identifier: String, source: MLNSource, sourceLayerIdentifier: String? = nil) {
        self.identifier = identifier
        self.source = .mglSource(source)
        self.sourceLayerIdentifier = sourceLayerIdentifier
    }

    public func makeStyleLayer(style: MLNStyle) -> StyleLayer {
        let styleSource = addSource(to: style)

        return LineStyleLayerInternal(definition: self, mglSource: styleSource)
    }

    fileprivate var lineColor: NSExpression? = nil

    public func lineColor(_ value: UIColor) -> Self {
        var copy = self
        copy.lineColor = NSExpression(forConstantValue: value)
        return copy
    }

    public func lineColor(expression: NSExpression) -> Self {
        var copy = self
        copy.lineColor = expression
        return copy
    }

    public func lineColor(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineColor = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func lineColor(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.lineColor = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var lineOpacity: NSExpression? = nil

    public func lineOpacity(_ value: Float) -> Self {
        var copy = self
        copy.lineOpacity = NSExpression(forConstantValue: value)
        return copy
    }

    public func lineOpacity(expression: NSExpression) -> Self {
        var copy = self
        copy.lineOpacity = expression
        return copy
    }

    public func lineOpacity(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineOpacity = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func lineOpacity(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.lineOpacity = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var lineCap: NSExpression? = nil

    public func lineCap(_ value: LineCap) -> Self {
        var copy = self
        copy.lineCap = NSExpression(forConstantValue: value.mlnRawValue.rawValue)
        return copy
    }

    public func lineCap(expression: NSExpression) -> Self {
        var copy = self
        copy.lineCap = expression
        return copy
    }

    public func lineCap(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineCap = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var lineJoin: NSExpression? = nil

    public func lineJoin(_ value: LineJoin) -> Self {
        var copy = self
        copy.lineJoin = NSExpression(forConstantValue: value.mlnRawValue.rawValue)
        return copy
    }

    public func lineJoin(expression: NSExpression) -> Self {
        var copy = self
        copy.lineJoin = expression
        return copy
    }

    public func lineJoin(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineJoin = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var lineDashPattern: NSExpression? = nil

    public func lineDashPattern(_ value: [Float]) -> Self {
        var copy = self
        copy.lineDashPattern = NSExpression(forConstantValue: value)
        return copy
    }

    public func lineDashPattern(expression: NSExpression) -> Self {
        var copy = self
        copy.lineDashPattern = expression
        return copy
    }

    public func lineDashPattern(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineDashPattern = NSExpression(forKeyPath: keyPath)
        return copy
    }

    fileprivate var lineWidth: NSExpression? = nil

    public func lineWidth(_ value: Float) -> Self {
        var copy = self
        copy.lineWidth = NSExpression(forConstantValue: value)
        return copy
    }

    public func lineWidth(expression: NSExpression) -> Self {
        var copy = self
        copy.lineWidth = expression
        return copy
    }

    public func lineWidth(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineWidth = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func lineWidth(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.lineWidth = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }

    fileprivate var lineBlur: NSExpression? = nil

    public func lineBlur(_ value: Float) -> Self {
        var copy = self
        copy.lineBlur = NSExpression(forConstantValue: value)
        return copy
    }

    public func lineBlur(expression: NSExpression) -> Self {
        var copy = self
        copy.lineBlur = expression
        return copy
    }

    public func lineBlur(featurePropertyNamed keyPath: String) -> Self {
        var copy = self
        copy.lineBlur = NSExpression(forKeyPath: keyPath)
        return copy
    }

    public func lineBlur(
        interpolatedBy expression: MLNVariableExpression,
        curveType: MLNExpressionInterpolationMode,
        parameters: NSExpression?,
        stops: NSExpression
    ) -> Self {
        var copy = self
        copy.lineBlur = interpolatingExpression(
            expression: expression,
            curveType: curveType,
            parameters: parameters,
            stops: stops
        )
        return copy
    }
}

private struct LineStyleLayerInternal: StyleLayer {
    private var definition: LineStyleLayer
    private let mglSource: MLNSource

    var identifier: String {
        definition.identifier
    }

    var insertionPosition: LayerInsertionPosition {
        get { definition.insertionPosition }
        set { definition.insertionPosition = newValue }
    }

    var isVisible: Bool {
        get { definition.isVisible }
        set { definition.isVisible = newValue }
    }

    var maximumZoomLevel: Float? {
        get { definition.maximumZoomLevel }
        set { definition.maximumZoomLevel = newValue }
    }

    var minimumZoomLevel: Float? {
        get { definition.minimumZoomLevel }
        set { definition.minimumZoomLevel = newValue }
    }

    init(definition: LineStyleLayer, mglSource: MLNSource) {
        self.definition = definition
        self.mglSource = mglSource
    }

    func makeMLNStyleLayer() -> MLNStyleLayer {
        let result = MLNLineStyleLayer(identifier: identifier, source: mglSource)

        result.lineColor = definition.lineColor
        result.lineOpacity = definition.lineOpacity
        result.lineCap = definition.lineCap
        result.lineWidth = definition.lineWidth
        result.lineJoin = definition.lineJoin
        result.lineDashPattern = definition.lineDashPattern
        result.lineBlur = definition.lineBlur
        result.predicate = definition.predicate
        result.sourceLayerIdentifier = definition.sourceLayerIdentifier

        return result
    }
}
