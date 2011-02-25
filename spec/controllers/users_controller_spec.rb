require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should show correct user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end
    
    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content =>@user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar")
    end
    
    it "should have the right url" do
      get :show, :id => @user
      response.should have_selector('td>a', :content => user_path(@user),
                                           :href    => user_path(@user))
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => ""}
                
        
      end
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end
  end
  describe "success" do
    before(:each) do
      @attr = { :name =>"New User", :email => "iser@example.com",
                :password => "foobar", :password_confirmation => "foobar"

                }
    end

    it "should create a user" do
      lambda do
        post :create, :user => @attr
      end.should change(User, :count).by(1)
    end

      it "should redirect to user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

    it "should sign user in" do
      post :create, :user => @attr
      controller.should be_signed_in
    end

    
  end

  describe "GET 'edit'" do
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content =>"Edit User")
    end

    it "should have alink to change gravatat" do
      get :edit, :id => @user
      response.should have_selector('a', :href => 'http://gravatar.com/emails',
                                         :content => 'Change')
    end
  end

  describe "PUT 'update'" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end    
    describe "failure" do
      before (:each) do
      @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => ""}

      end

      it "should render the edit page" do
        put :update, :id => @user, :user =>@attr
        response.should render_template("edit")
      end

      it "should have the right title" do
        put :update, :id => @user, :user =>@attr
        response.should have_selector('title', :content=> "Edit User")
      end
    
    end

    describe "success" do
      before(:each) do
        @attr = { :name =>"New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
        
      end

      it "should update the users attr" do
        put :update, :id => @user, :user => @attr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end

      it "should have flash msg" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /Profile Updated/
      end
    end

  end

 end

