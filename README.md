[![ready issues](https://badge.waffle.io/open-app/circles-api.png?label=ready&title=Ready)](https://waffle.io/open-app/circles-api)
[![server tests](https://travis-ci.org/open-app/circles-api.svg)](https://travis-ci.org/open-app/circles-api)
[![test coverage](https://img.shields.io/coveralls/open-app/circles-api.svg)](https://coveralls.io/r/open-app/circles-api)
[![npm version](https://badge.fury.io/js/open-app-circles-api.png)](https://npmjs.org/package/open-app-circles-api)
[![dependency status](https://david-dm.org/open-app/circles-api.png)](https://david-dm.org/open-app/circles-api)
[![devDependency status](https://david-dm.org/open-app/circles-api/dev-status.png)](https://david-dm.org/open-app/circles-api#info=devDependencies)


# Circles API

#### prototype in progress

Circles API of Open App Ecosystem

Groups should only need to be defined in one place. That place is here. Administrators can also define relationships with other circles.

## vocab

### name (foaf:name)

name of this Circle

### members (relations:members)

list of People who are members of this Circle

### sub (relations:subset)

list of Circles who are sub-Circles of this Circle

### super (relations:superset)

list of Circles who are super-Circles of this Circle

## how to

### install

```bash
git clone https://github.com/open-app/circles-prototype
cd circles-prototype
npm install
```

### run

```bash
npm start
```

### develop

```bash
npm run develop
```


### test

```bash
npm test
```

## license

[AGPLv3](LICENSE)
