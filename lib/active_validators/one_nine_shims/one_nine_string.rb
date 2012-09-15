module ActiveValidators
  module OneNineShims
    class OneNineString < String
      def gsub(pattern, hash)
        super(pattern) do |m|
          hash[m]
        end
      end
    end
  end
end
