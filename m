From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v8 0/2] seccomp trap to userspace
Date: Mon, 29 Oct 2018 16:40:29 -0600
Message-ID: <20181029224031.29809-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

Hi everyone,

Here's v8 of the seccomp trap to userspace series. Major changes are:

* dropped the ptrace API all together. I believe based on the last
  thread that it could be made safe by adding a check on the refcount of
  the filter when grabbing it, but that sort of feels like a hack and
  it's not strictly necessary, so I dropped it.
* dropped the fd passing bits (for now). I like Andy's API proposal, and
  there are a few ways to implement it, but how exactly is
  controversial, and the stuff I'm really interested in using this for
  doesn't need the fd passing bits.
* applied all the feedback from v7 (I think, there was a lot of it :)

Link to v7: https://lkml.org/lkml/2018/9/27/968

Cheers,

Tycho

Tycho Andersen (2):
  seccomp: add a return code to trap to userspace
  samples: add an example of seccomp user trap

 Documentation/ioctl/ioctl-number.txt          |   1 +
 .../userspace-api/seccomp_filter.rst          |  66 +++
 include/linux/seccomp.h                       |   7 +-
 include/uapi/linux/seccomp.h                  |  35 +-
 kernel/seccomp.c                              | 475 +++++++++++++++++-
 samples/seccomp/.gitignore                    |   1 +
 samples/seccomp/Makefile                      |   7 +-
 samples/seccomp/user-trap.c                   | 345 +++++++++++++
 tools/testing/selftests/seccomp/foo           | 106 ++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 355 ++++++++++++-
 10 files changed, 1387 insertions(+), 11 deletions(-)
 create mode 100644 samples/seccomp/user-trap.c
 create mode 100644 tools/testing/selftests/seccomp/foo

-- 
2.17.1
