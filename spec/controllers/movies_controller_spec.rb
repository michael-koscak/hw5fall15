require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
        before :each do
            @fake_results = [double('movie1'), double('movie2')]
        end
        
        it 'should call the model method that performs TMDb search' do
            expect(Movie).to receive(:find_in_tmdb).with('hardware').and_return(@fake_results)
            post :search_tmdb, {:search_terms => {'term' => 'hardware'}}
        end
        
        describe 'after valid search' do
            before :each do 
                expect(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
                post :search_tmdb, {:search_terms => {'term' => 'hardware'}}
            end
            
            it 'should select the Search Results template for rendering' do 
                expect(response).to render_template('search_tmdb')
            end
            
            it 'should make the TMDb search results available to that template' do 
                expect(assigns(:movies)).to be @fake_results
            end
        end
        
        describe 'after invalid search' do 
            it 'should send the user to the index path if the search is nil' do
                post :search_tmdb, {:search_terms => {'term' => nil}}
            end 
            
            it 'should send the user to the index path if the search is empty' do 
                post :search_tmdb, {:search_terms => {'term' => ''}}
            end 
            
            after :each do 
                expect(response).to redirect_to(movies_path)
            end 
        end
        
        describe 'with no search results' do
            # the response could be nil or it could be empty
            it 'should send the user to the index path if the results are empty' do 
                expect(Movie).to receive(:find_in_tmdb).with('hardware').and_return([])
            end 
            
            it 'should send the user to the index path if the results are nil' do
                expect(Movie).to receive(:find_in_tmdb).with('hardware').and_return(nil)
            end 
            
            after :each do 
                post :search_tmdb, {:search_terms => {'term' => 'hardware'}}
                expect(response). to redirect_to(movies_path)
            end
        end
    end
end