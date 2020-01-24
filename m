From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH 2/4] fork: Use newly created pidfd_create_file helper
Date: Fri, 24 Jan 2020 01:17:41 -0800
Message-ID: <20200124091743.3357-3-sargun@sargun.me>
References: <20200124091743.3357-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200124091743.3357-1-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sargun Dhillon <sargun@sargun.me>, tycho@tycho.ws, christian.brauner@ubuntu.com
List-Id: linux-api@vger.kernel.org

Rather than duplicating the code to create a pidfd_file in kernel/fork.c,
use the helper in kernel/pid.c.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 kernel/fork.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 080809560072..181ab2958cad 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2106,14 +2106,12 @@ static __latent_entropy struct task_struct *copy_process(
 
 		pidfd = retval;
 
-		pidfile = anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
-					      O_RDWR | O_CLOEXEC);
+		pidfile = pidfd_create_file(pid);
 		if (IS_ERR(pidfile)) {
 			put_unused_fd(pidfd);
 			retval = PTR_ERR(pidfile);
 			goto bad_fork_free_pid;
 		}
-		get_pid(pid);	/* held by pidfile now */
 
 		retval = put_user(pidfd, args->pidfd);
 		if (retval)
-- 
2.20.1
