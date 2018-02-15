From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH -next v2 0/3] sysvipc: introduce STAT_ANY commands
Date: Thu, 15 Feb 2018 08:24:55 -0800
Message-ID: <20180215162458.10059-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mhocko@kernel.org, mtk.manpages@gmail.com, robert.kettler@outlook.com, manfred@colorfullife.com, ebiederm@xmission.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net
List-Id: linux-api@vger.kernel.org

Changes from v1 (https://lwn.net/Articles/747225/):
- Renamed cmds to STAT_ANY, instead of STAT_ALL (per Eric).
- Added Robert's reported-by tag.
- Added changes for smack lsm.

Hi,

The following patches adds the discussed[1] new command for shm
as well as for sems and msq as they are subject to the same discrepancies
for ipc object permission checks between the syscall and via procfs.
These new commands are justified in that (1) we are stuck with this
semantics as changing syscall and procfs can break userland; and (2) some
users can benefit from performance (for large amounts of shm segments,
for example) from not having to parse the procfs interface.

Once (if) merged, I will submit the necesary manpage updates. But I'm
thinking something like:

diff --git a/man2/shmctl.2 b/man2/shmctl.2
index 7bb503999941..bb00bbe21a57 100644
--- a/man2/shmctl.2
+++ b/man2/shmctl.2
@@ -41,6 +41,7 @@
 .\" 2005-04-25, mtk -- noted aberrant Linux behavior w.r.t. new
 .\"	attaches to a segment that has already been marked for deletion.
 .\" 2005-08-02, mtk: Added IPC_INFO, SHM_INFO, SHM_STAT descriptions.
+.\" 2018-02-13, dbueso: Added SHM_STAT_ANY description.
 .\"
 .TH SHMCTL 2 2017-09-15 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -242,6 +243,18 @@ However, the
 argument is not a segment identifier, but instead an index into
 the kernel's internal array that maintains information about
 all shared memory segments on the system.
+.TP
+.BR SHM_STAT_ANY " (Linux-specific)"
+Return a
+.I shmid_ds
+structure as for
+.BR SHM_STAT .
+However, the
+.I shm_perm.mode
+is not checked for read access for
+.IR shmid ,
+resembing the behaviour of
+/proc/sysvipc/shm.
 .PP
 The caller can prevent or allow swapping of a shared
 memory segment with the following \fIcmd\fP values:
@@ -287,7 +300,7 @@ operation returns the index of the highest used entry in the
 kernel's internal array recording information about all
 shared memory segments.
 (This information can be used with repeated
-.B SHM_STAT
+.B SHM_STAT/SHM_STAT_ANY
 operations to obtain information about all shared memory segments
 on the system.)
 A successful
@@ -328,7 +341,7 @@ isn't accessible.
 \fIshmid\fP is not a valid identifier, or \fIcmd\fP
 is not a valid command.
 Or: for a
-.B SHM_STAT
+.B SHM_STAT/SHM_STAT_ANY
 operation, the index value specified in
 .I shmid
 referred to an array slot that is currently unused.


Thanks!

[1] https://lkml.org/lkml/2017/12/19/220

*** BLURB HERE ***

Davidlohr Bueso (3):
  ipc/shm: introduce shmctl(SHM_STAT_ANY)
  ipc/sem: introduce semctl(SEM_STAT_ANY)
  ipc/msg: introduce msgctl(MSG_STAT_ANY)

 include/uapi/linux/msg.h   |  1 +
 include/uapi/linux/sem.h   |  1 +
 include/uapi/linux/shm.h   |  5 +++--
 ipc/msg.c                  | 17 ++++++++++++-----
 ipc/sem.c                  | 17 ++++++++++++-----
 ipc/shm.c                  | 23 ++++++++++++++++++-----
 security/selinux/hooks.c   |  3 +++
 security/smack/smack_lsm.c |  3 +++
 8 files changed, 53 insertions(+), 17 deletions(-)

-- 
2.13.6
