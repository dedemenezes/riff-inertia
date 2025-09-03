module BreadcrumbsHelper
  def breadcrumbs(*crumbs)
    crumbs.map do |label, path|
      { label: label, href: path }
    end
  end
end
