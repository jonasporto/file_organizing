class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_save :generate_uuid, if: :sqlite_adapter?

  private

  def sqlite_adapter?
  	ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::SQLite3Adapter
  end

  # just because sqlite doesn't support uuid
  def generate_uuid
    self.uuid= SecureRandom.uuid unless uuid
  end
end
