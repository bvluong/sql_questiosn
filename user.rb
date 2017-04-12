require_relative 'connection'

class User

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM users')
    data.map{|row| User.new(row)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
    SELECT
    *
    FROM
    users
    WHERE
    id = ?
    SQL
    return nil if data.empty?
    User.new(data.first)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
    SELECT
    *
    FROM
    users
    WHERE
    fname = ? AND lname = ?
    SQL
    return nil if data.empty?
    data.map {|row| User.new(row) }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} already in database" if @id
    QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
      users(fname, lname)
      VALUES
      (?, ?)
    SQL
    @id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} already in database" unless @id
    QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
      users
      SET
      fname = ?, lname = ?
      WHERE
      id = ?
    SQL
  end

  def authored_questions
    raise "User not in database" unless @id
    data = Question.find_by_author_id(@id)


  end

  def authored_replies
    raise "User not in database" unless @id
    data = Reply.find_by_user_id(@id)


  end

  def followed_questions
    raise "user not in db" unless @id
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    raise "user not in db" unless @id
    QuestionLike.liked_questions_for_user_id(@id)
  end

end
