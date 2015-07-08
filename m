From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 2/8] lsm: smack: Make ipc/kdbus includes visible so smack
 callbacks could see them
Date: Wed, 08 Jul 2015 12:25:04 +0200
Message-ID: <1436351110-5902-3-git-send-email-p.osmialowsk@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1436351110-5902-1-git-send-email-p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lukasz Skalski <l.skalski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 security/smack/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/Makefile b/security/smack/Makefile
index ee2ebd5..bd6927c 100644
--- a/security/smack/Makefile
+++ b/security/smack/Makefile
@@ -6,3 +6,5 @@ obj-$(CONFIG_SECURITY_SMACK) := smack.o
 
 smack-y := smack_lsm.o smack_access.o smackfs.o
 smack-$(CONFIG_SECURITY_SMACK_NETFILTER) += smack_netfilter.o
+
+ccflags-y += -Iipc
-- 
1.9.1
