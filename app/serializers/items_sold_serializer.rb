class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name
  attributes :count do |object|
    object.total_sold
  end
end
