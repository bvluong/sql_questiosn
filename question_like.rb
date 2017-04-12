class QuestionLike
  def self.likers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
      *
      FROM
      questions_likes
      WHERE
      question_id = ?

    SQL
    return nil if data.empty?
    data.map{|row| QuestionLike.new(row)}
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
      COUNT(*)
      FROM
      questions_likes
      WHERE
      question_id = ?

    SQL
    data
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
      q.id, q.title, q.body, q.user_id
      FROM
      questions_likes
      JOIN questions as q
        ON questions_likes.question_id = q.id
      WHERE
        questions_likes.user_id = ?
    SQL
    data.map{|row| Question.new(row)}
  end

  def self.most_liked_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
      question_id AS id, q1.title, q1.body, q1.user_id
      FROM
      questions_likes
        JOIN questions AS q1
          ON q1.id = questions_likes.question_id
      GROUP BY
      question_id
      ORDER BY
      COUNT(DISTINCT questions_likes.user_id) DESC
      LIMIT ?
    SQL
    return nil if data.empty?
    data.map {|row| Question.new(row) }
  end


  def initialize(options)
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end


end
