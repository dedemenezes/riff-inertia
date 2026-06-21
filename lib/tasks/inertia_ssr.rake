# frozen_string_literal: true

namespace :inertia do
  namespace :ssr do
    desc "Build the Inertia SSR bundle"
    task :build do
      sh "npm run build:ssr"
    end
  end
end

Rake::Task["assets:precompile"].enhance do
  Rake::Task["inertia:ssr:build"].invoke
end
