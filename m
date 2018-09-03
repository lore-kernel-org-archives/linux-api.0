From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [PATCH 00/10] Removing SEND_SIG_FORCED
Date: Mon, 03 Sep 2018 22:41:13 +0200
Message-ID: <87musyl3fa.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


SEND_SIG_FORCED has two functions.  It forces a pid namespace init to
receive a signal it would ordinarily ignore, and it causes a siginfo to
not be allocated for a signal.

This patchset makes __send_signal a little bit smarter so that it can
detect when to apply these optimizations and the senders of signals
don't have to worry about them.

The coupling of forcing a signal to the pid namespace init and not
allocating siginfo resulted in serveral minor bugs where a signal
sent by the kernel was marked SI_USER suggesting another userspace
process sent that signal.  I have cc'd linux-api in case anyone cares
about these minor userspace visible differences.

Unless someone notices a bug I intend to merge these changes through my
tree during the next merge window.   While there are numerous fixes here
none of them appear to be the kind that fixes real world problems so I
don't see any urgency here.

Please look read and send my your review.  I will be out for about a
week so I will address any comments when I get back.

Eric W. Biederman (10):
      signal: Always ignore SIGKILL and SIGSTOP sent to the global init
      signal: Properly deliver SIGILL from uprobes
      signal: Properly deliver SIGSEGV from x86 uprobes
      signal: Always deliver the kernel's SIGKILL and SIGSTOP to a pid namespace init
      signal: send_sig_all no longer needs SEND_SIG_FORCED
      signal: Remove the siginfo paramater from kernel_dqueue_signal
      signal: Don't send siginfo to kthreads.
      signal: Never allocate siginfo for SIGKILL or SIGSTOP
      signal: Use SEND_SIG_PRIV not SEND_SIG_FORCED with SIGKILL and SIGSTOP
      signal: Remove SEND_SIG_FORCED

 arch/x86/kernel/uprobes.c                    |  2 +-
 drivers/tty/sysrq.c                          |  2 +-
 drivers/usb/gadget/function/f_mass_storage.c |  4 ++--
 fs/jffs2/background.c                        |  2 +-
 include/linux/sched/signal.h                 |  5 ++---
 include/trace/events/signal.h                |  3 +--
 kernel/events/uprobes.c                      |  4 ++--
 kernel/pid_namespace.c                       |  2 +-
 kernel/ptrace.c                              |  4 ++--
 kernel/signal.c                              | 14 +++++++++-----
 mm/oom_kill.c                                |  4 ++--
 11 files changed, 24 insertions(+), 22 deletions(-)

Eric
