if Profile.count() > 0
  p '> Deleting all existent profiles!'
  Profile.all().each do |p|
    p.destroy
  end
end

p '> Creating new profiles!'
Profile.create!([
  {name: 'Andre de Sousa Costa Filho', url: 'https://github.com/andre-filho'},
  {name: 'Alax Alves', url: 'https://github.com/alaxalves'},
  {name: 'Thalisson Melo', url: 'https://github.com/ThalissonMelo'},
  {name: 'Guilherme Augusto', url: 'https://github.com/guiaugusto'},
  {name: 'Matheus Richard', url: 'https://github.com/MatheusRich'},
  {name: 'Yukihiro Matsumoto', url: 'https://github.com/matz'},
  {name: 'Andre Lewis', url: 'https://github.com/andre'},
  {name: 'Matheus Batista', url: 'https://github.com/matheusbsilva'},
  {name: 'Emanoel Belchior', url: 'https://github.com/nukdown'},
  {name: 'Arthur Assis', url: 'https://github.com/arthur0496'},
])
