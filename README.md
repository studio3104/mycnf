# mycnf

parser of `my.cnf`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mycnf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mycnf

## Usage

###### my.cnf

```sh
$ cat /etc/my.cnf.1
[client]
port            = 3306
socket          = /var/lib/mysql/mysql.sock

[mysql]
no_auto_rehash

[mysqld]
datadir         = /var/lib/mysql
port            = 3306
socket          = /var/lib/mysql/mysql.sock
```

```sh
$ cat /etc/my.cnf.2
[client]
port            = 3308
socket          = /var/lib/mysql/mysql.sock

[mysql]
no_auto_rehash
safe-updates

[mysqld]
datadir         = /var/lib/mysql
port            = 3308
socket          = /var/lib/mysql/mysql.sock
```

#### parse

```ruby
MyCnf.parse('/etc/my.cnf.1')
```
```ruby
{
   client: {
     port: 3306, socket: '/var/lib/mysql/mysql.sock'
   },
   mysql: {
     no_auto_rehash: ''
   },
   mysqld: {
     datadir: '/var/lib/mysql', port: 3306, socket: '/var/lib/mysql/mysql.sock'
   }
}
```

#### generate

```ruby
MyCnf.generate({
  client: {
    port: 3306,
    socket: '/var/lib/mysql/mysql.sock'
  }
})
```
```ruby
[client]
port = 3306
socket = /var/lib/mysql/mysql.sock
```

#### compare

```ruby
MyCnf.compare(MyCnf.parse('/etc/my.cnf.1'), MyCnf.parse('/etc/my.cnf.2'))
MyCnf.compare_files('/etc/my.cnf.1', '/etc/my.cnf.2')
```
```ruby
{
  client: {
    port: [ 3306, 3308 ],
    socket: [ '/var/lib/mysql/mysql.sock', '/var/lib/mysql/mysql.sock' ]
  },
  mysql: {
    no_auto_rehash: [ '', '' ],
    safe_updates: [ nil, '' ]
  },
  mysqld: {
    datadir: [ '/var/lib/mysql', '/var/lib/mysql' ],
    port: [ 3306, 3308 ],
    socket: [ '/var/lib/mysql/mysql.sock', '/var/lib/mysql/mysql.sock' ]
  }
}
```

#### diff

```ruby
MyCnf.diff(MyCnf.parse('/etc/my.cnf.1'), MyCnf.parse('/etc/my.cnf.2'))
MyCnf.diff_files('/etc/my.cnf.1', '/etc/my.cnf.2')
```
```ruby
{
  client: {
    port: [ 3306, 3308 ]
  },
  mysql: {
    safe_updates: [ nil, '' ]
  },
  mysqld: {
    port: [ 3306, 3308 ]
  }
}
```

## Contributing

1. Fork it ( https://github.com/studio3104/mycnf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
