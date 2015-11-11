require_relative 'questions_database'

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

    result.map { |found| Question.new(found) }
  end

  attr_accessor :id, :title, :body, :author_id
  def initialize(options)
    @id, @title, @body, @author_id = options.values_at('id', 'title', 'body', 'author_id')
  end
end
