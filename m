From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v6 0/5] seccomp trap to userspace
Date: Thu,  6 Sep 2018 09:28:54 -0600
Message-ID: <20180906152859.7810-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Hi all,

Here's a v6 of the seccomp trap to userspace series. v5 [1] was fairly
quiet, with Christian reminding me that I had forgotten to update the
docs for the ioctl change. Other than that, there are no changes.

[1]: https://lkml.org/lkml/2018/8/28/590

Thoughts welcome,

Tycho

Tycho Andersen (5):
  seccomp: add a return code to trap to userspace
  seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
  seccomp: add a way to get a listener fd from ptrace
  seccomp: add support for passing fds via USER_NOTIF
  samples: add an example of seccomp user trap

 Documentation/ioctl/ioctl-number.txt          |   1 +
 .../userspace-api/seccomp_filter.rst          |  84 +++
 arch/Kconfig                                  |   9 +
 include/linux/seccomp.h                       |  18 +-
 include/uapi/linux/ptrace.h                   |   2 +
 include/uapi/linux/seccomp.h                  |  36 +-
 kernel/ptrace.c                               |   4 +
 kernel/seccomp.c                              | 538 +++++++++++++++-
 samples/seccomp/.gitignore                    |   1 +
 samples/seccomp/Makefile                      |   7 +-
 samples/seccomp/user-trap.c                   | 312 ++++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 587 +++++++++++++++++-
 12 files changed, 1586 insertions(+), 13 deletions(-)
 create mode 100644 samples/seccomp/user-trap.c

-- 
2.17.1
