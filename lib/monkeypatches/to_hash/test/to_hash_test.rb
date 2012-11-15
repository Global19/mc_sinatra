require "test/unit"
require_relative "../object.rb"

class Person
  def initialize(name, age, height = 6)
    @name = name
    @age = age
    @height = height
  end

  def person_is_how_old
    "#{@name} is #{@age}"
  end

  def name_upcase
    @name.upcase
  end

  def relative_age
    if @age < 10
      "young"
    elsif @age < 20
      "teenager"
    elsif @age > 20
      "old"
    end
  end

  def serializable_methods
    [:relative_age, :name_upcase, :person_is_how_old]
  end

end

class Paul < Person
  def initialize
    super("Paul A", 35, 8)
  end

  def test_method
    "return from test method"
  end

  def serializable_methods
    super + [:test_method]
  end
end

class ToHashTest < Test::Unit::TestCase
  PERSON = Person.new("Simon", 21)
  PAUL = Paul.new

  def test_normal
    person = PERSON.to_hash
    reference = {:name=>"Simon", :age=>21, :height=>6}
    assert_equal person, reference
  end

  def test_all
    person = PERSON.to_hash(:all => true)
    reference = {:name=>"Simon", :age=>21, :height=>6, :relative_age=>"old", :name_upcase=>"SIMON", :person_is_how_old=>"Simon is 21"}
    assert_equal person, reference
  end

  def test_include_methods
    person = PERSON.to_hash(:methods => [:person_is_how_old, :name_upcase])
    reference = {:name=>"Simon", :age=>21, :height=>6, :person_is_how_old=>"Simon is 21", :name_upcase=>"SIMON"}
    assert_equal person, reference
  end

  def test_only
    person = PERSON.to_hash(:only => [:age])
    reference = {:age=>21}
    assert_equal person, reference
  end

  def test_except
    person = PERSON.to_hash(:except => [:age])
    reference = {:name=>"Simon", :height=>6}
    assert_equal person, reference
  end

  def test_methods_with_except
    person = PERSON.to_hash(:methods => [:person_is_how_old, :name_upcase, :relative_age], :except => [:age])
    reference = {:name=>"Simon", :height=>6, :person_is_how_old=>"Simon is 21", :name_upcase=>"SIMON", :relative_age=>"old"}
    assert_equal person, reference
  end

  def test_methods_with_only
    person = PERSON.to_hash(:methods => [:person_is_how_old, :name_upcase, :relative_age], :only => [:age])
    reference = {:age=>21}
    assert_equal person, reference
  end

  def test_all_with_except
    person = PERSON.to_hash(:all => true, :except => [:age])
    reference = {:name=>"Simon", :height=>6, :relative_age=>"old", :name_upcase=>"SIMON", :person_is_how_old=>"Simon is 21"}
    assert_equal person, reference
  end

  def test_all_with_only
    person = PERSON.to_hash(:all => true, :only => [:age])
    reference = {:age=>21}
    assert_equal person, reference
  end

  def test_subclass_inheritance
    person = PAUL.to_hash(:all => true)
    reference = {:name=>"Paul A", :age=>35, :height=>8, :relative_age=>"old", :name_upcase=>"PAUL A", :person_is_how_old=>"Paul A is 35", :test_method=>"return from test method"}
    assert_equal person, reference
  end
end