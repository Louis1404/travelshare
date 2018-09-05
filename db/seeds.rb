puts 'Creating profiles'
Way.destroy_all
Traveller.destroy_all
Trip.destroy_all
Profile.destroy_all
User.destroy_all

User.create!(
  email:'clem@clem.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Clem',
  last_name:'Clem',
  city: 'Lille'
)
sleep(1)
User.create!(
  email:'paul@dujardin.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Paul',
  last_name:'Dujardin',
  city: 'Paris'
 )
sleep(1)
 User.create!(
  email:'mario@palomi.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Mario',
  last_name:'Palomi',
  city: 'Rome'
 )
sleep(1)
 User.create!(
  email:'monica@sanchez.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Monica',
  last_name:'Sanchez',
  city: 'Barcelone'
 )
sleep(1)
 User.create!(
  email:'patrick@collins.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Patrick',
  last_name:'Collins',
  city: 'Dublin'
 )
sleep(1)
 User.create!(
  email:'kristen@garner.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Kristen',
  last_name:'Garner',
  city: 'Berlin'
 )
sleep(1)
 User.create!(
  email:'marie@durand.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Marie',
  last_name:'Durand',
  city: 'Bordeaux'
 )
sleep(1)
 User.create!(
  email:'pedro@alvarez.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Pedro',
  last_name:'Alvarez',
  city: 'Madrid'
 )
sleep(1)
 User.create!(
  email:'emilie@vanbruge.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Emilie',
  last_name:'Vanbruge',
  city: 'Bruxelles'
 )
sleep(1)
 User.create!(
  email:'john@snow.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'John',
  last_name:'Snow',
  city: 'London'
 )
sleep(1)
<<<<<<< HEAD
User.create!(
=======
 User.create!(
>>>>>>> master
  email:'anna@dipatri.com',
  password:'123456',
  password_confirmation:'123456',
  first_name:'Anna',
  last_name:'Dipatri',
  city: 'Milan'
)

Profile.where(latitude: nil).each do |p|
  p.geocode
  p.save
end

