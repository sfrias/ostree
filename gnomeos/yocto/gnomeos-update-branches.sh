#!/bin/sh
#
# Copyright (C) 2011,2012 Colin Walters <walters@verbum.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

set -e
set -x

ARCH=i686
BRANCH_PREFIX="gnomeos-3.4-${ARCH}-"

test -d repo || exit 1

for branch in runtime devel; do
    rev=$(ostree --repo=$(pwd)/repo rev-parse ${BRANCH_PREFIX}${branch});
    if ! test -d ${BRANCH_PREFIX}${branch}-${rev}; then
        ostree --repo=repo checkout ${rev} ${BRANCH_PREFIX}${branch}-${rev}
        ostbuild chroot-run-triggers ${BRANCH_PREFIX}${branch}-${rev}
        cp -ar /lib/modules/${uname} ${BRANCH_PREFIX}${branch}-${rev}/lib/modules/${uname}
    fi
    ln -sf ${BRANCH_PREFIX}${branch}-${rev} ${BRANCH_PREFIX}${branch}-current.new
    mv ${BRANCH_PREFIX}${branch}-current{.new,}
done
ln -sf ${BRANCH_PREFIX}runtime-current current.new
mv current.new current