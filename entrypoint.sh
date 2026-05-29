#!/bin/bash
set -e

# Rails 起動時に残った server.pid を削除（再起動時のエラー防止）
rm -f /myapp/tmp/pids/server.pid

# Dockerfile の CMD（または compose の command）を実行
exec "$@"
