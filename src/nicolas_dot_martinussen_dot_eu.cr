require "kemal"
require "i18n"

module Nicolas::Martinussen::EU
  VERSION = "0.1.0"
  
  I18n.load_path += ["locales"]
  I18n.init

  get "/" do
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