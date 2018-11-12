class FilesController < ApplicationController
  include Pagy::Backend

  def index
    tag_search_query = params.fetch(:tag_search_query)
 
    FileTag.filter_by_tags(tag_search_query).tap do |filetag|

      _, records = pagy(filetag, page: params.fetch(:page), items: 10)

      exclude_tags = tag_search_query.gsub(/\+|\-/, '').split

      render json: {
        total_records: filetag.size,
        related_tags: records.related_tags(exclude_tags: exclude_tags),
        records: records.select(:uuid, :tags)
      }
    end
  end

  def create
    filetag = FileTag.create(file_params)

    if filetag.valid?
      render json: { uuid: filetag.uuid }, status: :ok
    else
      render json: { error: filetag.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def file_params
    params.permit(:name, tags: [])
  end
end
