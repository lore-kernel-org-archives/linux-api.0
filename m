From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] p9auth: add p9auth driver
Date: Tue, 20 Apr 2010 20:29:08 -0500
Message-ID: <20100421012908.GB24251@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100421012749.GA21338-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a driver that adds Plan 9 style capability device
implementation.  See Documentation/p9auth.txt for a description
of how to use this.

This driver allows the implementation of completely unprivileged
login daemons.  However, doing so requires a fundamental change
regarding linux userids: a server privileged with the new
CAP_GRANT_ID capability can create a one-time setuid capability
allowing another process to change to one specific new userid.
This is a change which must be discussed.  The use of this
privilege can be completely prevented by having init remove
CAP_GRANT_ID from its capability bounding set before forking any
processes.

Signed-off-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 Documentation/p9auth.txt     |   47 ++++
 drivers/char/Kconfig         |    2 +
 drivers/char/Makefile        |    2 +
 drivers/char/p9auth/Kconfig  |    9 +
 drivers/char/p9auth/Makefile |    1 +
 drivers/char/p9auth/p9auth.c |  517 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 578 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/p9auth.txt
 create mode 100644 drivers/char/p9auth/Kconfig
 create mode 100644 drivers/char/p9auth/Makefile
 create mode 100644 drivers/char/p9auth/p9auth.c

diff --git a/Documentation/p9auth.txt b/Documentation/p9auth.txt
new file mode 100644
index 0000000..14a69d8
--- /dev/null
+++ b/Documentation/p9auth.txt
@@ -0,0 +1,47 @@
+The p9auth device driver implements a plan-9 factotum-like
+capability API.  Tasks which are privileged (authorized by
+possession of the CAP_GRANT_ID privilege (POSIX capability))
+can write new capabilities to /dev/caphash.  The kernel then
+stores these until a task uses them by writing to the
+/dev/capuse device.  Each capability represents the ability
+for a task running as userid X to switch to userid Y and
+some set of groups.  Each capability may be used only once,
+and unused capabilities are cleared after two minutes.
+
+The following examples shows how to use the API.  Shell 1
+contains a privileged root shell.  Shell 2 contains an
+unprivileged shell as user 501 in the same user namespace.  If
+not already done, the privileged shell should create the p9auth
+devices:
+
+	majfile=/sys/module/p9auth/parameters/cap_major
+	minfile=/sys/module/p9auth/parameters/cap_minor
+	maj=`cat $majfile`
+	mknod /dev/caphash c $maj 0
+	min=`cat $minfile`
+	mknod /dev/capuse c $maj 1
+	chmod ugo+w /dev/capuse
+
+Now shell 2 somehow communicates to shell 1 that it possesses
+valid login credentials to switch to userid 502.  Shell 2 then
+looks up the groups which uid 502 is a member of, and builds
+a capability string to pass to the kernel.  It does this by
+concatenating the old userid, new userid, new primary group,
+number of auxiliary groups, and each auxiliary group, all
+as integers separated by '@'.  The resulting string is hashed
+with a random string.  In our example, userid 501 may transition
+to userid 502, with primary group 502 and auxiliary group 29.
+
+	capstr="501@502@502@1@29"
+	echo -n "$capstr" > /tmp/txtfile
+	randstr=`dd if=/dev/urandom count=1 2>/dev/null | \
+			uuencode -m - | head -n 2 | tail -n 1 | cut -c -8 `
+	openssl sha1 -hmac "$randstr" /tmp/txtfile | awk '{ print $2 '} \
+		> /tmp/hex
+	./unhex < /tmp/hex > /dev/caphash
+
+The source for unhex.c can be found in the ltp testsuite under
+ltp-dev/testcases/kernel/security/p9auth.  To shell 2 it passes $capstr
+and $randstr.  Shell 2 can then transition to the new userid by doing
+
+	echo -n "$capstr@$randstr" > /dev/capuse
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3141dd3..e7ff2a9 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1113,5 +1113,7 @@ config DEVPORT
 
 source "drivers/s390/char/Kconfig"
 
+source "drivers/char/p9auth/Kconfig"
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f957edf..3c27905 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -111,6 +111,8 @@ obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
+obj-$(CONFIG_PLAN9AUTH)		+= p9auth/
+
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
diff --git a/drivers/char/p9auth/Kconfig b/drivers/char/p9auth/Kconfig
new file mode 100644
index 0000000..d1c66d2
--- /dev/null
+++ b/drivers/char/p9auth/Kconfig
@@ -0,0 +1,9 @@
+config PLAN9AUTH
+	tristate "Plan 9 style capability device implementation"
+	default n
+	depends on CRYPTO
+	help
+	  This module implements the Plan 9 style capability device.
+
+	  To compile this driver as a module, choose
+	  M here: the module will be called p9auth.
diff --git a/drivers/char/p9auth/Makefile b/drivers/char/p9auth/Makefile
new file mode 100644
index 0000000..3ebf6ff
--- /dev/null
+++ b/drivers/char/p9auth/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PLAN9AUTH)	+= p9auth.o
diff --git a/drivers/char/p9auth/p9auth.c b/drivers/char/p9auth/p9auth.c
new file mode 100644
index 0000000..d14f709
--- /dev/null
+++ b/drivers/char/p9auth/p9auth.c
@@ -0,0 +1,517 @@
+/*
+ * Plan 9 style capability device implementation for the Linux Kernel
+ *
+ * Copyright 2008, 2009 Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * Released under the GPLv2
+ *
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/fcntl.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/user_namespace.h>
+
+#ifndef CAP_MAJOR
+#define CAP_MAJOR 0
+#endif
+
+#ifndef CAP_NR_DEVS
+#define CAP_NR_DEVS 2		/* caphash and capuse */
+#endif
+
+#ifndef CAP_NODE_SIZE
+#define CAP_NODE_SIZE 20
+#endif
+
+#define MAX_DIGEST_SIZE  20
+
+struct cap_node {
+	char data[CAP_NODE_SIZE];
+	struct user_namespace *user_ns;
+	unsigned long time_created;
+	struct list_head list;
+};
+
+#define CAP_HASH_COUNT_LIM 4000  /* make configurable sometime */
+/*
+ * cap_list, the list of valid capability tokens
+ * todo: put into user_namespace
+ */
+static LIST_HEAD(cap_list);
+static int cap_hash_count;  /* number of entries cap_list */
+DEFINE_MUTEX(cap_mutex); /* TODO fix up the locking one day */
+
+struct cap_dev {
+	struct cdev cdev;
+};
+
+static int cap_major = CAP_MAJOR;
+static int cap_minor;
+
+module_param(cap_major, int, S_IRUGO);
+module_param(cap_minor, int, S_IRUGO);
+
+MODULE_AUTHOR("Ashwin Ganti");
+MODULE_LICENSE("GPL");
+
+static struct cap_dev *cap_devices;
+
+static void hexdump(unsigned char *buf, unsigned int len)
+{
+	while (len--)
+		printk(KERN_DEBUG "%02x", *buf++);
+	printk(KERN_DEBUG "\n");
+}
+
+static char *cap_hash(char *plain_text, unsigned int plain_text_size,
+		      char *key, unsigned int key_size)
+{
+	struct scatterlist sg;
+	char *result;
+	struct crypto_hash *tfm;
+	struct hash_desc desc;
+	int ret;
+
+	tfm = crypto_alloc_hash("hmac(sha1)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR
+		       "failed to load transform for hmac(sha1): %ld\n",
+		       PTR_ERR(tfm));
+		return NULL;
+	}
+
+	desc.tfm = tfm;
+	desc.flags = 0;
+
+	result = kzalloc(MAX_DIGEST_SIZE, GFP_KERNEL);
+	if (!result) {
+		printk(KERN_ERR "out of memory!\n");
+		goto out;
+	}
+
+	sg_set_buf(&sg, plain_text, plain_text_size);
+
+	ret = crypto_hash_setkey(tfm, key, key_size);
+	if (ret) {
+		printk(KERN_ERR "setkey() failed ret=%d\n", ret);
+		kfree(result);
+		result = NULL;
+		goto out;
+	}
+
+	ret = crypto_hash_digest(&desc, &sg, plain_text_size, result);
+	if (ret) {
+		printk(KERN_ERR "digest () failed ret=%d\n", ret);
+		kfree(result);
+		result = NULL;
+		goto out;
+	}
+
+	printk(KERN_DEBUG "crypto hash digest size %d\n",
+	       crypto_hash_digestsize(tfm));
+	hexdump(result, MAX_DIGEST_SIZE);
+
+out:
+	crypto_free_hash(tfm);
+	return result;
+}
+
+static int cap_open(struct inode *inode, struct file *filp)
+{
+	struct cap_dev *dev;
+	dev = container_of(inode->i_cdev, struct cap_dev, cdev);
+	filp->private_data = dev;
+
+	return 0;
+}
+
+static int cap_release(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+struct id_set {
+	char *source_user, *target_user;
+	uid_t old_uid, new_uid;
+	gid_t new_gid;
+	unsigned int ngroups;
+	struct group_info *newgroups;
+	char *full;  /* The full entry which must be freed */
+};
+
+/*
+ * read an entry.  For now it is
+ * source_user@target_user@rand
+ * Next it will become
+ * source_user@target_user@target_group@numgroups@grp1..@grpn@rand
+ */
+static int parse_user_capability(char *s, struct id_set *set)
+{
+	char *tmp, *tmpu;
+	int i, ret;
+	unsigned long res;
+
+	/*
+	 * break the supplied string into tokens with @ as the
+	 * delimiter If the string is "user1@user2@randomstring" we
+	 * need to split it and hash 'user1@user2' using 'randomstring'
+	 * as the key.
+	 */
+	tmpu = set->full = kstrdup(s, GFP_KERNEL);
+	if (!tmpu)
+		return -ENOMEM;
+
+	ret = -EINVAL;
+	set->source_user = strsep(&tmpu, "@");
+	set->target_user = strsep(&tmpu, "@");
+	tmp = strsep(&tmpu, "@");
+	if (!set->source_user || !set->target_user || !tmp)
+		goto out;
+
+	if (strict_strtoul(set->target_user, 0, &res))
+		goto out;
+	set->new_uid = (uid_t) res;
+	if (strict_strtoul(set->source_user, 0, &res))
+		goto out;
+	set->old_uid = (uid_t) res;
+	if (strict_strtoul(tmp, 0, &res))
+		goto out;
+	set->new_gid = (gid_t) res;
+
+	tmp = strsep(&tmpu, "@");
+	if (!tmp)
+		goto out;
+	if (sscanf(tmp, "%d", &set->ngroups) != 1 || set->ngroups < 0)
+		goto out;
+
+	ret = -ENOMEM;
+	set->newgroups = groups_alloc(set->ngroups);
+	if (!set->newgroups)
+		goto out;
+
+	ret = -EINVAL;
+	for (i = 0; i < set->ngroups; i++) {
+		gid_t g;
+
+		tmp = strsep(&tmpu, "@");
+		if (!tmp || sscanf(tmp, "%d", &g) != 1) {
+			groups_free(set->newgroups);
+			goto out;
+		}
+		GROUP_AT(set->newgroups, i) = g;
+	}
+
+	ret = 0;
+
+out:
+	kfree(set->full);
+	return ret;
+}
+
+static int grant_id(struct id_set *set)
+{
+	struct cred *new;
+	int ret;
+
+	/*
+	 * Check whether the process writing to capuse
+	 * is actually owned by the source owner
+	 */
+	if (set->old_uid != current_uid()) {
+		printk(KERN_ALERT
+			"p9auth: process %d may switch from uid %d to %d, "
+			" but is uid %d (denied).\n", current->pid,
+			set->old_uid, set->new_uid, current_uid());
+		return -EFAULT;
+	}
+
+	/*
+	 * Change uid, euid, and fsuid.  The suid remains for
+	 * flexibility - though I'm torn as to the tradeoff of
+	 * usefulness vs. danger in that.
+	 */
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = set_groups(new, set->newgroups);
+	if (!ret)
+		ret = cred_setresgid(new, set->new_gid, set->new_gid,
+				     set->new_gid, CRED_SETID_FORCE);
+	if (!ret)
+		ret = cred_setresuid(new, set->new_uid, set->new_uid,
+				     set->new_uid, CRED_SETID_FORCE);
+	if (ret == 0)
+		commit_creds(new);
+	else
+		abort_creds(new);
+
+	return ret;
+}
+
+/* Delete a capability entry from the list */
+static void del_cap_node(struct cap_node *node)
+{
+	list_del(&node->list);
+	put_user_ns(node->user_ns);
+	kfree(node);
+	cap_hash_count--;
+}
+
+/* Expose this through sysctl eventually?  2 min timeout for hashes */
+static int cap_timeout = 120;
+
+/* Remove unused entries older tha (cap_timeout) seconds */
+static void remove_old_entries(void)
+{
+	struct cap_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &cap_list, list)
+		if (node->time_created + HZ * cap_timeout < jiffies)
+			del_cap_node(node);
+}
+
+/*
+ * There are CAP_HASH_COUNT_LIM (4k) entries -
+ *   trim the 5 oldest even though newer than cap_timeout
+ */
+static void trim_oldest_entries(void)
+{
+	struct cap_node *node, *tmp;
+	int i = 0;
+
+	list_for_each_entry_safe(node, tmp, &cap_list, list)  {
+		if (++i > 5)
+			break;
+		del_cap_node(node);
+	}
+}
+
+/*
+ * Add a capability hash entry to the list - called by the
+ * privileged factotum server.  Called with cap_mutex held.
+ */
+static int add_caphash_entry(char *user_buf, size_t count)
+{
+	struct cap_node *node_ptr;
+
+	if (count > CAP_NODE_SIZE)
+		return -EINVAL;
+	if (!capable(CAP_GRANT_ID))
+		return -EPERM;
+	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
+	if (!node_ptr)
+		return -ENOMEM;
+
+	printk(KERN_INFO "Capability being written to /dev/caphash :\n");
+	hexdump(user_buf, count);
+	memcpy(node_ptr->data, user_buf, count);
+	node_ptr->user_ns = get_user_ns(current_user_ns());
+	node_ptr->time_created = jiffies;
+	list_add(&(node_ptr->list), &(cap_list));
+	cap_hash_count++;
+	remove_old_entries();
+	if (cap_hash_count > CAP_HASH_COUNT_LIM)
+		trim_oldest_entries();
+
+	return 0;
+}
+
+/*
+ * Use a capability hash entry from the list - called by the
+ * unprivileged login daemon.  Called with cap_mutex held.
+ */
+static int use_caphash_entry(char *ubuf)
+{
+	struct cap_node *node;
+	struct id_set set;
+	int ret, found = 0;
+	char *hashed = NULL, *sep;
+	struct list_head *pos;
+
+	if (list_empty(&(cap_list)))
+		return -EINVAL;
+
+	ret = parse_user_capability(ubuf, &set);
+	if (ret)
+		return ret;
+
+	/*
+	 * hash the string user1@user2@ngrp@grp... with randstr as the key
+	 * XXX is there any vulnerability we're opening ourselves up to by
+	 * not rebuilding the string from its components?
+	 */
+	sep = strrchr(ubuf, '@');
+	if (sep) {
+		char *rand = sep + 1;
+		*sep = '\0';
+		hashed = cap_hash(ubuf, strlen(ubuf), rand, strlen(rand));
+	}
+	if (NULL == hashed) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Change the process's uid if the hash is present in the
+	 * list of hashes
+	 */
+	list_for_each(pos, &(cap_list)) {
+		node = list_entry(pos, struct cap_node, list);
+		if (current_user_ns() != node->user_ns)
+			continue;
+		if (0 == memcmp(hashed, node->data, CAP_NODE_SIZE)) {
+			ret = grant_id(&set);
+			if (ret < 0)
+				goto out;
+
+			/* Capability may only be used once */
+			del_cap_node(node);
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		printk(KERN_ALERT
+		       "Invalid capabiliy written to /dev/capuse\n");
+		ret = -EFAULT;
+	}
+out:
+	put_group_info(set.newgroups);
+	kfree(hashed);
+	return ret;
+}
+
+static ssize_t cap_write(struct file *filp, const char __user *buf,
+			 size_t count, loff_t *f_pos)
+{
+	ssize_t retval = -ENOMEM;
+	char *user_buf;
+
+	if (mutex_lock_interruptible(&cap_mutex))
+		return -EINTR;
+
+	user_buf = kzalloc(count+1, GFP_KERNEL);
+	if (!user_buf)
+		goto out;
+
+	if (copy_from_user(user_buf, buf, count)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * If the minor number is 0 ( /dev/caphash ) then simply add the
+	 * hashed capability supplied by the user to the list of hashes
+	 */
+	if (cap_minor == iminor(filp->f_dentry->d_inode))
+		retval = add_caphash_entry(user_buf, count);
+	else
+		retval = use_caphash_entry(user_buf);
+
+	*f_pos += count;
+	retval = count;
+
+out:
+	kfree(user_buf);
+	mutex_unlock(&cap_mutex);
+	return retval;
+}
+
+static const struct file_operations cap_fops = {
+	.owner = THIS_MODULE,
+	.write = cap_write,
+	.open = cap_open,
+	.release = cap_release,
+};
+
+/* delete all hashed entries (at module exit) */
+static void cap_trim(void)
+{
+	struct cap_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &cap_list, list)
+		del_cap_node(node);
+}
+
+/* no __exit here because it can be called by the init function */
+static void cap_cleanup_module(void)
+{
+	int i;
+	dev_t devno = MKDEV(cap_major, cap_minor);
+	cap_trim();
+	if (cap_devices) {
+		for (i = 0; i < CAP_NR_DEVS; i++)
+			cdev_del(&cap_devices[i].cdev);
+		kfree(cap_devices);
+	}
+	unregister_chrdev_region(devno, CAP_NR_DEVS);
+
+}
+
+static void cap_setup_cdev(struct cap_dev *dev, int index)
+{
+	int err, devno = MKDEV(cap_major, cap_minor + index);
+	cdev_init(&dev->cdev, &cap_fops);
+	dev->cdev.owner = THIS_MODULE;
+	dev->cdev.ops = &cap_fops;
+	err = cdev_add(&dev->cdev, devno, 1);
+	if (err)
+		printk(KERN_NOTICE "Error %d adding cap%d", err, index);
+}
+
+static int __init cap_init_module(void)
+{
+	int result, i;
+	dev_t dev = 0;
+
+	if (cap_major) {
+		dev = MKDEV(cap_major, cap_minor);
+		result = register_chrdev_region(dev, CAP_NR_DEVS, "cap");
+	} else {
+		result = alloc_chrdev_region(&dev, cap_minor, CAP_NR_DEVS,
+					     "cap");
+		cap_major = MAJOR(dev);
+	}
+
+	if (result < 0) {
+		printk(KERN_WARNING "cap: can't get major %d\n",
+		       cap_major);
+		return result;
+	}
+
+	cap_devices = kzalloc(CAP_NR_DEVS * sizeof(struct cap_dev),
+			      GFP_KERNEL);
+	if (!cap_devices) {
+		result = -ENOMEM;
+		goto fail;
+	}
+
+	/* Initialize each device. */
+	for (i = 0; i < CAP_NR_DEVS; i++)
+		cap_setup_cdev(&cap_devices[i], i);
+
+	return 0;
+
+fail:
+	cap_cleanup_module();
+	return result;
+}
+
+module_init(cap_init_module);
+module_exit(cap_cleanup_module);
+
+
-- 
1.7.0.4
