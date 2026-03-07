import SwiftUI

struct RadarDimension: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let key: String
}

struct RadarChartView: View {
    let scoresA: [String: Int]
    let scoresB: [String: Int]?
    let colorA: Color = AppColors.accent
    let colorB: Color = .orange
    
    let dimensions = [
        RadarDimension(name: "推理能力", key: "reasoning"),
        RadarDimension(name: "多模态", key: "multimodal"),
        RadarDimension(name: "响应速度", key: "speed"),
        RadarDimension(name: "性价比", key: "cost"),
        RadarDimension(name: "易用性", key: "easeOfUse")
    ]
    
    var body: some View {
        ZStack {
            backgroundGrid
            axisLines
            labels
            dataPolygons
        }
        .frame(height: 220)
        .padding(40)
    }
    
    private var backgroundGrid: some View {
        ZStack {
            ForEach([1.0, 0.75, 0.5, 0.25], id: \.self) { scale in
                RadarBackgroundShape(sides: dimensions.count)
                    .scale(scale)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
    }
    
    private var axisLines: some View {
        RadarAxisShape(sides: dimensions.count)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    }
    
    private var labels: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2
            
            ForEach(0..<dimensions.count, id: \.self) { i in
                RadarLabel(
                    name: dimensions[i].name,
                    index: i,
                    total: dimensions.count,
                    center: center,
                    radius: radius
                )
            }
        }
    }
    
    private var dataPolygons: some View {
        ZStack {
            let keys = dimensions.map(\.key)
            polygonA(keys: keys)
            polygonB(keys: keys)
        }
    }
    
    private func polygonA(keys: [String]) -> some View {
        ZStack {
            RadarDataShape(sides: dimensions.count, scores: scoresA, keys: keys)
                .fill(colorA.opacity(0.4))
            RadarDataShape(sides: dimensions.count, scores: scoresA, keys: keys)
                .stroke(colorA, lineWidth: 2)
        }
    }
    
    private func polygonB(keys: [String]) -> some View {
        Group {
            if let scoresB = scoresB {
                RadarDataShape(sides: dimensions.count, scores: scoresB, keys: keys)
                    .fill(colorB.opacity(0.3))
                RadarDataShape(sides: dimensions.count, scores: scoresB, keys: keys)
                    .stroke(colorB, lineWidth: 2)
            }
        }
    }
}


private struct RadarLabel: View {
    let name: String
    let index: Int
    let total: Int
    let center: CGPoint
    let radius: CGFloat
    
    var body: some View {
        let angle = (CGFloat(index) * (2.0 * .pi) / CGFloat(total)) - (.pi / 2.0)
        let point = CGPoint(
            x: center.x + (radius * 1.2) * cos(angle),
            y: center.y + (radius * 1.2) * sin(angle)
        )
        
        Text(name)
            .font(.caption2)
            .foregroundColor(AppColors.textSecondary)
            .position(point)
    }
}

private struct RadarBackgroundShape: Shape {
    let sides: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<sides {
            let angle = (CGFloat(i) * (2 * .pi) / CGFloat(sides)) - (.pi / 2)
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

private struct RadarAxisShape: Shape {
    let sides: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<sides {
            let angle = (CGFloat(i) * (2 * .pi) / CGFloat(sides)) - (.pi / 2)
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            path.move(to: center)
            path.addLine(to: point)
        }
        return path
    }
}

private struct RadarDataShape: Shape {
    let sides: Int
    let scores: [String: Int]
    let keys: [String]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<sides {
            let score = CGFloat(scores[keys[i]] ?? 3) // Default to 3 if missing
            let normalizedScore = score / 5.0
            let angle = (CGFloat(i) * (2 * .pi) / CGFloat(sides)) - (.pi / 2)
            let point = CGPoint(
                x: center.x + (radius * normalizedScore) * cos(angle),
                y: center.y + (radius * normalizedScore) * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
