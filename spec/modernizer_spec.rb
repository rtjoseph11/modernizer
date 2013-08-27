require 'rspec'

$: << File.dirname(__FILE__) + '/../lib'

require 'modernizer'

describe 'Modernize' do
  context 'add a field' do
    before do
      @m = Modernize::Modernizer.new do
        request_version {|env| env['version'] }
        
        modernize '0.0.1' do
          add(:foo){ 'bar' }
        end
      end
    end

    it 'should add foo to the body' do
      result = @m.translate({'version' => '0.0.1'}, {})
      result.should == {'foo' => 'bar'}
    end
  end

  context 'remove a field' do
    before do
      @m = Modernize::Modernizer.new do
        request_version {|env| env['version'] }
        
        modernize '0.0.1' do
          remove :foo
        end
      end
    end

    it "should remove foo from the body" do
      result = @m.translate({'version' => '0.0.1'}, {foo: 'bar', 'fizz' => 'buzz'})
      result.should == {'fizz' => 'buzz'}
    end
  end

  context 'compute a field' do
    before do
      @m = Modernize::Modernizer.new do
        request_version {|env| env['version'] }
        
        modernize '0.0.1' do
          compute(:retina) do |env, body|
            if body['device-type'] == 'android'
              false
            else
              case body['retina']
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
      result = @m.translate({'version' => '0.0.1'}, {foo: 'bar', 'device-type' => 'android'})
      result.should == {:foo => 'bar', 'device-type' => 'android', 'retina' => false}
    end

    it "should convert numbers to booleans" do
      result = @m.translate({'version' => '0.0.1'}, {foo: 'bar', 'device-type' => 'iOS', 'retina' => 1})
      result.should == {:foo => 'bar', 'device-type' => 'iOS', 'retina' => true}
    end
  end
end