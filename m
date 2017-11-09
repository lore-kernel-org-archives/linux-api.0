From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v3 5/7] proc: move hidepid definitions to proc files
Date: Thu,  9 Nov 2017 17:14:04 +0100
Message-ID: <1510244046-3256-6-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

This moves the 'hidepid' definitions to proc files. The 'hidepid' is a
proc mount option, not really a per pid namespace value. It was there
since it was used inside PID namespaces, however now we have improved
proc logic and reduce the complexity and ties with PID namespaces lets
move this last bit to where it really belongs.

Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 include/linux/pid_namespace.h | 6 ------
 include/linux/proc_fs.h       | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 786ea04..66f47f1 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,12 +15,6 @@
 
 struct fs_pin;
 
-enum { /* definitions for pid_namespace's hide_pid field */
-	HIDEPID_OFF	  = 0,
-	HIDEPID_NO_ACCESS = 1,
-	HIDEPID_INVISIBLE = 2,
-};
-
 struct pid_namespace {
 	struct kref kref;
 	struct idr idr;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 408b51d..c123e5ec 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -12,6 +12,12 @@
 struct proc_dir_entry;
 struct pid_namespace;
 
+enum { /* definitions for 'hidepid' mount option */
+	HIDEPID_OFF	  = 0,
+	HIDEPID_NO_ACCESS = 1,
+	HIDEPID_INVISIBLE = 2,
+};
+
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self; /* For /proc/self/ */
-- 
2.7.4
