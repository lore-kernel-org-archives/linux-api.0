From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v3 0/4] Add pidfd getfd ioctl (Was Add ptrace get_fd request)
Date: Tue, 17 Dec 2019 00:58:45 +0000
Message-ID: <20191217005842.GA14379@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

This patchset introduces a mechanism to capture file descriptors from other
processes by pidfd and ioctl. Although this can be achieved using
SCM_RIGHTS, and parasitic code injection, this offers a more
straightforward mechanism.

It has a flags mechanism that's only usable to set CLOEXEC on the fd,
but I'm thinking that it could be extended to other aspects. For example,
for sockets, one could want to scrub the cgroup information.

Changes since v2:
 * Move to ioctl on pidfd instead of ptrace function
 * Add security check before moving file descriptor

Changes since the RFC v1:
 * Introduce a new helper to fs/file.c to fetch a file descriptor from
   any process. It largely uses the code suggested by Oleg, with a few
   changes to fix locking
 * It uses an extensible options struct to supply the FD, and option.
 * I added a sample, using the code from the user-ptrace sample

Sargun Dhillon (4):
  vfs, fdtable: Add get_task_file helper
  pid: Add PIDFD_IOCTL_GETFD to fetch file descriptors from processes
  samples: split generalized user-trap code into helper file
  samples: Add example of using pidfd getfd in conjunction with user
    trap

 Documentation/ioctl/ioctl-number.rst |   1 +
 fs/file.c                            |  22 +++-
 include/linux/file.h                 |   2 +
 include/linux/pid.h                  |   1 +
 include/uapi/linux/pid.h             |  26 ++++
 kernel/fork.c                        |  72 ++++++++++
 samples/seccomp/.gitignore           |   1 +
 samples/seccomp/Makefile             |  15 ++-
 samples/seccomp/user-trap-helper.c   |  84 ++++++++++++
 samples/seccomp/user-trap-helper.h   |  13 ++
 samples/seccomp/user-trap-pidfd.c    | 190 +++++++++++++++++++++++++++
 samples/seccomp/user-trap.c          |  85 +-----------
 12 files changed, 424 insertions(+), 88 deletions(-)
 create mode 100644 include/uapi/linux/pid.h
 create mode 100644 samples/seccomp/user-trap-helper.c
 create mode 100644 samples/seccomp/user-trap-helper.h
 create mode 100644 samples/seccomp/user-trap-pidfd.c

-- 
2.20.1
