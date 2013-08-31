require 'couchmusic/data/library'

describe Couchmusic::Data::Library do
  let(:host) { 'mercury' }
  let(:config_json) { { libraries: {
    'main' => '/Users/johnsmith/Music',
    'external' => '/Volumes/KINGSTON',
    'xmas' => '/Volumes/KINGSTON/Christmas'
  } } }
  let(:config) { double(:config, hostname: host, json: config_json) }
  subject { Couchmusic::Data::Library.new(config) }

  it 'should match a file in the library' do
    subject.gather(host, '/Users/johnsmith/Music/01.mp3').should ==
      { library: 'main', library_path: '/01.mp3' }
  end

  it 'should not match a file on a different host' do
    subject.gather('venus', '/Users/johnsmith/Music/01.mp3').should == { }
  end

  it 'should not match a file outside the library folder' do
    subject.gather(host, '/tmp/01.mp3').should == { }
  end

  it 'should match a file in a second library' do
    subject.gather(host, '/Volumes/KINGSTON/Sasha/ABC.mp3').should ==
      { library: 'external', library_path: '/Sasha/ABC.mp3' }
  end

  it 'should match a file in a library within another library' do
    subject.gather(host, '/Volumes/KINGSTON/Christmas/Jolly.mp3').should ==
      { library: 'xmas', library_path: '/Jolly.mp3' }
  end

  context 'when the libraries withing other libraries are listed first' do
    let(:config_json) { { libraries: {
      'xmas' => '/Volumes/KINGSTON/Christmas',
      'external' => '/Volumes/KINGSTON'
    } } }

    it 'should match a file in a library within another library' do
      subject.gather(host, '/Volumes/KINGSTON/Christmas/Jolly.mp3').should ==
        { library: 'xmas', library_path: '/Jolly.mp3' }
    end
  end

  context 'with no configured libraries' do
    let(:config_json) { { } }
  end
end