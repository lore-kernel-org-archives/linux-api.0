From: Nicolas Belouin <nicolas@belouin.fr>
Subject: [PATCH] fs: check for CAP_SYS_RESOURCE instead of CAP_SYS_ADMIN
Date: Sat, 21 Oct 2017 15:36:06 +0200
Message-ID: <20171021133606.18866-1-nicolas@belouin.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Nicolas Belouin <nicolas@belouin.fr>
List-Id: linux-api@vger.kernel.org

This check is meant to allow a privileged process to go above max_files,
such a check must be done against CAP_SYS_RESOURCE as its role is to
allow resources limits override.

Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
---
 fs/file_table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 61517f57f8ef..4bc74fd50838 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -111,7 +111,8 @@ struct file *get_empty_filp(void)
 	/*
 	 * Privileged users can go above max_files
 	 */
-	if (get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN)) {
+	if (get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN) &&
+	    !capable(CAP_SYS_RESOURCE)) {
 		/*
 		 * percpu_counters are inaccurate.  Do an expensive check before
 		 * we go and fail.
-- 
2.14.2
