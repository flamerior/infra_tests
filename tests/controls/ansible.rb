# encoding: utf-8
# copyright: 2018, The Authors

title 'ansible validation'

control 'ansible' do
  impact 1
  title 'Run ansible validation'

  describe command('cd ansible && ansible-galaxy install -r environments/stage/requirements.yml') do
    its('exit_status') { should eq 0 }
  end

  Dir.glob('ansible/playbooks/*.yml') do |playbook|
    describe command('cd ansible && ansible-lint playbooks/' + playbook + '.yml --exclude=roles/jdauphant.nginx && cd ..') do
      its('stdout') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end

  describe command('find ansible/playbooks -name "*.yml" -type f -print0 | ANSIBLE_ROLES_PATH=ansible/roles xargs -0 -n1 ansible-playbook --syntax-check') do
    its('stderr') { should_not match (/The error appears to have been/) }
    its('exit_status') { should eq 0 }
  end

end
