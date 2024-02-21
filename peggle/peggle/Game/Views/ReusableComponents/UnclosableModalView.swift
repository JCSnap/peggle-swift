//
//  ModalView.swift
//  peggle
//
//  Created by Justin Cheah Yun Fei on 16/2/24.
//

import SwiftUI

// cannot be closed by tapping around the modal
// must pass in a content with a button that
struct UnclosableModalView<Content: View>: View {
    let content: Content

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            content
                .frame(width: 400, height: 500)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
        }
    }
}

#Preview {
    UnclosableModalView(content: Text("This is a test content"))
}
