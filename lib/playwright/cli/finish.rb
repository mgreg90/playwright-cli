module Playwright
  module Cli
    module Finish
      TYPE_MAP = {
        success: 0,
        failure: 1,
        0 => 0,
        1 => 1
      }
      def finish type
        raise ValidationError.new("Invalid finish type!") unless TYPE_MAP.keys.include?(type)
        exit TYPE_MAP[type]
      end
    end
  end
end