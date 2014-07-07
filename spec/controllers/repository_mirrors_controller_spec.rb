require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RepositoryMirrorsController do

  def success_url
    "/repositories/#{@repository_git.id}/edit?tab=repository_mirrors"
  end


  before(:all) do
    @project        = FactoryGirl.create(:project)
    @repository_git = FactoryGirl.create(:repository, :project_id => @project.id)
    @mirror         = FactoryGirl.create(:repository_mirror, :repository_id => @repository_git.id)
    @user           = FactoryGirl.create(:user, :admin => true)
  end


  describe "GET #index" do
    before do
      request.session[:user_id] = @user.id
      get :index, :repository_id => @repository_git.id
    end

    it "populates an array of mirrors" do
      expect(assigns(:repository_mirrors)).to eq [@mirror]
    end

    it "renders the :index view" do
      expect(response).to render_template(:index)
    end
  end


  describe "GET #show" do
    before do
      request.session[:user_id] = @user.id
      get :show, :repository_id => @repository_git.id, :id => @mirror.id
    end

    it "renders 404" do
      expect(response.status).to eq 404
    end
  end


  describe "GET #new" do
    before do
      request.session[:user_id] = @user.id
      get :new, :repository_id => @repository_git.id
    end

    it "assigns a new RepositoryMirror to @mirror" do
      expect(assigns(:mirror)).to be_an_instance_of(RepositoryMirror)
    end

    it "renders the :new template" do
      expect(response).to render_template(:new)
    end
  end


  describe "POST #create" do
    context "with valid attributes" do
      before do
        request.session[:user_id] = @user.id
      end

      it "saves the new mirror in the database" do
        expect{
          post :create, :repository_id => @repository_git.id,
                        :repository_mirror => {
                          :url => 'ssh://git@redmine.example.org/project1/project2/project3/project4.git',
                          :push_mode => 0
                        }
        }.to change(RepositoryMirror, :count).by(1)
      end

      it "redirects to the repository page" do
        post :create, :repository_id => @repository_git.id,
                      :repository_mirror => {
                        :url => 'ssh://git@redmine.example.org/project1/project2/project3/project4/repo1.git',
                        :push_mode => 0
                      }
        expect(response).to redirect_to(success_url)
      end
    end

    context "with invalid attributes" do
      before do
        request.session[:user_id] = @user.id
      end

      it "does not save the new mirror in the database" do
        expect{
          post :create, :repository_id => @repository_git.id,
                        :repository_mirror => {
                          :url => 'git@redmine.example.org/project1/project2/project3/project4.git',
                          :push_mode => 0
                        }
        }.to_not change(RepositoryMirror, :count)
      end

      it "re-renders the :new template" do
        post :create, :repository_id => @repository_git.id,
                      :repository_mirror => {
                        :url => 'git@redmine.example.org/project1/project2/project3/project4.git',
                        :push_mode => 0
                      }
        expect(response).to render_template(:new)
      end
    end
  end


  describe "GET #edit" do
    before do
      request.session[:user_id] = @user.id
      get :edit, :repository_id => @repository_git.id, :id => @mirror.id
    end

    it "assigns the requested mirror to @mirror" do
      expect(assigns(:mirror)).to eq @mirror
    end

    it "renders the :edit template" do
      expect(response).to render_template(:edit)
    end
  end


  describe "PUT #update" do
    before do
      request.session[:user_id] = @user.id
    end

    context "with valid attributes" do
      before do
        put :update, :repository_id => @repository_git.id,
                     :id => @mirror.id,
                     :repository_mirror => {
                       :url => 'ssh://git@redmine.example.org/project1/project2/project3/project4.git'
                     }
      end

      it "located the requested @mirror" do
        expect(assigns(:mirror)).to eq @mirror
      end

      it "changes @mirror's attributes" do
        @mirror.reload
        expect(@mirror.url).to eq 'ssh://git@redmine.example.org/project1/project2/project3/project4.git'
      end

      it "redirects to the repository page" do
        expect(response).to redirect_to success_url
      end
    end

    context "with invalid attributes" do
      before do
        put :update, :repository_id => @repository_git.id,
                     :id => @mirror.id,
                     :repository_mirror => {
                       :url => 'git@redmine.example.org/project1/project2/project3/project4.git'
                     }
      end

      it "located the requested @mirror" do
        expect(assigns(:mirror)).to eq @mirror
      end

      it "does not change @mirror's attributes" do
        @mirror.reload
        expect(@mirror.url).to eq 'ssh://host.xz/path/to/repo.git'
      end

      it "re-renders the :edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end

end