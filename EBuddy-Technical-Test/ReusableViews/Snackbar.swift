//
//  Snackbar.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

public struct SnackbarView: View {

    public init(show: Binding<Bool>, bgColor: Color, txtColor: Color, icon: String?, iconColor: Color, message: String) {
        self._show = show
        self.bgColor = bgColor
        self.txtColor = txtColor
        self.icon = icon
        self.iconColor = iconColor
        self.message = message
    }

    @Binding public var show: Bool
    public var bgColor: Color
    public var txtColor: Color
    public var icon: String?
    public var iconColor: Color
    public var message: String
    let paddingBottom = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 54

    public var body: some View {
        if self.show {
            VStack {
                Spacer()
                HStack(alignment: .center, spacing: 12) {
                    if let name = icon {
                        Image(systemName: name)
                            .resizable()
                            .foregroundColor(self.iconColor)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                    }

                    Text(message)
                        .foregroundColor(txtColor)
                        .font(.system(size: 14))
                        .frame(alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 35)
                .padding(.vertical, 8)
                .background(bgColor)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, show ? self.paddingBottom : 0)
                .animation(.easeInOut)
            }
            .transition(.move(edge: .bottom))
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.show = false
                }
            }
        }
    }
}

extension View {
    func snackbar(show: Binding<Bool>, bgColor: Color, txtColor: Color, icon: String?, iconColor: Color, message: String) -> some View {
        self.modifier(SnackbarModifier(show: show, bgColor: bgColor, txtColor: txtColor, icon: icon, iconColor: iconColor, message: message))
    }
}

struct SnackbarModifier: ViewModifier {
    @Binding var show: Bool
    var bgColor: Color
    var txtColor: Color
    var icon: String?
    var iconColor: Color
    var message: String

    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView(show: $show, bgColor: bgColor, txtColor: txtColor, icon: icon, iconColor: iconColor, message: message)
        }
    }
}
