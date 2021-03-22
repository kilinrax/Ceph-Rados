#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_17 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     CEPH_OSD_TMAP_HDR CEPH_OSD_TMAP_SET LIBRADOS_SNAP_DIR */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'D':
    if (memEQ(name, "CEPH_OSD_TMAP_HDR", 17)) {
    /*                              ^        */
#ifdef CEPH_OSD_TMAP_HDR
      *iv_return = CEPH_OSD_TMAP_HDR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "CEPH_OSD_TMAP_SET", 17)) {
    /*                              ^        */
#ifdef CEPH_OSD_TMAP_SET
      *iv_return = CEPH_OSD_TMAP_SET;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "LIBRADOS_SNAP_DIR", 17)) {
    /*                              ^        */
#ifdef LIBRADOS_SNAP_DIR
      *iv_return = LIBRADOS_SNAP_DIR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_18 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     LIBRADOS_SNAP_HEAD LIBRADOS_VER_EXTRA LIBRADOS_VER_MAJOR
     LIBRADOS_VER_MINOR */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'E':
    if (memEQ(name, "LIBRADOS_SNAP_HEAD", 18)) {
    /*                              ^         */
#ifdef LIBRADOS_SNAP_HEAD
      *iv_return = LIBRADOS_SNAP_HEAD;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'J':
    if (memEQ(name, "LIBRADOS_VER_MAJOR", 18)) {
    /*                              ^         */
#ifdef LIBRADOS_VER_MAJOR
      *iv_return = LIBRADOS_VER_MAJOR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "LIBRADOS_VER_MINOR", 18)) {
    /*                              ^         */
#ifdef LIBRADOS_VER_MINOR
      *iv_return = LIBRADOS_VER_MINOR;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'T':
    if (memEQ(name, "LIBRADOS_VER_EXTRA", 18)) {
    /*                              ^         */
#ifdef LIBRADOS_VER_EXTRA
      *iv_return = LIBRADOS_VER_EXTRA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_26 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     LIBRADOS_CREATE_IDEMPOTENT LIBRADOS_SUPPORTS_GETADDRS
     LIBRADOS_SUPPORTS_SERVICES */
  /* Offset 23 gives the best switch position.  */
  switch (name[23]) {
  case 'C':
    if (memEQ(name, "LIBRADOS_SUPPORTS_SERVICES", 26)) {
    /*                                      ^         */
#ifdef LIBRADOS_SUPPORTS_SERVICES
      *iv_return = LIBRADOS_SUPPORTS_SERVICES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'D':
    if (memEQ(name, "LIBRADOS_SUPPORTS_GETADDRS", 26)) {
    /*                                      ^         */
#ifdef LIBRADOS_SUPPORTS_GETADDRS
      *iv_return = LIBRADOS_SUPPORTS_GETADDRS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "LIBRADOS_CREATE_IDEMPOTENT", 26)) {
    /*                                      ^         */
#ifdef LIBRADOS_CREATE_IDEMPOTENT
      *iv_return = LIBRADOS_CREATE_IDEMPOTENT;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!/usr/bin/perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(CEPH_OSD_TMAP_CREATE CEPH_OSD_TMAP_HDR CEPH_OSD_TMAP_RM
	       CEPH_OSD_TMAP_SET LIBRADOS_CREATE_EXCLUSIVE
	       LIBRADOS_CREATE_IDEMPOTENT LIBRADOS_LOCK_FLAG_RENEW
	       LIBRADOS_SNAP_DIR LIBRADOS_SNAP_HEAD
	       LIBRADOS_SUPPORTS_APP_METADATA LIBRADOS_SUPPORTS_GETADDRS
	       LIBRADOS_SUPPORTS_SERVICES LIBRADOS_SUPPORTS_WATCH
	       LIBRADOS_VERSION_CODE LIBRADOS_VER_EXTRA LIBRADOS_VER_MAJOR
	       LIBRADOS_VER_MINOR));

print constant_types(), "\n"; # macro defs
foreach (C_constant ("Ceph::Rados", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "\n#### XS Section:\n";
print XS_constant ("Ceph::Rados", $types);
__END__
   */

  switch (len) {
  case 16:
    if (memEQ(name, "CEPH_OSD_TMAP_RM", 16)) {
#ifdef CEPH_OSD_TMAP_RM
      *iv_return = CEPH_OSD_TMAP_RM;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 17:
    return constant_17 (aTHX_ name, iv_return);
    break;
  case 18:
    return constant_18 (aTHX_ name, iv_return);
    break;
  case 20:
    if (memEQ(name, "CEPH_OSD_TMAP_CREATE", 20)) {
#ifdef CEPH_OSD_TMAP_CREATE
      *iv_return = CEPH_OSD_TMAP_CREATE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 21:
    if (memEQ(name, "LIBRADOS_VERSION_CODE", 21)) {
#ifdef LIBRADOS_VERSION_CODE
      *iv_return = LIBRADOS_VERSION_CODE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 23:
    if (memEQ(name, "LIBRADOS_SUPPORTS_WATCH", 23)) {
#ifdef LIBRADOS_SUPPORTS_WATCH
      *iv_return = LIBRADOS_SUPPORTS_WATCH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 24:
    if (memEQ(name, "LIBRADOS_LOCK_FLAG_RENEW", 24)) {
#ifdef LIBRADOS_LOCK_FLAG_RENEW
      *iv_return = LIBRADOS_LOCK_FLAG_RENEW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 25:
    if (memEQ(name, "LIBRADOS_CREATE_EXCLUSIVE", 25)) {
#ifdef LIBRADOS_CREATE_EXCLUSIVE
      *iv_return = LIBRADOS_CREATE_EXCLUSIVE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 26:
    return constant_26 (aTHX_ name, iv_return);
    break;
  case 30:
    if (memEQ(name, "LIBRADOS_SUPPORTS_APP_METADATA", 30)) {
#ifdef LIBRADOS_SUPPORTS_APP_METADATA
      *iv_return = LIBRADOS_SUPPORTS_APP_METADATA;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

