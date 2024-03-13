module RecordOperations
  extend ActiveSupport::Concern

  module ClassMethods
    def search_objects(objects, searchable_fields, query)
      objects.where(
        searchable_fields.map { |field| "#{self.arel_table.name}.#{field} LIKE :query" }.join(" OR "),
        query: "%#{query}%",
      )
    end

    def load_objects(fields_for_load, page, &additional_query)
      page ||= 1
      page = page.to_i

      query = self.where(user_id: Current.user.id)

      if block_given?
        query = yield(query)
      end

      user_objects = query.select(fields_for_load.join(", "))

      user_objects.limit(OBJECTS_PER_PAGE).offset((page - 1) * OBJECTS_PER_PAGE)
    end
  end
end
