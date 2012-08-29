class Date
  class << self
    def _parse_with_american(str, comp=true)
      hash = _parse_without_american(str, comp)
      if str=~/\A(\d{1,2})\/(\d{1,2})\/(\d{4})/
        tmp = hash[:mon]
        hash[:mon] = hash[:mday]
        hash[:mday] = tmp
      end
      hash
    end
    alias_method_chain :_parse, :american
  end
end