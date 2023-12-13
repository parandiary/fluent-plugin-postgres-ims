require 'fluent/plugin/output'
require 'pg'

class Fluent::Plugin::PostgresimsOutput < Fluent::Plugin::Output
  Fluent::Plugin.register_output('postgresims', self)

  helpers :inject, :compat_parameters

  config_param :host, :string
  config_param :port, :integer, :default => nil
  config_param :database, :string
  config_param :username, :string
  config_param :password, :string, :default => ''

  config_param :key_names, :string, :default => nil # nil allowed for json format
  config_param :sql, :string, :default => nil
  config_param :table, :string, :default => nil
  config_param :columns, :string, :default => nil

  config_param :format, :string, :default => "raw" # or json

  attr_accessor :handler

  # We don't currently support mysql's analogous json format
  def configure(conf)
    compat_parameters_convert(conf, :inject)
    super

    if @format == 'json'
      @format_proc = Proc.new{|tag, time, record| record.to_json}
    else
      @key_names = @key_names.split(/\s*,\s*/)
      @format_proc = Proc.new{|tag, time, record| @key_names.map{|k| record[k]}}
    end

    if @columns.nil? and @sql.nil?
      raise Fluent::ConfigError, "columns or sql MUST be specified, but missing"
    end
    if @columns and @sql
      raise Fluent::ConfigError, "both of columns and sql are specified, but specify one of them"
    end
  end

  def start
    super
  end

  def shutdown
    super
  end

  def format(tag, time, record)
    record = inject_values_to_record(tag, time, record)
    [tag, time, @format_proc.call(tag, time, record)].to_msgpack
  end

  def multi_workers_ready?
    true
  end

  def formatted_to_msgpack_binary?
    true
  end

  def client
    PG::Connection.new({
      :host => @host, 
      :port => @port,
      :user => @username, :password => @password,
      :dbname => @database,
      # :options => "-c readOnlyMode=ignore" # Set readOnly to true
      :options => "-c readOnly=true" # Set readOnly to true
    })
  end

  def write(chunk)
    handler = self.client
    handler.prepare("write", @sql)
    chunk.msgpack_each { |tag, time, data|
      handler.exec_prepared("write", data)
    }
    handler.close
  end
end
