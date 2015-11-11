require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'

class User

  def self.find_by_id(query_id)

    result_id = QuestionsDatabase.instance.execute(<<-SQL, query_id)
      SELECT
       *
      FROM
        users
      WHERE
        id = ?
    SQL

    result_id.map { |result_id| User.new(result_id) }.first
  end

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
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end
