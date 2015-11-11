require_relative 'questions_database'
require_relative 'question'

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
    raise "More than one record!" if result.count > 1
    result.map { |found| User.new(found) }.first
  end

  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
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
