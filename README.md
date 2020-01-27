## iBank

*   Ruby on Rails Bank Account System API made with Rails 6, Ruby 2.6.3 and Postgres 9.5 or superior

## Installation
1.  Download this repository

```
git clone https://github.com/jpsb/iBank.git
cd iBank
```

2.  Change your credentials in database.yml
3.  Install gem and execute db:setup

```
bundle install
bundle exec rake db:setup
```

4.  Run the tests

```
rspec
```

5.  Run the aplication

```
rails s
```

## API
### create a bank user 

only bank users can create accounts, transfer and view account balance

```bash
curl -H 'Accept: application/json' \
     -H 'Content-type: application/json' \
     -X POST http://localhost:3000/auth \
     -d '{ "email": "default@email.com", "password": "12345678", "name": "Username"}'

Response:

{
  "status":"success",
  "data":{
      "id":3,
      "provider":"email",
      "uid":"default@email.com",
      "allow_password_change":false,
      "name":null,
      "nickname":null,
      "image":null,
      "email":"default@email.com",
      "created_at":"2020-01-27T15:17:50.963Z",
      "updated_at":"2020-01-27T15:17:51.490Z"
  }
}
```

### login
```bash
curl -i -H 'Accept: application/json' \
     -H 'Content-type: application/json' \
     -X POST http://localhost:3000/auth/sign_in \
     -d '{ "email": "default@email.com", "password": "12345678"}'

Response:
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Download-Options: noopen
X-Permitted-Cross-Domain-Policies: none
Referrer-Policy: strict-origin-when-cross-origin
Content-Type: application/json; charset=utf-8
access-token: 4BntiMRt5LYL98fAIMz6YA
token-type: Bearer
client: mFR4BwjaL9OkIGDB9fSS3Q
expiry: 1581354990
uid: default1@email.com
ETag: W/"42a53cdd6859304e5ddccc8909811450"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: b7fca015-6846-43c8-bf5f-f620f11eb43f
X-Runtime: 0.529063
Vary: Origin
Transfer-Encoding: chunked

{
  "data": {
    "id":4,
    "email":"default1@email.com",
    "provider":"email",
    "uid":"default1@email.com",
    "allow_password_change":false,
    "name":null,
    "nickname":null,
    "image":null
  }
}
```

The authentication information should be included by the client in the headers of each request. The authentication headers (each one is a seperate header) consists of the following params:
*   access-token
*   client
*   uid

### create a new account
```bash
curl -H 'Content-Type: application/json' \
     -H 'access-token: 4BntiMRt5LYL98fAIMz6YA' \
     -H 'client: mFR4BwjaL9OkIGDB9fSS3Q' \
     -H 'uid: default@email.com' \
     -d '{"number": "1234-5", "opening_balance": 100.0}' \
     -X POST 'http://localhost:3000/api/v1/accounts'

Response:
{
  "number":"1234-5",
  "balance":"100.0"
}
```

```bash
curl -H 'Content-Type: application/json' \
     -H 'access-token: 4BntiMRt5LYL98fAIMz6YA' \
     -H 'client: mFR4BwjaL9OkIGDB9fSS3Q' \
     -H 'uid: default@email.com' \
     -d '{"number": "6789-0", "opening_balance": 100.0}' \
     -X POST 'http://localhost:3000/api/v1/accounts'

Response:
{
  "number":"6789-0",
  "balance":"100.0"
}
```

### transfer from one account to another account
```bash
curl -H 'Content-Type: application/json' \
     -H 'access-token: 4BntiMRt5LYL98fAIMz6YA' \
     -H 'client: mFR4BwjaL9OkIGDB9fSS3Q' \
     -H 'uid: default@email.com' \
     -d '{"source_account_number": "1234-5", "destination_account_number": "6789-0", "amount": 6.99}' \
     -X POST 'http://localhost:3000/api/v1/transfers'

Response:
{
  "id":21,
  "amount":"6.99",
  "user_transfer":"default@email.com",
  "source_account_number":"1234-5",
  "destination_account_number":"6789-0"
}
```

### show balance
```bash
curl -H 'Content-Type: application/json' \
     -H 'access-token: 4BntiMRt5LYL98fAIMz6YA' \
     -H 'client: mFR4BwjaL9OkIGDB9fSS3Q' \
     -H 'uid: default@email.com' \
     -d '{"account_number": "1234-5"}' \
     -X POST 'http://localhost:3000/api/v1/accounts/balance'

Response:
{
  "number":"1234-5",
  "balance":"72.08"
}
```

## Contributing
*   Fork it
*   Create your feature branch (`git checkout -b my-new-feature`)
*   Commit your changes (`git commit -am 'Add some feature'`)
*   Push to the branch (`git push origin my-new-feature`)
*   Create new Pull Request

### Maintaners

*   [João Paulo Barros](https://github.com/jpsb)
