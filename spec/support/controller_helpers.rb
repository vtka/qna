module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def should_expose(name)
    value = controller.send(name)
    expect(value).to_not be_nil
    Class.new do
      def initialize(exposed)
        @exposed = exposed
      end

      def as(value)
        expect(@exposed).to eq value
      end
    end.new(value)
  end
end