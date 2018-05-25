From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 0/6 v1 resend] statfs: handle mount propagation
Date: Fri, 25 May 2018 14:48:19 +0200
Message-ID: <20180525124825.23875-1-christian@brauner.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, ebiederm@xmission.com, seth.forshee@canonical.com, viro@zeniv.linux.org.uk, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Hey,

This is v1 of this patchset. All changes from v0 to v1 are non-functional.
Specifically, the commit messages and justification have been extended as
requested by Linus and Al.

This little series does the following:

- unify the definition of constants in statfs.h and fs.h:
  The definitions for MS_* flags are currently a mixture between hex values
  and bit-shifts. All higher values are already initialized with bit-shifts
  for MS_* constants starting with (1<<16). This patch switches the
  definitions for MS_* constants over to uniformly use bit-shifts and
  alignes the definitions of ST_* flags too.
  Initializing them identically let's userspace easily detect when flags
  indicate the same property but use a different value in doing so.

- extend statfs to handle mount propagation:
  For all cases the only way to do this right now is by parsing
  /proc/<pid>/mountinfo. Yes, it is doable but still it is somewhat costly
  and annoying as e.g. those mount propagation fields are optional.
  1. prevent propagation from happening:
     From a userspace perspective we often run into the case where we
     simply want to know whether a given mountpoint is MS_SHARED or is
     MS_SLAVE. If it is we remount it as MS_PRIVATE to prevent any
     propagation from happening. We don't care about the peer
     relationship or how the propagation is exactly setup. We only want
     to prevent any propagation from happening.
     These mountpoints might be known in advance so parsing
     /proc/<pid>/mountinfo should not be needed.
  2. differentiate between MS_SLAVE and MS_SHARED mountpoints:
     Mountpoints that are MS_SLAVE are kept intact and mountpoints that
     are MS_SHARED are made MS_PRIVATE. These mountpoint might be known in
     advance so parsing /proc/<pid>/mountinfo should not be needed.
  3. retrieve propagation properties when procfs is not mounted:
     When the set of interesting mountpoints is known and /proc is not
     mounted calling statfs() is the only good way to reliably determine
     the propagation property of a mountpoint.
  4. inspecting file descriptors to mountpoints for propagation
     properties:
     When file descriptors to mountpoints are passed around between
     processes it is useful to have fstatvfs() handle mount propagation
     properties too.
  To this end the flags:
  - ST_UNBINDABLE
  - ST_SHARED
  - ST_PRIVATE
  - ST_SLAVE
  are added. They have the same value as their MS_* counterparts.

- Testing:
  I verified that now userspace can do e.g.

  int ret;
  char *s = "/some/path";
  struct statvfs sb;

  ret = statvfs(s, &sb);
  if (ret < 0)
          return false;

  if (sb.f_flag & ST_SHARED) {
          ret = mount("", s, NULL, MS_SLAVE | MS_REC, NULL);
          if (ret < 0)
                  return -1;
  }

Thanks!
Christian

Christian Brauner (6):
  fs: use << for MS_* flags
  statfs: use << to align with fs header
  statfs: add ST_UNBINDABLE
  statfs: add ST_SHARED
  statfs: add ST_SLAVE
  statfs: add ST_PRIVATE

 fs/statfs.c             | 16 +++++++++++++++-
 include/linux/statfs.h  | 30 +++++++++++++++++-------------
 include/uapi/linux/fs.h | 33 +++++++++++++++++----------------
 3 files changed, 49 insertions(+), 30 deletions(-)

-- 
2.17.0
