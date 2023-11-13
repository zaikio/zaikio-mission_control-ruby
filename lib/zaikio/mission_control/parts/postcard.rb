module Zaikio
  module MissionControl
    module Parts
      class Postcard < Base
        @worksteps = {
          ctp: { required: false },
          printing: { required: false },
          cutting: { required: false }
        }
      end
    end
  end
end