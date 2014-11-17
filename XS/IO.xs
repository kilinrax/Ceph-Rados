#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <rados/librados.h>

MODULE = Ceph::Rados    	PACKAGE = Ceph::Rados::IO

rados_ioctx_t
create(cluster, pool_name)
    rados_t *        cluster
    const char *     pool_name
  PREINIT:
    rados_ioctx_t    io;
    int              err;
  INIT:
    New( 0, io, 1, rados_ioctx_t );
  CODE:
    err = rados_ioctx_create(cluster, pool_name, &io);
    if (err < 0)
        croak("cannot open rados pool '%s': %s", pool_name, strerror(-err));
    RETVAL = io;
  OUTPUT:
    RETVAL

int
_write(io, oid, data, len)
    rados_ioctx_t    io
    const char *     oid
    SV *             data
    size_t           len;
  PREINIT:
    const char *     buf;
    int              err;
  CODE:
    buf = (const char *)SvPV(data, len);
    err = rados_write_full(io, oid, buf, len);
    if (err < 0)
        croak("cannot write object '%s': %s", oid, strerror(-err));
    RETVAL = err == 0;
  OUTPUT:
    RETVAL

int
_append(io, oid, data, len)
    rados_ioctx_t    io
    const char *     oid
    SV *             data
    size_t           len;
  PREINIT:
    const char *     buf;
    int              err;
  CODE:
    buf = (const char *)SvPV(data, len);
    err = rados_append(io, oid, buf, len);
    if (err < 0)
        croak("cannot append to object '%s': %s", oid, strerror(-err));
    RETVAL = err == 0;
  OUTPUT:
    RETVAL

SV *
read(io, oid, len, off = 0)
    rados_ioctx_t    io
    const char *     oid
    size_t           len
    uint64_t         off
  PREINIT:
    char *           buf;
    int              err;
  INIT:
    Newx(buf, len, char);
  CODE:
    err = rados_read(io, oid, buf, len, off);
    if (err < 0)
        croak("cannot read object '%s': %s", oid, strerror(-err));
    RETVAL = newSVpv(buf, len);
  OUTPUT:
    RETVAL

int
remove(io, oid)
    rados_ioctx_t    io
    const char *     oid
  PREINIT:
    int              err;
  CODE:
    err = rados_remove(io, oid);
    if (err < 0)
        croak("cannot remove object '%s': %s", oid, strerror(-err));
    RETVAL = err == 0;
  OUTPUT:
    RETVAL

void
destroy(io)
    rados_ioctx_t    io
  CODE:
    rados_ioctx_destroy(io);
