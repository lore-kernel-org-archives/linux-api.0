From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Subject: [tip:mm/urgent] fs/proc: Stop reporting eip and esp in
 /proc/PID/stat
Date: Thu, 20 Oct 2016 04:13:20 -0700
Message-ID: <tip-0a1eb2d474edfe75466be6b4677ad84e5e8ca3f5@git.kernel.org>
References: <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
Reply-To: torvalds@linux-foundation.org, jann@thejh.net,
          tycho.andersen@canonical.com, viro@zeniv.linux.org.uk,
          peterz@infradead.org, bp@alien8.de, luto@kernel.org,
          keescook@chromium.org, mingo@kernel.org,
          akpm@linux-foundation.org, tglx@linutronix.de,
          linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
          brgerst@gmail.com, linux-api@vger.kernel.org, hpa@zytor.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: brgerst@gmail.com, penguin-kernel@i-love.sakura.ne.jp, hpa@zytor.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tglx@linutronix.de, luto@kernel.org, keescook@chromium.org, mingo@kernel.org, bp@alien8.de, peterz@infradead.org, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, tycho.andersen@canonical.com, jann@thejh.net
List-Id: linux-api@vger.kernel.org

Commit-ID:  0a1eb2d474edfe75466be6b4677ad84e5e8ca3f5
Gitweb:     http://git.kernel.org/tip/0a1eb2d474edfe75466be6b4677ad84e5e8ca3f5
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Fri, 30 Sep 2016 10:58:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Oct 2016 09:21:41 +0200

fs/proc: Stop reporting eip and esp in /proc/PID/stat

Reporting these fields on a non-current task is dangerous.  If the
task is in any state other than normal kernel code, they may contain
garbage or even kernel addresses on some architectures.  (x86_64
used to do this.  I bet lots of architectures still do.)  With
CONFIG_THREAD_INFO_IN_TASK=y, it can OOPS, too.

As far as I know, there are no use programs that make any material
use of these fields, so just get rid of them.

Reported-by: Jann Horn <jann@thejh.net>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Tycho Andersen <tycho.andersen@canonical.com>
Link: http://lkml.kernel.org/r/a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/proc/array.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 89600fd..81818ad 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -412,10 +412,11 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
-		if (permitted) {
-			eip = KSTK_EIP(task);
-			esp = KSTK_ESP(task);
-		}
+		/*
+		 * esp and eip are intentionally zeroed out.  There is no
+		 * non-racy way to read them without freezing the task.
+		 * Programs that need reliable values can use ptrace(2).
+		 */
 	}
 
 	get_task_comm(tcomm, task);
