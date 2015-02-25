From: Scot Doyle <lkml14@scotdoyle.com>
Subject: Re: [PATCH 2/2] fbcon: expose cursor blink interval via sysfs
Date: Wed, 25 Feb 2015 23:32:00 +0000 (UTC)
Message-ID: <alpine.LNX.2.11.1502252319330.276@localhost>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150225094946.GA24627@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 25 Feb 2015, Pavel Machek wrote:
> On Mon 2015-01-26 20:41:53, Scot Doyle wrote:
> > The fbcon cursor, when set to blink, is hardcoded to toggle display state
> > five times per second. Expose this setting via
> > /sys/class/graphics/fbcon/cursor_blink_ms
> > 
> > Values written to the interface set the approximate time interval in
> > milliseconds between cursor toggles, from 1 to 32767. Since the interval
> > is stored internally as a number of jiffies, the millisecond value read
> > from the interface may not exactly match the entered value.
> > 
> > An outstanding blink timer is reset after a new value is entered.
> > 
> > If the cursor blink is disabled, either via the 'cursor_blink' boolean
> > setting or some other mechanism, the 'cursor_blink_ms' setting may still
> > be modified. The new value will be used if the blink is reactivated.
> > 
> > Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> 
> Normally, this would be set by ansi escape sequences, no? We can hide
> cursor using them, set its appearance.. makes sense to change timing
> value there, too....
> 									Pavel

Hi Pavel, what about something like this? For example,
"echo -e '\033[16;500]' would set the blink interval to 500 milliseconds.

The duration is stored twice to avoid locking the console in
cursor_timer_handler().


diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 6e00572..f117966 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -135,6 +135,7 @@ const struct consw *conswitchp;
  */
 #define DEFAULT_BELL_PITCH	750
 #define DEFAULT_BELL_DURATION	(HZ/8)
+#define DEFAULT_CURSOR_BLINK_MS	200
 
 struct vc vc_cons [MAX_NR_CONSOLES];
 
@@ -1590,6 +1591,13 @@ static void setterm_command(struct vc_data *vc)
 		case 15: /* activate the previous console */
 			set_console(last_console);
 			break;
+		case 16: /* set cursor blink duration in msec */
+			if (vc->vc_npar >= 1 && vc->vc_par[1] > 0 &&
+					vc->vc_par[1] <= USHRT_MAX)
+				vc->vc_cur_blink_ms = vc->vc_par[1];
+			else
+				vc->vc_cur_blink_ms = DEFAULT_CURSOR_BLINK_MS;
+			break;
 	}
 }
 
@@ -1717,6 +1725,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 
 	vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
 	vc->vc_bell_duration = DEFAULT_BELL_DURATION;
+	vc->vc_cur_blink_ms = DEFAULT_CURSOR_BLINK_MS;
 
 	gotoxy(vc, 0, 0);
 	save_cur(vc);
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
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index e859c98..e329ee2 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -104,6 +104,7 @@ struct vc_data {
 	unsigned int    vc_resize_user;         /* resize request from user */
 	unsigned int	vc_bell_pitch;		/* Console bell pitch */
 	unsigned int	vc_bell_duration;	/* Console bell duration */
+	unsigned short	vc_cur_blink_ms;	/* Cursor blink duration */
 	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
 	struct uni_pagedir *vc_uni_pagedir;
 	struct uni_pagedir **vc_uni_pagedir_loc; /* [!] Location of uni_pagedir variable for this console */
