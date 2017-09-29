From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Thu, 28 Sep 2017 17:43:55 -0700
Message-ID: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Calvin Owens <calvinowens@fb.com>
List-Id: linux-api@vger.kernel.org

Not all consoles are created equal: depending on the actual hardware,
the latency of a printk() call can vary dramatically. The worst examples
are serial consoles, where it can spin for tens of milliseconds banging
the UART to emit a message, which can cause application-level problems
when the kernel spews onto the console.

At Facebook we use netconsole to monitor our fleet, but we still have
serial consoles attached on each host for live debugging, and the latter
has caused problems. An obvious solution is to disable the kernel
console output to ttyS0, but this makes live debugging frustrating,
since crashes become silent and opaque to the ttyS0 user. Enabling it on
the fly when needed isn't feasible, since boxes you need to debug via
serial are likely to be borked in ways that make this impossible.

That puts us between a rock and a hard place: we'd love to set
kernel.printk to KERN_INFO and get all the logs. But while netconsole is
fast enough to permit that without perturbing userspace, ttyS0 is not,
and we're forced to limit console logging to KERN_WARNING and higher.

This patch introduces a new per-console loglevel setting, and changes
console_unlock() to use max(global_level, per_console_level) when
deciding whether or not to emit a given log message.

This lets us have our cake and eat it too: instead of being forced to
limit all consoles verbosity based on the speed of the slowest one, we
can "promote" the faster console while still using a conservative system
loglevel setting to avoid disturbing applications.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
(V1: https://lkml.org/lkml/2017/4/4/783)

Changes in V2:
	* Honor the ignore_loglevel setting in all cases
	* Change semantics to use max(global, console) as the loglevel
	  for a console, instead of the previous patch where we treated
	  the per-console one as a filter downstream of the global one.

 include/linux/console.h |  1 +
 kernel/printk/printk.c  | 38 +++++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index b8920a0..a5b5d79 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -147,6 +147,7 @@ struct console {
 	int	cflag;
 	void	*data;
 	struct	 console *next;
+	int	level;
 };
 
 /*
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 512f7c2..3f1675e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1141,9 +1141,14 @@ module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ignore_loglevel,
 		 "ignore loglevel setting (prints all kernel messages to the console)");
 
-static bool suppress_message_printing(int level)
+static int effective_loglevel(struct console *con)
 {
-	return (level >= console_loglevel && !ignore_loglevel);
+	return max(console_loglevel, con ? con->level : LOGLEVEL_EMERG);
+}
+
+static bool suppress_message_printing(int level, struct console *con)
+{
+	return (level >= effective_loglevel(con) && !ignore_loglevel);
 }
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
@@ -1175,7 +1180,7 @@ static void boot_delay_msec(int level)
 	unsigned long timeout;
 
 	if ((boot_delay == 0 || system_state >= SYSTEM_RUNNING)
-		|| suppress_message_printing(level)) {
+		|| suppress_message_printing(level, NULL)) {
 		return;
 	}
 
@@ -1549,7 +1554,7 @@ SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
  * The console_lock must be held.
  */
 static void call_console_drivers(const char *ext_text, size_t ext_len,
-				 const char *text, size_t len)
+				 const char *text, size_t len, int level)
 {
 	struct console *con;
 
@@ -1568,6 +1573,8 @@ static void call_console_drivers(const char *ext_text, size_t ext_len,
 		if (!cpu_online(smp_processor_id()) &&
 		    !(con->flags & CON_ANYTIME))
 			continue;
+		if (suppress_message_printing(level, con))
+			continue;
 		if (con->flags & CON_EXTENDED)
 			con->write(con, ext_text, ext_len);
 		else
@@ -1856,10 +1863,9 @@ static ssize_t msg_print_ext_body(char *buf, size_t size,
 				  char *dict, size_t dict_len,
 				  char *text, size_t text_len) { return 0; }
 static void call_console_drivers(const char *ext_text, size_t ext_len,
-				 const char *text, size_t len) {}
+				 const char *text, size_t len, int level) {}
 static size_t msg_print_text(const struct printk_log *msg,
 			     bool syslog, char *buf, size_t size) { return 0; }
-static bool suppress_message_printing(int level) { return false; }
 
 #endif /* CONFIG_PRINTK */
 
@@ -2199,22 +2205,11 @@ void console_unlock(void)
 		} else {
 			len = 0;
 		}
-skip:
+
 		if (console_seq == log_next_seq)
 			break;
 
 		msg = log_from_idx(console_idx);
-		if (suppress_message_printing(msg->level)) {
-			/*
-			 * Skip record we have buffered and already printed
-			 * directly to the console when we received it, and
-			 * record that has level above the console loglevel.
-			 */
-			console_idx = log_next(console_idx);
-			console_seq++;
-			goto skip;
-		}
-
 		len += msg_print_text(msg, false, text + len, sizeof(text) - len);
 		if (nr_ext_console_drivers) {
 			ext_len = msg_print_ext_header(ext_text,
@@ -2230,7 +2225,7 @@ void console_unlock(void)
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
-		call_console_drivers(ext_text, ext_len, text, len);
+		call_console_drivers(ext_text, ext_len, text, len, msg->level);
 		start_critical_timings();
 		printk_safe_exit_irqrestore(flags);
 
@@ -2497,6 +2492,11 @@ void register_console(struct console *newcon)
 		newcon->flags &= ~CON_PRINTBUFFER;
 
 	/*
+	 * By default, the per-console minimum forces no messages through.
+	 */
+	newcon->level = LOGLEVEL_EMERG;
+
+	/*
 	 *	Put this console in the list - keep the
 	 *	preferred driver at the head of the list.
 	 */
-- 
2.9.5
