require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Question
  def self.find_by_id(query_id)

    result = QuestionsDatabase.instance.execute(<<-SQL, query_id)
      SELECT
       *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(result)
  end

  attr_accessor :id, :title, :body, :author_id
  def initialize(options)
    p options
    @id, @title, @body, @author_id = options.first.values_at('id', 'title', 'body', 'author_id')
  end
end

class User
  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    User.new(result)
  end

  attr_accessor :id, :fname, :lname

  def initialize(options)
    p options
    @id, @fname, @lname = options.first.values_at('id', 'fname', 'lname')
  end

  def authored_questions
    questions = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    questions.map { |question| Question.new(question)  }
  end


end
