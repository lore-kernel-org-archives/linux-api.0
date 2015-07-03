From: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 1/8] printk: move code regarding log message storing format
Date: Fri, 03 Jul 2015 12:49:48 +0200
Message-ID: <1435920595-30879-2-git-send-email-m.niesluchow@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1435920595-30879-1-git-send-email-m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Preparation commit for future changes purpose.

Moves some code responsible for storing log messages in proper format.

Signed-off-by: Marcin Niesluchowski <m.niesluchow-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 kernel/printk/printk.c | 254 ++++++++++++++++++++++++-------------------------
 1 file changed, 127 insertions(+), 127 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cf8c242..98f5af5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -475,6 +475,133 @@ static int log_store(int facility, int level,
 	return msg->text_len;
 }
 
+static bool printk_time = IS_ENABLED(CONFIG_PRINTK_TIME);
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
+
+static size_t print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	if (!printk_time)
+		return 0;
+
+	rem_nsec = do_div(ts, 1000000000);
+
+	if (!buf)
+		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
+
+	return sprintf(buf, "[%5lu.%06lu] ",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
+/*
+ * Continuation lines are buffered, and not committed to the record buffer
+ * until the line is complete, or a race forces it. The line fragments
+ * though, are printed immediately to the consoles to ensure everything has
+ * reached the console in case of a kernel crash.
+ */
+static struct cont {
+	char buf[LOG_LINE_MAX];
+	size_t len;			/* length == 0 means unused buffer */
+	size_t cons;			/* bytes written to console */
+	struct task_struct *owner;	/* task of first print*/
+	u64 ts_nsec;			/* time of first print */
+	u8 level;			/* log level of first message */
+	u8 facility;			/* log facility of first message */
+	enum log_flags flags;		/* prefix, newline flags */
+	bool flushed:1;			/* buffer sealed and committed */
+} cont;
+
+static void cont_flush(enum log_flags flags)
+{
+	if (cont.flushed)
+		return;
+	if (cont.len == 0)
+		return;
+
+	if (cont.cons) {
+		/*
+		 * If a fragment of this line was directly flushed to the
+		 * console; wait for the console to pick up the rest of the
+		 * line. LOG_NOCONS suppresses a duplicated output.
+		 */
+		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
+			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
+		cont.flags = flags;
+		cont.flushed = true;
+	} else {
+		/*
+		 * If no fragment of this line ever reached the console,
+		 * just submit it to the store and free the buffer.
+		 */
+		log_store(cont.facility, cont.level, flags, 0,
+			  NULL, 0, cont.buf, cont.len);
+		cont.len = 0;
+	}
+}
+
+static bool cont_add(int facility, int level, const char *text, size_t len)
+{
+	if (cont.len && cont.flushed)
+		return false;
+
+	/*
+	 * If ext consoles are present, flush and skip in-kernel
+	 * continuation.  See nr_ext_console_drivers definition.  Also, if
+	 * the line gets too long, split it up in separate records.
+	 */
+	if (nr_ext_console_drivers || cont.len + len > sizeof(cont.buf)) {
+		cont_flush(LOG_CONT);
+		return false;
+	}
+
+	if (!cont.len) {
+		cont.facility = facility;
+		cont.level = level;
+		cont.owner = current;
+		cont.ts_nsec = local_clock();
+		cont.flags = 0;
+		cont.cons = 0;
+		cont.flushed = false;
+	}
+
+	memcpy(cont.buf + cont.len, text, len);
+	cont.len += len;
+
+	if (cont.len > (sizeof(cont.buf) * 80) / 100)
+		cont_flush(LOG_CONT);
+
+	return true;
+}
+
+static size_t cont_print_text(char *text, size_t size)
+{
+	size_t textlen = 0;
+	size_t len;
+
+	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
+		textlen += print_time(cont.ts_nsec, text);
+		size -= textlen;
+	}
+
+	len = cont.len - cont.cons;
+	if (len > 0) {
+		if (len+1 > size)
+			len = size-1;
+		memcpy(text + textlen, cont.buf + cont.cons, len);
+		textlen += len;
+		cont.cons = cont.len;
+	}
+
+	if (cont.flushed) {
+		if (cont.flags & LOG_NEWLINE)
+			text[textlen++] = '\n';
+		/* got everything, release buffer */
+		cont.len = 0;
+	}
+	return textlen;
+}
+
 int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);
 
 static int syslog_action_restricted(int type)
@@ -1030,25 +1157,6 @@ static inline void boot_delay_msec(int level)
 }
 #endif
 
-static bool printk_time = IS_ENABLED(CONFIG_PRINTK_TIME);
-module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
-
-static size_t print_time(u64 ts, char *buf)
-{
-	unsigned long rem_nsec;
-
-	if (!printk_time)
-		return 0;
-
-	rem_nsec = do_div(ts, 1000000000);
-
-	if (!buf)
-		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
-
-	return sprintf(buf, "[%5lu.%06lu] ",
-		       (unsigned long)ts, rem_nsec / 1000);
-}
-
 static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
@@ -1544,114 +1652,6 @@ static inline void printk_delay(void)
 	}
 }
 
-/*
- * Continuation lines are buffered, and not committed to the record buffer
- * until the line is complete, or a race forces it. The line fragments
- * though, are printed immediately to the consoles to ensure everything has
- * reached the console in case of a kernel crash.
- */
-static struct cont {
-	char buf[LOG_LINE_MAX];
-	size_t len;			/* length == 0 means unused buffer */
-	size_t cons;			/* bytes written to console */
-	struct task_struct *owner;	/* task of first print*/
-	u64 ts_nsec;			/* time of first print */
-	u8 level;			/* log level of first message */
-	u8 facility;			/* log facility of first message */
-	enum log_flags flags;		/* prefix, newline flags */
-	bool flushed:1;			/* buffer sealed and committed */
-} cont;
-
-static void cont_flush(enum log_flags flags)
-{
-	if (cont.flushed)
-		return;
-	if (cont.len == 0)
-		return;
-
-	if (cont.cons) {
-		/*
-		 * If a fragment of this line was directly flushed to the
-		 * console; wait for the console to pick up the rest of the
-		 * line. LOG_NOCONS suppresses a duplicated output.
-		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
-		cont.flags = flags;
-		cont.flushed = true;
-	} else {
-		/*
-		 * If no fragment of this line ever reached the console,
-		 * just submit it to the store and free the buffer.
-		 */
-		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.buf, cont.len);
-		cont.len = 0;
-	}
-}
-
-static bool cont_add(int facility, int level, const char *text, size_t len)
-{
-	if (cont.len && cont.flushed)
-		return false;
-
-	/*
-	 * If ext consoles are present, flush and skip in-kernel
-	 * continuation.  See nr_ext_console_drivers definition.  Also, if
-	 * the line gets too long, split it up in separate records.
-	 */
-	if (nr_ext_console_drivers || cont.len + len > sizeof(cont.buf)) {
-		cont_flush(LOG_CONT);
-		return false;
-	}
-
-	if (!cont.len) {
-		cont.facility = facility;
-		cont.level = level;
-		cont.owner = current;
-		cont.ts_nsec = local_clock();
-		cont.flags = 0;
-		cont.cons = 0;
-		cont.flushed = false;
-	}
-
-	memcpy(cont.buf + cont.len, text, len);
-	cont.len += len;
-
-	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(LOG_CONT);
-
-	return true;
-}
-
-static size_t cont_print_text(char *text, size_t size)
-{
-	size_t textlen = 0;
-	size_t len;
-
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
-		size -= textlen;
-	}
-
-	len = cont.len - cont.cons;
-	if (len > 0) {
-		if (len+1 > size)
-			len = size-1;
-		memcpy(text + textlen, cont.buf + cont.cons, len);
-		textlen += len;
-		cont.cons = cont.len;
-	}
-
-	if (cont.flushed) {
-		if (cont.flags & LOG_NEWLINE)
-			text[textlen++] = '\n';
-		/* got everything, release buffer */
-		cont.len = 0;
-	}
-	return textlen;
-}
-
 asmlinkage int vprintk_emit(int facility, int level,
 			    const char *dict, size_t dictlen,
 			    const char *fmt, va_list args)
-- 
1.9.1
