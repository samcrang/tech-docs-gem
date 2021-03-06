module GovukTechDocs
  class Pages
    attr_reader :sitemap

    def initialize(sitemap, config)
      @sitemap = sitemap
      @config = config
    end

    def to_json
      as_json.to_json
    end

  private

    def as_json
      pages.map do |page|
        {
          title: page.data.title,
          url: "#{@config[:tech_docs][:host]}#{page.url}",
          review_by: PageReview.new(page).review_by,
          owner_slack: page.data.owner_slack,
        }
      end
    end

    def pages
      sitemap.resources.select { |page| page.url.end_with?('.html') && page.data.title }
    end
  end
end
