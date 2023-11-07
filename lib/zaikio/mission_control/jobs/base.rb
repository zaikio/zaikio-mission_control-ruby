module Zaikio
  module MissionControl
    module Jobs
      class Base < Zaikio::MissionControl::Base
        class << self
          def has_one_part(name, required: false) # rubocop:disable Naming/PredicateName
            @parts ||= {}
            @parts[name] = { required: required, multiples: false }
          end

          def has_many_parts(name, required: false) # rubocop:disable Naming/PredicateName
            @parts ||= {}
            @parts[name.to_s.singularize.to_sym] = { required: required, multiples: true }
          end

          def parts
            @parts ||= {}
            @parts.keys
          end

          def worksteps
            steps ||= {}

            @parts.keys.flat_map do |part|
              steps[part] = Zaikio::MissionControl::Parts.const_get(part.to_s.classify).worksteps
            end

            steps
          end

          def finishings
            finishings ||= {}

            @parts.keys.flat_map do |part|
              finishings[part] = Zaikio::MissionControl::Parts.const_get(part.to_s.classify).finishings
            end

            finishings
          end

          def part_config(part_name_or_klass)
            @parts ||= {}
            part_name_or_klass = if part_name_or_klass.is_a?(Symbol)
                                   part_name_or_klass.to_s.singularize.to_sym
                                 else
                                   part_name_or_klass.name.split("::").last.underscore.to_sym
                                 end
            @parts[part_name_or_klass] or raise ArgumentError,
                                                "Part #{part_name_or_klass} could not be found in #{self.class.name}"
          end

          def part_klasses
            parts.map do |name|
              Zaikio::MissionControl::Parts.const_get(name.to_s.classify)
            end
          end

          def multiples?(part_name_or_klass)
            part_config(part_name_or_klass)[:multiples]
          end

          def required?(part_name_or_klass)
            part_config(part_name_or_klass)[:required]
          end
        end
      end
    end
  end
end
