defimpl Jason.Encoder, for: ExFtx.Market do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:price_increment, :min_provide_size, :name]), opts)
  end
end
