//
//  LegalPage.swift
//  ATV-AiYiFan
//
//  Created by Tong Miao on 5/29/25.
//
import SwiftUI

struct LegalPage: View {
    // Dictionary mapping section titles to their content
    private let legalSections: [String: String] = [
        "1. 服务条款": """
        欢迎使用我们的服务。在您使用本服务前，请仔细阅读以下条款和条件。

        1.1 服务说明
        我们提供的服务包括但不限于视频内容的浏览、搜索和播放功能。我们保留随时修改或中断服务的权利。

        1.2 用户责任
        您同意在使用本服务时遵守所有适用的法律法规。您应对通过您的账户进行的所有活动负责。

        1.3 知识产权
        本服务提供的所有内容，包括但不限于文本、图形、标识、图标、图像、音频和视频，均受版权和其他知识产权法保护。
        """,

        "2. 版权声明": """

        2.1 懒人影视” 是一个视频内容聚合与播放平台。本应用本身不存储、不生产任何影视、综艺内容。 所有呈现的视频内容均来源于互联网公开的第三方资源。

        2.2 懒人影视不拥有所播放的任何电影、电视剧、综艺节目的版权。 所有版权均归原著作权人（制片方、发行方、播出平台等）所有。

        2.3 本应用提供的链接播放服务，旨在为用户提供信息索引和便利。我们尊重版权，并致力于遵守适用的版权法律和法规。

        2.4 如果您是版权所有者，认为懒人影视上展示或链接的内容侵犯了您的权利，请通过[clarktong8@gmail.com]与我们联系。 我们将在收到符合法律要求的有效通知后，尽快移除或屏蔽相关链接。请提供充分的权属证明和侵权材料具体信息。
        """,

        "3. 内容免责": """
        3.1 懒人影视对通过本应用访问的任何第三方内容的合法性、准确性、完整性、时效性、可用性或质量不作任何明示或暗示的保证或陈述。

        3.2 用户理解并同意，其观看、使用或依赖任何通过本应用获得的内容风险完全自负。懒人影视对因使用或无法使用这些内容而导致的任何直接、间接、附带、特殊、惩罚性或后果性损害不承担任何责任。

        3.3 应用内呈现的内容可能包含用户认为不当或冒犯性的材料（如暴力、成人主题、强烈语言等）。用户应自行判断并承担观看此类内容的风险。懒人影视对内容的适宜性不承担责任。
        """,

        "4. 服务与技术支持免责": """
        4.1 懒人影视尽力提供稳定可靠的服务，但不保证应用或服务不会中断、无错误、无病毒或有害组件。

        4.2 对因技术问题、网络连接问题、设备兼容性问题、维护或其他不可抗力因素导致的任何播放故障、数据丢失、服务中断等，懒人影视不承担责任。
        """,
        "5. 用户责任": """
        5.1 用户应遵守其所在地的所有适用法律和法规使用本应用及其提供的内容。

        5.2 用户对其使用本应用的行为及其后果承担全部责任。
        """,
        "6. 服务变更与终止": """
        6.1 懒人影视保留随时修改、暂停或终止本应用或其任何功能、内容（包括免费内容的范围）的权利，无需事先通知。对于未来可能引入的订阅模式，具体条款将在实施时公布。
        """,
        "7. AirPlay 免责": """
        7.1 AirPlay 功能依赖于 Apple 的技术和用户设备的兼容性。懒人影视对 AirPlay 投屏过程中的任何功能限制、延迟或失败不承担责任。
        """,
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Iterate through the dictionary in a specific order
                ForEach(Array(legalSections.keys.sorted()), id: \.self) { key in
                    if let content = legalSections[key] {
                        LegalSection(title: key) {
                            Text(content)
                                .legalTextStyle()
                        }
                        .buttonStyle(PlainButtonStyle())  // Makes section focusable
                        .focusable()  // Explicitly make it focusable
                    }
                }

                Text("最后更新日期: 2025年5月30日")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
            }
            .padding()
            .frame(maxWidth: 800)
            .focusSection()
        }
        .navigationTitle("法律声明")
        #if os(tvOS)
            .padding(.top, 30)
            .onMoveCommand { direction in
                // Handle remote swipes for scrolling
                NotificationCenter.default.post(
                    name: NSNotification.Name("ScrollViewMove"),
                    object: nil,
                    userInfo: ["direction": direction]
                )
            }
        #endif
    }
}

struct LegalSection<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            content()
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(6)
        }
        .padding(.vertical, 8)
    }
}

extension View {
    func legalTextStyle() -> some View {
        self
            .font(.body)
            .foregroundColor(.secondary)
            .lineSpacing(6)
            .padding(.vertical, 4)
    }
}
