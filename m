From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH v3 00/18] fscrypt: key management improvements
Date: Tue, 19 Feb 2019 23:18:21 -0800
Message-ID: <1660609D-3525-4485-9652-57976DB020F4@dilger.ca>
References: <20190220065249.32099-1-ebiggers@kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/mixed; boundary="===============4928510563471635485=="
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20190220065249.32099-1-ebiggers@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Satya Tangirala <satyat@google.com>, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org


--===============4928510563471635485==
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BF861CC0-6F7D-45E4-A4DC-D77A4C3AE913";
 protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_BF861CC0-6F7D-45E4-A4DC-D77A4C3AE913
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 19, 2019, at 10:52 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> Hello,
>=20
> This patchset makes major improvements to how keys are added, removed,
> and derived in fscrypt, aka ext4/f2fs/ubifs encryption.  It does this =
by
> adding new ioctls that add and remove encryption keys directly to/from
> the filesystem, and by adding a new encryption policy version ("v2")
> where the user-provided keys are only used as input to HKDF-SHA512 and
> are identified by their cryptographic hash.

Just to confirm for the layman reader - the fact that the crypto keys
are registered with the filesystem and not with the user process doesn't
prevent user(s) from having different crypto keys for different subdirs
in a single filesystem?

Secondly, does this progress fscrypt toward allowing multiple master =
keys
to decrypt a single per-file key?

Cheers, Andreas

> All new APIs and all cryptosystem changes are documented in
> Documentation/filesystems/fscrypt.rst.  Userspace can use the new key
> management ioctls with existing encrypted directories, but migrating =
to
> v2 encryption policies is needed for the full benefits.
>=20
> These changes solve four interrelated problems:
>=20
> (1) Providing fscrypt keys via process-subscribed keyrings is abusing
>    encryption as an OS-level access control mechanism, causing many
>    bugs where processes don't get access to the keys they need -- =
e.g.,
>    when a 'sudo' command or a system service needs to access encrypted
>    files.  It's also inconsistent with the filesystem/VFS "view" of
>    encrypted files which is global, so sometimes things randomly =
happen
>    to work anyway due to caching.  Regardless, currently almost all
>    fscrypt users actually do need global keys, so they're having to =
use
>    workarounds that heavily abuse the session or user keyrings, e.g.
>    Android and Chromium OS both use a systemwide "session keyring" and
>    the 'fscrypt' tool links all user keyrings into root's user =
keyring.
>=20
> (2) Currently there's no way to securely and efficiently remove a
>    fscrypt key such that not only is the original key wiped, but also
>    all files and directories protected by that key are "locked" and
>    their per-file keys wiped.  Many users want this and are using
>    'echo 2 > /proc/sys/vm/drop_caches' as a workaround, but this is
>    root-only, and also is overkill so can be a performance disaster.
>=20
> (3) The key derivation function (KDF) that fscrypt uses to derive
>    per-file keys is nonstandard, inflexible, and has some weaknesses
>    such as being reversible and not evenly distributing the entropy
>    from the user-provided keys.
>=20
> (4) fscrypt doesn't check that the correct key was supplied.  This can
>    be a security vulnerability, since it allows malicious local users
>    to associate the wrong key with files to which they have read-only
>    access, causing other users' processes to read/write the wrong =
data.
>=20
> Ultimately, the solutions to these problems all tie into each other.  =
By
> adding a filesystem-level encryption keyring with ioctls to add/remove
> keys to/from it, the keys are made usable filesystem-wide (solves
> problem #1).  It also becomes easy to track the inodes that were
> "unlocked" with each key, so they can be evicted when the key is =
removed
> (solves problem #2).  Moreover, the filesystem-level keyring is a
> natural place to store an HMAC transform keyed by each key, thus =
making
> it easy and efficient to switch the KDF to HKDF (solves problem #3).
>=20
> Finally, to check that the correct key was supplied, I use HKDF to
> derive a cryptographically secure key_identifier for each key (solves
> problem #4).  This in combination with key quotas and other careful
> precautions also makes it safe to allow non-root users to add and =
remove
> keys to/from the filesystem-level keyring.  Thus, all problems are
> solved without having to restrict the fscrypt API to root only.
>=20
> The patchset is organized as follows:
>=20
> - Patches 1-10 add new ioctls FS_IOC_ADD_ENCRYPTION_KEY,
>  FS_IOC_REMOVE_ENCRYPTION_KEY, and FS_IOC_GET_ENCRYPTION_KEY_STATUS.
>  Adding a key logically "unlocks" all files on the filesystem that are
>  protected by that key; removing a key "locks" them again.
>=20
> - Patches 11-14 add support for v2 encryption policies.
>=20
> - Patches 15-17 wire up the new ioctls to ext4, f2fs, and ubifs.
>=20
> - Patch 18 updates the fscrypt documentation for all the changes.
>=20
> Changes v2 =3D> v3:
>    - Use ->drop_inode() to trigger the inode eviction during/after
>      FS_IOC_REMOVE_ENCRYPTION_KEY, as suggested by Dave Chinner.
>    - A few small cleanups.
>=20
> v1 of this patchset was sent in October 2017 with title "fscrypt:
> filesystem-level keyring and v2 policy support".  This revived version
> follows the same basic design but incorporates numerous improvements,
> such as splitting keyinfo.c into multiple files for much better
> understandability, and introducing "per-mode" encryption keys to
> implement the semantics of the DIRECT_KEY encryption policy flag.
>=20
> This applies to the fscrypt.git tree.  You can also get it from git =
at:
>=20
> 	Repository:   =
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> 	Branch:       fscrypt-key-mgmt-improvements-v3
>=20
> I've started writing xfstests for the new APIs.  So far they cover =
basic
> functionality.  They can be found at:
>=20
> 	Repository:   =
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
> 	Branch:       fscrypt-key-mgmt-improvements
>=20
> The xfstests depend on new xfs_io commands which can be found at:
>=20
> 	Repository:   =
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfsprogs-dev.git
> 	Branch:       fscrypt-key-mgmt-improvements
>=20
> I've also made proof-of-concept changes to the 'fscrypt' userspace
> program (https://github.com/google/fscrypt) to make it support v2
> encryption policies.  You can find these changes in git at:
>=20
> 	Repository:   https://github.com/ebiggers/fscrypt.git
> 	Branch:       fscrypt-key-mgmt-improvements
>=20
> To make the 'fscrypt' userspace program experimentally use v2 =
encryption
> policies on new encrypted directories, add the following to
> /etc/fscrypt.conf within the "options" section:
>=20
> 	"policy_version": "2"
>=20
> It's also planned for Android and Chromium OS to switch to the new
> ioctls and eventually to v2 encryption policies.  Work-in-progress,
> proof-of-concept changes by Satya Tangirala for AOSP can be found at
> =
https://android-review.googlesource.com/q/topic:fscrypt-key-mgmt-improveme=
nts
>=20
> Eric Biggers (18):
>  fs, fscrypt: move uapi definitions to new header <linux/fscrypt.h>
>  fscrypt: use FSCRYPT_ prefix for uapi constants
>  fscrypt: use FSCRYPT_* definitions, not FS_*
>  fs: add ->s_master_keys to struct super_block
>  fscrypt: add ->ci_inode to fscrypt_info
>  fscrypt: refactor v1 policy key setup into keysetup_legacy.c
>  fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
>  fs/dcache.c: add shrink_dcache_inode()
>  fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
>  fscrypt: add FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl
>  fscrypt: add an HKDF-SHA512 implementation
>  fscrypt: v2 encryption policy support
>  fscrypt: allow unprivileged users to add/remove keys for v2 policies
>  fscrypt: require that key be added when setting a v2 encryption =
policy
>  ext4: wire up new fscrypt ioctls
>  f2fs: wire up new fscrypt ioctls
>  ubifs: wire up new fscrypt ioctls
>  fscrypt: document the new ioctls and policy version
>=20
> Documentation/filesystems/fscrypt.rst | 670 +++++++++++++++----
> MAINTAINERS                           |   1 +
> fs/crypto/Kconfig                     |   2 +
> fs/crypto/Makefile                    |  10 +-
> fs/crypto/crypto.c                    |  14 +-
> fs/crypto/fname.c                     |   5 +-
> fs/crypto/fscrypt_private.h           | 364 ++++++++--
> fs/crypto/hkdf.c                      | 188 ++++++
> fs/crypto/keyinfo.c                   | 592 -----------------
> fs/crypto/keyring.c                   | 911 ++++++++++++++++++++++++++
> fs/crypto/keysetup.c                  | 540 +++++++++++++++
> fs/crypto/keysetup_legacy.c           | 340 ++++++++++
> fs/crypto/policy.c                    | 388 ++++++++---
> fs/dcache.c                           |  32 +
> fs/ext4/ioctl.c                       |  24 +
> fs/ext4/super.c                       |   3 +
> fs/f2fs/file.c                        |  46 ++
> fs/f2fs/super.c                       |   2 +
> fs/super.c                            |   3 +
> fs/ubifs/ioctl.c                      |  24 +-
> fs/ubifs/super.c                      |   3 +
> include/linux/dcache.h                |   1 +
> include/linux/fs.h                    |   1 +
> include/linux/fscrypt.h               |  43 +-
> include/uapi/linux/fs.h               |  54 +-
> include/uapi/linux/fscrypt.h          | 163 +++++
> 26 files changed, 3496 insertions(+), 928 deletions(-)
> create mode 100644 fs/crypto/hkdf.c
> delete mode 100644 fs/crypto/keyinfo.c
> create mode 100644 fs/crypto/keyring.c
> create mode 100644 fs/crypto/keysetup.c
> create mode 100644 fs/crypto/keysetup_legacy.c
> create mode 100644 include/uapi/linux/fscrypt.h
>=20
> --
> 2.20.1
>=20


Cheers, Andreas






--Apple-Mail=_BF861CC0-6F7D-45E4-A4DC-D77A4C3AE913
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxs/z0ACgkQcqXauRfM
H+DlvBAAvOZ9ghTw4OWfocz9i6Sq+5IyW5m9q3LwPQBc5IqlEIh/Z1UQxEcHtzAf
IS+jZylXuPON90IK6FT1YnjDOOGXnua+ZBIF3Lv8AsUilT26gXYaTPxDD5gta8kb
nRArNAoVuVTw9FiDAN459njJb8FVayL9IUvMQo+S0ALbkTVXi4H54MNlq9jN46bQ
aFF3q4Vr7L57YlR2WJu9n6AykfrZztWlXeLuHrlxWsCzxYmScty+NtmsY/iGHXke
Eo8WBVBi7Js1SA/vYvG9aqDQiATThrl+4RDOw08XQ5gemKF8MRvVFXnnBAEwwOn+
vPVPL0vRoX5UIiL5vPuv+IplrMaL72ckdMVMar7sZBCBhYkHejoP6uPcJZSyEosP
WcXFBmVBs+q00gaeHEVsefzNmpls8rIbtAmK3AlcZ95bP22Z/C3eW2LPgxDmgYhM
2nOQIHEPegZdyaGNybRC3Z+Sqa9YQIOX3/0ql9KM9v04frVNnfvP/qpHeHjsExM6
8zbXLC23uxDfvmvwK0vNpjKfcnbUWXwAD6zyj6L1ONQpFPNBr2L8/RAWoJukO3M7
ND2mLK9794N3c0XxirJe78aNz0wLnCAcMh2fX4O0AIOOGcDR5x1T5pfzyB85XqcE
Jqitr7AXTq0S2InbBiTICa0oI2HCALvhcOXWoL2mYsqJVqMJgmk=
=5CU+
-----END PGP SIGNATURE-----

--Apple-Mail=_BF861CC0-6F7D-45E4-A4DC-D77A4C3AE913--


--===============4928510563471635485==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--===============4928510563471635485==--
