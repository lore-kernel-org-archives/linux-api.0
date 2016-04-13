From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v3 0/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 14:57:55 +0100
Message-ID: <1460555877-12950-1-git-send-email-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

v2 -> v3:

 - Add the syscall to uapi/asm-generic/unistd.h.

 - Retest.

----------------------------------------------------------------------

It's not possible to read the process umask without also modifying it,
which is what umask(2) does.  A library cannot read umask safely,
especially if the main program might be multithreaded.

This patch series adds a trivial system call "getumask" which returns
the umask of the current process.

Another approach to this has been attempted before, adding something
to /proc, although it didn't go anywhere.  See:

  http://comments.gmane.org/gmane.linux.kernel/1292109

Another way to solve this would be to add a thread-safe getumask to
glibc.  Since glibc could own the mutex, this would permit libraries
linked to this glibc to read umask safely.

I should also note that man-pages documents getumask(3), but no
version of glibc has ever implemented it.

Typical test script:

#include <stdio.h>
#include <stdlib.h>
#include <linux/unistd.h>
#include <sys/syscall.h>

int main(int argc, char *argv[])
{
  int r = syscall(329);
  if (r == -1) {
    perror("getumask");
    exit(1);
  }
  printf("umask = %o\n", r);
  exit(0);
}

$ ./getumask 
umask = 22

Rich.
