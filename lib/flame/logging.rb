require 'active_record'

module Logging
  class Log < ActiveRecord::Base
    def self.process(values)
      Log.create(values)
    end
  end
end
