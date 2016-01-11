require_relative '../test_helper'

class BlogAuthorsTest < ActiveSupport::TestCase

  def test_blog_association
    assert_equal [comfy_blog_authors(:default)], comfy_blog_blogs(:default).authors
  end

  def test_fixtures_validity
    Comfy::Blog::Author.all.each do |author|
      assert author.valid?, author.errors.full_messages.to_s
    end
  end

  def test_validations
    author = Comfy::Blog::Author.new
    assert author.invalid?
    assert_errors_on author, :first_name, :last_name, :blog_id
  end

  def test_creation
    assert_difference 'Comfy::Blog::Author.count' do
      author = comfy_blog_blogs(:default).authors.create!(
        :first_name   => 'John',
        :last_name    => 'Smith',
        :blog         => Comfy::Blog::Blog.first
      )
      assert_equal 'John', author.first_name
      assert_equal 'Smith', author.last_name
      assert_equal Comfy::Blog::Blog.first, author.blog
    end
  end

  def test_destroy
    assert_difference ['Comfy::Blog::Author.count'], -1 do
      comfy_blog_authors(:default).destroy
    end
  end

  def test_full_name
    author = comfy_blog_authors(:default)
    assert_equal 'John Smith', author.full_name
  end
end
