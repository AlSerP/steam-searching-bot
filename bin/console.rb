#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require_relative '../config/config'

class ConsoleBotMock
  def initialize(logger)
    @logger = logger
  end

  attr_reader :logger
end

$bot = ConsoleBotMock.new(Logger.new(Bot::Config::MAIN_LOGS))

require 'irb'
IRB.start(__FILE__)
