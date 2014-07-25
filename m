From: David Drysdale <drysdale@google.com>
Subject: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
Date: Fri, 25 Jul 2014 14:47:07 +0100
Message-ID: <1406296033-32693-12-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add the current thread and thread group IDs into the data
available for seccomp-bpf programs to work on.  This allows
installation of filters that police syscalls based on thread
or process ID, e.g. tgkill(2)/kill(2)/prctl(2).

Signed-off-by: David Drysdale <drysdale@google.com>
---
 include/uapi/linux/seccomp.h | 10 ++++++++++
 kernel/seccomp.c             |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index ac2dc9f72973..b88370d6f6ca 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -36,12 +36,22 @@
  * @instruction_pointer: at the time of the system call.
  * @args: up to 6 system call arguments always stored as 64-bit values
  *        regardless of the architecture.
+ * @tgid: thread group ID of the thread executing the BPF program.
+ * @tid: thread ID of the thread executing the BPF program.
+ * The SECCOMP_DATA_TID_PRESENT macro indicates the presence of the
+ * tgid and tid fields; user programs may use this macro to conditionally
+ * compile code against older versions of the kernel.  Note also that
+ * BPF programs should cope with the absence of these fields by testing
+ * the length of data available.
  */
 struct seccomp_data {
 	int nr;
 	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 args[6];
+	__u32 tgid;
+	__u32 tid;
 };
+#define SECCOMP_DATA_TID_PRESENT	1
 
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 301bbc24739c..dd5146f15d6d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -80,6 +80,8 @@ static void populate_seccomp_data(struct seccomp_data *sd)
 	sd->args[4] = args[4];
 	sd->args[5] = args[5];
 	sd->instruction_pointer = KSTK_EIP(task);
+	sd->tgid = task_tgid_vnr(current);
+	sd->tid = task_pid_vnr(current);
 }
 
 /**
-- 
2.0.0.526.g5318336

