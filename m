From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 1/8] lsm: make security_file_receive available for external
 modules
Date: Wed, 08 Jul 2015 12:25:03 +0200
Message-ID: <1436351110-5902-2-git-send-email-p.osmialowsk@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

From: Karol Lewandowski <k.lewandowsk@samsung.com>

This is required for using filedesc related LSM hooks in kdbus code
if it is built as a module.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
---
 security/security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/security.c b/security/security.c
index 595fffa..b1e935b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -837,6 +837,7 @@ int security_file_receive(struct file *file)
 {
 	return call_int_hook(file_receive, 0, file);
 }
+EXPORT_SYMBOL(security_file_receive);
 
 int security_file_open(struct file *file, const struct cred *cred)
 {
-- 
1.9.1
