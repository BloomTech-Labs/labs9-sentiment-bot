// Update with your config settings.

// used for postgres config

const localPg = {
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASS
};

const dbConnection = process.env.DATABASE_URL || localPg

module.exports = {

  development: {
    client: 'sqlite3',
    connection: {
      filename: './data/feelzy.sqlite3'
    },
    useNullAsDefault: true,
    migrations: {
      directory: './data/migrations',
      tableName: 'dbmigrations'
    },
    seeds: {
      directory: './data/seeds'
    }
  },

  production: {
    client: 'postgresql',
    connection: dbConnection,
    pool: {
      min: 2,
      max: 10
    },
    migrations: {
      directory: './data/migrations',
      tableName: 'dbmigrations'
    },
    seeds: {
      directory: './data/seeds'
    }
  }
};