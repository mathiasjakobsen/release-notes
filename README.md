# Release Notes

Release notes service to proxy Github release notes directly into an embedable release notes log, for product users. The service will query Github, at runtime, for the latest 100 releases and display them as a nice one pager of markdown release notes.

### Example

The release notes for this repository, will look like this.

![Cool cool cool cool..](cool.png)


### Prerequisites

The service requires three enviroment variables, at runtime:
- `BEARER` - Github personal token, with `repo:read` permissions
- `OWNER`- Github organization name
- `TOKENS`- Comma (,) separated list of custom tokens, used for embedding the one page into your app- or website

### How to Use

Install dependecies:
```sh
bundle install
```

Run the service by:
```sh
rackup config.ru
```

Open:
```rb
http://localhost:9292/:repo?bearer=:token
```
