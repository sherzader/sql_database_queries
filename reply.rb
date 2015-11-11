require_relative 'questions_database'

class Reply

  def self.find_by_id(query_id)
    result_id = QuestionsDatabase.instance.execute(<<-SQL, query_id)
      SELECT
       *
      FROM
        replies
      WHERE
        id = ?
    SQL

    result_id.map { |result_id| Reply.new(result_id) }.first
  end


  def self.find_by_user_id(user_id)
    replies_for_user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    replies_for_user.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies_for_question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    replies_for_question.map { |reply| Reply.new(reply) }
  end

  attr_accessor :id, :question_id, :user_id, :parent_reply, :body
  def initialize(options)
    @id, @question_id, @user_id, @parent_reply, @body =
      options.values_at('id', 'question_id', 'user_id', 'parent_reply', 'body')
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_reply) unless @parent_reply == 'NULL'
  end

  def child_replies
    Reply.find_child_replies(@id)
  end

  def self.find_child_replies(id)
    result_id = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
       *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    result_id.map { |result_id| Reply.new(result_id) }
  end
end
