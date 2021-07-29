
## 23.july.2021


NEXT:
- Async stuff:
  - Add thread-pool where needed      ~
  - Add mutex where needed
  - Add connection pool where needed
- Client side:
  - Add client side JS to the project
  - Add client side reconnections
- Consumer handling:
  - Add user-id to requests
  - Extract cookies, headers from request
- Remove stale connections from Registry
- Persistance for presence
- Pings for connection alive checks
- Tests

TODO:
- Replace Faye::WebSocket event-loop with nio
- Fix broadcast latency
- Optimize broadcast loop
