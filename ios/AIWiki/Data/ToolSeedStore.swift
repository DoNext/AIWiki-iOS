import Foundation

protocol ToolRepository {
    func fetchAll() throws -> [AITool]
}

protocol LearningMaterialRepository {
    func fetchAllLearningMaterials() throws -> [LearningMaterial]
}

enum ToolSeedStoreError: Error, LocalizedError {
    case fileNotFound(String)
    case decodeFailed(Error)

    var errorDescription: String? {
        switch self {
        case let .fileNotFound(fileName):
            return "Seed file not found: \(fileName)"
        case let .decodeFailed(error):
            return "Failed to decode seed file: \(error.localizedDescription)"
        }
    }
}

struct ToolSeedStore: ToolRepository {
    private let bundle: Bundle
    private let fileName: String
    private let fileExtension: String

    init(
        bundle: Bundle = .main,
        fileName: String = "tools.seed",
        fileExtension: String = "json"
    ) {
        self.bundle = bundle
        self.fileName = fileName
        self.fileExtension = fileExtension
    }

    func fetchAll() throws -> [AITool] {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw ToolSeedStoreError.fileNotFound("\(fileName).\(fileExtension)")
        }

        let data = try Data(contentsOf: fileURL)
        do {
            return try JSONDecoder().decode([AITool].self, from: data)
        } catch {
            throw ToolSeedStoreError.decodeFailed(error)
        }
    }
}

struct LearningMaterialSeedStore: LearningMaterialRepository {
    private let bundle: Bundle
    private let fileName: String
    private let fileExtension: String

    init(
        bundle: Bundle = .main,
        fileName: String = "learning_materials",
        fileExtension: String = "json"
    ) {
        self.bundle = bundle
        self.fileName = fileName
        self.fileExtension = fileExtension
    }

    func fetchAllLearningMaterials() throws -> [LearningMaterial] {
        guard let fileURL = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw ToolSeedStoreError.fileNotFound("\(fileName).\(fileExtension)")
        }

        let data = try Data(contentsOf: fileURL)
        do {
            return try JSONDecoder().decode([LearningMaterial].self, from: data)
        } catch {
            throw ToolSeedStoreError.decodeFailed(error)
        }
    }
}
