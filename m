From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Thu, 31 Jul 2014 17:30:46 -0700
Message-ID: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
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
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


This patchset implements /proc/thread-self a magic symlink that
solves a couple of problems.

- It makes it easy to get to a specific threads directory in /proc
  with gettid() not being exported in glibc this is currently a pain.

- It allows fixing the problem present in /proc/mounts and /proc/net
  that when the thread group leader exits but the entire thread group
  remains /proc/self/net and /proc/self/mounts and thus /proc/mounts and
  /proc/net become empty.

- As mount and network namespaces are per thread it allows /proc/net and
  /proc/mounts to reflect this.

This is small chance changing /proc/net and /proc/mounts will cause
userspace regressions (although nothing has shown up in my testing) if
that happens we can just point the change that moves them from
/proc/self/... to /proc/thread-self/...

Eric W. Biederman (4):
      proc: Have net show up under /proc/<tgid>/task/<tid>
      proc: Implement /proc/thread-self to point at the directory of the current thread
      proc: Point /proc/net at /proc/thread-self/net instead of /proc/self/net
      proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts

 fs/proc/Makefile              |  1 +
 fs/proc/base.c                | 18 ++++++---
 fs/proc/inode.c               |  7 +++-
 fs/proc/internal.h            |  6 +++
 fs/proc/proc_net.c            |  2 +-
 fs/proc/root.c                |  5 ++-
 fs/proc/thread_self.c         | 85 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pid_namespace.h |  1 +
 8 files changed, 117 insertions(+), 8 deletions(-)

Eric
