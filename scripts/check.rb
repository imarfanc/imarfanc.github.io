#!/usr/bin/env ruby
# frozen_string_literal: true

# Checks post front matter, then the built pages in _site: `make check` builds first.

require "date"
require "uri"
require "yaml"

ROOT = File.expand_path("..", __dir__)
SITE = File.join(ROOT, "_site")
TAGS = YAML.safe_load(File.read(File.join(ROOT, "_data/tags.yml")))
SLUG = /\A\d{4}-\d{2}-\d{2}-[a-z0-9-]+\.md\z/.freeze

PAGE_RULES = {
  "title" => /<title>\s*\S/,
  "lang" => /<html\b[^>]*\blang="\S/,
  "viewport" => /<meta\b[^>]*name="viewport"/,
  "description" => /<meta\b[^>]*name="description"\s+content="\s*(?!\{%)\S/,
  "favicon" => /<link\b[^>]*rel="icon"/,
  "dark mode" => /<meta\b[^>]*name="color-scheme"\s+content="[^"]*dark/
}.freeze

def post_problems(path)
  name = File.basename(path)
  problems = []
  problems << "filename must be YYYY-MM-DD-lowercase-slug.md" unless name == "EXAMPLE.md" || name.match?(SLUG)

  front_matter = File.read(path, encoding: "UTF-8")[/\A---\s*\n(.*?)\n---\s*\n/m, 1]
  return problems << "no front matter" unless front_matter

  data = YAML.safe_load(front_matter, permitted_classes: [Date, Time]) || {}
  %w[title share-description].each { |key| problems << "missing #{key}" if data[key].to_s.strip.empty? }
  tags = Array(data["tags"])
  problems << "missing tags" if tags.empty?
  (tags - TAGS).each { |tag| problems << "tag '#{tag}' is not in _data/tags.yml" }
  problems
end

def link_exists?(page, link)
  path = URI.decode_www_form_component(link.sub(/[?#].*\z/, "").gsub("+", "%2B"))
  return true if path.empty?

  target = path.start_with?("/") ? File.join(SITE, path) : File.join(File.dirname(page), path)
  [target, "#{target}.html", File.join(target, "index.html")].any? { |file| File.file?(file) }
end

def page_problems(page)
  html = File.read(page, encoding: "UTF-8")
  return [] if html.match?(/http-equiv="refresh"/i) # jekyll-redirect-from stub

  problems = PAGE_RULES.reject { |_, rule| html.match?(rule) }.keys.map { |rule| "missing #{rule}" }
  title = html[%r{<title>\s*(.*?)\s*</title>}m, 1].to_s
  left, right = title.split(" | ", 2)
  problems << "repeated title: #{title}" if right && left == right

  html.scan(/\b(?:href|src)="([^"]+)"/).flatten.uniq.each do |link|
    next if link.match?(%r{\A(?:[a-z][a-z0-9+.-]*:|//|#|\{)}i)

    problems << "broken link: #{link}" unless link_exists?(page, link)
  end
  problems
end

def report(label, paths)
  failures = paths.map { |path| [path, yield(path)] }.reject { |_, problems| problems.empty? }
  puts "#{failures.empty? ? 'ok  ' : 'FAIL'} #{label} (#{paths.size})"
  failures.each do |path, problems|
    relative = path.delete_prefix("#{ROOT}/")
    problems.each { |problem| puts "     #{relative}: #{problem}" }
  end
  failures.empty?
end

abort "No _site directory: run `make build` first" unless Dir.exist?(SITE)

results = [
  report("posts", Dir[File.join(ROOT, "{_posts,_drafts}/*")].sort) { |path| post_problems(path) },
  report("pages", Dir[File.join(SITE, "**/*.html")].sort) { |path| page_problems(path) }
]
exit(results.all? ? 0 : 1)
