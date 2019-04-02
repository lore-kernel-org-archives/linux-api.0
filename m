From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 00/17] fscrypt: key management improvements
Date: Tue,  2 Apr 2019 08:45:43 -0700
Message-ID: <20190402154600.32432-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

Hello,

This patchset makes major improvements to how keys are added, removed,
and derived in fscrypt, aka ext4/f2fs/ubifs encryption.  It does this by
adding new ioctls that add and remove encryption keys directly to/from
the filesystem, and by adding a new encryption policy version ("v2")
where the user-provided keys are only used as input to HKDF-SHA512 and
are identified by their cryptographic hash.

All new APIs and all cryptosystem changes are documented in
Documentation/filesystems/fscrypt.rst.  Userspace can use the new key
management ioctls with existing encrypted directories, but migrating to
v2 encryption policies is needed for the full benefits.

These changes solve four interrelated problems:

(1) Providing fscrypt keys via process-subscribed keyrings is abusing
    encryption as an OS-level access control mechanism, causing many
    bugs where processes don't get access to the keys they need -- e.g.,
    when a 'sudo' command or a system service needs to access encrypted
    files.  It's also inconsistent with the filesystem/VFS "view" of
    encrypted files which is global, so sometimes things randomly happen
    to work anyway due to caching.  Regardless, currently almost all
    fscrypt users actually do need global keys, so they're having to use
    workarounds that heavily abuse the session or user keyrings, e.g.
    Android and Chromium OS both use a systemwide "session keyring" and
    the 'fscrypt' tool links all user keyrings into root's user keyring.

(2) Currently there's no way to securely and efficiently remove a
    fscrypt key such that not only is the original key wiped, but also
    all files and directories protected by that key are "locked" and
    their per-file keys wiped.  Many users want this and are using
    'echo 2 > /proc/sys/vm/drop_caches' as a workaround, but this is
    root-only, and also is overkill so can be a performance disaster.

(3) The key derivation function (KDF) that fscrypt uses to derive
    per-file keys is nonstandard, inflexible, and has some weaknesses
    such as being reversible and not evenly distributing the entropy
    from the user-provided keys.

(4) fscrypt doesn't check that the correct key was supplied.  This can
    be a security vulnerability, since it allows malicious local users
    to associate the wrong key with files to which they have read-only
    access, causing other users' processes to read/write the wrong data.

Ultimately, the solutions to these problems all tie into each other.  By
adding a filesystem-level encryption keyring with ioctls to add/remove
keys to/from it, the keys are made usable filesystem-wide (solves
problem #1).  It also becomes easy to track the inodes that were
"unlocked" with each key, so they can be evicted when the key is removed
(solves problem #2).  Moreover, the filesystem-level keyring is a
natural place to store an HMAC transform keyed by each key, thus making
it easy and efficient to switch the KDF to HKDF (solves problem #3).

Finally, to check that the correct key was supplied, I use HKDF to
derive a cryptographically secure key_identifier for each key (solves
problem #4).  This in combination with key quotas and other careful
precautions also makes it safe to allow non-root users to add and remove
keys to/from the filesystem-level keyring.  Thus, all problems are
solved without having to restrict the fscrypt API to root only.

The patchset is organized as follows:

- Patches 1-9 add new ioctls FS_IOC_ADD_ENCRYPTION_KEY,
  FS_IOC_REMOVE_ENCRYPTION_KEY, and FS_IOC_GET_ENCRYPTION_KEY_STATUS.
  Adding a key logically "unlocks" all files on the filesystem that are
  protected by that key; removing a key "locks" them again.

- Patches 10-13 add support for v2 encryption policies.

- Patches 14-16 wire up the new ioctls to ext4, f2fs, and ubifs.

- Patch 17 updates the fscrypt documentation for all the changes.

Changes v3 => v4:
    - Introduce fscrypt_sb_free() to avoid an extra #ifdef.
    - Fix UBIFS's ->drop_inode().
    - Add 'version' to union fscrypt_policy and union fscrypt_context.

Changes v2 => v3:
    - Use ->drop_inode() to trigger the inode eviction during/after
      FS_IOC_REMOVE_ENCRYPTION_KEY, as suggested by Dave Chinner.
    - A few small cleanups.

v1 of this patchset was sent in October 2017 with title "fscrypt:
filesystem-level keyring and v2 policy support".  This revived version
follows the same basic design but incorporates numerous improvements,
such as splitting keyinfo.c into multiple files for much better
understandability, and introducing "per-mode" encryption keys to
implement the semantics of the DIRECT_KEY encryption policy flag.

This applies to v5.1-rc3.  You can also get it from git at:

	Repository:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
	Branch:       fscrypt-key-mgmt-improvements-v4

I've started writing xfstests for the new APIs.  So far they cover basic
functionality.  They can be found at:

	Repository:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
	Branch:       fscrypt-key-mgmt-improvements

The xfstests depend on new xfs_io commands which can be found at:

	Repository:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfsprogs-dev.git
	Branch:       fscrypt-key-mgmt-improvements

I've also made proof-of-concept changes to the 'fscrypt' userspace
program (https://github.com/google/fscrypt) to make it support v2
encryption policies.  You can find these changes in git at:

	Repository:   https://github.com/ebiggers/fscrypt.git
	Branch:       fscrypt-key-mgmt-improvements

To make the 'fscrypt' userspace program experimentally use v2 encryption
policies on new encrypted directories, add the following to
/etc/fscrypt.conf within the "options" section:

	"policy_version": "2"

It's also planned for Android and Chromium OS to switch to the new
ioctls and eventually to v2 encryption policies.  Work-in-progress,
proof-of-concept changes by Satya Tangirala for AOSP can be found at
https://android-review.googlesource.com/q/topic:fscrypt-key-mgmt-improvements

Eric Biggers (17):
  fs, fscrypt: move uapi definitions to new header <linux/fscrypt.h>
  fscrypt: use FSCRYPT_ prefix for uapi constants
  fscrypt: use FSCRYPT_* definitions, not FS_*
  fscrypt: add ->ci_inode to fscrypt_info
  fscrypt: refactor v1 policy key setup into keysetup_legacy.c
  fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
  fs/dcache.c: add shrink_dcache_inode()
  fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
  fscrypt: add FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl
  fscrypt: add an HKDF-SHA512 implementation
  fscrypt: v2 encryption policy support
  fscrypt: allow unprivileged users to add/remove keys for v2 policies
  fscrypt: require that key be added when setting a v2 encryption policy
  ext4: wire up new fscrypt ioctls
  f2fs: wire up new fscrypt ioctls
  ubifs: wire up new fscrypt ioctls
  fscrypt: document the new ioctls and policy version

 Documentation/filesystems/fscrypt.rst | 670 +++++++++++++++----
 MAINTAINERS                           |   1 +
 fs/crypto/Kconfig                     |   2 +
 fs/crypto/Makefile                    |  10 +-
 fs/crypto/crypto.c                    |  14 +-
 fs/crypto/fname.c                     |   5 +-
 fs/crypto/fscrypt_private.h           | 366 ++++++++--
 fs/crypto/hkdf.c                      | 188 ++++++
 fs/crypto/keyinfo.c                   | 592 -----------------
 fs/crypto/keyring.c                   | 917 ++++++++++++++++++++++++++
 fs/crypto/keysetup.c                  | 540 +++++++++++++++
 fs/crypto/keysetup_legacy.c           | 340 ++++++++++
 fs/crypto/policy.c                    | 388 ++++++++---
 fs/dcache.c                           |  32 +
 fs/ext4/ioctl.c                       |  24 +
 fs/ext4/super.c                       |   3 +
 fs/f2fs/file.c                        |  46 ++
 fs/f2fs/super.c                       |   2 +
 fs/super.c                            |   2 +
 fs/ubifs/ioctl.c                      |  23 +-
 fs/ubifs/super.c                      |  11 +
 include/linux/dcache.h                |   1 +
 include/linux/fs.h                    |   1 +
 include/linux/fscrypt.h               |  49 +-
 include/uapi/linux/fs.h               |  54 +-
 include/uapi/linux/fscrypt.h          | 163 +++++
 26 files changed, 3516 insertions(+), 928 deletions(-)
 create mode 100644 fs/crypto/hkdf.c
 delete mode 100644 fs/crypto/keyinfo.c
 create mode 100644 fs/crypto/keyring.c
 create mode 100644 fs/crypto/keysetup.c
 create mode 100644 fs/crypto/keysetup_legacy.c
 create mode 100644 include/uapi/linux/fscrypt.h

-- 
2.21.0
