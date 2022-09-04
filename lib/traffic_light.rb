# frozen_string_literal: true

require 'aasm'

# class TrafficLight
class TrafficLight
  include AASM

  aasm do
    state :turned_off, initial: true
    state :turned_on, :broken
    state :red, :green
    state :yellow, before_enter: :keep_before_color_state

    event :switch_on do # , binding_event: :start do
      transitions from: :turned_off, to: :turned_on
    end

    event :break_down do
      transitions from: %i[turned_off turned_on red yellow green], to: :broken
    end

    event :stop do
      transitions from: :turned_on, to: :red
      transitions from: :yellow, to: :red, guard: :red_before?
      transitions from: :green, to: :yellow
    end

    event :ready do
      transitions from: :red, to: :yellow
      transitions from: :green, to: :yellow
    end

    event :go do
      transitions from: :yellow, to: :green, guard: :green_before?
    end

    event :switch_off do
      transitions from: %i[turned_on red yellow geen], to: :turned_off
    end
  end

  def green_before?
    return false if @before_yellow_color == :green

    true
  end

  def red_before?
    return false if @before_yellow_color == :red

    true
  end

  def keep_before_color_state
    @before_yellow_color = aasm.current_state
  end

  def classic_work
    %i[stop ready go ready]
  end
end
