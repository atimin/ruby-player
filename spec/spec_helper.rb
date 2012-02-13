require 'ruby-player'

def mock_client
  client = mock("Client")
  client.stub!(:write)
  client.stub!(:log_level).and_return :debug
  client
end

def mock_sending_message(device)
  define_singleton_method(:should_send_message) do |*args|
    device.should_receive(:send_message)
      .with(*args)
  end
end
