require 'gzr/commands/role/user_add'

RSpec.describe Gzr::Commands::Role::UserAdd do
  it "executes `role user_add` command successfully" do
    require 'sawyer'
    users = (100..105).collect do |i|
      user_doc = {
          :id=>i
      }
      mock_user = double(Sawyer::Resource, user_doc)
      allow(mock_user).to receive(:to_attrs).and_return(user_doc)
      mock_user
    end
    mock_sdk = Object.new
    allow(mock_sdk).to receive(:logout)
    allow(mock_sdk).to receive(:role_users) do |role_id,body|
      users
    end
    allow(mock_sdk).to receive(:set_role_users) do |role_id,body|
      expect(body).to contain_exactly(100, 101, 102, 103, 104, 105, 106)
      nil 
    end
    output = StringIO.new
    options = {}
    command = Gzr::Commands::Role::UserAdd.new(1,[106],options)

    command.instance_variable_set(:@sdk, mock_sdk)

    command.execute(output: output)

    expect(output.string).to eq("")
  end
end
