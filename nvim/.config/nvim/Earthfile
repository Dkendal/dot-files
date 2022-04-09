VERSION 0.6

lua:
  FROM alpine:latest
  ENV LUA_VERSION 5.3
  ENV LUAROCKS_VERSION 3.8.0
  RUN --mount=type=cache,target=/var/cache/apk \
    apk update \
    && apk add \
           lua${LUA_VERSION} \
           lua${LUA_VERSION}-dev \
           musl-dev \
           openssl \
           wget \
           unzip \
           gcc \
           make \
    && ln -s /usr/bin/lua${LUA_VERSION} /usr/bin/lua \
    && wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
    && tar zxpf luarocks-${LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure && make && make install \
    && lua -v \
    && luarocks --version

fennel:
  FROM +lua
  RUN luarocks install fennel && which fennel
  ENTRYPOINT ["/usr/local/bin/fennel"]
  SAVE IMAGE fennel:latest

fnlfmt:
  FROM +fennel
  ENV FNLFMT_VERSION 0.2.2
  RUN wget https://git.sr.ht/~technomancy/fnlfmt/archive/${FNLFMT_VERSION}.tar.gz \
      && tar xpf ${FNLFMT_VERSION}.tar.gz \
      && cd fnlfmt-${FNLFMT_VERSION} \
      && make fnlfmt
  WORKDIR /fnlfmt-${FNLFMT_VERSION}
  SAVE ARTIFACT ./fnlfmt
  ENTRYPOINT ["./fnlfmt"]
  SAVE IMAGE fnlfmt:latest

tl:
  FROM +lua
  RUN luarocks install tl && which tl
  ENTRYPOINT ["tl"]
  SAVE IMAGE teal:latest

compile-fennel:
  FROM +fennel
  WORKDIR /code
  COPY --dir fnl /code/fnl
  RUN mkdir -p lua/user
  ENV COMPILE fennel --add-macro-path fnl/?.fnl --compile
  RUN $COMPILE fnl/user.fnl            > lua/user.lua \
   # && $COMPILE ftdetect/fennel.fnl     > lua/ftdetect/fennel.fnl \
   # && $COMPILE lua/dirlocal.fnl        > lua/dirlocal.fnl \
   && $COMPILE fnl/keymaps.fnl         > lua/keymaps.lua \
   && $COMPILE fnl/nvim.fnl            > lua/nvim.lua \
   && $COMPILE fnl/user.fnl            > lua/user.lua \
   && $COMPILE fnl/user/statusline.fnl > lua/user/statusline.lua \
   && $COMPILE fnl/user/treesitter.fnl > lua/user/treesitter.lua \
   && $COMPILE fnl/user/formatter.fnl  > lua/user/formatter.lua \
   && find . -name "*.lua"
  SAVE ARTIFACT lua AS LOCAL lua/fnl

build:
  BUILD +lua
  BUILD +tl
  BUILD +fennel
  BUILD +fnlfmt
  BUILD +compile-fennel
