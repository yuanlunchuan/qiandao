# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Admin.create name: 'test', 
  password_digest: '123',
  auth_token: '123'

Event.create(name: '成都比赛', 
  start: '2016-01-01',
  end: '2016-01-02', 
  desc: '天府广场',
  location: '', 
  starts_at: '2015-12-31 16:00:00', 
  ends_at: '2016-01-01 16:00:00', 
  created_at: '2016-01-19 10:03:05', 
  updated_at: '2016-01-19 10:03:05'
  )