class Object

  def ax()
    'ax'
  end

  def bx()
    'bx'
  end

  def cx()
    'cx'
  end

  def dx()
    'dx'
  end

end
module Jumps

  def jmp(label)
    if(labels_lookup_table[label] == nil)
      @@operations_log.each(&:eval)
    else
      @@operations_log.each(&:eval)
    end
  end

  def je(label)
  end

  def jne(label)
  end

  def jl(label)
  end

  def jle(label)
  end

  def jg(label)
  end

  def jge(label)
  end

end
module Asm

  include Jumps

  def Asm.asm(&block)
    @@registers = {'ax' => 0, 'bx' => 0, 'cx' => 0, 'dx' => 0}
    @@flag = 0
    @@operations_log = []
    @@labels_lookup_table = {}
    block.call
    @@registers.values
  end

  def mov(destination_register, source)
    if (@@registers[source] == nil)
      @@registers[destination_register] = source
    else
      @@registers[destination_register] = @@registers[source]
    end
    @@operations_log << "mov #{destination_register}, #{source}"
  end

  def inc(destination_register, source = 1)
    if (@@registers[source] == nil)
      @@registers[destination_register] += source
    else
      @@registers[destination_register] += @@registers[source]
    end
    @@operations_log << "inc #{destination_register}, #{source}"
  end

  def dec(destination_register, source = 1)
    if (@@registers[source] == nil)
      @@registers[destination_register] -= source
    else
      @@registers[destination_register] -= @@registers[source]
    end
    @@operations_log << "dec #{destination_register}, #{source}"
  end

  def cmp(destination_register, source)
    if (@@registers[source] == nil)
      @@flag = (@@registers[destination_register] <=> source)
    else
      @@flag = (@@registers[destination_register] <=> @@registers[source])
    end
    @@operations_log << "cmp #{destination_register}, #{source}"
  end

  def label(label)
    @@labels_lookup_table[label] = @@operations_log.size
  end

end