import SwiftUICore
import SwiftUI
import Kingfisher

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            KFImage(article.imageUrl)
                .placeholder { Color.gray.frame(width: 80, height: 80) }
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(article.newsSite)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(article.publishedAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
