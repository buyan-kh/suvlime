import SwiftUI

struct CoachView: View {
    @Bindable var viewModel: CoachViewModel

    var body: some View {
        BoldScreen {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    PillMascot(size: 56)
                    VStack(alignment: .leading, spacing: 4) {
                        Sticker(text: "Coach", color: BoldPalette.lime, size: .small)
                        Text("Ask anything.")
                            .font(.boldDisplay(24))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message) { action in
                                viewModel.sendQuickQuestion(action)
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TRY ASKING")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .foregroundStyle(BoldPalette.ink.opacity(0.5))
                            ForEach(["Is my dose right?", "Best peptides for fat loss?", "Read my bloodwork"], id: \.self) { prompt in
                                Button {
                                    viewModel.sendQuickQuestion(prompt)
                                } label: {
                                    HStack {
                                        Text(prompt).font(.system(size: 14, weight: .bold, design: .rounded))
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundStyle(BoldPalette.ink)
                                    .padding(12)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(BoldPalette.ink, lineWidth: 2.5))
                                    .shadow(color: BoldPalette.ink, radius: 0, x: 2, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                }

                HStack(spacing: 8) {
                    TextField("Type a question...", text: $viewModel.draft)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    Button {
                        let question = viewModel.draft
                        viewModel.sendQuickQuestion(question)
                        viewModel.draft = ""
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(BoldPalette.ink)
                            .frame(width: 38, height: 38)
                            .background(BoldPalette.lime)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(BoldPalette.ink, lineWidth: 2.5))
                    }
                    .accessibilityLabel("Send question")
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(BoldPalette.ink, lineWidth: 3))
                .shadow(color: BoldPalette.ink, radius: 0, x: 3, y: 3)
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
    }
}

private struct MessageBubble: View {
    var message: ChatMessage
    var onAction: (String) -> Void

    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
            Text(message.text)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .lineSpacing(3)
                .foregroundStyle(message.isUser ? .white : BoldPalette.ink)
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(message.isUser ? BoldPalette.ink : .white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(BoldPalette.ink, lineWidth: message.isUser ? 0 : 2.5))
                .shadow(color: message.isUser ? .clear : BoldPalette.ink, radius: 0, x: 2, y: 2)
                .frame(maxWidth: 292, alignment: message.isUser ? .trailing : .leading)
            if !message.quickActions.isEmpty {
                HStack(spacing: 6) {
                    ForEach(message.quickActions, id: \.self) { action in
                        Button(action) { onAction(action) }
                            .font(.boldBody(13))
                            .foregroundStyle(BoldPalette.ink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(action == message.quickActions.first ? BoldPalette.lime : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(BoldPalette.ink, lineWidth: 2.5))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}

struct CoachView_Previews: PreviewProvider {
    static var previews: some View {
        CoachView(viewModel: CoachViewModel(appModel: AppViewModel(seed: MockSuppsData.seed, hasCompletedOnboarding: true)))
    }
}
