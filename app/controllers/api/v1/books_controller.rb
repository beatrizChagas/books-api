module Api
  module V1
    class BooksController < ApplicationController
      before_action :find_book, only: %i[show update destroy]

      # GET /books
      def index
        @books = Book.all

        render json: BooksRepresenter.new(@books).as_json
      end

      # POST /books
      def create
        @book = Book.create(book_params)

        if @book.save
          render json: BookRepresenter.new(@book).as_json, status: :created
        else
          render json: @book.errors, status: :unprocessable_entity
        end
      end

      # GET /books/:id
      def show
        render json: BookRepresenter.new(@book).as_json
      end

      # PUT /books/:id
      def update
        @book.update(book_params)

        head :no_content
      end

      # DELETE /books/:id
      def destroy
        @book.destroy

        head :no_content
      end

      private

      def book_params
        params.permit(:title, :author, :category_id)
      end

      def find_book
        @book = Book.find(params[:id])
      end
    end
  end
end
