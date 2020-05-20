shared_examples_for 'API Authorizable' do
  context 'unauthorized returns status 401' do
    it 'unless access_token' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end

    it 'if invalid access_token' do
      do_request(method, api_path, params: { access_token: '123123' }, headers: headers)

      expect(response.status).to eq 401
    end
  end
end