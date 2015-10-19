From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC v4 2/9] printk: add one function for storing log in proper format
Date: Mon, 19 Oct 2015 18:49:57 +0200
Message-ID: <1445273404-24562-3-git-send-email-p.osmialowsk@samsung.com>
References: <1445273404-24562-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1445273404-24562-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

From: Marcin Niesluchowski <m.niesluchow@samsung.com>

Preparation commit for future changes purpose.

Separate code responsible for storing log message in proper format
from operations on consoles by putting it in another function.

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 kernel/printk/printk.c | 222 ++++++++++++++++++++++++++-----------------------
 1 file changed, 119 insertions(+), 103 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c1b7a79..518cbdf 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -181,6 +181,27 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
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
+static void cont_flush(enum log_flags flags);
+static bool cont_add(int facility, int level, const char *text, size_t len);
+
 /* Return log buffer address */
 char *log_buf_addr_get(void)
 {
@@ -332,6 +353,102 @@ static int log_store(int facility, int level,
 	return msg->text_len;
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
@@ -1165,24 +1282,6 @@ static inline void printk_delay(void)
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
 static void cont_flush(enum log_flags flags)
 {
 	if (cont.flushed)
@@ -1278,10 +1377,6 @@ asmlinkage int vprintk_emit(int facility, int level,
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
@@ -1335,87 +1430,8 @@ asmlinkage int vprintk_emit(int facility, int level,
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
