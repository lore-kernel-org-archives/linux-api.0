From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [PATCH review 0/11] General unprivileged mount support
Date: Sat, 02 Jul 2016 12:18:08 -0500
Message-ID: <87ziq03qnj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Djalal Harouni <tixxdz@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org


As well as in these patches the code is also available from:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing

It has been a long time in coming but recently in the userns tree the
superblock has been expanded with a s_user_ns field indicating the user
namespace that owns a superblock.

The s_user_ns owner of a superblock has three implications.
- Only kuids and kgids that map into s_user_ns are allowed to be sent to a
 filesystem from the vfs.
- If the uid or gid on the filesystem does not map into s_user_ns i_uid
  is set to INVALID_UID and i_gid is set to INVALID_GID.
- The scope of permission checks can be changed from global to a
  capabilitiy check in s_user_ns.

The overall strategy is to handle as much of this as possible in the VFS
so that what is happening is consistent between filesystems and has
widespread review, and so that individual filesystems don't need to
duplicate code.

This set of patches inserts checks to ensure only kuids and kgids that
map into s_user_ns are sent to filesystems.

This set of patches updates the vfs to deal with potentially unmapped
uids and gids in the i_uid and i_gid fields.  The strategy adopted is to
deny any activity that causes inodes with unmapped uids or gid to be
written to disk except for a chown that causes makes i_uid and i_gid
to map into s_user_ns.

Relaxing of the capability checks and adding new filesystems that would
benefit from the changes is held off until the vfs support is complete.

I believe this work is complete so if there anything questionable you
see please let me know.

I have included linux-api because several system calls get new failure
modes mostly -EOVERFLOW, and that may need separate documenation and
review.

The target for this work is to enable fully unprivileged fuse mounts
and whichever filesystem results from the uid shifting work.  These
vfs changes should support all kinds of filesystems, but in practice
it is an open problem if it is possible to modify a block based
filesystem to be safe from people manipulating filesystem images in an
attempt to get the kernel to malfunction so only a very limited set of
additional filesystems is ever expected to be enabled by this work.

Eric W. Biederman (6):
      userns: Handle -1 in k[ug]id_has_mapping when !CONFIG_USER_NS
      vfs: Verify acls are valid within superblock's s_user_ns.
      vfs: Don't modify inodes with a uid or gid unknown to the vfs
      vfs: Don't create inodes with a uid or gid unknown to the vfs
      quota: Ensure qids map to the filesystem
      quota: Handle quota data stored in s_user_ns.

Seth Forshee (5):
      fs: Refuse uid/gid changes which don't map into s_user_ns
      fs: Check for invalid i_uid in may_follow_link()
      cred: Reject inodes with invalid ids in set_create_file_as()
      evm: Translate user/group ids relative to s_user_ns when computing HMAC
      fs: Update i_[ug]id_(read|write) to translate relative to s_user_ns

 drivers/staging/lustre/lustre/mdc/mdc_request.c |  2 +-
 fs/9p/acl.c                                     |  2 +-
 fs/attr.c                                       | 19 +++++++++
 fs/inode.c                                      |  7 ++++
 fs/namei.c                                      | 40 ++++++++++++++----
 fs/posix_acl.c                                  |  8 ++--
 fs/quota/dquot.c                                |  7 +++-
 fs/quota/quota.c                                | 14 +++----
 fs/quota/quota_tree.c                           | 23 +++++++----
 fs/quota/quota_v1.c                             |  6 ++-
 fs/quota/quota_v2.c                             | 10 +++--
 fs/xattr.c                                      |  7 ++++
 include/linux/fs.h                              | 55 ++++++++++++++-----------
 include/linux/posix_acl.h                       |  2 +-
 include/linux/quota.h                           | 10 +++++
 include/linux/uidgid.h                          |  4 +-
 kernel/cred.c                                   |  2 +
 security/integrity/evm/evm_crypto.c             |  4 +-
 18 files changed, 154 insertions(+), 68 deletions(-)

Eric
