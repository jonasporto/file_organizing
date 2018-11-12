module QueryFilter
  module SQL
    extend ActiveSupport::Concern

    class_methods do
      def has_filter_column(column)
        @@_filter_column = column
        
        class << self
          # generate filter_by_column class method
          define_method :"filter_by_#{@@_filter_column}" do |search_query|
            query_builder = QueryBuilder.new(@@_filter_column, search_query)
            where(query_builder.to_sql)
          end
        end
      end      
    end
  
    class QueryBuilder
      class InvalidOperatorError < StandardError; end

      attr_reader :search_query, :filter_column

      INCLUDE_FILTER_OPERATOR = '+'
      EXCLUDE_FILTER_OPERATOR = '-'

      def initialize(filter_column, search_query = '')
        @search_query = search_query
        @filter_column = filter_column
      end

      def to_sql
        [build_sql, *query_values]
      end

      private

      def build_sql
        grouped_terms.map do |operator, terms|
          terms
            .map{ |term| fetch_query_by_operator(operator) }
            .join(' AND ')
        end.join(' AND ')
      end

      def query_values
        grouped_terms.values.flatten.map{|term| "%#{term}%" }
      end

      # transforms "+term1 -term2" in { "+" => ["term1"], "-" => ["term2"] }
      def grouped_terms
        @@_grouped_terms ||= search_query.split.inject({}) do |acc, term|
          (acc[term[0]] ||= []) << term[1..-1]
          acc
        end
      end

      def fetch_query_by_operator(operator)
        case operator
        when INCLUDE_FILTER_OPERATOR
          include_query
        when EXCLUDE_FILTER_OPERATOR
          exclude_query
        else
          raise InvalidOperatorError, "operator #{operator} is not allowed."
        end
      end

      def include_query
        "#{filter_column} LIKE ?"
      end

      def exclude_query
        "#{filter_column} NOT LIKE ?"
      end
    end
  end
end
