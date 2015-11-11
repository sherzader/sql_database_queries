require_relative 'questions_database'
require_relative 'user'

class Question
  def self.find_by_id(query_id)
    result_id = QuestionsDatabase.instance.execute(<<-SQL, query_id)
      SELECT
       *
      FROM
        questions
      WHERE
        id = ?
    SQL

    result_id.map { |result_id| Question.new(result_id) }.first
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
       *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    questions.map { |question| Question.new(question)  }
  end

  attr_accessor :id, :title, :body, :author_id
  def initialize(options)
    @id, @title, @body, @author_id = options.values_at('id', 'title', 'body', 'author_id')
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end
