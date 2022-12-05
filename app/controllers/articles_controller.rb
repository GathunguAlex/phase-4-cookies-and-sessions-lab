class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views]  +=1

    if session[:page_views]>3
      return render json: {error:"Maximum pageview limit reached"}, status: :unauthorized
    end
    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found"}, status: :not_found
  end

end

Articles
  GET /articles
    returns an array of all articles
  GET /articles/:id
    with one pageviews
      returns the correct article
      uses the session to keep track of the number of page views
    with three pageviews
      returns the correct article
      uses the session to keep track of the number of page views
    with more than three pageviews
      returns an error message
      returns a 401 unauthorized status
      uses the session to keep track of the number of page views