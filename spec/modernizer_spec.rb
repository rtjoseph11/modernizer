require 'rspec'

$: << File.dirname(__FILE__) + '/../lib'

require 'modernizer'

describe 'Modernize' do
  context 'add a field' do
    before do
      @m = Modernize::Modernizer.new do
        version { @env['version'] }
        
        modernize '0.0.1' do
          add('foo'){ 'bar' }
        end
      end
    end

    it 'should add foo to the body' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {})
      result.should == {'foo' => 'bar'}
    end
  end

  context 'remove a field' do
    before do
      @m = Modernize::Modernizer.new do
        version { @env['version'] }
        
        modernize '0.0.1' do
          remove 'foo'
        end
      end
    end

    it "should remove foo from the body" do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'bar', 'fizz' => 'buzz'})
      result.should == {'fizz' => 'buzz'}
    end
  end

  context 'compute a field' do
    before do
      @m = Modernize::Modernizer.new do
        version { @env['version'] }
        
        modernize '0.0.1' do
          compute('retina') do |value|
            if @hash['device-type'] == 'android'
              false
            else
              case value
              when 1 then true
              when 0 then false
              else false
              end
            end
          end
        end
      end
    end

    it "should set retina to false for android" do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'bar', 'device-type' => 'android'})
      result.should == {'foo' => 'bar', 'device-type' => 'android', 'retina' => false}
    end

    it "should convert numbers to booleans" do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'bar', 'device-type' => 'iOS', 'retina' => 1})
      result.should == {'foo' => 'bar', 'device-type' => 'iOS', 'retina' => true}
    end
  end

  context 'first methods' do
    before do
      @m = Modernize::Modernizer.new do
        version { @env['version'] }
        
        first do
          add('foo'){'bar'}

          compute('fizz'){|value| "thing-#{value}"}
        end

        modernize '0.0.1' do
          remove 'foo'
        end
      end
    end

    it "should remove foo from the body" do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'baz' => 'thing', 'fizz' => 'buzz'})
      result.should == {'baz' => 'thing', 'fizz' => 'thing-buzz'}
    end
  end

  context 'last methods' do
    before do
      @m = Modernize::Modernizer.new do
        version { @env['version'] }

        modernize '0.0.1' do
          remove 'foo'
        end

        last do
          add('foo'){'bar'}

          compute('fizz'){|value| "thing-#{value}"}
        end
      end
    end

    it "should remove foo from the body" do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'thing', 'fizz' => 'buzz'})
      result.should == {'foo' => 'bar', 'fizz' => 'thing-buzz'}
    end
  end

  context 'version sorting' do
    before do
      @m = Modernize::Modernizer.new do
        modernize '0.0.2' do
          add('foo'){'bar'}

          compute('fizz'){|value| "thing-#{value}"}
        end

        modernize '0.0.1' do
          remove 'foo'
        end

        version { @env['version'] }
      end
    end

    it "should remove foo from the body" do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'thing', 'fizz' => 'buzz'})
      result.should == {'foo' => 'bar', 'fizz' => 'thing-buzz'}
    end
  end
end