require "spec_helper"

describe CartsController do

  describe "GET #show" do
    it "redirect to 404 if cart has not existed" do
      get :show, id: 1
      response.should redirect_to error_404_path
    end
    context "when the cart has courses" do
      cart = Cart.create
      it "redirect to root in html format" do
        get :show, id: cart.cartid, format: 'html'
        response.should redirect_to root_path
      end
      it "render text in csv format" do
        get :show, id: cart.cartid, format: 'csv'
        response.should render_template(text: assigns(:cart).to_csv)
      end
    end
  end

  describe "POST #create" do
    context "creates a new cart with courses" do
      courses = { 214 => "Principles of Computer Science" }
      it "should have cartid in cookies" do
        post :create, courses: courses, format: 'js'
        cartid = assigns(:cart).cartid
        response.cookies['cart'].should eq(cartid)
      end
      it "should have courses in cart" do
        post :create, courses: courses, format: 'js'
        assigns(:cart_courses).should be_true
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the cookies" do
      cart_before = Cart.all
      cart = Cart.create
      delete :destroy, id: cart.cartid, format: 'js'
      cart_after = Cart.all
      cart_after.should eq(cart_before)
    end
  end

  describe "PUT #update" do
    course_arr = ["Computer Science", "CSCI", "214", "01", 
                    "532", "Full Term", "", "202009",
                    "", "Principles of Computer Science", 
                    "Geitz, Bob"]
    course = Course.build(course_arr)
    course.save               
    courses = { "f20_532" => "Principles of Computer Science" }

    it "adds selected courses to the cart" do
      cart = Cart.create
      course.semcrn.should eq("f20_532")
      put :update, id: cart.cartid, courses: courses, format: 'js'
      assigns(:cart_courses).should eq(assigns(:cart).get_courses)
      cart.delete
    end
=begin THIS TEST COSTS TOO MANY TIME IN CURRENT IMPLEMENTATION
    context "returns current cart" do
      it "when too many courses are selected" do
        cart = Cart.create
        cart_before = cart.get_courses
        #16777215.times { |key| courses[key] = key }
        put :update, id: cart.cartid, courses: courses, format: 'js'
        assigns(:cart_courses).should eq(cart_before)
        cart.delete
      end
=end
    it "returns current cart when no course is selected" do
      cart = Cart.create
      cart_before = cart.get_courses
      put :update, id: cart.cartid, courses: nil, format: 'js'
      assigns(:cart_courses).should eq(cart_before)
      cart.delete
    end
  end
  
  describe "PUT #remove" do

  end

  describe "PUT #clear" do
    it "should clear the cart of courses" do
      
    end
  end

  describe "GET #mail_to" do

  end

  describe "GET #search" do

  end

end
