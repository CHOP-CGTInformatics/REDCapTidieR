structure(list(
  url = "https://my.institution.edu/redcap/api/",
  status_code = 403L, headers = structure(list(
    date = "Thu, 01 Jun 2023 21:31:42 GMT",
    server = "Apache", expires = "0", `cache-control` = "no-store, no-cache, must-revalidate",
    pragma = "no-cache", `x-xss-protection` = "1;  mode=block",
    `x-content-type-options` = "nosniff", `access-control-allow-origin` = "*",
    `strict-transport-security` = "max-age=31536000; includeSubdomains;",
    `redcap-random-text` = "3ZQ", `content-encoding` = "gzip",
    vary = "Accept-Encoding", `x-frame-options` = "SAMEORIGIN",
    `access-control-allow-headers` = "Origin, X-Requested-With, Content-Type, Accept",
    `x-ua-compatible` = "IE=edge,chrome=1", connection = "close",
    `transfer-encoding` = "chunked", `content-type` = "application/json; charset=utf-8"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 403L, version = "HTTP/1.1",
    headers = structure(list(
      date = "Thu, 01 Jun 2023 21:31:42 GMT",
      server = "Apache", expires = "0", `cache-control` = "no-store, no-cache, must-revalidate",
      pragma = "no-cache", `x-xss-protection` = "1;  mode=block",
      `x-content-type-options` = "nosniff", `access-control-allow-origin` = "*",
      `strict-transport-security` = "max-age=31536000; includeSubdomains;",
      `redcap-random-text` = "3ZQ", `content-encoding` = "gzip",
      vary = "Accept-Encoding", `x-frame-options` = "SAMEORIGIN",
      `access-control-allow-headers` = "Origin, X-Requested-With, Content-Type, Accept",
      `x-ua-compatible` = "IE=edge,chrome=1", connection = "close",
      `transfer-encoding` = "chunked", `content-type` = "application/json; charset=utf-8"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = logical(0),
    flag = logical(0), path = logical(0), secure = logical(0),
    expiration = structure(numeric(0), class = c(
      "POSIXct",
      "POSIXt"
    )), name = logical(0), value = logical(0)
  ), row.names = integer(0), class = "data.frame"),
  content = charToRaw("{\"error\":\"You do not have permissions to use the API\"}"),
  date = structure(1685655102, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 1.7e-05,
    connect = 0.113915, pretransfer = 0.336791, starttransfer = 0.336804,
    total = 0.604953
  )
), class = "response")
