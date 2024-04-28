//
//  LoginView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    
                    SecureField("Enter your password", text: $viewModel.password)                      .modifier(TextFieldModifier())
                }
                
                Button {
                    viewModel.isShowFogotPassword = true
                } label: {
                    Text("Forgot passsword")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .padding(.trailing, 28)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button {
                    Task {
                        try await viewModel.login()
                    }
                } label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 44)
                        .background(.black)
                        .cornerRadius(8)
                }
                    
                
                GoogleSignInButton(scheme: .dark, style: .standard) {
                    Task {
                        do {
                            try await viewModel.singInGoogle()
                        } catch {
                            viewModel.isShowAlert = true
                            viewModel.message = error.localizedDescription
                            print(error.localizedDescription)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                        .environment(\.loginVm, viewModel)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don`t have an account?")
                        
                        Text("Sing Up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            .sheet(isPresented: $viewModel.isShowFogotPassword) {
                ForgotPasswordView()
                    .environment(\.loginVm, viewModel)
            }
        }
        .alert(isPresented: $viewModel.isShowAlert, content: {
            Alert(title: Text("Message"), message: Text(viewModel.message),
            dismissButton: . destructive (Text ("Ok")))
        })
    }
}

#Preview {
    LoginView()
}

