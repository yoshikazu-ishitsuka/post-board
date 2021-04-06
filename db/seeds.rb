# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env == 'development'
  Tag.create([
    { name: '本' },
    { name: '動画' },
    { name: 'お役立ち' },
    { name: 'ニュース' },
    { name: '小ネタ' }
  ])
end
