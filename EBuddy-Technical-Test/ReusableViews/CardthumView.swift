//
//  Cardthum.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI

struct CardthumView: View {
    @EnvironmentObject var userVM: UserViewModel
    var user: UserJSON
    var onTapAction: () -> Void
    @State var profileImage: UIImage?

    var body: some View {
        VStack{
            HStack(spacing: 0){
                Text(user.name ?? "")
                    .bold()
                    .font(.system(size: 25))
                    .padding(.trailing, 8)

                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)

                Spacer()

                Image("checkmark")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 10)

                Image("instagram")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            ZStack(alignment: .top){
                if let image = user.image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .frame(maxWidth: .infinity)
                        .frame(height: 450)
                } else {
                    ZStack {
                        Color.orange
                        Image(systemName: "person.crop.square.badge.camera.fill")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 100, height: 80, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 450)
                    .cornerRadius(18)
                }

                VStack {
                    HStack(spacing: 6) {
                        Image("lighting")
                            .resizable()
                            .frame(width: 30, height: 40)
                        Text("Available today!")
                            .font(.system(size: 25))
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 280, height: 60)
                    .foregroundStyle(Color.white.opacity(0.4))
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .padding(.top, 24)

                    Spacer()

                    HStack {
                        ZStack {
                            Image("game-1")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            Image("game-2")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                                .offset(x: 75)
                                .overlay {
                                    ZStack {
                                        Color.black.opacity(0.7)
                                            .clipShape(Circle())
                                        Text("+3")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 35))
                                    }
                                    .offset(x: 75)
                                }
                        }

                        Spacer()

                        Image("voice")
                            .resizable()
                            .frame(width: 100, height: 100)

                    }
                    .padding(.horizontal, 24)
                    //                        .position(x: 0, y: 0)
                }
            }
            .frame(height: 500)
            .padding(.bottom, 16)


            HStack(spacing: 10){
                Image("star")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text(String(user.rating ?? 0.0))
                    .bold()
                    .font(.system(size: 30))

                Text("(61)")
                    .font(.system(size: 30))
                    .foregroundColor(Color.gray)
                Spacer()
            }
            .padding(.leading, 16)

            HStack(spacing: 10){
                Image("mana")
                    .resizable()
                    .frame(width: 40, height: 40)
                HStack(spacing: 0){
                    Text(String(format: "%.2f", user.price ?? 0.0))
                        .bold()
                        .font(.system(size: 37))
                    Text("/1Hr").font(.system(size: 35))
                }

                Spacer()
            }
            .padding(.leading, 16)
        }
        .cornerRadius(4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 700)
        .padding(.horizontal, 8)
        .padding(.bottom, 24)
        .onTapGesture {
            onTapAction()
        }
        .onAppear {
            if user.imageUrl != "" {
                self.userVM.retrieveImage(user: user, selectedImage: $profileImage)
            }
        }
    }
}
