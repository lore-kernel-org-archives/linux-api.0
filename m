From: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 2/8] printk: add one function for storing log in proper format
Date: Fri, 03 Jul 2015 12:49:49 +0200
Message-ID: <1435920595-30879-3-git-send-email-m.niesluchow@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1435920595-30879-1-git-send-email-m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Preparation commit for future changes purpose.

Separate code responsible for storing log message in proper format
from operations on consoles by putting it in another function.

Signed-off-by: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 kernel/printk/printk.c | 183 ++++++++++++++++++++++++++-----------------------
 1 file changed, 98 insertions(+), 85 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 98f5af5..105887c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -602,6 +602,102 @@ static size_t cont_print_text(char *text, size_t size)
 	return textlen;
 }
 
+static int log_format_and_store(int facility, int level,
+				const char *dict, size_t dictlen,
+				const char *fmt, va_list args)
+{
+	static char textbuf[LOG_LINE_MAX];
+	char *text = textbuf;
+	size_t text_len = 0;
+	enum log_flags lflags = 0;
+	int printed_len = 0;
+
+	/*
+	 * The printf needs to come first; we need the syslog
+	 * prefix which might be passed-in as a parameter.
+	 */
+	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
+
+	/* mark and strip a trailing newline */
+	if (text_len && text[text_len-1] == '\n') {
+		text_len--;
+		lflags |= LOG_NEWLINE;
+	}
+
+	/* strip kernel syslog prefix and extract log level or control flags */
+	if (facility == 0) {
+		int kern_level = printk_get_level(text);
+
+		if (kern_level) {
+			const char *end_of_header = printk_skip_level(text);
+
+			switch (kern_level) {
+			case '0' ... '7':
+				if (level == LOGLEVEL_DEFAULT)
+					level = kern_level - '0';
+				/* fallthrough */
+			case 'd':	/* KERN_DEFAULT */
+				lflags |= LOG_PREFIX;
+			}
+			/*
+			 * No need to check length here because vscnprintf
+			 * put '\0' at the end of the string. Only valid and
+			 * newly printed level is detected.
+			 */
+			text_len -= end_of_header - text;
+			text = (char *)end_of_header;
+		}
+	}
+
+	if (level == LOGLEVEL_DEFAULT)
+		level = default_message_loglevel;
+
+	if (dict)
+		lflags |= LOG_PREFIX|LOG_NEWLINE;
+
+	if (!(lflags & LOG_NEWLINE)) {
+		/*
+		 * Flush the conflicting buffer. An earlier newline was missing,
+		 * or another task also prints continuation lines.
+		 */
+		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
+			cont_flush(LOG_NEWLINE);
+
+		/* buffer line if possible, otherwise store it right away */
+		if (cont_add(facility, level, text, text_len))
+			printed_len += text_len;
+		else
+			printed_len += log_store(facility, level,
+						 lflags | LOG_CONT, 0,
+						 dict, dictlen, text, text_len);
+	} else {
+		bool stored = false;
+
+		/*
+		 * If an earlier newline was missing and it was the same task,
+		 * either merge it with the current buffer and flush, or if
+		 * there was a race with interrupts (prefix == true) then just
+		 * flush it out and store this line separately.
+		 * If the preceding printk was from a different task and missed
+		 * a newline, flush and append the newline.
+		 */
+		if (cont.len) {
+			if (cont.owner == current && !(lflags & LOG_PREFIX))
+				stored = cont_add(facility, level, text,
+						  text_len);
+			cont_flush(LOG_NEWLINE);
+		}
+
+		if (stored)
+			printed_len += text_len;
+		else
+			printed_len += log_store(facility, level,
+						 lflags, 0, dict, dictlen,
+						 text, text_len);
+	}
+	return printed_len;
+}
+
 int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);
 
 static int syslog_action_restricted(int type)
@@ -1657,10 +1753,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    const char *fmt, va_list args)
 {
 	static int recursion_bug;
-	static char textbuf[LOG_LINE_MAX];
-	char *text = textbuf;
-	size_t text_len = 0;
-	enum log_flags lflags = 0;
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
@@ -1714,87 +1806,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 					 strlen(recursion_msg));
 	}
 
-	/*
-	 * The printf needs to come first; we need the syslog
-	 * prefix which might be passed-in as a parameter.
-	 */
-	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
-
-	/* mark and strip a trailing newline */
-	if (text_len && text[text_len-1] == '\n') {
-		text_len--;
-		lflags |= LOG_NEWLINE;
-	}
-
-	/* strip kernel syslog prefix and extract log level or control flags */
-	if (facility == 0) {
-		int kern_level = printk_get_level(text);
-
-		if (kern_level) {
-			const char *end_of_header = printk_skip_level(text);
-			switch (kern_level) {
-			case '0' ... '7':
-				if (level == LOGLEVEL_DEFAULT)
-					level = kern_level - '0';
-				/* fallthrough */
-			case 'd':	/* KERN_DEFAULT */
-				lflags |= LOG_PREFIX;
-			}
-			/*
-			 * No need to check length here because vscnprintf
-			 * put '\0' at the end of the string. Only valid and
-			 * newly printed level is detected.
-			 */
-			text_len -= end_of_header - text;
-			text = (char *)end_of_header;
-		}
-	}
-
-	if (level == LOGLEVEL_DEFAULT)
-		level = default_message_loglevel;
-
-	if (dict)
-		lflags |= LOG_PREFIX|LOG_NEWLINE;
-
-	if (!(lflags & LOG_NEWLINE)) {
-		/*
-		 * Flush the conflicting buffer. An earlier newline was missing,
-		 * or another task also prints continuation lines.
-		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
-			cont_flush(LOG_NEWLINE);
-
-		/* buffer line if possible, otherwise store it right away */
-		if (cont_add(facility, level, text, text_len))
-			printed_len += text_len;
-		else
-			printed_len += log_store(facility, level,
-						 lflags | LOG_CONT, 0,
-						 dict, dictlen, text, text_len);
-	} else {
-		bool stored = false;
-
-		/*
-		 * If an earlier newline was missing and it was the same task,
-		 * either merge it with the current buffer and flush, or if
-		 * there was a race with interrupts (prefix == true) then just
-		 * flush it out and store this line separately.
-		 * If the preceding printk was from a different task and missed
-		 * a newline, flush and append the newline.
-		 */
-		if (cont.len) {
-			if (cont.owner == current && !(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text,
-						  text_len);
-			cont_flush(LOG_NEWLINE);
-		}
-
-		if (stored)
-			printed_len += text_len;
-		else
-			printed_len += log_store(facility, level, lflags, 0,
-						 dict, dictlen, text, text_len);
-	}
+	printed_len += log_format_and_store(facility, level, dict, dictlen,
+					    fmt, args);
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
-- 
1.9.1
