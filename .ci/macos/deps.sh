#!/bin/sh

# SPDX-FileCopyrightText: Copyright 2026 crueter
# SPDX-License-Identifier: GPL-3.0-or-later

brew install --formula --quiet \
  fmt \
  llvm \
  ninja \
  cmake \
  python \
  git

pip install jinja2
