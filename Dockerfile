FROM ruby:3.1.2

# 必要なパッケージ: ビルドツール / PostgreSQL クライアント
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /myapp

# 先に Gemfile だけコピーして bundle install（レイヤキャッシュを効かせる）
COPY Gemfile Gemfile.lock /myapp/
RUN bundle install

# アプリ本体をコピー
COPY . /myapp

# 起動前処理（server.pid の削除など）
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# デフォルトコマンド: Rails サーバを 0.0.0.0 で起動
CMD ["rails", "server", "-b", "0.0.0.0"]
