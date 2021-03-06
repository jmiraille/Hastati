describe 'Questions API', type: :request do
  let!(:questions) { create_list(:question, 9) }
  let(:question) {create :question}

  #GET /questions
  describe "GET INDEX /questions" do
    before {get "/questions"}
    it "has HTTP status 200" do
      expect(response).to have_http_status 200
    end
    it "returns questions" do
      expect(json_body.size).to eq 9
    end
  end

  #GET /questions/:id
  describe "GET SHOW /questions/:id" do

    context "when the record exists" do
      before {get "/questions/#{question.id}"}

      it "has HTTP status 200" do
        expect(response).to have_http_status 200
      end
      it "return the question" do
        expect(json_body['id']).to eq question.id
      end
    end
    context "when the record dont exists" do
      before {get "/questions/666"}

      it "has HTTP status 404" do
        expect(response).to have_http_status 404
      end
      it "returns not found error message" do
        expect(json_body['message']).to match /Could not find question with id:666/
      end
    end
  end

  # POST /questions
  describe "POST CREATE /questions" do
    let(:valid_attr) {{content: "How I create a question ?"}}

    context "when the request is valid" do

      it "has a status code 201" do
        post "/questions", params: valid_attr
        expect(response).to have_http_status 201
      end
      it "create a question" do
        expect{post "/questions", params: valid_attr}.to change(Question, :count).by 1
      end
      it "return new question" do
        post "/questions", params: valid_attr
        expect(json_body["id"]).to eq Question.last.id
      end
    end

    context "when the request is not valid" do
      before {post "/questions", params: {content: nil}}

      it "has a status code 422" do
        expect(response).to have_http_status 422
      end
      it "returns error message" do
        expect(json_body["message"]).to match /Could not create question record : content can't be blank/
      end
    end
  end

  # PUT /questions/:id
  describe "PUT UPDATE /questions/:id" do
    let(:valid_attr) {{content: 'How to test ?'}}

    context "when the record exists" do
      before {put "/questions/#{question.id}", params: valid_attr}

      it "has a HTTP code 204" do
        expect(response).to have_http_status 204
      end
      it "updates the record" do
        expect(question.reload.content).to eq "How to test ?"
      end
      it "return no content" do
        expect(response.body).to be_empty
      end
    end

    context "when the record do not exist" do
      before {put "/questions/666", params: valid_attr}

      it "has a HTTP code 404" do
        expect(response).to have_http_status 404
      end
      it "returns not found error message" do
        expect(json_body["message"]).to match /Could not find question with id:666/
      end
    end

    context "with invalid params" do
      before {put "/questions/#{question.id}", params: {content: nil}}

      it "has a HTTP code 204" do
        expect(response).to have_http_status 422
      end
      it "do not update the record" do
        expect(question.reload.content).to eq "Question?"
      end
      it "return error message" do
        expect(json_body["message"]).to match /Could not update question record : content can't be blank/
      end
    end
  end

  # DELETE /questions/:id
  describe "DELETE  DESTROY /questions/:id" do

    context "when record exists" do
      before {delete "/questions/#{question.id}"}

      it "has a HTTP code 204" do
        expect(response).to have_http_status 204
      end
      it "delete the record" do
        response
        expect(Question.find_by(id: question.id)).to eq nil
      end
      it "return no content" do
        expect(response.body).to be_empty
      end
    end

    context "when record do not exists" do
      before {delete "/questions/666"}

      it "has a HTTP code 404" do
        expect(response).to have_http_status 404
      end
      it "returns not found error message" do
        expect(json_body["message"]).to match /Could not find question with id:666/
      end
    end
  end
end
