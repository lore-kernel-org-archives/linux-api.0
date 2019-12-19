From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 079/162] fs/proc: Report eip/esp in /prod/PID/stat for coredumping
Date: Thu, 19 Dec 2019 19:33:07 +0100
Message-ID: <20191219183212.607563852@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Marco Felsch <marco.felsch@preh.de>, John Ogness <john.ogness@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho.andersen@canonical.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, "zhangyi (F)" <yi.zhang@huawei.com>
List-Id: linux-api@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

commit fd7d56270b526ca3ed0c224362e3c64a0f86687a upstream.

Commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in
/proc/PID/stat") stopped reporting eip/esp because it is
racy and dangerous for executing tasks. The comment adds:

    As far as I know, there are no use programs that make any
    material use of these fields, so just get rid of them.

However, existing userspace core-dump-handler applications (for
example, minicoredumper) are using these fields since they
provide an excellent cross-platform interface to these valuable
pointers. So that commit introduced a user space visible
regression.

Partially revert the change and make the readout possible for
tasks with the proper permissions and only if the target task
has the PF_DUMPCORE flag set.

Fixes: 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in> /proc/PID/stat")
Reported-by: Marco Felsch <marco.felsch@preh.de>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Cc: Tycho Andersen <tycho.andersen@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux API <linux-api@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/87poatfwg6.fsf@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ zhangyi: 68db0cf10678 does not merged, skip the task_stack.h for 4.4]
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/array.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -429,7 +429,15 @@ static int do_task_stat(struct seq_file
 		 * esp and eip are intentionally zeroed out.  There is no
 		 * non-racy way to read them without freezing the task.
 		 * Programs that need reliable values can use ptrace(2).
+		 *
+		 * The only exception is if the task is core dumping because
+		 * a program is not able to use ptrace(2) in that case. It is
+		 * safe because the task has stopped executing permanently.
 		 */
+		if (permitted && (task->flags & PF_DUMPCORE)) {
+			eip = KSTK_EIP(task);
+			esp = KSTK_ESP(task);
+		}
 	}
 
 	get_task_comm(tcomm, task);
