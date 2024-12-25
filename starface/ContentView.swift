import SwiftUI

struct ContentView: View {
    
    
    // https://stackoverflow.com/questions/26971240/how-do-i-run-a-terminal-command-in-a-swift-script-e-g-xcodebuild#50035059
    @discardableResult // Add to suppress warnings when you don't want/need a result
    func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    @State var textInput = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        VStack {
            TextField("", text: $textInput)
                .textFieldStyle(
                    .roundedBorder
                    )

                .font(.system(size: 18))
                .onSubmit {
                    do {
                        try textInput = safeShell("open \"https://www.google.com/search?q=\(textInput)\"")
                        exit(0)
                    }
                    catch {
                        print("\(error)") //handle or silence the error here
                    }
                }
                .focused($focus)
        }
        .onAppear{
            focus = true
        }
        .onExitCommand {
            exit(0)
        }
        .onDisappear {
            exit(0)
        }
    }
}

#Preview {
    ContentView()
}
