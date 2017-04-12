require_relative 'connection'

class Question
  attr_accessor :id, :title, :body, :user_id
  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    data.map{|row| Question.new(row)}
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]


  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
      *
      FROM
      questions
      WHERE
      id = ?

    SQL
    return nil if data.empty?
    Question.new(data.first)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
      *
      FROM
      questions
      WHERE
      user_id = ?

    SQL
    return nil if data.empty?
    Question.new(data.first)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDBConnection.instance.execute(<<-SQL, title1: @title,body1:@body, user_id1:@user_id)
      INSERT INTO
      questions(title, body, user_id)
      VALUES
      (:title1, :body1, :user_id1);
    SQL

    @id = QuestionsDBConnection.instance.last_insert_row_id
    new = QuestionFollow.new("user_id"=>@user_id, "question_id" => @id)
    new.create
  end


  def update
    raise "#{self} already in database" unless @id
    QuestionsDBConnection.instance.execute(<<-SQL, @title, @body, @user_id, @id)
      UPDATE
      questions
      SET
      title = ?, body = ?, user_id = ?
      WHERE
      id = ?
    SQL
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    raise "Question not in database" unless @id
    Reply.find_by_question_id(@id)
  end

  def followers
    raise "question not in db" unless @id
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    raise "#{self} already in database" unless @id
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    raise "#{self} already in database" unless @id
    QuestionLike.num_likes_for_question_id(@id)

  end



end
