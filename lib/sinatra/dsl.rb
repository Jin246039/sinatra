module Kernel

  %w( get post put delete ).each do |verb|
    eval <<-end_eval
      def #{verb}(path, &block)
        Sinatra::Event.new(:#{verb}, path, &block)
      end
    end_eval
  end
  
  def after_attend(filter_name = nil, &block)
    Sinatra::Event.after_attend(filter_name, &block)
  end
  
  def helpers(&block)
    Sinatra::EventContext.class_eval(&block)
  end

  def static(path, root)
    Sinatra::StaticEvent.new(path, root)
  end
    
  %w(test development production).each do |env|
    module_eval <<-end_eval
      def #{env}
        yield if Sinatra::Options.environment == :#{env}
      end
    end_eval
  end
  
  def layout(name = :layout, options = {})
    Layouts[name] = unless block_given?
      File.read("%s/%s" % [options[:views_directory] || 'views', name])
    else
      yield
    end
  end
  
  def sessions(on_off)
    Sinatra::Session::Cookie.use = on_off
  end
end
