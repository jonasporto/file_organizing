# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FileTag.create(name: 'File1', tags: %w{Tag1 Tag2 Tag3 Tag5})
FileTag.create(name: 'File2', tags: %w{Tag2})
FileTag.create(name: 'File3', tags: %w{Tag2 Tag3 Tag5})
FileTag.create(name: 'File4', tags: %w{Tag2 Tag3 Tag4 Tag5})
FileTag.create(name: 'File5', tags: %w{Tag3 Tag4})
