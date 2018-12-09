From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v10 0/4] seccomp trap to userspace
Date: Sun,  9 Dec 2018 11:24:10 -0700
Message-ID: <20181209182414.30862-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Hi all,

Here's v10 of the seccomp trap to userspace series. The only changes
since v9 was to fix up a compilation error in the
!CONFIG_ARCH_HAS_SYSCALL_WRAPPER case, and to add Serge's acks.

Link to v9: https://lore.kernel.org/lkml/20181203032827.27978-1-tycho@tycho.ws/T/#u

Cheers,

Tycho

Tycho Andersen (4):
  seccomp: hoist struct seccomp_data recalculation higher
  seccomp: switch system call argument type to void *
  seccomp: add a return code to trap to userspace
  samples: add an example of seccomp user trap

 Documentation/ioctl/ioctl-number.txt          |   1 +
 .../userspace-api/seccomp_filter.rst          |  84 ++++
 include/linux/seccomp.h                       |   9 +-
 include/linux/syscalls.h                      |   2 +-
 include/uapi/linux/seccomp.h                  |  40 +-
 kernel/seccomp.c                              | 468 +++++++++++++++++-
 samples/seccomp/.gitignore                    |   1 +
 samples/seccomp/Makefile                      |   7 +-
 samples/seccomp/user-trap.c                   | 375 ++++++++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 447 ++++++++++++++++-
 10 files changed, 1411 insertions(+), 23 deletions(-)
 create mode 100644 samples/seccomp/user-trap.c

-- 
2.19.1
