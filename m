From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tty: Add a new file /proc/tty/consoles
Date: Tue, 7 Sep 2010 10:18:35 -0700
Message-ID: <20100907101835.a699ef6c.randy.dunlap@oracle.com>
References: <20100907165305.GA18757@boole.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907165305.GA18757-NrQI8kIimLNolqkO4TVVkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dr. Werner Fink" <werner-l3A5Bk7waGM@public.gmane.org>
Cc: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 7 Sep 2010 18:53:05 +0200 Dr. Werner Fink wrote:

>  Add a new file /proc/tty/consoles to be able to
>  determine the registered system console lines.
>  If the reading process holds /dev/console open at
>  the regular standard input stream the active device
>  will be marked by an asterisk.
> 
> Signed-off-by: Werner Fink <werner-l3A5Bk7waGM@public.gmane.org>
> ---
>  Documentation/filesystems/proc.txt |   16 ++++
>  fs/proc/proc_tty.c                 |  138 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 154 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 9fb6cbe..a5b6dd5 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -1074,6 +1074,7 @@ Table 1-11: Files in /proc/tty
>   drivers       list of drivers and their usage                
>   ldiscs        registered line disciplines                    
>   driver/serial usage statistic and status of single tty lines 
> + consoles      registered system console lines
>  ..............................................................................
>  
>  To see  which  tty's  are  currently in use, you can simply look into the file
> @@ -1092,6 +1093,21 @@ To see  which  tty's  are  currently in use, you can simply look into the file
>    /dev/tty             /dev/tty        5       0 system:/dev/tty 
>    unknown              /dev/tty        4    1-63 console 
>  
> +To see which character device lines are currently used for the system console
> +/dev/console, you may simply look into the file /proc/tty/consoles:
> +
> +  > cat /proc/tty/consoles
> +  tty0                 4:7
> +  ttyS0                4:64
> +
> +If the reading process holds /dev/console open at the regular standard input
> +stream the active device will be marked by an asterisk:
> +
> +  > cat /proc/tty/consoles < /dev/console
> +  *tty0                4:7
> +  > tty
> +  /dev/pts/3
> +
>  
>  1.8 Miscellaneous kernel statistics in /proc/stat
>  -------------------------------------------------
> diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
> index 83adcc8..f717e84 100644
> --- a/fs/proc/proc_tty.c
> +++ b/fs/proc/proc_tty.c
> @@ -12,7 +12,10 @@
>  #include <linux/proc_fs.h>
>  #include <linux/stat.h>
>  #include <linux/tty.h>
> +#include <linux/tty_driver.h>
> +#include <linux/console.h>
>  #include <linux/seq_file.h>
> +#include <linux/fdtable.h>
>  #include <linux/bitops.h>
>  
>  /*
> @@ -137,6 +140,140 @@ static const struct file_operations proc_tty_drivers_operations = {
>  };
>  
>  /*
> + * The device ID of file descriptor 0 of the current reading
> + * task if a character device...
> + */
> +static dev_t current_dev;
> +
> +/*
> + * This is the handler for /proc/tty/consoles
> + */
> +static int show_console_dev(struct seq_file *m, void *v)
> +{
> +	const struct tty_driver * driver;

	                        *driver;
(no space between them, here and other places)


> +	struct console * con;
> +	int index, len;
> +	dev_t dev;
> +
> +	if (v == SEQ_START_TOKEN)
> +		return 0;
> +	con = (struct console *)v;
> +	if (!con)
> +		return 0;
> +	driver = con->device(con, &index);
> +	if (!driver)
> +		return 0;
> +
> +	dev = MKDEV(driver->major, driver->minor_start) + index;
> +
> +	seq_printf(m, "%s%s%d%n", (current_dev == dev) ? "*" : "",
> +			con->name, con->index, &len);

I would decode con->flags here (like I did in a similar 2006 patch).

http://www.xenotime.net/linux/patches/consoles-list.patch
(not kept up to date)

> +	len = 19 - len;
> +	if (len < 1)
> +		len = 1;
> +	seq_printf(m, "%*c%d:%d\n", len, ' ', MAJOR(dev), MINOR(dev));
> +
> +	return 0;
> +}
> +
> +/* iterator for consoles */
> +static void *c_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct console * con;
> +	loff_t off = 0;
> +
> +	if (*pos == 0)
> +		return SEQ_START_TOKEN;
> +
> +	acquire_console_sem();
> +	for (con = console_drivers; con; con = con->next) {
> +		if (!con->device)
> +			continue;
> +		if (!con->write)
> +			continue;
> +		if ((con->flags & CON_ENABLED) == 0)
> +			continue;
> +		if (++off == *pos)
> +			break;
> +	}
> +	release_console_sem();
> +
> +	return con;
> +}
> +
> +static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	struct console * con;
> +
> +	acquire_console_sem();
> + 	if (v == SEQ_START_TOKEN)
> +		con = console_drivers;
> +	else
> +		con = ((struct console *)v)->next;
> +	for (; con; con = con->next) {
> +		if (!con->device)
> +			continue;
> +		if (!con->write)
> +			continue;
> +		if ((con->flags & CON_ENABLED) == 0)
> +			continue;
> +		++*pos;
> +		break;
> +	}
> +	release_console_sem();
> +
> +	return con;
> +}
> +
> +static void c_stop(struct seq_file *m, void *v)
> +{
> +}
> +
> +static const struct seq_operations tty_consoles_op = {
> +	.start	= c_start,
> +	.next	= c_next,
> +	.stop	= c_stop,
> +	.show	= show_console_dev
> +};
> +
> +static int tty_consoles_open(struct inode *inode, struct file *file)
> +{
> +	struct files_struct * curfiles;
> +
> +	current_dev = 0;
> +	curfiles = get_files_struct(current);
> +	if (curfiles) {
> +		const struct file * curfp;
> +		spin_lock(&curfiles->file_lock);
> +		curfp = fcheck_files(curfiles, 0);
> +		if (curfp && curfp->private_data) {
> +			const struct inode * inode;
> +			dget(curfp->f_dentry);
> +			inode = curfp->f_dentry->d_inode;
> +			if (S_ISCHR(inode->i_mode)) {
> +				struct tty_struct * tty;
> +				tty = (struct tty_struct *)curfp->private_data;
> +				if (tty && tty->magic == TTY_MAGIC) {
> +					tty = tty_pair_get_tty(tty);
> +					current_dev = tty_devnum(tty);
> +				}
> +			}
> +			dput(curfp->f_dentry);
> +		}
> +		spin_unlock(&curfiles->file_lock);
> +		put_files_struct(curfiles);
> +	}
> +	return seq_open(file, &tty_consoles_op);
> +}
> +
> +static const struct file_operations proc_tty_consoles_operations = {
> +	.open		= tty_consoles_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +/*
>   * This function is called by tty_register_driver() to handle
>   * registering the driver's /proc handler into /proc/tty/driver/<foo>
>   */
> @@ -186,4 +323,5 @@ void __init proc_tty_init(void)
>  	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR|S_IXUSR, NULL);
>  	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
>  	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
> +	proc_create("tty/consoles", 0, NULL, &proc_tty_consoles_operations);
>  }
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
