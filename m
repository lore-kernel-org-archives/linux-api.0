From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/5] security: export security_file_receive for modules
Date: Fri, 31 Oct 2014 17:36:34 +0100
Message-ID: <1414773397-26490-3-git-send-email-k.lewandowsk@samsung.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: pmoore@redhat.com, jkosina@suse.cz, linux-api@vger.kernel.org, inux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk, daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com, marcel@holtmann.org, tixxdz@opendz.org, javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk, linux-security-module@vger.kernel.org, lmctlx@gmail.com, r.krypa@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>
List-Id: linux-api@vger.kernel.org

This is required for kdbus built as module.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
---
 security/security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/security.c b/security/security.c
index e41b1a8..d29b28b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -790,6 +790,7 @@ int security_file_receive(struct file *file)
 {
 	return security_ops->file_receive(file);
 }
+EXPORT_SYMBOL(security_file_receive);
 
 int security_file_open(struct file *file, const struct cred *cred)
 {
-- 
2.1.1

