require 'spec_helper'

describe "CommentPages" do

  subject { page }

  describe "list comments page" do
    let(:path) { comments_path }

    #it_behaves_like "a page that requires an active regular user"

    context "when visited by an user" do
      let(:user) { create(:user) }

      it "should list all the comments and have an appropriate header and title" do
        comments = create_list(:comment, 2)
        log_in_and_visit(user, path)
        #visit(path)
        expect(page).to have_title(full_title('Comments'))
        expect(page).to have_selector('h1', 'Comments')
        expect(page).to have_selector('table#comments')
        expect(page.all('table tr').count).to eq 3

        comments.each do |comment|
          expect(page).to have_link(comment.content, href: discussion_comment_path(comment))
          expect(page).to have_link(comment.post_id, href: discussion_post_path(comment.post_id))
        end
      end
    end
  end

  describe "show comment page" do
    let(:comment) { create(:comment) }
    let(:path) { comment_path(comment) }

    context "when visited by an user" do
      let(:user) { create(:user) }
      before { log_in_and_visit(user, path) }
      #before { visit(path) }

      it "should have comment name and an edit link" do
        expect(page).to have_title(full_title('Comment Info'))
        expect(page).to have_selector('h1', 'Comment Info')
        expect(page).to have_content(comment.content)
        expect(page).to have_link('Edit', discussion_edit_comment_path(comment))

      end
    end
  end

  describe "edit comment page" do
    let(:comment) { create(:comment) }
    let(:path) { discussion_edit_comment_path(comment) }

    #it_behaves_like "a page that requires an active admin user"

    context "when visited by the author" do
      let(:user) { create(:user) }
      before { log_in_and_visit(user, path) }
      #before { visit(path) }

      it "should have title, header, and editing form" do
        expect(page).to have_title(full_title("Edit Comment"))
        expect(page).to have_selector('h1', 'Edit Comment')
        expect(page).to have_selector('form')
      end

      context "when the form is submitted" do

        context "without any changes" do
          before { click_button "Save" }

          it { should have_selector('.success', text: 'Comment updated.') }
        end

        context "with invalid information" do
          before do
            fill_in "Content", with: ''
            click_button "Save"
          end

          it { should have_selector('.alert', text: 'error') }
        end

        context "with valid information" do
          before do
            fill_in "Content", with: 'new.content'
            click_button "Save"
          end

          it "should be successful" do
            expect(page).to have_selector('.success', text: 'Comment updated.')
            expect(page).to have_content('new.content')
          end
        end
      end
    end
  end

  describe "new comment page" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let(:path) { discussion_new_comment_path(post) }

    context "when visited by a signed-in user" do
      before { log_in_and_visit(user, path) }

      it "should have title, header, and new comment form" do
        expect(page).to have_title(full_title("New Comment"))
        expect(page).to have_selector('h1', 'New Comment')
        expect(page).to have_selector('form')
        expect(page).to have_button('Post')
      end

      context "when the form is submitted" do
        context "with invalid information" do
          before do
            fill_in "Content", with: ''
            click_button "Post"
          end

          it { should have_selector('.alert', text: 'error') }
        end

        context "with valid information" do
          before do
            fill_in "Content", with: 'new.content'
            click_button "Post"
          end

          it "should be successful" do
            expect(page).to have_selector('.success', text: 'Comment created.')
            expect(page).to have_content('new.content')
          end
        end
      end

    end
  end

end
