# How to Run:
* in your shell console:
```
git clone https://github.com/dchbx/slack-jenkins-proxy.git
cd slack-jenkins-proxy
export RUBY_SLACK_TOKEN=''
export RUBY_SLACK_JENKINS_JOB_URL=''
export RUBY_SLACK_JENKINS_JOB_TOKEN=''
export RUBY_SLACK_BOT_USERNAME=''
bundle install
rails server --port 1234567890 --binding 127.0.0.1 --daemon &
```

# How to Setup Bot:
* Setup your Slack bot at http://slack.com/services/new/bot
