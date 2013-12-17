require 'spec_helper'

describe "BoardPages" do
  
  subject { page }

  describe "list boards page" do
    let(:path) { discussion_boards_path }

    it_behaves_like "a page that requires an active admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }

      it "should list all the boards and have an appropriate header and title" do
        boards = create_list(:board, 2)
        log_in_and_visit(admin, path)
        expect(page).to have_title(full_title('Boards'))
        expect(page).to have_selector('h1', 'Boards')
        expect(page).to have_selector('table#boards')
        expect(page.all('table tr').count).to eq 3
        boards.each do |board|
          expect(page).to have_link(board.name, href: discussion_board_path(board.id))
          expect(page).to have_link('Edit', href: discussion_edit_board_path(board.id))
        end
      end
    end

  end

  describe "show board page" do
    let(:board) { create(:board) }
    let(:path) { board_path(board) }

    let!(:topic1) { create(:topic, board_id: board.id) }
    let!(:topic2) { create(:topic, board_id: board.id) }

    it_behaves_like "a page that requires an active admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }
      before { log_in_and_visit(admin, path) }

      it "should have board name and an edit link" do
        expect(page).to have_title(full_title('Board Info'))
        expect(page).to have_selector('h1', 'Board Info')
        expect(page).to have_content(board.name)
        expect(page.all('table tr').count).to eq 3

        expect(page).to have_link(topic1.name, href: discussion_topic_path(topic1))
        expect(page).to have_link(topic2.name, href: discussion_topic_path(topic2))
      end
    end
  end

end
