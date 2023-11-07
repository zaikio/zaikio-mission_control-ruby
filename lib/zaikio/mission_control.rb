require "faraday"
require "spyke"
require "zaikio-client-helpers"
require "zaikio/mission_control/configuration"

# Jobs
require "zaikio/mission_control/base"
require "zaikio/mission_control/jobs/base"
require "zaikio/mission_control/jobs/booklet"
require "zaikio/mission_control/jobs/carton"
require "zaikio/mission_control/jobs/carton_two_piece"
require "zaikio/mission_control/jobs/brochure"
require "zaikio/mission_control/jobs/business_card"
require "zaikio/mission_control/jobs/box"
require "zaikio/mission_control/jobs/compliment_slip"
require "zaikio/mission_control/jobs/continuation_sheet"
require "zaikio/mission_control/jobs/cover_letter"
require "zaikio/mission_control/jobs/envelope"
require "zaikio/mission_control/jobs/flyer"
require "zaikio/mission_control/jobs/hardcover_book"
require "zaikio/mission_control/jobs/label"
require "zaikio/mission_control/jobs/leaflet"
require "zaikio/mission_control/jobs/letter_head"
require "zaikio/mission_control/jobs/magazine"
require "zaikio/mission_control/jobs/map"
require "zaikio/mission_control/jobs/ncr_pad"
require "zaikio/mission_control/jobs/newspaper"
require "zaikio/mission_control/jobs/notebook"
require "zaikio/mission_control/jobs/postcard"
require "zaikio/mission_control/jobs/poster"
require "zaikio/mission_control/jobs/self_mailer"
require "zaikio/mission_control/jobs/sheet"
require "zaikio/mission_control/jobs/softcover_book"

# Parts
require "zaikio/mission_control/parts/base"
require "zaikio/mission_control/parts/content"
require "zaikio/mission_control/parts/cover"
require "zaikio/mission_control/parts/insert"
require "zaikio/mission_control/parts/outsert"
require "zaikio/mission_control/parts/carton"
require "zaikio/mission_control/parts/lid"
require "zaikio/mission_control/parts/business_card"
require "zaikio/mission_control/parts/compliment_slip"
require "zaikio/mission_control/parts/continuation_sheet"
require "zaikio/mission_control/parts/cover_letter"
require "zaikio/mission_control/parts/envelope"
require "zaikio/mission_control/parts/flyer"
require "zaikio/mission_control/parts/case"
require "zaikio/mission_control/parts/endpaper"
require "zaikio/mission_control/parts/jacket"
require "zaikio/mission_control/parts/label"
require "zaikio/mission_control/parts/leaflet"
require "zaikio/mission_control/parts/letter_head"
require "zaikio/mission_control/parts/map_sheet"
require "zaikio/mission_control/parts/back"
require "zaikio/mission_control/parts/postcard"
require "zaikio/mission_control/parts/poster"
require "zaikio/mission_control/parts/self_mailer"
require "zaikio/mission_control/parts/sheet"

# Finishings
require "zaikio/mission_control/finishings/base"
require "zaikio/mission_control/finishings/comb_binding"
require "zaikio/mission_control/finishings/embossing"
require "zaikio/mission_control/finishings/foil_stamp"
require "zaikio/mission_control/finishings/glue"
require "zaikio/mission_control/finishings/head_band"
require "zaikio/mission_control/finishings/hole"
require "zaikio/mission_control/finishings/lamination"
require "zaikio/mission_control/finishings/perforation"
require "zaikio/mission_control/finishings/ring_binding"
require "zaikio/mission_control/finishings/perfect_binding"
require "zaikio/mission_control/finishings/saddle_stitch"
require "zaikio/mission_control/finishings/spiral_binding"
require "zaikio/mission_control/finishings/strip_binding"
require "zaikio/mission_control/finishings/thread_sewing"

# Worksteps
require "zaikio/mission_control/worksteps/base"
require "zaikio/mission_control/worksteps/ctp"
require "zaikio/mission_control/worksteps/printing"
require "zaikio/mission_control/worksteps/cutting"
require "zaikio/mission_control/worksteps/folding"
require "zaikio/mission_control/worksteps/thread_sewing"
require "zaikio/mission_control/worksteps/lamination"

# Intermediate products
require "zaikio/mission_control/intermediate_product/base"
require "zaikio/mission_control/intermediate_product/plate"
require "zaikio/mission_control/intermediate_product/sheet"
require "zaikio/mission_control/intermediate_product/fold"
require "zaikio/mission_control/intermediate_product/product"
require "zaikio/mission_control/intermediate_product/book_block"
require "zaikio/mission_control/intermediate_product/laminated_sheet"

# Models
require "zaikio/mission_control/job"
require "zaikio/mission_control/part"
require "zaikio/mission_control/color"
require "zaikio/mission_control/contact"
require "zaikio/mission_control/customer"
require "zaikio/mission_control/desired_substrate"
require "zaikio/mission_control/execution"
require "zaikio/mission_control/finishing_application"
require "zaikio/mission_control/finishing"
require "zaikio/mission_control/file_reference"
require "zaikio/mission_control/machine"
require "zaikio/mission_control/order"
require "zaikio/mission_control/order_line_item"
require "zaikio/mission_control/shipping_option"
require "zaikio/mission_control/slot"
require "zaikio/mission_control/production_frame"

module Zaikio
  module MissionControl
    class << self
      attr_accessor :configuration

      class_attribute :connection

      def configure
        self.connection = nil
        self.configuration ||= Configuration.new
        yield(configuration)

        Base.connection = create_connection
        I18n.load_path += Dir["#{File.expand_path('../../config/locales', __dir__)}/*.yml"]
      end

      def with_token(token, &block)
        Zaikio::Client.with_token(token, &block)
      end

      def create_connection
        self.connection = Zaikio::Client.create_connection(configuration)
      end

      def job_klasses
        @job_klasses ||= Zaikio::MissionControl::Jobs
                         .constants.sort
                         .map { |c| Zaikio::MissionControl::Jobs.const_get(c) }
                         .select { |c| c.is_a?(Class) } - [Zaikio::MissionControl::Jobs::Base]
      end

      def part_klasses
        @part_klasses ||= Zaikio::MissionControl::Parts.constants.sort
                                                       .map { |c| Zaikio::MissionControl::Parts.const_get(c) }
                                                       .select { |c| c.is_a?(Class) }
      end

      def finishing_klasses
        @finishing_klasses ||= Zaikio::MissionControl::Finishings
                               .constants.sort
                               .map { |c| Zaikio::MissionControl::Finishings.const_get(c) }
                               .select { |c| c.is_a?(Class) } - [Zaikio::MissionControl::Finishings::Base]
      end

      def workstep_klasses
        @workstep_klasses ||= Zaikio::MissionControl::Worksteps
                              .constants.sort
                              .map { |c| Zaikio::MissionControl::Worksteps.const_get(c) }
                              .select { |c| c.is_a?(Class) } - [Zaikio::MissionControl::Worksteps::Base]
      end

      def jobs
        @jobs ||= job_klasses.map { |k| k.name.demodulize.underscore.to_sym }
      end

      def parts
        @parts ||= part_klasses.map { |k| k.name.demodulize.underscore.to_sym }
      end

      def finishings
        @finishings ||= finishing_klasses.map { |k| k.name.demodulize.underscore.to_sym }
      end

      def worksteps
        @worksteps ||= workstep_klasses.map { |k| k.name.demodulize.underscore.to_sym }
      end

      (Zaikio::MissionControl::Jobs.constants  - [:Base]).each do |klass|
        Zaikio.const_set(klass, Zaikio::MissionControl::Jobs.const_get(klass))
      end
    end
  end
end
