From: y@redhat.com
Subject: [Patch v5 1/6] Add missing accounting calls to compat_sys_{readv,writev}.
Date: Fri, 19 Dec 2008 16:58:20 +0100
Message-ID: <27068.7220422134$1229702505@news.gmane.org>
References: <1229702305-23027-1-git-send-email-y>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752070AbYLSP7S@vger.kernel.org>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Note: unrelated bugfix spotted during preadv review,
  included for completeness, akpm picked it into -mm already. ]

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index e5f49f5..aab2234 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1187,6 +1187,9 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsign
 	ret = compat_do_readv_writev(READ, file, vec, vlen, &file->f_pos);
 
 out:
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
 	fput(file);
 	return ret;
 }
@@ -1210,6 +1213,9 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsig
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
 
 out:
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
 	fput(file);
 	return ret;
 }
-- 
1.5.6.5
