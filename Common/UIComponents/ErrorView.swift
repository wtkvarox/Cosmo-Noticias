import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retryAction) {
                Text("Reintentar")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor))
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Ocurrió un error al cargar los artículos") {
            // Acción de retry
        }
        .previewLayout(.sizeThatFits)
    }
}
