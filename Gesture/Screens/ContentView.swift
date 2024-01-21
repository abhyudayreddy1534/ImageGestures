//
//  ContentView.swift
//  Gesture
//
//  Created by Sravanthi Chinthireddy on 18/01/24.
//

import SwiftUI

struct ContentView: View {
//    MARK: Property
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen : Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
//    MARK: Function
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
//    MARK: Content
    
    var body: some View {
        NavigationStack {
            ZStack(content: {
                
                Color(.clear)
                
//                MARK: Page image
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
//                Tap gesture // count 2 means double tap
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        }
                        else {
                            resetImageState()
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
//                MARK: Magnification:
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    }
                                    else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                }
                                else if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
            })//: Zstack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
//            MARK: Info panel
            .overlay(alignment: .top, content: {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                
            })
            
//            MARK: Controls
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
//                        Scale down
                        Button(action: {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                                
                            }
                        }, label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        })
//                        reset
                        Button(action: {
                            withAnimation(.spring()) {
                                resetImageState()
                                
                            }
                        }, label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        })
//                        scale up
                        Button(action: {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                                
                            }
                        }, label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        })
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30)
            }
            .overlay(
                HStack(spacing: 10) {
//                    MARK: Drawer handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    Spacer()
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    
                    Spacer()
//                    MARK: thumbnails
                    
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 300)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20 : 220)
                , alignment: .topTrailing
            )
        }//: Navigation stack
        
    }
}

#Preview {
    ContentView()
}
