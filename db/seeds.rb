require 'Faker'

puts 'Creating users...'

User.create!([
  { email: 'admin@email.com', name: 'Admin user', is_admin: true, password: '123456', password_confirmation: '123456' },
  { email: 'fernando@email.com', name: 'Fernando', is_admin: false, password: '123456', password_confirmation: '123456' },
  { email: 'alejo@email.com', name: 'Alejo', is_admin: false, password: '123456', password_confirmation: '123456' },
  { email: 'victor@email.com', name: 'Victor', is_admin: false, password: '123456', password_confirmation: '123456' },
  { email: 'franco@email.com', name: 'Franco', is_admin: false, password: '123456', password_confirmation: '123456' },
  { email: 'jeremias@email.com', name: 'Jeremias', is_admin: false, password: '123456', password_confirmation: '123456' },
  { email: 'german@email.com', name: 'German', is_admin: false, password: '123456', password_confirmation: '123456' },
  { email: 'jorge@email.com', name: 'Jorge', is_admin: false, password: '123456', password_confirmation: '123456' }
])

puts 'Users created!!!'

puts 'Creating conversations...'

Conversation.create!([
  { state: '{ "status": "started" }', users: [User.find_by(name: 'Fernando'), User.find_by(name: 'Alejo')] },
  { state: '{ "status": "started" }', users: [User.find_by(name: 'Victor'), User.find_by(name: 'Franco')] },
  { state: '{ "status": "started" }', users: [User.find_by(name: 'Jeremias'), User.find_by(name: 'Jorge')] },
  { state: '{ "status": "started" }', users: [User.find_by(name: 'German'), User.find_by(name: 'Alejo')] }
])

puts 'Conversations created!!!'

puts 'Creating messages...'

Message.create!([
  { detail: Faker::Movies::BackToTheFuture.quote, conversation: Conversation.first, user: User.find_by(name: 'Fernando'), modified: false },
  { detail: Faker::Movies::BackToTheFuture.quote, conversation: Conversation.first, user: User.find_by(name: 'Alejo'), modified: false },
  { detail: Faker::Movies::BackToTheFuture.quote, conversation: Conversation.first, user: User.find_by(name: 'Fernando'), modified: false },
  { detail: Faker::Movies::BackToTheFuture.quote, conversation: Conversation.first, user: User.find_by(name: 'Alejo'), modified: false },
  { detail: Faker::Movies::BackToTheFuture.quote, conversation: Conversation.first, user: User.find_by(name: 'Fernando'), modified: false },
  { detail: Faker::Movies::BackToTheFuture.quote, conversation: Conversation.first, user: User.find_by(name: 'Alejo'), modified: false }
])

puts 'Messages created!!!'
