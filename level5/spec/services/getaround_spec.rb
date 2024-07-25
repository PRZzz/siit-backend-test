require './app/services/getaround'

describe 'Getaround' do
  describe '#run' do
    let(:input_file_path) { 'data/input.json' }
    let(:output_file_path) { 'data/output.json' }

    subject do
      Getaround.new(input_file_path).run(output_file_path)
      JSON.parse(File.read(output_file_path))
    end

    after do
      File.delete(output_file_path) if File.exist?(output_file_path)
    end

    let(:expected_output) { JSON.parse(File.read('data/expected_output.json')) }

    it 'produce the expected output' do
      expect(subject).to eq(expected_output)
    end
  end
end
