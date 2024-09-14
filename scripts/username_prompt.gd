class_name UsernamePrompt extends Control

signal username_set(un: String)

var username := ''

func _on_username_edit_text_changed(new_text: String) -> void:
	var len = new_text.length()
	if len > 0 && len <= 16:
		%SubmitButton.disabled = false
		username = new_text.to_lower()
	else:
		%SubmitButton.disabled = true

func _on_submit_button_pressed() -> void:
	%LoadingLabelBox.visible = true
	%SubmitButton.disabled = true
	%UsernameExistsLabel.visible = false
	$HTTPRequest.request('https://brackeys-12-game-jam-api.fly.dev/scores/myscore/' + username)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	%LoadingLabelBox.visible = false
	var json = JSON.parse_string(body.get_string_from_utf8())
	if 'username' in json:
		%UsernameExistsLabel.visible = true
		%SubmitButton.disabled = false
	else:
		username_set.emit(username)
		queue_free()
