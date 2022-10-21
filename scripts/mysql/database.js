// path: /srv/strapi/mystrapiapp/config/database.js

module.exports = ({ env }) => ({
  connection: {
    client: 'mysql',
    connection: {
      host: env('DB_HOST'),
      port: env.int('DB_PORT'),
      database: env('DB_NAME'),
      user: env('DB_USER'),
      password: env('DB_PASS'),
//      ssl: {
//        rejectUnauthorized: env.bool('DATABASE_SSL_SELF', false), // For self-signed certificates
//      },
    },
    debug: false,
  },
});
