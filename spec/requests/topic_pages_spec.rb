require 'spec_helper'

describe "TopicPages" do

  subject { page }

  describe "list topics page" do
    let(:path) { topics_path }

    it_behaves_like "a page that requires an active admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }

      it "should list all the topics and have an appropriate header and title" do
        topics = create_list(:topic, 2)
        log_in_and_visit(admin, path)
        expect(page).to have_title(full_title('Topics'))
        expect(page).to have_selector('h1', 'Topics')
        expect(page).to have_selector('table#topics')
        expect(page.all('table tr').count).to eq 3
        #expect(page).to have_content(topic.board_id)

        topics.each do |topic|
          expect(page).to have_content(topic.name)
          expect(page).to have_link('Edit', href: topic_path(topic.id))
        end
      end
    end

  end  
end
