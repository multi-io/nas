. "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")/.env"

override_env="$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")/override.env"

if [ -f "$override_env" ]; then
    . "$override_env"
fi
