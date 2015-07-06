From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/24] kernel: make taskstats available from all net namespaces
Date: Mon,  6 Jul 2015 11:47:04 +0300
Message-ID: <1436172445-6979-4-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/taskstats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index d70f1e5..0c90d11 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -47,6 +47,7 @@ struct genl_family taskstats_family = {
 	.name		= TASKSTATS_GENL_NAME,
 	.version	= TASKSTATS_GENL_VERSION,
 	.maxattr	= TASKSTATS_CMD_ATTR_MAX,
+	.netnsok	= true,
 };
 
 static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
-- 
2.1.0
