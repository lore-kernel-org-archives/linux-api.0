From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [REVIEW][PATCH 00/11] ipc: Fixing the pid namespace support
Date: Fri, 23 Mar 2018 14:11:23 -0500
Message-ID: <87vadmobdw.fsf_-_@xmission.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
	<87vadzqqq6.fsf@xmission.com>
	<990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
	<877eqejowd.fsf@xmission.com>
	<3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
	<87a7v2z2qa.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87a7v2z2qa.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
	"Tue, 20 Mar 2018 19:33:49 -0500")
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
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


While discussing a proposal by Nagarathnam Muthusamy I realized that
the ipc namespace has never been given proper pid namespace support.
In particular if objects in a single ipc namespace are accessed from
different pid namespaces they will return the wrong pids.

Then when trying to test this I discovered that definitions that are
only used in msg.c, sem.c, and shm.c are included in linux/sched.h
resulting in what should be simple local modifications requring
nearly a full kernel rebuild.

So this patchset does several things.
- Changes the types that are passed into the security hooks to struct
  kern_ipc_perm because that is all the security hooks use.
- Moves definitions from include/{msg,sem,shm}.h into ipc/{msg,sem,shm}.c
  So the code can be modified without excessive development time.
- Instead of storing pids as intergers stores struct pid * instead.

I took a careful look to see if it seems likely the performance
regression in credential passing that af_unix experienced after
a similar conversion would be likely, but I don't see it.

So I think the biggest concern is if someone in the last 10 years
has come to depend on the buggy behavior.  If either the performance
is problematic or the there are regression caused by the change
in behavior we can revert.

Still I would like to see this fixed and I plan on merging this code.

Eric W. Biederman (11):
      sem/security: Pass kern_ipc_perm not sem_array into the sem security hooks
      shm/security: Pass kern_ipc_perm not shmid_kernel into the shm security hooks
      msg/security: Pass kern_ipc_perm not msg_queue into the msg_queue security hooks
      sem: Move struct sem and struct sem_array into ipc/sem.c
      shm: Move struct shmid_kernel into ipc/shm.c
      msg: Move struct msg_queue into ipc/msg.c
      ipc: Move IPCMNI from include/ipc.h into ipc/util.h
      ipc/util: Helpers for making the sysvipc operations pid namespace aware
      ipc/shm: Fix shmctl(..., IPC_STAT, ...) between pid namespaces.
      ipc/msg: Fix msgctl(..., IPC_STAT, ...) between pid namespaces
      ipc/sem: Fix semctl(..., GETPID, ...) between pid namespaces

include/linux/ipc.h        |  2 -
 include/linux/lsm_hooks.h  | 32 ++++++++--------
 include/linux/msg.h        | 18 ---------
 include/linux/security.h   | 67 ++++++++++++++++-----------------
 include/linux/sem.h        | 40 +-------------------
 include/linux/shm.h        | 23 ------------
 ipc/msg.c                  | 54 ++++++++++++++++++---------
 ipc/sem.c                  | 73 ++++++++++++++++++++++++++----------
 ipc/shm.c                  | 60 +++++++++++++++++++++---------
 ipc/util.c                 |  9 +++++
 ipc/util.h                 | 12 ++++++
 security/security.c        | 32 ++++++++--------
 security/selinux/hooks.c   | 92 +++++++++++++++++++++++-----------------------
 security/smack/smack_lsm.c | 68 +++++++++++++++++-----------------
 14 files changed, 297 insertions(+), 285 deletions(-)


Eric
