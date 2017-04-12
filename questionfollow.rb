require_relative 'connection'

class QuestionFollow
  attr_accessor :id, :user_id, :question_id
  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions_follows')
    data.map{|row| QuestionFollow.new(row)}
  end

  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]


  end

  def self.followers_for_question_id(question_id)

    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
      users.*
      FROM
      questions_follows
        JOIN
          users
          ON users.id = questions_follows.user_id
      WHERE
      questions_follows.question_id = ?
    SQL
    return nil if data.empty?
    data.map {|row| User.new(row) }
  end

    def self.followed_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
      questions.*
      FROM
      questions_follows
        JOIN
          questions
          ON questions.id = questions_follows.question_id
      WHERE
      questions_follows.user_id = ?

    SQL
    return nil if data.empty?
    data.map {|row| Question.new(row) }
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
      *
      FROM
      questions_follows
      WHERE
      id = ?

    SQL
    return nil if data.empty?
    QuestionFollow.new(data.first)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
      *
      FROM
      questions_follows
      WHERE
      user_id = ?

    SQL
    return nil if data.empty?
    QuestionFollow.new(data.first)
  end

  def self.most_followed_questions(n)

    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
      question_id AS id, q1.title, q1.body, q1.user_id
      FROM
      questions_follows
        JOIN questions AS q1
          ON q1.id = questions_follows.question_id
      GROUP BY
      question_id
      ORDER BY
      COUNT(DISTINCT questions_follows.user_id) DESC
      LIMIT ?
    SQL
    return nil if data.empty?
    data.map {|row| Question.new(row) }
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDBConnection.instance.execute(<<-SQL, @user_id, @question_id )
      INSERT INTO
      questions_follows(user_id, question_id)
      VALUES
      (?, ?)

    SQL

    @id = QuestionsDBConnection.instance.last_insert_row_id
  end


  def update
    raise "#{self} already in database" unless @id
    QuestionsDBConnection.instance.execute(<<-SQL, @user_id, @question_id, @id)
      UPDATE
      questions_follows
      SET
      user_id = ?, question_id = ?
      WHERE
      id = ?
    SQL
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    raise "Question not in database" unless @question_id
    Reply.find_by_question_id(@question_id)
  end




end
