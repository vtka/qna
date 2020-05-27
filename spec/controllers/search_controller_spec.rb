require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:params) do
      { q: 'abcdef',
        scope: Rails.configuration.x.search.available_resources.first }
    end

    before do
      allow(ThinkingSphinx).to receive(:search).and_return([])
      allow(SearchService).to receive(:new).and_return(SearchService.new(params))
      get :index, params: params
    end

    it 'should expose search result' do
      expect(SearchService).to receive(:new)
      expect_any_instance_of(SearchService).to receive(:call).and_call_original
      should_expose(:search_result)
    end

    it 'returns status 200' do
      expect(response.status).to eq 200
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
