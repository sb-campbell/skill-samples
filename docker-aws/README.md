# Multi-tiered React node.js application to AWS utilizing Docker containerization

A Fibonacci Sequence Generator as a complex, multi-tiered web application.

### Purpose/Objective

This project represents a CI/CD workflow utilizing Docker containerization, GitHub source-control, Travis CI testing and AWS deployment. The architecture is deployed to Elastic Beanstalk application environment, utilizing multi-tiered nginx routing to React node.js web, API and app servers, and SQL and in-memory database back-ends.

### Credit

Thanks to [Stephen Grider](https://www.linkedin.com/in/stephengrider/) for both the inspiration and excellent training and foundation provided for this build...

> [Docker and Kubernetes: The Complete Guide](https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/)

### Architecture

* Docker
* GitHub
* TravisCI
* Node.js
* React
* Nginx
* AWS
** Elastic Beanstalk
** RDS Postgresql
** Elasticache Redis

### Required Software

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/downloads/)

### Potential Enhancements

- Migrate CI/CD workflow to GitHub Actions

### File Tree

```
.
├── README.md
├── .travis.yml
├── client                            # web server
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   ├── README.md
│   ├── nginx
│   │   └── default.conf
│   ├── node_modules
│   ├── package.json
│   ├── public
│   │   ├── favicon.ico
│   │   ├── index.html
│   │   ├── logo192.png
│   │   ├── logo512.png
│   │   ├── manifest.json
│   │   └── robots.txt
│   └── src
│       ├── App.css
│       ├── App.js
│       ├── App.test.js
│       ├── Fib.js
│       ├── OtherPage.js
│       ├── index.css
│       ├── index.js
│       ├── logo.svg
│       ├── reportWebVitals.js
│       └── setupTests.js
├── docker-compose-dev.yml         # dev/test build
├── docker-compose.yml             # production build
├── nginx                          # routing web server
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   └── default.conf
├── server                         # api server
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   ├── index.js
│   ├── keys.js
│   ├── node_modules
│   └── package.json
└── worker                         # application server
    ├── Dockerfile
    ├── Dockerfile.dev
    ├── index.js
    ├── keys.js
    ├── node_modules
    └── package.json
```

