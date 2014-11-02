#!/bin/sh

PATCH_DIR=`dirname $0`

patch -p 1 <"$PATCH_DIR/01-uname-29ed580.patch"
patch -p 1 <"$PATCH_DIR/02-libbb-8ed9672.patch"
patch -p 1 <"$PATCH_DIR/03-ls-fca0ee5.patch"
patch -p 1 <"$PATCH_DIR/04-libbb-15a357e.patch"
patch -p 1 <"$PATCH_DIR/05-libbb-e765b5a.patch"
mv libbb/execable.c libbb/executable.c
patch -p 1 <"$PATCH_DIR/06-which-a875d59.patch"
patch -p 1 <"$PATCH_DIR/07-awk-5f8daef.patch"
patch -p 1 <"$PATCH_DIR/08-test-98654b9.patch"
patch -p 1 <"$PATCH_DIR/09-top-7df1f1d.patch"
patch -p 1 <"$PATCH_DIR/10-top-6c6d37e.patch"
patch -p 1 <"$PATCH_DIR/11-ash-2ec3496.patch"
patch -p 1 <"$PATCH_DIR/12-ash-07f7ea7.patch"
patch -p 1 <"$PATCH_DIR/13-mdev-26a8b9f.patch"
patch -p 1 <"$PATCH_DIR/14-less-865814a.patch"
patch -p 1 <"$PATCH_DIR/15-less-307d26c.patch"
