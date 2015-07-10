From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [REVIEW][PATCH 0/2] noexec on proc and sysfs
Date: Fri, 10 Jul 2015 11:16:14 -0500
Message-ID: <87mvz4yomp.fsf_-_@x220.int.ebiederm.org>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
	<CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
	<87pp4eqktr.fsf@x220.int.ebiederm.org>
	<CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA@mail.gmail.com>
	<20150704231118.GT17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150704231118.GT17109-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> (Al Viro's message of
	"Sun, 5 Jul 2015 00:11:18 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Given the code I have seen executables especially suid root executable
appearing on proc or sysfs will break userspace because there are
current applications that depend on nosuid and noexec on proc and sysfs
being meaningless.

This patchset addes a new flag SB_I_NOEXEC to enforce that restriction,
and to make it hard for a kernel developer to make the mistake of adding
executables to sysfs or proc.

The first patch has been updated since last time to a super block  flags
instead of a file_system type flag based on Al's suggestion.

The code in fs_fully_visible to enforce nosuid and noexec when needed
has also been added.

At a practical level this code is a no-op on a slow path, to guard
against future mistakes and to make auditing the kernel for this class
of problem trivial.

git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing

Eric W. Biederman (2):
      vfs: Commit to never having exectuables on proc and sysfs.
      mnt: fs_fully_visible enforce noexec and nosuid  if !SB_I_NOEXEC

 fs/exec.c           | 10 ++++++++--
 fs/namespace.c      | 33 +++++++++++++++++++++++++--------
 fs/open.c           |  2 +-
 fs/proc/root.c      |  2 ++
 fs/sysfs/mount.c    |  4 ++++
 include/linux/fs.h  |  3 +++
 kernel/sys.c        |  3 +--
 mm/mmap.c           |  4 ++--
 mm/nommu.c          |  2 +-
 security/security.c |  2 +-
 10 files changed, 48 insertions(+), 17 deletions(-)
