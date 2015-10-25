require 'rails_helper'
require 'spec_helper'

describe Movie do
    describe 'searching TMDB' do
        it 'should successfully return an existing movie' do
            expect((Movie.find_in_tmdb('Ted')).any? {|movie| movie[:title] == 'Ted'}).to be_truthy
        end
        it 'should fail to return a nonexistent movie' do
           expect(Movie.find_in_tmdb('lolnoreturn').empty?).to be_truthy
        end
    end
end