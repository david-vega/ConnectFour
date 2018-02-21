require 'spec_helper'

describe Board do
  `let(:matrix){ Array.new(6){ Array.new(5) } }`
  let(:board){ described_class.new }
  let(:color){ 'red' }
  let(:matrix){ Array.new(6){ Array.new(5) } }

  describe '#initialize' do
    subject{ board }

    it{ expect(subject.matrix).to eq matrix }
  end

  describe '#add_chip' do
    let(:column_number){ 1 }
    let(:column_result){ [nil, nil, nil, nil, color] }

    before{ matrix[column_number] = column_result }

    subject{ board.add_chip(color: color, column_number: column_number) }

    context 'when the selected column is empty' do
      it{ is_expected.to eq color }
      it{ subject; expect(board.matrix).to eq matrix }
    end

    context 'when has values in the column' do
      let(:colors){ %w[gray blue green] }
      let(:column_result){ [nil, color, colors.reverse].flatten }

      before{ colors.each{ |color| board.add_chip(color: color, column_number: column_number) } }

      it{ is_expected.to eq color }
      it{ subject; expect(board.matrix).to eq matrix }
    end

    context 'when the column is full' do
      let(:colors){ %w[gray blue green yellow black] }
      let(:column_result){ colors.reverse }

      before{ colors.each{ |color| board.add_chip(color: color, column_number: column_number) } }

      it{ is_expected.to be_falsey }
      it{ subject; expect(board.matrix).to eq matrix }
      it{ subject; expect(board.matrix[column_number]).not_to include(color) }
    end
  end

  describe 'line?' do
    subject{ board.line?(color: color) }

    before{ board.instance_variable_set(:@matrix, matrix) }

    context 'when there is no line' do
      context 'when is new' do
        it{ is_expected.to be_falsey }
      end

      context 'when has 2 values in a contiguous' do
        let(:matrix) do
          matrix = Array.new(6){ Array.new(5) }
          matrix[0][4] = 'red'
          matrix[1][4] = 'red'
          matrix[3][4] = 'blue'
          matrix
        end

        it{ is_expected.to be_falsey }
      end
    end

    context 'when there is a line' do
      context 'when is horizontally' do
        let(:matrix){ Array.new(6){ Array.new(5){ |index| index == 2 ? color : 'blue' } } }

        it{ is_expected.to be_truthy }
      end

      context 'when is vertically' do
        let(:matrix){ Array.new(6){ |index| Array.new(5){ index == 2 ? color : 'blue' } } }

        it{ is_expected.to be_truthy }
      end

      context 'when is diagonally' do
        context 'the diagonal is bottom to top' do
          let(:matrix){ Array.new(6){ |i| Array.new(5){ |k| i == k ? color : 'blue' } }.reverse }

          it{ is_expected.to be_truthy }
        end

        context 'the diagonal is top to bottom' do
          let(:matrix){ Array.new(6){ |i| Array.new(5){ |k| i == k ? color : 'blue' } } }

          it{ is_expected.to be_truthy }
        end
      end
    end
  end

  describe 'full?' do
    subject{ board.full? }

    before{ board.instance_variable_set(:@matrix, matrix) }

    context 'when has some nil values' do
      it{ is_expected.to be_falsey }
    end

    context 'when has no more nil values' do
      let(:matrix){ Array.new(6){ Array.new(5){ color } } }

      it{ is_expected.to be_truthy }
    end
  end
end
