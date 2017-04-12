require_relative 'connection'

  class Reply
    def self.all
      data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
      data.map{|row| Reply.new(row)}
    end

    def self.find_by_id(id)
      data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
      *
      FROM
      replies
      WHERE
      id = ?
      SQL
      return nil if data.empty?
      Reply.new(data.first)
    end

    def self.find_by_question_id(question_id)
      data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
      *
      FROM
      replies
      WHERE
      question_id = ?
      SQL
      return nil if data.empty?
      data.map { |row| Reply.new(row) }
    end

    def self.find_by_user_id(user_id)
      data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
      *
      FROM
      replies
      WHERE
      user_id = ?
      SQL
      return nil if data.empty?
      data.map { |row| Reply.new(row) }
    end

    def initialize(options)
      @id = options['id']
      @question_id = options['question_id']
      @user_id = options['user_id']
      @parent_reply = options['parent_reply']
      @body = options['body']
    end

    def create
      raise "#{self} already in database" if @id
      QuestionsDBConnection.instance.execute(<<-SQL, @question_id, @user_id, @parent_reply, @body)
        INSERT INTO
        replies(question_id, user_id, parent_reply, body)
        VALUES
        (?, ?, ?, ?)
      SQL
      @id = QuestionsDBConnection.instance.last_insert_row_id
    end

    def update
      raise "#{self} already in database" unless @id
      QuestionsDBConnection.instance.execute(<<-SQL, @question_id, @user_id, @parent_reply, @body, @id)
        UPDATE
        replies
        SET
        question_id = ?, user_id = ?, parent_reply = ?, body = ?
        WHERE
        id = ?
      SQL
    end

    def author
      User.find_by_id(@user_id)
    end

    def question
      Question.find_by_id(@question_id)
    end

    def parent_reply
      return nil unless @parent_reply
      Reply.find_by_id(@parent_reply)
    end

    def child_replies
      raise "#{self} already in database" unless @id
      data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
      *
      FROM
      replies
      WHERE
      parent_reply = ?
      SQL
      return nil if data.empty?
      data.map { |row| Reply.new(row) }
    end

end
