# Minecraft Server Final Project 2

### Background: What will we do? How will we do it? 
This repo is used to run a script that does the majority of the work for setting up an EC2 instance and setting up a Minecraft server on it that can be connected to from anywhere.


### Requirements:
  - What will the user need to configure to run the pipeline?
    - Copy and paste your AWS credentials in the credentials file of the repository.
  - What tools should be installed?
    - awscli version 2.16.2 for interacting with aws via command line.
      - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    - If not using Ubuntu, manually install the following and remove lines `14-37` from the script: (commands are specific to distro so I have not included them)
      - terraform version 1.8.5
      - ansible version 2.14.14
  - Are there any credentials or CLI required?
    - the AWS cli is required
  - Should the user set environment variables or configure anything?
    - No, this is done through the script

### Diagram of the major steps in the pipeline. 
![image](https://github.com/eggeg/Minecraft-Server/assets/82609842/8909d8ea-3f50-4c18-ab8d-39f5f72023c3)


### List of commands to run, with explanations.

  Commands may be different if not using Ubuntu
  - clone the repo
  - install `awscli`
  - put AWS credentials into the `credentials` file of the repo so that terraform can connect to your AWS account to set up the EC2 instance
  - run the deploy script with admin privileges. The script will generate a key pair, run the terraform file that creates an EC2 instance on Amazon, sleep for two minutes to give the instance time to set up, and then run an ansible playbook that remotes in to the EC2 instance and does everything needed to set up the minecraft server. You may be asked to input "Y" or "yes" at various spots to give permission for installation and SSH connections.
    - `sudo bash deploy.bash`
  

### How to connect to the Minecraft server once it's running?

- Wait a minute or two after everything is finished running and then use the IP address that was output to connect to the minecraft server via the minecraft launcher. 
