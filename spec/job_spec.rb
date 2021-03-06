describe AnsibleTowerClient::Job do
  let(:url)            { "example.com/api/v1/job_update/10" }
  let(:api)            { AnsibleTowerClient::Api.new(instance_double("Faraday::Connection")) }
  let(:collection)     { api.jobs }
  let(:raw_collection) { build(:response_collection, :klass => described_class) }
  let(:raw_url_collection)  { build(:response_url_collection, :klass => described_class, :url => url) }
  let(:raw_instance)   { build(:response_instance, :job, :klass => described_class) }
  let(:raw_instance_no_extra_vars) { build(:response_instance, :job_template, :klass => described_class, :extra_vars => '') }
  let(:raw_instance_no_output)     { build(:response_instance, :job_template, :klass => described_class, :related => {}) }

  include_examples "Collection Methods"

  it "#initialize instantiates an #{described_class} from a hash" do
    obj = described_class.new(instance_double("AnsibleTowerClient::Api"), raw_instance)

    expect(obj).to         be_a described_class
    expect(obj.id).to      be_a Integer
    expect(obj.name).to    be_a String
    expect(obj.related).to be_a described_class::Related
  end

  describe "#extra_vars_hash" do
    describe "#extra_vars exists" do
      it "returns a hashed value" do
        obj = described_class.new(instance_double("AnsibleTowerClient::Api"), raw_instance)
        expect(obj.extra_vars_hash).to eq('option' => 'lots of options')
      end
    end

    describe "#extra_vars does not exist" do
      it "returns an empty hash" do
        obj = described_class.new(instance_double("AnsibleTowerClient::Api"), raw_instance_no_extra_vars)
        expect(obj.extra_vars_hash).to eq({})
      end
    end
  end

  context '#stdout' do
    describe "exists" do
      let(:stdout) { "Ansible Tower job output" }
      it "returns stdout" do
        expect(api).to receive(:get).and_return(instance_double("Faraday::Result", :body => stdout))
        expect(described_class.new(api, raw_instance).stdout).to eq(stdout)
      end
    end

    describe "does not exist" do
      it "returns nil" do
        expect(described_class.new(api, raw_instance_no_output).stdout).to be_nil
      end
    end
  end
end
