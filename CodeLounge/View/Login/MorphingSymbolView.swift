//
//  MorphingSymbolView.swift
//  CodeLounge
//
//  Created by 김동현 on 1/14/25.
//

import SwiftUI

struct Config {
    var font: Font                      // 글꼴 스타일
    var frame: CGSize                   // UI 요소 크기
    var radius: CGFloat                 // UI 요소 둥글기
    var foregroundColor: Color          // UI 요소 기본 색상
    var keyFrameDuration: CGFloat = 0.4 // 각 키프레임에서 애니메이션 지속되는 시간(초 단위)
    // 심볼 변경시 적용되는 애니메이션    duration: 애니메이션 지속 시간   extraBounce: 추가 튕김 효과
    var symbolAnimation: Animation = .smooth(duration: 0.5, extraBounce: 0)
}

// MARK: - 심볼이 부드럽게 전환되는 애니메이션 제공
struct MorphingSymbolView: View {
    var symbol: String                                  // 표시할 심볼
    var config: Config                                  // UI & Animation 설정 객체
    @State private var trigger: Bool = false            // 애니메이션 트리거 역할
    @State private var displayingSymbol: String = "leaf.circle.fill"    // 현재의 화면에 렌더링된 심볼
    @State private var nextSymbol: String = ""          // 다음에 렌더링될될 심볼
    
    var body: some View {
        
        // MARK: - Canvas 고급 그래픽 작업을 위한 드로잉 뷰
        
        Canvas { ctx, size in
            // MARK: - 그래픽 그리기
            // ctx: 렌더링 컨텍스트로, 그래픽 요소를 추가하거나 필터를 적용할 수 있다
            // size: 캔버스의 크기를 나타내며, 뷰의 크기와 동일하다.
            // 필터 추가: 알파값과 색상조건을 기반으로 그리기 제어
            // min: 알파 값의 최소 임계값 (여기선 0.4).
            // color: 필터를 적용할 색상
            // 효과: 특정 색상만 표시되고 나머지는 제거된다
            ctx.addFilter(.alphaThreshold(min: 0.4, color: config.foregroundColor))
            
            // 심볼 렌더링: 제공된 심볼을 렌더링하여 캔버스에 추가
            // ctx.resolveSymbol(id: 0): symbols 블록에서 정의한 심볼(ImageView)을 가져온다
            // ctx.draw(...): 해당 심볼을 캔버스의 특정 위치에 그린다
            // CGPoint(x: size.width / 2, y: size.height / 2)는 캔버스 중앙을 나타낸다
            if let renderedImage = ctx.resolveSymbol(id: 0) {
                ctx.draw(renderedImage, at: CGPoint(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            // MARK: - 심볼 정의(재사용 가능한 렌더링 요소(심볼) 정의
            // tag(0): 심볼에 고유 ID를 부여
            ImageView()
                .tag(0)
        }
        .frame(width: config.frame.width, height: config.frame.height)
        .onChange(of: symbol) { oldValue, newValue in
            trigger.toggle()
            nextSymbol = newValue
        }
        .task {
            guard displayingSymbol == "" else { return }
            displayingSymbol = symbol
        }
    }
    
    // SwiftUI의 커스텀 뷰를 작성할 때, 조건부 뷰 생성이나 여러 뷰 반환을 가능하게 해주는 속성
    // 여러 개의 뷰를 선언적으로 만들 수 있다
    // ImageView()는 선언적이고 동적인 뷰 생성을 지원한다
    
    /*
     KeyframeAnimator
     - 키프레임 기반 애니메이션을 생성
     - 애니메이션의 각 단계(키프레임)를 정의하고, 애니메이션 값을 뷰에 전달
     
     initialValue
     - 애니메이션의 시작 값
     - 여기서는 CGFloat.zero로, 블러 반지름이 0에서 시작합니다
     
     trigger
     - 애니메이션을 재생할 조건
     - trigger 상태가 변경되면 애니메이션이 실행됩니다
     
     애니메이션 동작
     radius
     - 현재 애니메이션 단계에서 전달되는 값. 이 값은 키프레임에 따라 변화합니다
     keyframes
     - 애니메이션의 각 단계(키프레임)를 정의
     - 첫 번째 키프레임: 블러 반지름(radius)이 config.radius로 증가
     - 두 번째 키프레임: 블러 반지름이 0으로 감소
     
     */
    @ViewBuilder
    func ImageView() -> some View {
        KeyframeAnimator(initialValue: CGFloat.zero, trigger: trigger) { radius in
            Image(systemName: displayingSymbol)
                .font(config.font)
                .blur(radius: radius)
                .foregroundStyle(config.foregroundColor)
                .frame(width: config.frame.width, height: config.frame.height)
                .onChange(of: radius) { oldValue, newValue in
                    if newValue.rounded() == config.radius {
                        withAnimation(config.symbolAnimation) {
                            displayingSymbol = symbol
                        }
                    }
                }
        } keyframes: { _ in
            CubicKeyframe(config.radius, duration: config.keyFrameDuration)
            CubicKeyframe(0, duration: config.keyFrameDuration)
        }
    }
}

#Preview {
    MorphingSymbolView(symbol: "gearshape.fill", config: .init(font: .system(size: 100, weight: .bold), frame: CGSize(width: 259, height: 200), radius: 15, foregroundColor: .black))
}
