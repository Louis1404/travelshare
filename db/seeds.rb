# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Creating profiles'


User.create!(
  email:'paul@dujardin.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Paul',
  last_name:'Dujardin',
  city: 'Paris'
 )

 User.create!(
  email:'mario@palomi.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Mario',
  last_name:'Palomi',
  city: 'Rome'
 )

 User.create!(
  email:'monica@sanchez.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Monica',
  last_name:'Sanchez',
  city: 'Barcelone'
 )

 User.create!(
  email:'patrick@collins.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Patrick',
  last_name:'Collins',
  city: 'Dublin'
 )

 User.create!(
  email:'kristen@garner.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Kristen',
  last_name:'Garner',
  city: 'Berlin'
 )

 User.create!(
  email:'marie@durand.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Marie',
  last_name:'Durand',
  city: 'Bordeaux'
 )

 User.create!(
  email:'pedro@alvarez.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Pedro',
  last_name:'Alvarez',
  city: 'Madrid'
 )

 User.create!(
  email:'emilie@vanbruge.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Emilie',
  last_name:'Vanbruge',
  city: 'Bruxelles'
 )

 User.create!(
  email:'john@snow.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'John',
  last_name:'Snow',
  city: 'London'
 )

 User.create!(
  email:'anna@dipatri.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Anna',
  last_name:'Dipatri',
  city: 'Milan'
 )

