import XCTest
@testable import CoolOpenAIKit

final class CoolOpenAIKitTests: XCTestCase {
    
    private var client: OpenAI.Client!
    
    override func setUp() {
        client = OpenAI.Client()
    }
    
    // MARK: List Models
    
    func testModelsListAsync() async throws {
        let models: [Model]? = try await client.models.list()
        print("Models.List (async): ", models)
        XCTAssertNotNil(models)
    }
    
    func testModelsListCompletion() {
        client.models.list { models in
            print("Models.List (completion handler): ", models)
            XCTAssertNotNil(models)
        }
    }
    
    // MARK: Retrieve Model
    
    func testModelsRetrieveAsync() async throws {
        let model = try await client.models.retrieve(model: "text-davinci-003")
        print("Models.Retrieve (async): ", model)
        XCTAssertNotNil(model)
    }
    
    func testModelsRetrieveCompletion() {
        client.models.retrieve(model: "text-davinci-003") { model in
            print("Models.Retrieve (completion handler): ", model)
            XCTAssertNotNil(model)
        }
    }
    
    // MARK: Create Completion
    
    func testCompletionsCreateAsync() async throws {
        let choices = try await client.completions.create(.davinci, prompt: .basic(prompt: "What color are your eyes?"), maxTokens: 100, temperature: 0.5, topP: 1, n: 1, presencePenalty: 0, frequencyPenalty: 0)
        print("Completions.Create (async): ", choices)
        XCTAssertNotNil(choices)
    }
    
    func testCompletionsCreateCompletion() {
        let prompt: Completions.Prompt = .basic(prompt: "What color are your eyes?")
        let request = Completions.Request(
            model: .davinci,
            prompt: prompt,
            maxTokens: 100,
            temperature: 0.5,
            topP: 1,
            n: 1,
            presencePenalty: 0,
            frequencyPenalty: 0
        )
        client.completions.create(request) { choices in
            print("Completions.Create (completion handler): ", choices)
            XCTAssertNotNil(choices)
        }
    }
}
