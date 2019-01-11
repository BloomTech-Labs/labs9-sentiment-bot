
https://feelzy-api.herokuapp.com/api/users ---> returns entire users table

https://feelzy-api.herokuapp.com/api/users/:id ---> returns user with that id


## for deployment

(from project root)

git subtree push --prefix backend heroku master

heroku run npx knex migrate:latest -a feelzy-api

heroku run npx knex seed:run -a feelzy-api