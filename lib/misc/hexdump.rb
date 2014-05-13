# hexdump.rb
# Copyright (C) 2010..2013 Carsten Bormann <cabo@tzi.org>

class String
  def hexdump(prefix = '', out = STDOUT)
    i = 0
    while i < length
      slice = byteslice(i, 16)
      out.puts '%s%-48s |%-16s|' %
        [prefix,
         slice.bytes.map { |b| '%02x' % b.ord }.join(' '),
         slice.gsub(/[^ -~]/mn, '.')]
      i += 16
    end
    out
  end
end
