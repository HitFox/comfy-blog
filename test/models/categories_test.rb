require_relative '../test_helper'

class BlogCategoriesTest < ActiveSupport::TestCase

  def test_blog_association
    assert_equal [comfy_blog_categories(:default)], comfy_blog_blogs(:default).categories
  end

  def test_fixtures_validity
    Comfy::Blog::Category.all.each do |category|
      assert category.valid?, category.errors.full_messages.to_s
    end
  end

  def test_validations
    category = Comfy::Blog::Category.new
    assert category.invalid?
    assert_errors_on category, :name, :blog_id
  end

  def test_name_uniqueness
    category = comfy_blog_categories(:default)
    second_category = Comfy::Blog::Category.create(name: category.name, blog: category.blog)

    assert_errors_on second_category, :name
  end

  def test_creation
    assert_difference 'Comfy::Blog::Category.count' do
      category = comfy_blog_blogs(:default).categories.create!(
        :name   => 'Test category',
        :blog   => Comfy::Blog::Blog.first
      )
      assert_equal 'Test category', category.name
      assert_equal Comfy::Blog::Blog.first, category.blog
    end
  end

  def test_destroy
    assert_difference ['Comfy::Blog::Category.count'], -1 do
      comfy_blog_categories(:default).destroy
    end
  end
end
