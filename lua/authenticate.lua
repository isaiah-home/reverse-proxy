local opts = {
    ssl_verify    = ngx.var.ssl_verify,
    redirect_uri  = ngx.var.redirect_uri,  -- Set your app's redirect URI here
    discovery     = ngx.var.discovery,     -- OpenID Connect Discovery endpoint
    client_id     = ngx.var.client_id,     -- OIDC Client ID
    client_secret = ngx.var.client_secret, -- OIDC Client Secret
    logout_path   = "/logout"
}

-- Authenticate the user
local res, err = require("resty.openidc").authenticate(opts)

-- Check for authentication errors
if err then
    ngx.log(ngx.ERR, err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- Ensure session is initialized properly
local session = require("resty.session").start({
    cookie = {
        persistent = true,   -- Ensure session persists across requests
        lifetime = 3600,     -- Set the session to expire after 1 hour (adjust as needed)
        path = "/",          -- Cookie path
        secure = true,       -- Use secure cookies (if HTTPS)
        httponly = true      -- Restrict cookie access to HTTP(S) only
    }
})

-- Save the session to ensure changes are applied
session:save()

-- Set user info in headers for downstream services
ngx.req.set_header("X-USER", res.id_token.sub)

