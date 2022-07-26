require 'sqlite3'

class Student
    attr_accessor :name, :grade
    attr_reader :id
    
    @@all = []
    @@database_connection = SQLite3::Database.new('/home/faruk/Development/Code/Phase-3/orms-mapping-database-records-to-ruby-objects/my_db.db')

#   def initialize(name, grade, id=nil)
#   @id=id
#   @name=name
#   @grade=grade
#   @@all << self
#   end
  
  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    @@database_connection.execute(sql).map do |row|
        self.new_from_db(row)
    end
  end
  
  def self.create_table()
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    @@database_connection.execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    @@database_connection.execute(sql)
    # DB[:conn].execute("DROP TABLE IF EXISTS students")
  end
  
  def save
    sql = <<-SQL
    INSERT INTO students(name, grade)
    VALUES (?, ?)
    SQL
    @@database_connection.execute(sql, self.name, self.grade)
    # DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
    @id = database_connection.execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
  
  def self.new_from_db(row)
    new_student = self.new
    # new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    @@database_connection.execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  end
  
# Student.all.each do |student|
# puts student.name
# end

# Student.all.each do |student|
#     puts "#{student.id}, #{student.name}, #{student.grade}"
# end

puts Student.find_by_name("New Student").name;




#   Student.create_table;
#   Student.create({name: "New Student2", grade: "New grade2"});


# class Song
#     attr_accessor :name, :album, :id
#     @@all = []
#     @@database_connection = SQLite3::Database.new('/home/faruk/Development/Code/Phase-3/orms-mapping-classes-to-database-tables/song.db')

#     def initialize(id=nil, name, album)
#       @id = id
#       @name = name
#       @album = album
#       @@all << self
      
#     end
  
#     def self.all
#         @@all
#     end

    # def self.create_table()
    #     sql =  <<-SQL 
    #       CREATE TABLE IF NOT EXISTS songs (
    #         id INTEGER PRIMARY KEY, 
    #         name TEXT, 
    #         album TEXT
    #         )
    #         SQL
    #         @@database_connection.execute(sql) 
    # end
  
    # def save
    #     sql = <<-SQL
    #     INSERT INTO songs (name, album) 
    #     VALUES (?, ?)
    #   SQL
  
    #   @@database_connection.execute("INSERT INTO songs (name, album) VALUES (?, ?)", self.name, self.album)

    #   @id = database_connection.execute("SELECT last_insert_rowid() FROM songs")[0][0]
  
    # end
  
#     def self.create(name:, album:)
#         song = Song.new(name, album)
#         song.save
#         song
#       end
#   end

#   Song.create_table;
#   Song.new("Hello", "25");
#   Song.new("99 Problems", "The Black Album");
#   Song.create({name: "New Song4", album: "New Album4"});

#   Song.all.each do |song|
#     Song.save(song.name, song.album)
#   end