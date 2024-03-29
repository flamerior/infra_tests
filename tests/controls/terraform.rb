# encoding: utf-8
# copyright: 2018, The Authors

title 'terraform validation'

control 'terraform' do
  impact 1
  title 'Run terraform validate for stage & prod'

  describe file('terraform/stage/terraform.tfvars.example') do
    it { should exist }
    its('content') { should match(%r{\n\Z}) }
  end

  describe file('terraform/prod/terraform.tfvars.example') do
    it { should exist }
    its('content') { should match(%r{\n\Z}) }
  end

  describe command('cd terraform && terraform init -backend=false && terraform validate -var-file=terraform.tfvars.example') do
    its('stdout') { should match "Terraform has been successfully initialized!" }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  describe command('cd terraform/prod && terraform init -backend=false && terraform validate -var-file=terraform.tfvars.example') do
    its('stdout') { should match "Terraform has been successfully initialized!" }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  describe command('cd terraform/stage && terraform init -backend=false && terraform validate -var-file=terraform.tfvars.example') do
    its('stdout') { should match "Terraform has been successfully initialized!" }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
    end
end

control 'terraform' do
  impact 1
  title 'Run terraform tflint for stage & prod'
  describe command('cd terraform/prod && terraform get && tflint --var-file=terraform.tfvars.example --error-with-issues') do
    its('stdout') { should match "Your code is following the best practices" }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end

  describe command('cd terraform/stage && terraform get && tflint --var-file=terraform.tfvars.example --error-with-issues') do
    its('stdout') { should match "Your code is following the best practices" }
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
end
