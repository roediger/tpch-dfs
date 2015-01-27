require_relative 'benchmark'

class HiveBenchmark < Benchmark
  
  def prepare(q) 
    File.open('no_query.sql', 'w') {|f| f.write(';') }
    
    @startup_time = ((self.benchmark 3 do 
      self.cmd "sudo -u hive hive --database tpch_orc -f no_query.sql"
    end).map{|o,t| t}.median)
    
    print "Startup Time Q #{q}: #{@startup_time}s"
    
    `rm no_query.sql`
  end
  
  def perform_run(q)
    return nil if not File.exist? self.query_file(q)
    
    out = nil
    o, t = (self.benchmark 1 do 
      out = self.cmd "sudo -u hive hive --database tpch_orc -f #{self.query_file(q)}"
    end)
    
    match = out.match(/OK\nTime taken: (\d+(?:\.\d+){0,1}) seconds$/)
    if match
      return t - @startup_time
    end
    return nil
  end
  
  def after_run(q)
    # TODO Transform output file
  end
end