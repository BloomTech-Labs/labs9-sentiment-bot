# labs9_sentiment_bot

Feelzy is a sentiment cataloging app for keeping track of how your teams are feeling. As a manager it helps you keep a finger on the emotional pulse of your teams. As a team member it helps you communicate your sentiment to your manager to achieve a sense of camaraderie.

## Backend startup
----------------
*work in progress use @Legitcoder's mock api [Sentiment-Bot-Mock-API](https://github.com/Legitcoder/sentiment-bot-mock-api) instead*

Install dependencies 
```sh
npm install
```

Migrate and seed the database
```sh
npx knex migrate:latest

npx knex seed:run
```

Then start the server!
```sh
npm run start
```

Or if you're developing
```sh
npm run dev
```

## Frontend startup
----------------
*currently depends on both the deployed backend and @Legitcoder's mock api [Sentiment-Bot-Mock-API](https://github.com/Legitcoder/sentiment-bot-mock-api)*

Install dependencies 
```sh
cd client/
yarn install
```

Start the React app
```sh
yarn start
```

The webpage will open automatically once the app has started!