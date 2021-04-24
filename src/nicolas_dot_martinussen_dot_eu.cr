require "kemal"
require "i18n"
require "sitemapper"

module Nicolas::Martinussen::EU
  VERSION = "0.1.0"

  I18n.load_path += ["locales"]
  I18n.init

  Sitemapper.configure do |c|
    c.host = "https://nicolas.martinussen.eu"
    c.compress = false
  end
  
  lastmod_index = File.info("./src/index.ecr").modification_time
  lastmod_language_chooser = File.info("./src/language-chooser.ecr").modification_time
  lastmod_english = File.info("./locales/en.yml").modification_time
  lastmod_french = File.info("./locales/fr.yml").modification_time

  sitemaps = Sitemapper.build do
    add("/", priority: 0.1, lastmod: (lastmod_language_chooser > lastmod_english) ? lastmod_language_chooser : lastmod_english)
    add("/en", priority: 0.9, lastmod: (lastmod_index > lastmod_english) ? lastmod_index : lastmod_english)
    add("/fr", priority: 0.9, lastmod: (lastmod_index > lastmod_french) ? lastmod_index : lastmod_french)
  end

  Sitemapper.store(sitemaps, "./public/")

  get "/" do
    I18n.locale = "en"
    render "src/language-chooser.ecr"
  end

  get "/en" do
    I18n.locale = "en"
    render "src/index.ecr"
  end

  get "/fr" do
    I18n.locale = "fr"
    render "src/index.ecr"
  end
end

Kemal.run