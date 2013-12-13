require 'spec_helper'

describe "PostPages" do
  subject { page }

  describe "list posts page" do
    let(:path) { posts_path }

    #it_behaves_like "a page that requires an active admin user"

    context "when visited by an user" do

      it "should list all the posts and have an appropriate header and title" do
        posts = create_list(:post, 2)
        visit(path)
        expect(page).to have_title(full_title('Posts'))
        expect(page).to have_selector('h1', 'Posts')
        expect(page).to have_selector('table#posts')
        expect(page.all('table tr').count).to eq 3

        posts.each do |post|
          expect(page).to have_link(post.title, href: post_path(post))
          expect(page).to have_link('Edit', href: edit_post_path(post))
        end
      end
    end
  end

  describe "show post page" do
    let(:post) { create(:post) }
    let(:path) { post_path(post) }

    let!(:comment1) { create(:comment, post_id: post.id) }
    let!(:comment2) { create(:comment, post_id: post.id) }

    context "when visited by an user" do
      before { visit(path) }

      it "should have post name and an edit link" do
        expect(page).to have_title(full_title('Post Info'))
        expect(page).to have_selector('h1', 'Post Info')
        expect(page).to have_content(post.title)
        expect(page.all('table tr').count).to eq 3
        
        expect(page).to have_link(comment1.content, href: comment_path(comment1))
        expect(page).to have_link(comment2.content, href: comment_path(comment2))
      end
    end
  end

end
