From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 1/3] Add missing accounting calls to compat_sys_{readv,writev}.
Date: Mon, 15 Dec 2008 12:36:15 +0100
Message-ID: <1229340977-24345-2-git-send-email-kraxel@redhat.com>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org


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
