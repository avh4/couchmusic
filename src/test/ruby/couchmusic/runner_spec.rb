require 'couchmusic/runner'

describe Couchmusic::Runner do
  let(:db) { double(:db) }
  let(:config) { double(:config) }
  let(:visitor) { double(:visitor) }
  let(:datas) { [
    double(:data1, gather: { data1: 'YES' }),
    double(:data2, gather: { data2: 'NO' })
  ] }
  subject { Couchmusic::Runner.new(config, visitor, datas) }

  before do
    Couchmusic::Database.stub(:connect).and_return(db)
    visitor.stub(:visit) do |&block|
      @doc1_result = block.call('HOST', 'FILE_1')
    end

    subject.perform()
  end

  it 'should call the visitor' do
    visitor.should have_received(:visit).with(db)
  end

  it 'should collect data for each document' do
    datas[0].should have_received(:gather).with('HOST', 'FILE_1')
  end

  it 'should collect data for each document from all data providers' do
    datas[1].should have_received(:gather).with('HOST', 'FILE_1')
  end

  it 'should combine results from all data providers' do
    @doc1_result.should == { data1: 'YES', data2: 'NO' }
  end
end