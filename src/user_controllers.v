module main

import vweb
import json

['/controller/users'; get]
pub fn (mut app App) controller_get_all_user() vweb.Result {
	// token := app.get_cookie('token') or { '' }
	token := app.req.header.get_custom('token') or { '' }

	if !auth_verify(token) {
		app.set_status(401, '')
		return app.text('Not valid token')
	}

	response := app.service_get_all_user() or {
		app.set_status(400, '')
		return app.text('${err}')
	}
	return app.json(response)
}

['/controller/user/create'; post]
pub fn (mut app App) controller_create_user(username string, password string) vweb.Result {
	response := app.service_add_user(username, password) or {
		app.set_status(400, '')
		return app.text('error: ${err}')
	}

	return app.json(response)
}
