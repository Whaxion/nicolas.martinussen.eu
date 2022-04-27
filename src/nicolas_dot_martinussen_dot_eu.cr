require "http_accept"
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
    add("/", changefreq: "monthly", priority: 0.1, lastmod: (lastmod_language_chooser > lastmod_english) ? lastmod_language_chooser : lastmod_english)
    add("/en", changefreq: "monthly", priority: 0.9, lastmod: (lastmod_index > lastmod_english) ? lastmod_index : lastmod_english)
    add("/fr", changefreq: "monthly", priority: 0.9, lastmod: (lastmod_index > lastmod_french) ? lastmod_index : lastmod_french)
  end

  Sitemapper.store(sitemaps, "./public/")

  get "/" do |env|
    wanted_languages : Array(HTTP::Accept::Language::Value)? = nil
    if env.request.headers["Accept-Language"]?
      wanted_languages = HTTP::Accept::Language.parse(env.request.headers["Accept-Language"])
    end
    case HTTP::Accept::Language.best_locale(["en", "fr"], wanted_languages)
    when "fr"
      env.redirect "/fr"
    else
      env.redirect "/en"
    end
    
    I18n.locale = "en"
    render "src/index.ecr"
  end

  get "/en" do
    I18n.locale = "en"
    render "src/index.ecr"
  end

  get "/fr" do
    I18n.locale = "fr"
    render "src/index.ecr"
  end

  get "/language-chooser" do |env|
    wanted_languages : Array(HTTP::Accept::Language::Value)? = nil
    if env.request.headers["Accept-Language"]?
      wanted_languages = HTTP::Accept::Language.parse(env.request.headers["Accept-Language"])
    end
    case HTTP::Accept::Language.best_locale(["en", "fr"], wanted_languages)
    when "fr"
      I18n.locale = "fr"
    else
      I18n.locale = "en"
    end
    render "src/language-chooser.ecr"
  end

  HORAIRE_REGEX = /(SUMMARY:(.+)?)(INF.+-[0-9]+-[0-9]+)/
  get "/horaire" do |env|
    response = HTTP::Client.get "https://horaire-hepl.provincedeliege.be/myical.php?groupe=INFS3_326"
    if response.status != HTTP::Status::OK
      halt env, status_code: 404
    end
    env.response.content_type = "text/calendar"
    response.body.gsub(HORAIRE_REGEX){ |s|
      md = s.match(HORAIRE_REGEX)
      if md != nil && md.as(Regex::MatchData)[1]? != nil
        s = md.as(Regex::MatchData)[1]
      end
      
      s
    }
  end
end

Kemal.run
