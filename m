From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH review 0/12] General unprivileged mount support v2
Date: Wed, 06 Jul 2016 13:10:23 -0500
Message-ID: <874m82bptc.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87ziq03qnj.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Sat, 02 Jul 2016 12:18:08 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


As well as in these patches the code is also available from:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing

v2 is slightly simplified.  During the review I realized the previous
quota changes while perhaps not wrong were in a part of the code I don't
want people to think is ready for use on unprivileged filesystems yet.

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

Eric W. Biederman (7):
      userns: Handle -1 in k[ug]id_has_mapping when !CONFIG_USER_NS
      vfs: Verify acls are valid within superblock's s_user_ns.
      vfs: Don't modify inodes with a uid or gid unknown to the vfs
      vfs: Don't create inodes with a uid or gid unknown to the vfs
      quota: Ensure qids map to the filesystem
      quota: Handle quota data stored in s_user_ns in quota_setxquota
      dquot: For now explicitly don't support filesystems outside of init_user_ns

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
 fs/quota/dquot.c                                |  8 ++++
 fs/quota/quota.c                                | 14 +++----
 fs/xattr.c                                      |  7 ++++
 include/linux/fs.h                              | 55 ++++++++++++++-----------
 include/linux/posix_acl.h                       |  2 +-
 include/linux/quota.h                           | 10 +++++
 include/linux/uidgid.h                          |  4 +-
 kernel/cred.c                                   |  2 +
 security/integrity/evm/evm_crypto.c             |  4 +-
 15 files changed, 133 insertions(+), 51 deletions(-)

Eric
