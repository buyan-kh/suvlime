import Foundation
import Observation

@Observable
final class CoachViewModel {
    private var appModel: AppViewModel
    var draft = ""

    init(appModel: AppViewModel) {
        self.appModel = appModel
    }

    var messages: [ChatMessage] { appModel.messages }

    func sendQuickQuestion(_ text: String) {
        appModel.messages.append(ChatMessage(text: text, isUser: true))
        appModel.messages.append(ChatMessage(
            text: "Good question. I checked your stack. Keep it simple and change one thing at a time.",
            isUser: false,
            quickActions: ["Add reminder", "Show studies"]
        ))
    }
}

