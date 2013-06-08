require 'psych'

module Settings
  pwd = Dir.getwd
  yml_structure = Psych.load_file("#{pwd}/settings.yml")
  files_base = yml_structure['files']
  creds_base = yml_structure['login']

  FILES = {
      log: files_base['log'],
      routers: files_base['router_list']
  }

  CREDENTIALS = {
      username: creds_base['username'],
      password: creds_base['password']
  }
end
