json.array!(@offices) do |office|
  json.extract! office, :id, :name, :age, :email
  json.url office_url(office, format: :json)
end
