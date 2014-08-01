From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [REVIEW][PATCH 1/4] proc: Have net show up under /proc/<tgid>/task/<tid>
Date: Thu, 31 Jul 2014 17:33:27 -0700
Message-ID: <87ha1xcalk.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 31 Jul 2014 17:30:46 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-api@vger.kernel.org, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Network namespaces are per task so it make sense for them to show up
in the task directory.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0c93bf..ed34e405c6b9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2895,6 +2895,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
+#ifdef CONFIG_NET
+	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
+#endif
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
-- 
1.9.1

