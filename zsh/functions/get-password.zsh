get_password() {
	if [ -z "$1" ]; then
		echo "Usage: get_password <site-name>"
		return 1
	fi

	local SPECTRE_USERNAME="$(< "$HOME/.spectre.d/user.txt")"

	if [ -z "$SPECTRE_USERNAME" ]; then
		echo "❌ Error: SPECTRE_USERNAME not set."
		return 1
	fi

	local SITE_NAME="$1"
	local TEST_PW="ThisIsForTestingOnly"
	local TEST_PW_FILE="$HOME/.spectre.d/test_pw.txt"

	while [ -z "$SPECTRE_SECRET" ]; do
		read -s "input_secret?Enter Spectre secret: "
		echo

		local validation_output=$(spectre -u "$SPECTRE_USERNAME" -S "$input_secret" "$TEST_PW" 2>/dev/null)
		local expected_output=$(<"$TEST_PW_FILE")

		if [ "$validation_output" = "$expected_output" ]; then
			export SPECTRE_SECRET="$input_secret"
		else
			echo "❌ Incorrect secret, try again."
		fi
	done

	local password=$(spectre -u "$SPECTRE_USERNAME" -S "$SPECTRE_SECRET" "$SITE_NAME" 2>/dev/null)

	if [ -z "$password" ]; then
		echo "❌ Failed to retrieve password for $SITE_NAME."
		return 1
	fi

	echo -n "$password" | pbcopy

	echo "🌈🌱🐤 Password for $SITE_NAME saved to clipboard! 🐤🌱🌈"
}