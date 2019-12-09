From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v2 0/4] Add ptrace get_fd request
Date: Mon, 9 Dec 2019 07:04:50 +0000
Message-ID: <20191209070446.GA32336@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

This patchest introduces a mechanism to capture file descriptors from other
processes via ptrace. Although this can be achieved using SCM_RIGHTS, and
parasitic code injection, this offers a slightly more straightforward
mechainsm. It also does not mutate the tracee in any way, nor does it
require that the tracee is stopped, as to avoid causing issues with
attaching debuggers or runtimes that expect syscalls to be preemptible, or
return within a specific amount of time.

It has an options mechanism that's only usable to set CLOEXEC on the fd,
but I'm thinking that it could be extended to other aspects. For example,
for sockets, one could want to scrub the cgroup information.

In the future, the API may not require ptrace attachment, or seizing, but
right now it does as a matter of safety.

Changes since the RFC v1:

 * Introduce a new helper to fs/file.c to fetch a file descriptor from
   any process. It largely uses the code suggested by Oleg, with a few
   changes to fix locking
 * It uses an extensible options struct to supply the FD, and option.
 * I added a sample, using the code from the user-ptrace sample

Sargun Dhillon (4):
  vfs, fdtable: Add get_task_file helper
  ptrace: add PTRACE_GETFD request to fetch file descriptors from
    tracees
  samples: split generalized user-trap code into helper file
  samples: Add example of using PTRACE_GETFD in conjunction with user
    trap

 fs/file.c                          |  19 +++
 include/linux/fdtable.h            |  10 ++
 include/uapi/linux/ptrace.h        |  15 +++
 kernel/ptrace.c                    |  35 +++++-
 samples/seccomp/.gitignore         |   1 +
 samples/seccomp/Makefile           |  15 ++-
 samples/seccomp/user-trap-helper.c |  84 +++++++++++++
 samples/seccomp/user-trap-helper.h |  13 ++
 samples/seccomp/user-trap-ptrace.c | 193 +++++++++++++++++++++++++++++
 samples/seccomp/user-trap.c        |  85 +------------
 10 files changed, 382 insertions(+), 88 deletions(-)
 create mode 100644 samples/seccomp/user-trap-helper.c
 create mode 100644 samples/seccomp/user-trap-helper.h
 create mode 100644 samples/seccomp/user-trap-ptrace.c

-- 
2.20.1
