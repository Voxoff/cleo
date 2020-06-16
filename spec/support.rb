# frozen_string_literal: true

def silence_output
  @original_stdout = $stdout
  $stdout = File.open(File::NULL, 'w')
end

def capture_stdout
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
