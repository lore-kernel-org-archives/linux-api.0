From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v5 0/5] seccomp trap to userspace
Date: Tue, 28 Aug 2018 08:35:58 -0600
Message-ID: <20180828143603.8127-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Hi all,

Here's v5 of the seccomp user set. Major changes from v4 include:

* switching to ioctl vs read/write
* adding a way to query whether a notification id is valid
* added a sample program that shows a complete usage of the API w/ notes
  about various TOCTOUs

as well as a bunch of smaller fixes. See individual patch notes for
details.

Thanks,

Tycho

Tycho Andersen (5):
  seccomp: add a return code to trap to userspace
  seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
  seccomp: add a way to get a listener fd from ptrace
  seccomp: add support for passing fds via USER_NOTIF
  samples: add an example of seccomp user trap

 Documentation/ioctl/ioctl-number.txt          |   1 +
 .../userspace-api/seccomp_filter.rst          |  80 +++
 arch/Kconfig                                  |   9 +
 include/linux/seccomp.h                       |  18 +-
 include/uapi/linux/ptrace.h                   |   2 +
 include/uapi/linux/seccomp.h                  |  36 +-
 kernel/ptrace.c                               |   4 +
 kernel/seccomp.c                              | 538 +++++++++++++++-
 samples/seccomp/.gitignore                    |   1 +
 samples/seccomp/Makefile                      |   9 +-
 samples/seccomp/user-trap.c                   | 312 ++++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 587 +++++++++++++++++-
 12 files changed, 1584 insertions(+), 13 deletions(-)
 create mode 100644 samples/seccomp/user-trap.c

-- 
2.17.1
