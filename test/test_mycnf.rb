require 'mycnf'
require 'tempfile'
require 'test/unit'

class TestMyCnf < Test::Unit::TestCase
  sub_test_case 'parse' do
    test 'cnf1' do
      assert_equal MyCnf.parse(@cnf1.path), {
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
    end

    test 'cnf2' do
      assert_equal MyCnf.parse(@cnf2.path), {
        client: {
          port: 3308, socket: '/var/lib/mysql/mysql.sock'
        },
        mysql: {
          no_auto_rehash: '', safe_updates: ''
        },
        mysqld: {
          datadir: '/var/lib/mysql', port: 3308, socket: '/var/lib/mysql/mysql.sock'
        }
      }
    end
  end

  sub_test_case 'generate' do
    test '' do
      assert_equal MyCnf.generate({
        client: {
          port: 3306, socket: '/var/lib/mysql/mysql.sock'
        },
        mysql: {
          no_auto_rehash: ''
        },
        mysqld: {
          datadir: '/var/lib/mysql', port: 3306, socket: '/var/lib/mysql/mysql.sock'
        }
      }),
      <<EOF
[client]
port = 3306
socket = /var/lib/mysql/mysql.sock

[mysql]
no_auto_rehash

[mysqld]
datadir = /var/lib/mysql
port = 3306
socket = /var/lib/mysql/mysql.sock
EOF
    end
  end

  sub_test_case 'compare' do
    test 'compare 1 2' do
      assert_equal MyCnf.compare_files(@cnf1.path, @cnf2.path), {
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
    end
  end

  sub_test_case 'diff' do
    test 'diff 1 2' do
      assert_equal MyCnf.diff_files(@cnf1.path, @cnf2.path), {
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
    end
  end

  def setup
    @cnf1 = Tempfile.new('my.cnf.1')
    @cnf2 = Tempfile.new('my.cnf.2')

    @cnf1.puts <<EOF
[client]
port            = 3306
socket          = /var/lib/mysql/mysql.sock

[mysql]
no_auto_rehash

[mysqld]
datadir         = /var/lib/mysql
port            = 3306
socket          = /var/lib/mysql/mysql.sock
EOF
      @cnf2.write <<EOF
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
EOF
      @cnf1.read
      @cnf2.read
  end

  def teardown
    @cnf1.close
    @cnf2.close
    @cnf1.unlink
    @cnf2.unlink
  end
end
