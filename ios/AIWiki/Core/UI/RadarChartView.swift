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
            // Background Grid
            RadarBackgroundShape(sides: dimensions.count)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
            RadarBackgroundShape(sides: dimensions.count)
                .scale(0.75)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
            RadarBackgroundShape(sides: dimensions.count)
                .scale(0.5)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
            RadarBackgroundShape(sides: dimensions.count)
                .scale(0.25)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
            // Axis Lines
            RadarAxisShape(sides: dimensions.count)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            
            // Labels
            GeometryReader { geo in
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                let radius = min(geo.size.width, geo.size.height) / 2
                
                ForEach(0..<dimensions.count, id: \.self) { i in
                    let angle = (CGFloat(i) * (2 * .pi) / CGFloat(dimensions.count)) - (.pi / 2)
                    let point = CGPoint(
                        x: center.x + (radius * 1.2) * cos(angle),
                        y: center.y + (radius * 1.2) * sin(angle)
                    )
                    
                    Text(dimensions[i].name)
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                        .position(point)
                }
            }
            
            // Data Polygon A
            RadarDataShape(sides: dimensions.count, scores: scoresA, keys: dimensions.map(\.key))
                .fill(colorA.opacity(0.4))
            RadarDataShape(sides: dimensions.count, scores: scoresA, keys: dimensions.map(\.key))
                .stroke(colorA, lineWidth: 2)
            
            // Data Polygon B (Optional)
            if let scoresB = scoresB {
                RadarDataShape(sides: dimensions.count, scores: scoresB, keys: dimensions.map(\.key))
                    .fill(colorB.opacity(0.3))
                RadarDataShape(sides: dimensions.count, scores: scoresB, keys: dimensions.map(\.key))
                    .stroke(colorB, lineWidth: 2)
            }
        }
        .frame(height: 220)
        .padding(40)
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
