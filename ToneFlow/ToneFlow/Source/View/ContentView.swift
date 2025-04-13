import SwiftUI

struct ContentView: View {
    @ObservedObject var audioManager = AudioManager.shared
    
    @State var inputVolume: Double = 0.5
    @State var outputVolume: Double = 0.5
    
    @State var inputKnobValue: Double = 0.5
    @State var outputKnobValue: Double = 0.5
    @State var compressorKnobValue: Double = 0.5
    @State var overdriveKnobValue: Double = 0.5
    @State var delayKnobValue: Double = 0.5
    @State var reverbKnobValue: Double = 0.5
    @State var ampBassKnobValue: Double = 0.5
    @State var ampMidKnobValue: Double = 0.5
    @State var ampTrebleKnobValue: Double = 0.5
    
    @State var hz65Value: Double = 0
    @State var hz125Value: Double = 0
    @State var hz250Value: Double = 0
    @State var khz1Value: Double = 0
    @State var khz2Value: Double = 0
    @State var khz4Value: Double = 0
    @State var khz8Value: Double = 0
    @State var khz16Value: Double = 0
    
    @State var compressorIsOn: Bool = true
    @State var overdriveIsOn: Bool = true
    @State var delayIsOn: Bool = true
    @State var reverbIsOn: Bool = true
    @State var ampIsOn: Bool = true
    @State var eqIsOn: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    InputView(inputVolume: $inputVolume, knobValue: $inputKnobValue)
                    Spacer()
                    OutputView(outputVolume: $outputVolume, knobValue: $outputKnobValue)
                }
                .padding(.horizontal, 40)
                .padding(.top, 15)
                
                HStack(spacing: 20) {
                    EffectorView(title: "Compressor", isOn: $compressorIsOn, knobValue: $compressorKnobValue)
                    
                    EffectorView(title: "Overdrive", isOn: $overdriveIsOn, knobValue: $overdriveKnobValue)
                }
                .padding(.horizontal, 20)
                .frame(height: 250)
                
                AmpView(
                    isOn: $ampIsOn,
                    bassKnobValue: $ampBassKnobValue,
                    midKnobValue: $ampMidKnobValue,
                    trebleKnobValue: $ampTrebleKnobValue
                )
                .frame(height: 230)
                .padding(.horizontal, 20)
                
                EQView(
                    isOn: $eqIsOn,
                    hz65Value: $hz65Value,
                    hz125Value: $hz125Value,
                    hz250Value: $hz250Value,
                    khz1Value: $khz1Value,
                    khz2Value: $khz2Value,
                    khz4Value: $khz4Value,
                    khz8Value: $khz8Value,
                    khz16Value: $khz16Value
                )
                .padding(.horizontal, 20)
                .frame(height: 310)
                
                HStack(spacing: 20) {
                    EffectorView(title: "Delay", isOn: $delayIsOn, knobValue: $delayKnobValue)
                    
                    EffectorView(title: "Reverb", isOn: $reverbIsOn, knobValue: $reverbKnobValue)
                }
                .padding(.horizontal, 20)
                .frame(height: 250)
            }
        }
        .background(backgroundView())
    }
    
    func backgroundView() -> some View {
        Color.background.ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
