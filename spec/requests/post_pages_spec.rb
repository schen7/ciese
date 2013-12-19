require 'spec_helper'

describe "PostPages" do
  
  subject { page }

  describe "list posts page" do
    let(:path) { posts_path }

    #it_behaves_like "a page that requires a logged-in user"

    context "when visited by an user" do
      let(:user) { create(:user) }

      it "should list all the posts and have an appropriate header and title" do
        posts = create_list(:post, 2)
        log_in_and_visit(user, path)
        #visit(path)
        expect(page).to have_title(full_title('Posts'))
        expect(page).to have_selector('h1', 'Posts')
        expect(page).to have_selector('table#posts')
        expect(page.all('table tr').count).to eq 3

        posts.each do |post|
          expect(page).to have_link(post.title, href: discussion_post_path(post))
          expect(page).to have_link('Edit', href: discussion_edit_post_path(post))
        end
      end
    end
  end

  describe "show post page" do
    let(:user) { create(:user) }

    let(:post) { create(:post) }
    let(:path) { discussion_post_path(post) }

    let!(:comment1) { create(:comment, post_id: post.id) }
    let!(:comment2) { create(:comment, post_id: post.id) }

    context "when visited by an user" do
      before { log_in_and_visit(user, path) }
      #before { visit(path) }

      it "should have post name and an edit link" do
        expect(page).to have_title(full_title('Post Info'))
        expect(page).to have_selector('h1', 'Post Info')
        expect(page).to have_content(post.title)
        expect(page).to have_content(post.content)
        expect(page).to have_link('Edit', discussion_edit_post_path(post))
        expect(page.all('table tr').count).to eq 3
        
        expect(page).to have_content(comment1.content)
        expect(page).to have_link('Edit', discussion_edit_comment_path(comment1))
        expect(page).to have_content(comment2.content)
        expect(page).to have_link('Edit', discussion_edit_comment_path(comment2))
      end
    end
  end

  describe "edit post page" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let(:path) { discussion_edit_post_path(post) }

    #it_behaves_like "a page that requires an active admin user"

    context "when visited by the author" do
      before { log_in_and_visit(user, path) }
      #before { visit(path) }
      
      it "should have title, header, and editing form" do
        expect(page).to have_title(full_title("Edit Post"))
        expect(page).to have_selector('h1', 'Edit Post')
        expect(page).to have_selector('form')
      end

      context "when the form is submitted" do

        context "without any changes" do
          before { click_button "Save" }

          it { should have_selector('.success', text: 'Post updated.') }
        end

        context "with invalid information" do
          before do
            fill_in "Title", with: ''
            click_button "Save"
          end

          it { should have_selector('.alert', text: 'error') }
        end
      
        context "with valid information" do
          before do
            fill_in "Title", with: 'new.title'
            fill_in "Content", with: 'new.content'
            click_button "Save"
          end

          it "should be successful" do
            expect(page).to have_selector('.success', text: 'Post updated.')
            expect(page).to have_content('new.title')
          end
        end
      end
    end
  end

end
