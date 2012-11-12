require 'uri'
require 'active_record'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/fflcontest')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :port     => db.port,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)
