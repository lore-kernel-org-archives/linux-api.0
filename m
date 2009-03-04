From: Cedric Roux <sed-GANU6spQydw@public.gmane.org>
Subject: [PATCH] [retry] vt: add ioctl commands to /dev/vcsaN to get/put the
 current palette of the given tty
Date: Wed, 4 Mar 2009 09:58:48 +0100 (CET)
Message-ID: <427911.793301236157128303.JavaMail.root@spooler2-g27.priv.proxad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Cedric Roux <sed-GANU6spQydw@public.gmane.org>

A ioctl interface and two ioctl commands added to /dev/vcsaN
to get/put the current palette of the given tty.

Signed-off-by: Cedric Roux <sed-GANU6spQydw@public.gmane.org>
---
This patch exists because there is no way to get the current
installed palette of a given tty. The PIO_CMAP and GIO_CMAP
in vt_ioctl.c:vt_ioctl play with the global default colormap.
And /dev/vcsaN don't dump the palette through their read
interface. And since a user may change colors of a given
tty by escape sequences, one should be able to retrieve
the palette through /dev/vcsaN, leading to this patch.

Based on remarks from Andrew Morton:
- the return value in case of error should now be OK
    + ENOTTY for /dev/vcs since the ioctl is not defined for
      /dev/vcs but only for /dev/vcsa
    + ENXIO if the console is not allocated as in other code
      that deal with consoles
    + EFAULT if userland buffers are not OK
    + ENOIOCTLCMD if we are given a wrong ioctl command
- registering as .unlocked_ioctl instead of .ioctl

Some points I am not fully confident with:
- vt.c:set_colormap is now used in vc_screen.c so cannot be static
  anymore.
  The goal of this patch is to allow read access to the palette,
  I can remove the PIO_CMAP case and make set_colormap static again.
  This case is there because /dev/vcsaN is read/write so the access
  to the palette should also be read/write. (Or I can do it
  differently, no problem, just tell me how.)
- the palette is returned as it is stored in the kernel, without
  taking into account color_table. So if a userland program
  gets an attribute for a given character, it won't match
  with the palette information. Say the user reads 0xXY through
  /dev/vcsa and takes Y as an index in the palette, it will return
  a bad color. One should do palette[color_table[Y]] to get the real
  color.
  Two "solutions" to this "problem" (it might be an non-issue):
    + export the palette by indexing with color_table:
      I don't like it.
    + let the userland program deal with that:
      the program may open a tty, send escape sequences to
      set the current color, write a character at a given position
      (through the tty, not /dev/vcs) and read back the attribute
      through /dev/vcsa this time. She will see what attribute
      corresponds to what color she sets by using escape sequences.
  If the color_table is non-mutable, all this is a non-issue.
  Userland programs just store the color_table and live with that.
  I've seen no code that modifies the color_table, so I bet it's
  non-mutable. (May it change in the future?)
- lock_kernel() is called. Maybe it's not necessary? I'm not
  confident enough. You decide.
- release_console_sem() is called before calling copy_from/to_user
  as is done in vcs_write/vcs_read, once again I am not confident
  with that.

diff -uprN -X linux-2.6.28-vanilla/Documentation/dontdiff linux-2.6.28-vanilla/drivers/char/vc_screen.c linux-2.6.28/drivers/char/vc_screen.c
--- linux-2.6.28-vanilla/drivers/char/vc_screen.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/char/vc_screen.c	2009-03-04 08:33:17.000000000 +0100
@@ -19,6 +19,8 @@
  * machek-DDRJgj0kmXRGcL5Ds9yaJ6VXKuFTiq87@public.gmane.org - modified not to send characters to wrong console
  *	 - fixed some fatal off-by-one bugs (0-- no longer == -1 -> looping and looping and looping...)
  *	 - making it shorter - scr_readw are macros which expand in PRETTY long code
+ *
+ * Colormap put/get for /dev/vcsaN, Cedric Roux <sed-GANU6spQydw@public.gmane.org>, March 2009.
  */
 
 #include <linux/kernel.h>
@@ -470,11 +472,75 @@ vcs_open(struct inode *inode, struct fil
 	return ret;
 }
 
+static long
+vcs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	unsigned int currcons = iminor(file->f_path.dentry->d_inode);
+	struct vc_data *vc;
+	unsigned char pal[16*3];
+	long ret = 0;
+
+	/* access only defined for /dev/vcsaN, not /dev/vcsN */
+	if (currcons < 128)
+		return -ENOTTY;
+
+	lock_kernel();
+
+	acquire_console_sem();
+
+	currcons &= 127;
+	if (currcons == 0)
+		currcons = fg_console;
+	else
+		currcons--;
+	if (!vc_cons_allocated(currcons)) {
+		ret = -ENXIO;
+		goto unlock_out;
+	}
+	vc = vc_cons[currcons].d;
+
+	switch (cmd) {
+	case PIO_CMAP:
+		release_console_sem();
+		ret = copy_from_user(pal, (void __user *)arg, 16*3);
+		acquire_console_sem();
+
+		if (ret) {
+			ret = -EFAULT;
+			goto unlock_out;
+		}
+		memcpy(vc->vc_palette, pal, 16*3);
+		set_palette(vc);
+		break;
+	case GIO_CMAP:
+		release_console_sem();
+		ret = copy_to_user((void __user *)arg, vc->vc_palette, 16*3);
+		acquire_console_sem();
+
+		if (ret) {
+			ret = -EFAULT;
+			goto unlock_out;
+		}
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+unlock_out:
+	release_console_sem();
+
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations vcs_fops = {
 	.llseek		= vcs_lseek,
 	.read		= vcs_read,
 	.write		= vcs_write,
 	.open		= vcs_open,
+	.unlocked_ioctl	= vcs_ioctl,
 };
 
 static struct class *vc_class;
diff -uprN -X linux-2.6.28-vanilla/Documentation/dontdiff linux-2.6.28-vanilla/drivers/char/vt.c linux-2.6.28/drivers/char/vt.c
--- linux-2.6.28-vanilla/drivers/char/vt.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/char/vt.c	2009-03-01 17:43:29.000000000 +0100
@@ -156,7 +156,6 @@ static void set_cursor(struct vc_data *v
 static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
-static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
@@ -3756,7 +3755,7 @@ void poke_blanked_console(void)
  *	Palettes
  */
 
-static void set_palette(struct vc_data *vc)
+void set_palette(struct vc_data *vc)
 {
 	WARN_CONSOLE_UNLOCKED();
 
diff -uprN -X linux-2.6.28-vanilla/Documentation/dontdiff linux-2.6.28-vanilla/include/linux/vt_kern.h linux-2.6.28/include/linux/vt_kern.h
--- linux-2.6.28-vanilla/include/linux/vt_kern.h	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/include/linux/vt_kern.h	2009-03-01 17:43:09.000000000 +0100
@@ -97,6 +97,7 @@ void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
+void set_palette(struct vc_data *vc);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
