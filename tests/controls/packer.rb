# encoding: utf-8
# copyright: 2018, The Authors

title 'packer validation'

control 'packer' do
  impact 1
  title 'Run packer validate for all templates'

  Dir.glob('packer/*.json') do |packerfile|
    describe command('packer validate -var-file=packer/variables.json.example '+ packerfile) do
      its('stdout') { should eq "Template validated successfully.\n" }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end

end
