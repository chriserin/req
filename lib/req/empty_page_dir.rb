module Req
  class EmptyPageDir < Dir
    class << self
      def create
        @dir = new("empty_page")
      end

      def path
        File.join(home, "empty_page")
      end

      def remove
        @dir.remove if @dir
      end
    end
  end
end
