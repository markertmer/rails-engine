class RevenueSerializer
  # include JSONAPI::Serializer
  # attributes :revenue
  def self.format_data(data)
    x = {
      "data":
      {
        "id": null
        "attributes": {
          "revenue": data.revenue
        }
      }
    }.to_json
  end
end
