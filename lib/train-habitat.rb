# frozen_string_literal: true

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require_relative "train-habitat/version"
require_relative "train-habitat/transport"
require_relative "train-habitat/platform"
require_relative "train-habitat/connection"
