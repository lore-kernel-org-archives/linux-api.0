From: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 2/2] fbcon: use the cursor blink interval provided by vt
Date: Fri, 27 Feb 2015 19:15:48 +0000 (UTC)
Message-ID: <alpine.LNX.2.11.1502271914040.4248@localhost>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd>
 <alpine.LNX.2.11.1502271905580.4212@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.11.1502271905580.4212@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

vt now provides a cursor blink interval via vc_data. Use this
interval instead of the currently hardcoded 200 msecs. Store it in
fbcon_ops to avoid locking the console in cursor_timer_handler().

Signed-off-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
---
 drivers/video/console/fbcon.c | 10 +++++-----
 drivers/video/console/fbcon.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index b972106..05b1d1a 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -402,7 +402,7 @@ static void cursor_timer_handler(unsigned long dev_addr)
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	queue_work(system_power_efficient_wq, &info->queue);
-	mod_timer(&ops->cursor_timer, jiffies + HZ/5);
+	mod_timer(&ops->cursor_timer, jiffies + ops->cur_blink_jiffies);
 }
 
 static void fbcon_add_cursor_timer(struct fb_info *info)
@@ -417,7 +417,7 @@ static void fbcon_add_cursor_timer(struct fb_info *info)
 
 		init_timer(&ops->cursor_timer);
 		ops->cursor_timer.function = cursor_timer_handler;
-		ops->cursor_timer.expires = jiffies + HZ / 5;
+		ops->cursor_timer.expires = jiffies + ops->cur_blink_jiffies;
 		ops->cursor_timer.data = (unsigned long ) info;
 		add_timer(&ops->cursor_timer);
 		ops->flags |= FBCON_FLAGS_CURSOR_TIMER;
@@ -1309,9 +1309,9 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
 
-	if (vc->vc_cursor_type & 0x10)
-		fbcon_del_cursor_timer(info);
-	else
+	ops->cur_blink_jiffies = msecs_to_jiffies(vc->vc_cur_blink_ms);
+	fbcon_del_cursor_timer(info);
+	if (!(vc->vc_cursor_type & 0x10))
 		fbcon_add_cursor_timer(info);
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 6bd2e0c..7aaa4ea 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -70,6 +70,7 @@ struct fbcon_ops {
 	struct fb_cursor cursor_state;
 	struct display *p;
         int    currcon;	                /* Current VC. */
+	int    cur_blink_jiffies;
 	int    cursor_flash;
 	int    cursor_reset;
 	int    blank_state;
-- 
2.3.0
