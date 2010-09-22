From: "Dr. Werner Fink" <werner-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] tty: Add a new file /proc/tty/consoles
Date: Wed, 22 Sep 2010 12:45:40 +0200
Message-ID: <20100922104540.GA14008@boole.suse.de>
References: <20100907165305.GA18757@boole.suse.de>
 <20100907101835.a699ef6c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100907101835.a699ef6c.randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 07, 2010 at 10:18:35AM -0700, Randy Dunlap wrote:
> > +static int show_console_dev(struct seq_file *m, void *v)
> > +{
> > +	const struct tty_driver * driver;
> 
> 	                        *driver;
> (no space between them, here and other places)

Thanks for spotting

> > +	seq_printf(m, "%s%s%d%n", (current_dev == dev) ? "*" : "",
> > +			con->name, con->index, &len);
> 
> I would decode con->flags here (like I did in a similar 2006 patch).

I've added a decoding part together with the possible
operations usabel on the shown conssole lines.

> http://www.xenotime.net/linux/patches/consoles-list.patch
> (not kept up to date)
> 

Thank you,

       Werner

 Add a new file /proc/tty/consoles to be able to
 determine the registered system console lines.
 If the reading process holds /dev/console open at
 the regular standard input stream the active device
 will be marked by an asterisk.  Show possible
 operations and also decode the used flags
 of the listed console lines.

Signed-off-by: Werner Fink <werner-l3A5Bk7waGM@public.gmane.org>
---
 Documentation/filesystems/proc.txt |   32 +++++++
 fs/proc/proc_tty.c                 |  158 ++++++++++++++++++++++++++++++++++++
 2 files changed, 190 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 9fb6cbe..8a0ba8f 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1074,6 +1074,7 @@ Table 1-11: Files in /proc/tty
  drivers       list of drivers and their usage                
  ldiscs        registered line disciplines                    
  driver/serial usage statistic and status of single tty lines 
+ consoles      registered system console lines
 ..............................................................................
 
 To see  which  tty's  are  currently in use, you can simply look into the file
@@ -1092,6 +1093,37 @@ To see  which  tty's  are  currently in use, you can simply look into the file
   /dev/tty             /dev/tty        5       0 system:/dev/tty 
   unknown              /dev/tty        4    1-63 console 
 
+To see which character device lines are currently used for the system console
+/dev/console, you may simply look into the file /proc/tty/consoles:
+
+  > cat /proc/tty/consoles
+  tty0                 -WU (ECp)       4:7
+  ttyS0                -W- (Ep)        4:64
+
+The columns are:
+
+  device               name of the device
+  operations           R = can do read operations
+                       W = can do write operations
+                       U = can do unblank
+  flags                E = it is enabled
+                       C = it is prefered console
+                       B = it is primary boot console
+                       p = it is used for printk buffer
+                       b = it is not a TTY but a Braille device
+                       a = it is safe to use when cpu is offline
+                       * = it is standard input of the reading process
+  major:minor          major and minor number of the device separated by a colon
+
+If the reading process holds /dev/console open at the regular standard input
+stream the active device will be marked by an asterisk:
+
+  > cat /proc/tty/consoles < /dev/console
+  tty0                 -WU (ECp*)      4:7
+  ttyS0                -W- (Ep)        4:64
+  > tty
+  /dev/pts/3
+
 
 1.8 Miscellaneous kernel statistics in /proc/stat
 -------------------------------------------------
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 83adcc8..b517c62 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -12,7 +12,10 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/console.h>
 #include <linux/seq_file.h>
+#include <linux/fdtable.h>
 #include <linux/bitops.h>
 
 /*
@@ -137,6 +140,160 @@ static const struct file_operations proc_tty_drivers_operations = {
 };
 
 /*
+ * The device ID of file descriptor 0 of the current reading
+ * task if a character device...
+ */
+static dev_t current_dev;
+
+/*
+ * This is the handler for /proc/tty/consoles
+ */
+static int show_console_dev(struct seq_file *m, void *v)
+{
+	const struct tty_driver *driver;
+	struct console *con;
+	int index, len;
+	char flags[10];
+	dev_t dev;
+
+	if (v == SEQ_START_TOKEN)
+		return 0;
+	con = (struct console *)v;
+	if (!con)
+		return 0;
+	driver = con->device(con, &index);
+	if (!driver)
+		return 0;
+	dev = MKDEV(driver->major, driver->minor_start) + index;
+
+	index = 0;
+	if (con->flags & CON_ENABLED)
+		flags[index++] = 'E';
+	if (con->flags & CON_CONSDEV)
+		flags[index++] = 'C';
+	if (con->flags & CON_BOOT)
+		flags[index++] = 'B';
+	if (con->flags & CON_PRINTBUFFER)
+		flags[index++] = 'p';
+	if (con->flags & CON_BRL)
+		flags[index++] = 'b';
+	if (con->flags & CON_ANYTIME)
+		flags[index++] = 'a';
+	if (current_dev == dev)
+		flags[index++] = '*';
+	flags[index] = 0;
+
+	seq_printf(m, "%s%d%n", con->name, con->index, &len);
+	len = 21 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c", len, ' ');
+	seq_printf(m, "%c%c%c (%s)%n", con->read ? 'R' : '-',
+			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
+			flags, &len);
+	len = 13 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c%4d:%d\n", len, ' ', MAJOR(dev), MINOR(dev));
+
+	return 0;
+}
+
+/* iterator for consoles */
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	struct console *con;
+	loff_t off = 0;
+
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	acquire_console_sem();
+	for (con = console_drivers; con; con = con->next) {
+		if (!con->device)
+			continue;
+		if (++off == *pos)
+			break;
+	}
+	release_console_sem();
+
+	return con;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct console *con;
+
+	acquire_console_sem();
+	if (v == SEQ_START_TOKEN)
+		con = console_drivers;
+	else
+		con = ((struct console *)v)->next;
+	for (; con; con = con->next) {
+		if (!con->device)
+			continue;
+		++*pos;
+		break;
+	}
+	release_console_sem();
+
+	return con;
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+static const struct seq_operations tty_consoles_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_console_dev
+};
+
+/*
+ * Used for open /proc/tty/consoles. Before this detect
+ * the device ID of file descriptor 0 of the current
+ * reading task if a character device...
+ */
+static int tty_consoles_open(struct inode *inode, struct file *file)
+{
+	struct files_struct *curfiles;
+
+	current_dev = 0;
+	curfiles = get_files_struct(current);
+	if (curfiles) {
+		const struct file *curfp;
+		spin_lock(&curfiles->file_lock);
+		curfp = fcheck_files(curfiles, 0);
+		if (curfp && curfp->private_data) {
+			const struct inode *inode;
+			dget(curfp->f_dentry);
+			inode = curfp->f_dentry->d_inode;
+			if (S_ISCHR(inode->i_mode)) {
+				struct tty_struct *tty;
+				tty = (struct tty_struct *)curfp->private_data;
+				if (tty && tty->magic == TTY_MAGIC) {
+					tty = tty_pair_get_tty(tty);
+					current_dev = tty_devnum(tty);
+				}
+			}
+			dput(curfp->f_dentry);
+		}
+		spin_unlock(&curfiles->file_lock);
+		put_files_struct(curfiles);
+	}
+	return seq_open(file, &tty_consoles_op);
+}
+
+static const struct file_operations proc_tty_consoles_operations = {
+	.open		= tty_consoles_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/*
  * This function is called by tty_register_driver() to handle
  * registering the driver's /proc handler into /proc/tty/driver/<foo>
  */
@@ -186,4 +343,5 @@ void __init proc_tty_init(void)
 	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR|S_IXUSR, NULL);
 	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
 	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
+	proc_create("tty/consoles", 0, NULL, &proc_tty_consoles_operations);
 }
-- 
1.6.0.2
