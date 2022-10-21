module.exports = {
  apps: [
    {
      name: 'strapi-dev',
      cwd: '/srv/strapi/blog',
      script: 'npm',
      args: 'start',
      env: {
        NODE_ENV: 'development',
        DB_HOST: 'localhost',
        DB_PORT: '3306',
        DB_NAME: 'strapi_dev',
        DB_USER: 'strapi',
        DB_PASS: 'mysecurepassword',
        JWT_SECRET: 'aSecretKey',
      },
    },
  ],
};
