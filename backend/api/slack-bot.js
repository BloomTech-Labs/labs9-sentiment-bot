'use strict'

const express = require('express')
const router = express();
const apiUrl = 'https://slack.com/api';

router.post('/echo', (req, res) => {

  if(req.body.token !== process.env.SLACK_VERIFICATION_TOKEN) {
    // the request is not coming from slack!
    res.status(401)
  } else {
    getReply(req.body).then((result) => {
      res.json(result)
    })
  }
})

// User info
const getUserFullname = (team, user) => new Promise((resolve, reject) => {
  let oauthToken = storage.getItemSync(team);
  console.log(oauthToken);
  request.post('https://slack.com/api/users.info', {form: {token: oauthToken, user: user}}, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      console.log(body);
      return resolve(JSON.parse(body).user.real_name);
    } else {
      return resolve('The user');
    }
  });
});

// Reply in JSON
const getReply = (body) => new Promise((resolve, reject) => {
  let data = {};
  if(body.text) {
    getUserFullname(body.team_id, body.user_id)
      .then((result) => {
        data = {
          response_type: 'in_channel', // public to the channle
          text: result + ' said',
          attachments:[{
            text: body.text
          }]
        };
        return resolve(data);
      })
      .catch(console.error);

  } else { // no query entered
    data = {
      response_type: 'ephemeral', // private message
      text: 'How to use /echo command:',
      attachments:[
      {
        text: 'Type some text after the command, e.g. `/echo hello`',
      }
    ]};
    return resolve(data);
  }
});

module.exports = router