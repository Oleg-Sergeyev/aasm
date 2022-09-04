# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require_relative 'lib/traffic_light'

Bundler.require(:default)

traffic_light = TrafficLight.new
@times_work = 10
# AASMDiagram::Diagram.new(traffic_light.aasm, 'traffic_light.png')
traffic_light.switch_on
while traffic_light.aasm.current_state != :turned_off
  traffic_light.classic_work.each do |event|
    sleep 1
    puts `clear`
    traffic_light.send(event.to_s)
    puts "#{@times_work} state: #{traffic_light.aasm.current_state}, event: #{event}"
    @times_work -= 1
    next unless @times_work.zero?

    traffic_light.switch_off
    sleep 1
    puts `clear`
    puts "TRAFFIC LIGHT state: #{traffic_light.aasm.current_state}"
    break
  end
end
