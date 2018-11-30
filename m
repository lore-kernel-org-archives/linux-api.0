From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH v2 0/1] Add prctl to kill descendants on exit
Date: Fri, 30 Nov 2018 08:00:03 +0000
Message-ID: <20181130080004.23635-1-j@bitron.ch>
References: <20181127225408.7553-2-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181127225408.7553-2-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
List-Id: linux-api@vger.kernel.org

This patch adds a new prctl to kill all descendant processes on exit.
See commit message for details of the prctl.

This is a replacement of PR_SET_PDEATHSIG_PROC I proposed last year [1].
In the following discussion, Oleg suggested this approach.

The motivation for this is to provide a lightweight mechanism to prevent
stray processes. There is also a related Bugzilla entry [2].

PID namespaces can also be used to prevent stray processes, of course.
However, they are not quite as lightweight as they typically also
require a new mount namespace to be able to mount a new /proc.  And they
require CAP_SYS_ADMIN.  User namespaces can help to gain CAP_SYS_ADMIN,
however, that further increases the overhead and the other effects of
the user namespace may not be desired.

PID 1 in PID namespaces also exhibits non-standard signal behavior
(SIGNAL_UNKILLABLE) [3].

Changes in v2:
  - Use bool instead of bitfield to avoid race with
    PR_SET_CHILD_SUBREAPER

[1] https://lkml.kernel.org/lkml/20170929123058.48924-1-j@bitron.ch/
[2] https://bugzilla.kernel.org/show_bug.cgi?id=43300
[3] https://lkml.kernel.org/lkml/20180803144021.56920-2-j@bitron.ch/

Jürg Billeter (1):
  prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT

 fs/exec.c                    |  6 ++++++
 include/linux/sched/signal.h |  3 +++
 include/uapi/linux/prctl.h   |  4 ++++
 kernel/exit.c                | 12 ++++++++++++
 kernel/sys.c                 | 11 +++++++++++
 security/apparmor/lsm.c      |  1 +
 security/selinux/hooks.c     |  3 +++
 7 files changed, 40 insertions(+)

-- 
2.19.2
