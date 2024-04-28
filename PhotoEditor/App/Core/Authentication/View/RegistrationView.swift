//
//  RegistrationView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State var viewModel = RegistrationViewModel()
    @Environment(\.loginVm) private var loginVm: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                
                VStack() {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    if !viewModel.isValidEmail() && !viewModel.email.isEmpty {
                        Text("Некоретный ввод почты")
                            .font(.caption)
                    }
                }
                
                
                VStack() {
                    SecureField("Enter your password", text: $viewModel.password)                      .modifier(TextFieldModifier())
                    
                    if !viewModel.isValidPassword() && !viewModel.password.isEmpty {
                        Text("Некоретный ввод пароля")
                            .font(.caption)
                    }
                }
                
            }
            
            Button {
                Task {
                    let uniq = try await viewModel.checkUniqueEmail()
                    if uniq {
                        loginVm.isShowAlert = true
                        loginVm.message = "Пользователь с такой почтой уже существует"
                        return
                    } else {
                        try await viewModel.createUser()
                        loginVm.isShowAlert = true
                        loginVm.message = "Вам отправленна ссылка для подтверждения почты"
                        dismiss()
                    }
                }
                
            } label: {
                Text("Sing Up")
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
    RegistrationView()
}

