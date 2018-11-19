From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v1 0/2] proc: allow signaling processes via file descriptors
Date: Mon, 19 Nov 2018 11:32:37 +0100
Message-ID: <20181119103241.5229-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey,

This little series introduces the ability to signal processes via file
descriptors to eliminate race-conditions caused by pid recycling.
With this patch an open() call on /proc/<pid> will give userspace a
handle to struct pid of the process associated with /proc/<pid>. This
allows to maintain a stable handle on a process.
Discussion has shown that a dedicated syscall is prefered over an ioctl().
Thus, the  new syscall procfd_signal() is introduced to solve this
problem. It operates on a process file descriptor. More details are
found in the individual commit messages.

With this series a process can be killed via:

 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <signal.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/types.h>
 #include <unistd.h>

 int main(int argc, char *argv[])
 {
         int ret;
         char buf[1000];

         if (argc < 2)
                 exit(EXIT_FAILURE);

         ret = snprintf(buf, sizeof(buf), "/proc/%s", argv[1]);
         if (ret < 0)
                 exit(EXIT_FAILURE);

         int fd = open(buf, O_DIRECTORY | O_CLOEXEC);
         if (fd < 0) {
                 printf("%s - Failed to open \"%s\"\n", strerror(errno), buf);
                 exit(EXIT_FAILURE);
         }

         ret = syscall(__NR_procfd_signal, fd, SIGKILL, NULL, 0);
         if (ret < 0) {
                 printf("Failed to send SIGKILL \"%s\"\n", strerror(errno));
                 close(fd);
                 exit(EXIT_FAILURE);
         }

         close(fd);

         exit(EXIT_SUCCESS);
 }

Thanks!
Christian

Christian Brauner (2):
  proc: get process file descriptor from /proc/<pid>
  signal: add procfd_signal() syscall
  procfd_signal.2: document procfd_signal syscall

 arch/x86/entry/syscalls/syscall_32.tbl |  1 +
 arch/x86/entry/syscalls/syscall_64.tbl |  1 +
 fs/proc/base.c                         | 23 ++++++++
 include/linux/proc_fs.h                |  1 +
 include/linux/syscalls.h               |  2 +
 kernel/signal.c                        | 76 ++++++++++++++++++++++++--
 6 files changed, 98 insertions(+), 6 deletions(-)

-- 
2.19.1
