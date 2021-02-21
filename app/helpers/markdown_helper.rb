module MarkdownHelper
  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      space_after_headers: true
    }
    extensions = {
      no_links: true,            # a 要素を無効化
      safe_links_only: true,
      highlight: true,
      lax_spacing: true,
      strikethrough: true,
      superscript: true,
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      quote: true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end
end
