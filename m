From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 16/36] uapi linux/dlm_netlink.h: include linux/dlmconstants.h
Date: Sun,  6 Aug 2017 18:44:07 +0200
Message-ID: <20170806164428.2273-17-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Christine Caulfield <ccaulfie@redhat.com>, David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: ‘DLM_RESNAME_MAXLEN’ undeclared here (not in a function)
  char resource_name[DLM_RESNAME_MAXLEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
---
 include/uapi/linux/dlm_netlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dlm_netlink.h b/include/uapi/linux/dlm_netlink.h
index 647c8ef27227..ef1e2e08769a 100644
--- a/include/uapi/linux/dlm_netlink.h
+++ b/include/uapi/linux/dlm_netlink.h
@@ -10,6 +10,7 @@
 #define _DLM_NETLINK_H
 
 #include <linux/types.h>
+#include <linux/dlmconstants.h>
 
 enum {
 	DLM_STATUS_WAITING = 1,
-- 
2.13.3
