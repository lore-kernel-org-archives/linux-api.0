From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v5 0/1] signaling processes through pidfds
Date: Sat,  8 Dec 2018 06:40:58 +0100
Message-ID: <20181208054059.19813-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, serge@hallyn.com, keescook@chromium.org
Cc: jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey everyone,

This is v5 of this patchset.
v5 does not introduce any functional changes since none were requested
or required in the thread. Instead, it focusses on updated documentation
making it very clear what the intentions are how to extend this syscall.

Eric, I dragged Serge into this and we went through the mails and tried
to very thoroughly address your concerns about whether the width of the
target should depend on flags or file descriptor types. As far as we
understand from the threads this was your ultimate worry and also the
reason why you withheld your agreement to the name of the syscall.
We have outlined how the syscall is intended to be extended and decided
that flags (e.g. PIDFD_TYPE_TID, PIDFD_TYPE_PGID) are the way to go. In
line with this we decided to accept "pidfd_" as prefix for the new
syscall.
All concerns we could identify and understand we tried to address. I
hope this will be sufficient for you to get behind the patch.
The relevant section in the commit message is titled:

/* sending signals to threads (tid) and process groups (pgid) */

Thanks!
Christian

Christian Brauner (1):
  signal: add pidfd_send_signal() syscall

 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/proc/base.c                         |  20 +++-
 include/linux/proc_fs.h                |  12 +++
 include/linux/syscalls.h               |   3 +
 include/uapi/asm-generic/unistd.h      |   4 +-
 kernel/signal.c                        | 141 +++++++++++++++++++++++--
 7 files changed, 173 insertions(+), 9 deletions(-)

-- 
2.19.1
