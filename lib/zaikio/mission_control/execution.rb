module Zaikio
  module MissionControl
    class Execution < Base
      include_root_in_json :execution

      attributes :id, :operator_id, :machine_id, :workstep_id, :quantity, :waste, :started_at, :ended_at, :phase,
                 :created_at, :updated_at

      belongs_to :workstep, class_name: "Zaikio::MissionControl::Workstep"
    end
  end
end
