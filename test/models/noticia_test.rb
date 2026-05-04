require "test_helper"

class NoticiaTest < ActiveSupport::TestCase
  setup do
    @valid = noticias(:one_talents)
  end

  test "valid fixture passes validations" do
    assert @valid.valid?
  end

  test "requires data" do
    @valid.data = nil
    assert_not @valid.valid?
    assert @valid.errors[:data].any?
  end

  test "requires titulo" do
    @valid.titulo = nil
    assert_not @valid.valid?
    assert @valid.errors[:titulo].any?
  end

  test "titulo cannot exceed 150 characters" do
    @valid.titulo = "a" * 151
    assert_not @valid.valid?
    assert @valid.errors[:titulo].any?
  end

  test "requires permalink" do
    @valid.permalink = nil
    assert_not @valid.valid?
    assert @valid.errors[:permalink].any?
  end

  test "permalink cannot exceed 150 characters" do
    @valid.permalink = "a" * 151
    assert_not @valid.valid?
    assert @valid.errors[:permalink].any?
  end

  test "permalink must be unique" do
    duplicate = @valid.dup
    duplicate.titulo = "Another titulo"
    assert_not duplicate.valid?
    assert duplicate.errors[:permalink].any?
  end
end
