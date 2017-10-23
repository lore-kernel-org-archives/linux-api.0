From: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 00/25] fscrypt: filesystem-level keyring and v2 policy support
Date: Mon, 23 Oct 2017 14:40:33 -0700
Message-ID: <20171023214058.128121-1-ebiggers3@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Theodore Y . Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ryo Hashimoto <hashimoto-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Sarthak Kukreti <sarthakkukreti-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

This patchset solves multiple interrelated problems with how filesystem
encryption keys are managed (for ext4, f2fs, and ubifs), including:

(1) There is a visibility mismatch between the filesystem/VFS "view" of
    encrypted files (which is global) and the process-subscribed
    keyrings (which are not global).  Relying on process-subscribed
    keyrings to provide the encryption keys on-demand makes it quite
    difficult to support even simple things like running 'sudo', if
    encrypted files need to be accessed.

(2) There is no API to securely remove an encryption key, which should
    wipe all secret keys from memory and revert the encrypted files to
    their ciphertext "view".  Many users want this, even to the extent
    that they're already working around it using the very bad hack of
    'echo 2 > /proc/sys/vm/drop_caches', or alternatively hacking in an
    ioctl to drop caches for a specific filesystem.

(3) The key derivation function (KDF) used to derive the per-file
    encryption keys is nonstandard and has a number of problems, such as
    being trivially reversible.  We've wanted to replace it for some
    time now.

(4) There is no verification that the correct master key was supplied.
    This is actually a security vulnerability, as it allows malicious
    local users to associate the wrong key with files to which they have
    *read-only* access.

This patchset is based loosely on my earlier patchset "fscrypt: key
verification and KDF improvement".  However, while the earlier patchset
solved problems (3) and (4) above, it ignored (1) and (2).
Consequently, it ended up with a solution which probably would have had
to be reworked when we also solved (1) and (2).  For example, the
'key_hash' field was hacked on to the existing on-disk format just to
solve (4), but really we need it a different way to solve (1) and (2) as
well, at least for non-root users.  There was also a filesystem-level
key cache hacked on for caching the HMAC transforms for HKDF, but really
it should be a real keyring which you can add and remove keys from, as
we need that anyway for (1) and (2).

By considering all the problems together we end up with a solution which
should be simpler in the end, notwithstanding the length of this
patchset.

This patchset is organized as follows:

- Patches 1-6 introduce a filesystem-level crypto keyring and a new
  ioctl, FS_IOC_ADD_ENCRYPTION_KEY, which adds a master encryption key
  to it.  This solves problem (1) above, though initially only for use
  cases where a privileged process sets up the keys.  Patch 20 will make
  it unprivileged in some cases.

- Patches 7-10 add a new ioctl, FS_IOC_REMOVE_ENCRYPTION_KEY, which
  removes a master encryption key from the filesystem-level crypto
  keyring.  It also evicts the inodes which had been "unlocked" using
  the key.  This solves problem (2) above, though initially only for use
  cases where a privileged process sets up the keys.  Patch 20 will make
  it unprivileged in some cases.

- Patch 11 adds an ioctl FS_IOC_GET_ENCRYPTION_KEY_STATUS which
  retrieves the status of a key in the filesystem-level crypto keyring.

- Patches 12-14 wire up the above ioctls to ext4, f2fs, and ubifs.

- Patches 15-25 introduce a new encryption policy version ("v2") where
  master_key_descriptor is replaced with master_key_identifier, which is
  a cryptographic hash of the master key.  This allows opening the
  FS_IOC_ADD_ENCRYPTION_KEY and FS_IOC_REMOVE_ENCRYPTION_KEY ioctls up
  to non-root users.  In turn, this avoids any need to rely on the
  process-subscribed keyrings and encounter their visibility problems,
  and it allows non-root users to securely remove their encryption keys.
  I also take the opportunity to replace the AES-ECB-based KDF with
  HKDF-SHA512, which is also used to compute the master_key_identifier
  so that we pass the master key into only a single cryptographic
  primitive.

Note that patches 1-14 can be reviewed (and potentially even merged) on
their own, without patches 15-25.  At just that point, the ioctls to
manage filesystem-level keys will be usable for existing encrypted
files, for privileged users only.  However, to understand some of the
decisions made when designing the ioctls, it will be helpful to see how
the later patches extend the ioctls to also be usable for v2 encryption
policies and by unprivileged users.

Please review all API and on-disk format changes carefully, as we will
be locked into them once merged.

You can also get this patchset from git at:

	Repository:   https://github.com/ebiggers/linux.git
	Branch:       fscrypt-v2-policy-and-api_v1

It has received light testing.  I've also made proof-of-concept changes
to the 'fscrypt' userspace program to make it support v2 encryption
policies and the filesystem-level keyring.  You can find those userspace
changes in git at:

	Repository:   https://github.com/ebiggers/fscrypt.git
	Branch:       v2-policy-support

To make the 'fscrypt' userspace program use v2 policies for new
encrypted directories, add

	"policy_version": "2"

to /etc/fscrypt.conf within the "options" section.  (Again: for now
please consider the userspace changes proof-of-concept quality only!
So far I've been focusing on the kernel changes.)

It's intended that the other major users of filesystem-level encryption,
including the Android and Chromium OS key management systems, will
switch to the new API and encryption policy version as well.

Eric Biggers (25):
  fs, fscrypt: move uapi definitions to new header <linux/fscrypt.h>
  fscrypt: use FSCRYPT_ prefix for uapi constants
  fscrypt: use FSCRYPT_* definitions, not FS_*
  fscrypt: refactor finding and deriving key
  fs: add ->s_master_keys to struct super_block
  fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
  fs/inode.c: export inode_lru_list_del()
  fs/inode.c: rename and export dispose_list()
  fs/dcache.c: add shrink_dcache_inode()
  fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
  fscrypt: add FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl
  ext4 crypto: wire up new ioctls for managing encryption keys
  f2fs crypto: wire up new ioctls for managing encryption keys
  ubifs crypto: wire up new ioctls for managing encryption keys
  fscrypt: add UAPI definitions to get/set v2 encryption policies
  fscrypt: implement basic handling of v2 encryption policies
  fscrypt: add an HKDF-SHA512 implementation
  fscrypt: allow adding and removing keys for v2 encryption policies
  fscrypt: use HKDF-SHA512 to derive the per-file keys for v2 policies
  fscrypt: allow unprivileged users to add/remove keys for v2 policies
  fscrypt: require that key be added when setting a v2 encryption policy
  ext4 crypto: wire up FS_IOC_GET_ENCRYPTION_POLICY_EX
  f2fs crypto: wire up FS_IOC_GET_ENCRYPTION_POLICY_EX
  ubifs crypto: wire up FS_IOC_GET_ENCRYPTION_POLICY_EX
  fscrypt: document the new ioctls and policy version

 Documentation/filesystems/fscrypt.rst |  575 ++++++++++--
 fs/crypto/Kconfig                     |    2 +
 fs/crypto/crypto.c                    |   19 +-
 fs/crypto/fname.c                     |    4 +-
 fs/crypto/fscrypt_private.h           |  196 +++-
 fs/crypto/keyinfo.c                   | 1619 ++++++++++++++++++++++++++++++---
 fs/crypto/policy.c                    |  373 +++++---
 fs/dcache.c                           |   33 +
 fs/ext4/ioctl.c                       |   22 +
 fs/f2fs/file.c                        |   21 +-
 fs/inode.c                            |   24 +-
 fs/super.c                            |    3 +
 fs/ubifs/ioctl.c                      |   24 +-
 include/linux/dcache.h                |    1 +
 include/linux/fs.h                    |    6 +
 include/linux/fscrypt.h               |   12 +-
 include/linux/fscrypt_notsupp.h       |   23 +
 include/linux/fscrypt_supp.h          |    4 +
 include/uapi/linux/fs.h               |   50 +-
 include/uapi/linux/fscrypt.h          |  159 ++++
 20 files changed, 2724 insertions(+), 446 deletions(-)
 create mode 100644 include/uapi/linux/fscrypt.h

-- 
2.15.0.rc0.271.g36b669edcc-goog
