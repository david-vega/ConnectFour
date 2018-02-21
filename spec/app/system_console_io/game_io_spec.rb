require 'spec_helper'

describe SystemConsoleIO::GameIO do
  let(:game){ described_class.new }

  describe '#initialize' do
    let(:matrix){ Array.new(6){ Array.new(5) } }

    subject{ game }

    it{ expect(subject.instance_variable_get(:@current_color)).to eq 'red' }
    it{ expect(subject.instance_variable_get(:@board).class).to eq Board }
    it{ expect(subject.instance_variable_get(:@board).matrix).to eq matrix }
  end

  describe '#run' do
    let(:game_header){ "\e[32m 1\t2\t3\t4\t5\t6\n\e[0m" }
    let(:empty_row){ " \e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\n" }
    let(:red_turn){ "\n \e[1m\e[31mred\e[0m\e[21m turn, please input column number" }
    let(:blue_turn){ "\n \e[1m\e[34mblue\e[0m\e[21m turn, please input column number" }
    let(:red_row){ " \e[1m\e[31m@\e[0m\e[21m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\n" }
    let(:blue_row){ " \e[37mO\e[0m\t\e[1m\e[34m@\e[0m\e[21m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\n" }
    let(:red_and_blue_row){ " \e[1m\e[31m@\e[0m\e[21m\t\e[1m\e[34m@\e[0m\e[21m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\n" }
    let(:red_blue_and_red_row){ " \e[1m\e[31m@\e[0m\e[21m\t\e[1m\e[34m@\e[0m\e[21m\t\e[1m\e[31m@\e[0m\e[21m\t\e[37mO\e[0m\t\e[37mO\e[0m\t\e[37mO\e[0m\n" }
    let(:red_wins){ "\n\t\e[1m\e[31mred\e[0m\e[21m Wins !!" }
    let(:blue_wins){ "\n\t\e[1m\e[34mblue\e[0m\e[21m Wins !!" }

    context 'reds win in a column' do
      subject{ game.run }

      before{ allow(STDIN).to receive(:gets).and_return('1','2','1','2','1','2','1') }

      it 'shows the red wins' do
        expect(STDOUT).to receive(:puts).with(game_header).exactly(8).times
        expect(STDOUT).to receive(:puts).with(empty_row).exactly(24).times
        expect(STDOUT).to receive(:puts).with(red_turn).exactly(4).times
        expect(STDOUT).to receive(:puts).with(red_row).exactly(4).times
        expect(STDOUT).to receive(:puts).with(blue_turn).exactly(3).times
        expect(STDOUT).to receive(:puts).with(red_and_blue_row).exactly(12).times
        expect(STDOUT).to receive(:puts).with(red_wins).once
        subject
      end
    end

    context 'blue win in a column' do
      subject{ game.run }

      before{ allow(STDIN).to receive(:gets).and_return('1','2','1','2','1','2','3','2') }

      it 'shows the blue wins' do
        expect(STDOUT).to receive(:puts).with(game_header).exactly(9).times
        expect(STDOUT).to receive(:puts).with(empty_row).exactly(26).times
        expect(STDOUT).to receive(:puts).with(red_turn).exactly(4).times
        expect(STDOUT).to receive(:puts).with(red_row).exactly(3).times
        expect(STDOUT).to receive(:puts).with(blue_turn).exactly(4).times
        expect(STDOUT).to receive(:puts).with(red_and_blue_row).exactly(13).times
        expect(STDOUT).to receive(:puts).with(red_blue_and_red_row).exactly(2).times
        expect(STDOUT).to receive(:puts).with(blue_row).once
        expect(STDOUT).to receive(:puts).with(blue_wins).once
        subject
      end
    end
  end
end
