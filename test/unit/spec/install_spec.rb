# Encoding: utf-8

require_relative 'spec_helper'

describe 'elasticsearch_test::default' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        # any platform specific data you want available to your test can be loaded here
        property = load_platform_properties(platform: platform, platform_version: version)

        it 'installs elasticsearch' do
          expect(chef_run).to install_elasticsearch('elasticsearch_p')
          expect(chef_run).to install_elasticsearch('elasticsearch_s')
        end
      end
    end
  end
end
