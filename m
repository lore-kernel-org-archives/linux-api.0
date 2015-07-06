From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 14/24] task_diag: add a marcos to enumirate memory mappings
Date: Mon,  6 Jul 2015 11:47:15 +0300
Message-ID: <1436172445-6979-15-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

This macros will help users to use this interface.

v2: Fix task_diag_for_each_vma to work with libnl // David Ahern

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/task_diag.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/task_diag.h b/include/uapi/linux/task_diag.h
index 73d33c8..9e4c3c4 100644
--- a/include/uapi/linux/task_diag.h
+++ b/include/uapi/linux/task_diag.h
@@ -143,6 +143,11 @@ static inline struct task_diag_vma_stat *task_diag_vma_stat(struct task_diag_vma
 	return ((void *)vma) + vma->stat_off;
 }
 
+#define task_diag_for_each_vma(vma, attr)			\
+	for (vma = nla_data(attr);				\
+		(void *) vma < nla_data(attr) + nla_len(attr);	\
+		vma = (void *) vma + vma->vma_len)
+
 #define TASK_DIAG_DUMP_ALL	0
 #define TASK_DIAG_DUMP_CHILDREN	1
 
-- 
2.1.0
