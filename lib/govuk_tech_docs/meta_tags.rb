module GovukTechDocs
  class MetaTags
    def initialize(config, current_page)
      @config = config
      @current_page = current_page
    end

    def tags
      all_tags = {
        'description' => page_description,
        'og:description' => page_description,
        'og:image' => page_image,
        'og:site_name' => site_name,
        'og:title' => page_title,
        'og:type' => 'object',
        'og:url' => canonical_url,
        'twitter:card' => 'summary',
        'twitter:domain' => URI.parse(host).host,
        'twitter:image' => page_image,
        'twitter:title' => browser_title,
        'twitter:url' => canonical_url,
      }

      Hash[all_tags.select { |_k, v| v }]
    end

    def browser_title
      [page_title, site_name].select(&:present?).uniq.join(' | ')
    end

    def canonical_url
      "#{host}#{current_page.url}"
    end

  private

    attr_reader :config, :current_page

    def page_image
      "#{host}/images/govuk-large.png"
    end

    def site_name
      config[:tech_docs][:service_name]
    end

    def page_description
      locals[:description] || frontmatter.description
    end

    def page_title
      locals[:title] || frontmatter.title
    end

    def host
      config[:tech_docs][:host].to_s
    end

    def locals
      current_page.metadata[:locals]
    end

    def frontmatter
      current_page.data
    end
  end
end
