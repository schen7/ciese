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

        topics.each do |topic|
          expect(page).to have_link(topic.name, href: topic_path(topic))
          expect(page).to have_link('Edit', href: edit_topic_path(topic))
        end
      end
    end
  end

  describe "show topic page" do
    let(:topic) { create(:topic) }
    let(:path) { topic_path(topic) }

    let!(:post1) { create(:post, topic_id: topic.id) }
    let!(:post2) { create(:post, topic_id: topic.id) }

    it_behaves_like "a page that requires an active admin user"

    context "when visited by an admin user" do
      let(:admin) { create(:admin) }
      before { log_in_and_visit(admin, path) }

      it "should have topic name and an edit link" do
        expect(page).to have_title(full_title('Topic Info'))
        expect(page).to have_selector('h1', 'Topic Info')
        expect(page).to have_content(topic.name)
        expect(page.all('table tr').count).to eq 3
        
        expect(page).to have_link(post1.title, href: post_path(post1))
        expect(page).to have_link(post2.title, href: post_path(post2))
      end
    end
  end
  
end
