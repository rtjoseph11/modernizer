require File.expand_path('../../lib/modernizer.rb', __FILE__)
require 'minitest/autorun'
require 'mocha/setup'

describe 'Modernize' do
  describe 'add a field' do
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
      expected = {'foo' => 'bar'}
      assert_equal expected, result
    end
  end

  describe 'remove a field' do
    before do
      @m = Modernize::Modernizer.new do
        version { @env['version'] }

        modernize '0.0.1' do
          remove 'foo'
        end
      end
    end

    it 'should remove foo from the body' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'bar', 'fizz' => 'buzz'})
      expected = {'fizz' => 'buzz'}
      assert_equal expected, result
    end
  end

  describe 'compute a field' do
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

    it 'should set retina to false for android' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'bar', 'device-type' => 'android'})
      expected = {'foo' => 'bar', 'device-type' => 'android', 'retina' => false}
      assert_equal expected, result
    end

    it 'should convert numbers to booleans' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'bar', 'device-type' => 'iOS', 'retina' => 1})
      expected = {'foo' => 'bar', 'device-type' => 'iOS', 'retina' => true}
      assert_equal expected, result
    end
  end

  describe 'first methods' do
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

    it 'should remove foo from the body' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'baz' => 'thing', 'fizz' => 'buzz'})
      expected = {'baz' => 'thing', 'fizz' => 'thing-buzz'}
      assert_equal expected, result
    end
  end

  describe 'last methods' do
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

    it 'should remove foo from the body' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'thing', 'fizz' => 'buzz'})
      expected = {'foo' => 'bar', 'fizz' => 'thing-buzz'}
      assert_equal expected, result
    end
  end

  describe 'version sorting' do
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

    it 'should remove foo from the body' do
      result = @m.translate({:env => {'version' => '0.0.1'}}, {'foo' => 'thing', 'fizz' => 'buzz'})
      expected = {'foo' => 'bar', 'fizz' => 'thing-buzz'}
      assert_equal expected, result
    end
  end
end