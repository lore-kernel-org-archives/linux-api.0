From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v9 0/4] seccomp trap to userspace
Date: Sun,  2 Dec 2018 20:28:23 -0700
Message-ID: <20181203032827.27978-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Hi all,

Here's a v9 of the seccomp trap to userspace series. Major changes are:

* drop the whole SIGNALED flag thing. This was confusing to a number of
  people, and Oleg pointed out that it makes it fairly easy to get a
  task into an uninterruptible sleep. Now, replies to a task with a
  signal will just get ENOENT, indicating that something happened to the
  other end.
* refactor the tests so that each test tests only one thing :)
* several other minor bug fixes

Cheers,

Tycho

Link to v8: https://lore.kernel.org/lkml/20181029224031.29809-1-tycho@tycho.ws/T/#u

Tycho Andersen (4):
  seccomp: hoist struct seccomp_data recalculation higher
  seccomp: switch system call argument type to void *
  seccomp: add a return code to trap to userspace
  samples: add an example of seccomp user trap

 Documentation/ioctl/ioctl-number.txt          |   1 +
 .../userspace-api/seccomp_filter.rst          |  84 ++++
 include/linux/seccomp.h                       |   9 +-
 include/uapi/linux/seccomp.h                  |  40 +-
 kernel/seccomp.c                              | 468 +++++++++++++++++-
 samples/seccomp/.gitignore                    |   1 +
 samples/seccomp/Makefile                      |   7 +-
 samples/seccomp/user-trap.c                   | 375 ++++++++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 447 ++++++++++++++++-
 9 files changed, 1410 insertions(+), 22 deletions(-)
 create mode 100644 samples/seccomp/user-trap.c

-- 
2.19.1
