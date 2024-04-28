//
//  ForgotPasswordView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 28.04.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.loginVm) private var loginVm: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        @Bindable var viewModel = loginVm
        VStack {
            Spacer()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
            }
            
            Button {
                Task { 
                    loginVm.isShowAlert = true
                    loginVm.message = "Вам отправлена ссылка для восстановления пароля"
                    try await loginVm.resetPassword()
                }
                dismiss()
            } label: {
                Text("Reset password")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(.black)
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sing In")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    ForgotPasswordView()
}
