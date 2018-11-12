class FileTag < ApplicationRecord
  include QueryFilter::SQL
  
  serialize :tags, Array
  has_filter_column :tags

  validates :name, :tags, presence: true
  validate :validate_tags

  def self.related_tags(exclude_tags: [])
    pluck(:tags)
      .flatten
      .reduce(Hash.new(0)) do |acc, (tag, _)| 
        acc[tag] += 1 unless exclude_tags.include? tag
        acc
      end
      .map{|tag, file_count| {tag: tag, file_count: file_count}}
  end

  private

  def validate_tags
    if tags.any?{ |tag| tag.match("\\-|\\+|\s+") }
      errors.add(:tags, "Tags can contain any characters except -, +, and whitespace characters")
    end
  end
end
