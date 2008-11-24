From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: [take1] Inotify: preliminary nested attributes support.
Date: Tue, 25 Nov 2008 01:40:56 +0300
Message-ID: <20081124224056.GA4329@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>, David Newall <davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi.

Attached patch (untested yet, created to show the idea) implementes
scalable nested attributes which are transferred on behalf the inotify
mechanism. It uses inotify_init1() to show that new event format should
be returned when reading from inotify file descriptor.

Attributes are attached to given inotify instance via TIOCSETD ioctl,
where ID of the attribute is transferred. If entry with given ID exists,
it is removed and -EEXIST is returned.

There is a set of callbacks indexed by ID (currently 4 attributes are
supported: pid, tid, io details (start/size of the written block) and
name), which are attached to given inotify device.
When new event is created, each callback is executed and may queue some
data into event structure, based on its internal details. When event is
read from the userspace, first its header is transferred (old
inotify_event structure) and then all attributes data in the order of
its registration via above ioctl. Nested attributes have following
structure: 

struct inotify_attribute
{
	unsigned int		id;
	unsigned int		size;
	unsigned char		data[0];
};

where size is nuber of attached bytes for given attribute.
inotify_event.len contains number of bytes used to store all attached
attributes and data.

Attribute callback can check if mask contains its bits and do some steps
based on that information, for example io details attribute does not add
own data (and header) if event mask does not contain IN_MODIFY bit.

It is possible to infinitely extend number of attributes processed, so
we will be no longer limited by inotify API and ABI.

I will cook up userspace example tomorrow and fix possible bugs if
find them during testing and would like to get a feedback on idea and
implementation. I added all involved in discussion people into copy
list, drop me a note if you want to be removed.

Signed-off-by: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>

diff --git a/fs/inotify.c b/fs/inotify.c
index 7bbed1b..b56cefc 100644
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
+#include <linux/fsnotify.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
@@ -251,8 +252,9 @@ static void remove_watch_no_event(struct inotify_watch *watch,
 void inotify_remove_watch_locked(struct inotify_handle *ih,
 				 struct inotify_watch *watch)
 {
+	INOTIFY_DETAILS(det, IN_IGNORED, 0, NULL);
 	remove_watch_no_event(watch, ih);
-	ih->in_ops->handle_event(watch, watch->wd, IN_IGNORED, 0, NULL, NULL);
+	ih->in_ops->handle_event(watch, watch->wd, &det, NULL);
 }
 EXPORT_SYMBOL_GPL(inotify_remove_watch_locked);
 
@@ -297,8 +299,8 @@ void inotify_d_move(struct dentry *entry)
  * @name: filename, if any
  * @n_inode: inode associated with name
  */
-void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
-			       const char *name, struct inode *n_inode)
+void inotify_inode_queue_event(struct inode *inode, struct inotify_details *det,
+		struct inode *n_inode)
 {
 	struct inotify_watch *watch, *next;
 
@@ -308,13 +310,12 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
 	mutex_lock(&inode->inotify_mutex);
 	list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
 		u32 watch_mask = watch->mask;
-		if (watch_mask & mask) {
+		if (watch_mask & det->mask) {
 			struct inotify_handle *ih= watch->ih;
 			mutex_lock(&ih->mutex);
 			if (watch_mask & IN_ONESHOT)
 				remove_watch_no_event(watch, ih);
-			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
-						 name, n_inode);
+			ih->in_ops->handle_event(watch, watch->wd, det, n_inode);
 			mutex_unlock(&ih->mutex);
 		}
 	}
@@ -329,8 +330,7 @@ EXPORT_SYMBOL_GPL(inotify_inode_queue_event);
  * @cookie: cookie for synchronization, or zero
  * @name: filename, if any
  */
-void inotify_dentry_parent_queue_event(struct dentry *dentry, u32 mask,
-				       u32 cookie, const char *name)
+void inotify_dentry_parent_queue_event(struct dentry *dentry, struct inotify_details *det)
 {
 	struct dentry *parent;
 	struct inode *inode;
@@ -345,8 +345,7 @@ void inotify_dentry_parent_queue_event(struct dentry *dentry, u32 mask,
 	if (inotify_inode_watched(inode)) {
 		dget(parent);
 		spin_unlock(&dentry->d_lock);
-		inotify_inode_queue_event(inode, mask, cookie, name,
-					  dentry->d_inode);
+		inotify_inode_queue_event(inode, det, dentry->d_inode);
 		dput(parent);
 	} else
 		spin_unlock(&dentry->d_lock);
@@ -428,9 +427,9 @@ void inotify_unmount_inodes(struct list_head *list)
 		watches = &inode->inotify_watches;
 		list_for_each_entry_safe(watch, next_w, watches, i_list) {
 			struct inotify_handle *ih= watch->ih;
+			INOTIFY_DETAILS(det, IN_UNMOUNT, 0, NULL);
 			mutex_lock(&ih->mutex);
-			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
-						 NULL, NULL);
+			ih->in_ops->handle_event(watch, watch->wd, &det, NULL);
 			inotify_remove_watch_locked(ih, watch);
 			mutex_unlock(&ih->mutex);
 		}
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index d367e9b..ee7f248 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -83,6 +83,9 @@ struct inotify_device {
 	unsigned int		queue_size;	/* size of the queue (bytes) */
 	unsigned int		event_count;	/* number of pending events */
 	unsigned int		max_events;	/* maximum number of events */
+	unsigned int		flags;		/* inotify_init1() flags */
+	struct mutex		attribute_lock;	/* attribute callback lock */
+	struct list_head	attribute_list;	/* attribute callback list */
 };
 
 /*
@@ -96,6 +99,7 @@ struct inotify_device {
 struct inotify_kernel_event {
 	struct inotify_event	event;	/* the user-space event */
 	struct list_head        list;	/* entry in inotify_device's list */
+	struct list_head	attribute_list;	/* List of the attributes */
 	char			*name;	/* filename, if any */
 };
 
@@ -108,6 +112,25 @@ struct inotify_user_watch {
 	struct inotify_watch	wdata;	/* inotify watch data */
 };
 
+struct inotify_attribute_callback {
+	/* entry in the inotify attribute list */
+	struct list_head	attribute_entry;
+
+	/* attribute id used to setup callback from userspace */
+	unsigned int		id;
+
+	/* callback which is used to attach attribute to given event */
+	int			(* callback)(struct inotify_device *dev,
+					     struct inotify_kernel_event *ev,
+					     struct inotify_details *det);
+};
+
+struct inotify_kernel_attribute
+{
+	struct list_head		attribute_entry;
+	struct inotify_attribute	attr;
+};
+
 #ifdef CONFIG_SYSCTL
 
 #include <linux/sysctl.h>
@@ -179,13 +202,46 @@ static void free_inotify_user_watch(struct inotify_watch *w)
 	kmem_cache_free(watch_cachep, watch);
 }
 
+static int inotify_kernel_fill_attributes(struct inotify_device *dev,
+		struct inotify_kernel_event *ev, struct inotify_details *det,
+		u32 wd)
+{
+	struct inotify_attribute_callback *attr;
+	int err = 0;
+
+	list_for_each_entry(attr, &ev->attribute_list, attribute_entry) {
+		err = attr->callback(dev, ev, det, wd);
+		if (err < 0)
+			break;
+		ev->event.len += err;
+		err = 0;
+	}
+
+	return err;
+}
+
+/*
+ * free_kevent - frees the given kevent.
+ */
+static void free_kevent(struct inotify_kernel_event *kevent)
+{
+	struct inotify_kernel_attribute *attr, *tmp;
+
+	list_for_each_entry_safe(attr, tmp, &kevent->attribute_list, attribute_entry) {
+		list_del(&attr->attribute_entry);
+		kfree(attr);
+	}
+	kfree(kevent->name);
+	kmem_cache_free(event_cachep, kevent);
+}
+
 /*
  * kernel_event - create a new kernel event with the given parameters
  *
  * This function can sleep.
  */
-static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
-						  const char *name)
+static struct inotify_kernel_event * kernel_event(struct inotify_device *dev,
+		s32 wd, struct inotify_details *det)
 {
 	struct inotify_kernel_event *kevent;
 
@@ -197,12 +253,23 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
 	memset(&kevent->event, 0, sizeof(struct inotify_event));
 
 	kevent->event.wd = wd;
-	kevent->event.mask = mask;
-	kevent->event.cookie = cookie;
+	kevent->event.mask = det->mask;
+	kevent->event.cookie = det->cookie;
+	kevent->event.len = 0;
+	kevent->name = NULL;
+
+	INIT_LIST_HEAD(&kevent->attribute_list);
+
+	if (dev->flags & IN_ATTRS) {
+		if (inotify_kernel_fill_attributes(dev, kevent, det)) {
+			free_kevent(kevent);
+			return NULL;
+		}
 
-	INIT_LIST_HEAD(&kevent->list);
+		return kevent;
+	}
 
-	if (name) {
+	if (det->name) {
 		size_t len, rem, event_size = sizeof(struct inotify_event);
 
 		/*
@@ -212,7 +279,7 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
 		 * up to the next multiple of the structure's sizeof.  This is
 		 * simple and safe for all architectures.
 		 */
-		len = strlen(name) + 1;
+		len = strlen(det->name) + 1;
 		rem = event_size - len;
 		if (len > event_size) {
 			rem = event_size - (len % event_size);
@@ -225,13 +292,10 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
 			kmem_cache_free(event_cachep, kevent);
 			return NULL;
 		}
-		memcpy(kevent->name, name, len);
+		memcpy(kevent->name, det->name, len);
 		if (rem)
 			memset(kevent->name + len, 0, rem);
 		kevent->event.len = len + rem;
-	} else {
-		kevent->event.len = 0;
-		kevent->name = NULL;
 	}
 
 	return kevent;
@@ -267,9 +331,8 @@ inotify_dev_get_last_event(struct inotify_device *dev)
  *
  * Can sleep (calls kernel_event()).
  */
-static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
-				    u32 cookie, const char *name,
-				    struct inode *ignored)
+static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd,
+		struct inotify_details *det, struct inode *ignored)
 {
 	struct inotify_user_watch *watch;
 	struct inotify_device *dev;
@@ -283,18 +346,19 @@ static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
 	/* we can safely put the watch as we don't reference it while
 	 * generating the event
 	 */
-	if (mask & IN_IGNORED || w->mask & IN_ONESHOT)
+	if (det->mask & IN_IGNORED || w->mask & IN_ONESHOT)
 		put_inotify_watch(w); /* final put */
 
 	/* coalescing: drop this event if it is a dupe of the previous */
 	last = inotify_dev_get_last_event(dev);
-	if (last && last->event.mask == mask && last->event.wd == wd &&
-			last->event.cookie == cookie) {
+	if (last && last->event.mask == det->mask &&
+		    last->event.wd == wd &&
+		    last->event.cookie == det->cookie) {
 		const char *lastname = last->name;
 
-		if (!name && !lastname)
+		if (!det->name && !lastname)
 			goto out;
-		if (name && lastname && !strcmp(lastname, name))
+		if (det->name && lastname && !strcmp(lastname, det->name))
 			goto out;
 	}
 
@@ -303,10 +367,12 @@ static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
 		goto out;
 
 	/* if the queue overflows, we need to notify user space */
-	if (unlikely(dev->event_count == dev->max_events))
-		kevent = kernel_event(-1, IN_Q_OVERFLOW, cookie, NULL);
-	else
-		kevent = kernel_event(wd, mask, cookie, name);
+	if (unlikely(dev->event_count == dev->max_events)) {
+		det->mask = IN_Q_OVERFLOW;
+		det->name = NULL;
+		kevent = kernel_event(dev, -1, det);
+	} else
+		kevent = kernel_event(dev, wd, det);
 
 	if (unlikely(!kevent))
 		goto out;
@@ -337,15 +403,6 @@ static void remove_kevent(struct inotify_device *dev,
 }
 
 /*
- * free_kevent - frees the given kevent.
- */
-static void free_kevent(struct inotify_kernel_event *kevent)
-{
-	kfree(kevent->name);
-	kmem_cache_free(event_cachep, kevent);
-}
-
-/*
  * inotify_dev_event_dequeue - destroy an event on the given device
  *
  * Caller must hold dev->ev_mutex.
@@ -427,6 +484,28 @@ static unsigned int inotify_poll(struct file *file, poll_table *wait)
 	return ret;
 }
 
+static int inotify_copy_user_attributes(struct inotify_kernel_event *ev,
+		void __user *buf)
+{
+	struct inotify_kernel_attribute *attr, *tmp;
+	int err = 0;
+
+	list_for_each_entry_safe(attr, tmp, &ev->attribute_list,
+			attribute_entry) {
+		unsigned int size = attr->attr.size +
+			sizeof(struct inotify_attribute);
+		
+		err = copy_to_user(buf, &attr->attr, size);
+		if (err)
+			return -EFAULT;
+		
+		list_del(&attr->attribute_entry);
+		kfree(attr);
+	}
+
+	return 0;
+}
+
 static ssize_t inotify_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *pos)
 {
@@ -500,15 +579,20 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		buf += event_size;
 		count -= event_size;
 
-		if (kevent->name) {
+		if (dev->flags & IN_ATTRS) {
+			ret = inotify_copy_user_attributes(kevent, buf);
+			if (ret < 0)
+				break;
+		} else if (kevent->name) {
 			if (copy_to_user(buf, kevent->name, kevent->event.len)){
 				ret = -EFAULT;
 				break;
 			}
-			buf += kevent->event.len;
-			count -= kevent->event.len;
 		}
 
+		buf += kevent->event.len;
+		count -= kevent->event.len;
+
 		free_kevent(kevent);
 
 		mutex_lock(&dev->ev_mutex);
@@ -525,6 +609,19 @@ static int inotify_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
 }
 
+static void inotify_drop_attribute_list(struct inotify_device *dev)
+{
+	struct inotify_attribute_callback *attr, *tmp;
+
+	mutex_lock(&dev->attribute_lock);
+	list_for_each_entry_safe(attr, tmp, &dev->attribute_list,
+			attribute_entry) {
+		list_del(&attr->attribute_entry);
+		kfree(attr);
+	}
+	mutex_unlock(&dev->attribute_lock);
+}
+
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct inotify_device *dev = file->private_data;
@@ -537,23 +634,145 @@ static int inotify_release(struct inode *ignored, struct file *file)
 		inotify_dev_event_dequeue(dev);
 	mutex_unlock(&dev->ev_mutex);
 
+	inotify_drop_attribute_list(dev);
+
 	/* free this device: the put matching the get in inotify_init() */
 	put_inotify_dev(dev);
 
 	return 0;
 }
 
+static int inotify_create_attr(struct inotify_kernel_event *ev,
+		unsigned int id, void *data, unsigned int size)
+{
+	struct inotify_kernel_attribute *attr;
+
+	attr = kmalloc(sizeof(struct inotify_kernel_attribute) + size,
+			GFP_NOFS);
+	if (!attr)
+		return -ENOMEM;
+
+	attr->attr.id = id;
+	attr->attr.size = size;
+	memcpy(attr->attr.data, data, size);
+
+	list_add_tail(&attr->attribute_entry, &ev->attribute_list);
+	return size + sizeof(struct inotify_attribute);
+}
+
+static int inotify_add_pid_attr(struct inotify_device *dev,
+				struct inotify_kernel_event *ev,
+				struct inotify_details *det)
+{
+	pid_t pid = task_tgid_vnr(current);
+
+	return inotify_create_attr(ev, INOTIFY_ATTR_PID, &pid, sizeof(pid_t));
+}
+
+static int inotify_add_tid_attr(struct inotify_device *dev,
+				struct inotify_kernel_event *ev,
+				struct inotify_details *det)
+{
+	pid_t pid = task_pid_vnr(current);
+
+	return inotify_create_attr(ev, INOTIFY_ATTR_TID, &pid, sizeof(pid_t));
+}
+
+static int inotify_add_io_details_attr(struct inotify_device *dev,
+				struct inotify_kernel_event *ev,
+				struct inotify_details *det)
+{
+	struct inotify_io_details io;
+
+	if (!(det->mask & IN_MODIFY))
+		return 0;
+
+	io.start = det->start;
+	io.size = det->size;
+
+	return inotify_create_attr(ev, INOTIFY_ATTR_IO,
+			&io, sizeof(struct inotify_io_details));
+}
+
+static int inotify_add_name_attr(struct inotify_device *dev,
+				struct inotify_kernel_event *ev,
+				struct inotify_details *det)
+{
+	return inotify_create_attr(ev, INOTIFY_ATTR_NAME,
+			(void *)det->name, strlen(det->name) + 1);
+}
+
+static struct inotify_attribute_callback inotify_supported_attrs[] = {
+	{ .id = INOTIFY_ATTR_PID,	.callback = inotify_add_pid_attr, },
+	{ .id = INOTIFY_ATTR_TID,	.callback = inotify_add_tid_attr, },
+	{ .id = INOTIFY_ATTR_IO,	.callback = inotify_add_io_details_attr, },
+	{ .id = INOTIFY_ATTR_NAME,	.callback = inotify_add_name_attr, },
+};
+
+static int inotify_attach_attribute_callback(struct inotify_device *dev,
+		unsigned int a)
+{
+	struct inotify_attribute_callback *attr, *new;
+	unsigned int i;
+	int err = -ENOENT;
+
+	for (i=0; i<ARRAY_SIZE(inotify_supported_attrs); ++i) {
+		attr = &inotify_supported_attrs[i];
+		
+		if (attr->id != a)
+			continue;
+
+		mutex_lock(&dev->attribute_lock);
+
+		err = 0;
+		list_for_each_entry(attr, &dev->attribute_list,
+				attribute_entry) {
+			if (attr->id == a) {
+				list_del(&attr);
+				kfree(attr);
+				err = -EEXIST;
+				break;
+			}
+		}
+
+		if (!err) {
+			err = -ENOMEM;
+			new = kmalloc(sizeof(struct inotify_attribute_callback),
+					GFP_KERNEL);
+			if (new) {
+				new->callback = attr->callback;
+				new->id = a;
+
+				list_add_tail(&new->attribute_entry,
+					      &dev->attribute_list);
+				err = 0;
+			}
+		}
+		mutex_unlock(&dev->attribute_lock);
+
+		break;
+	}
+
+	return err;
+}
+
 static long inotify_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
 	struct inotify_device *dev;
 	void __user *p;
 	int ret = -ENOTTY;
+	unsigned int attr;
 
 	dev = file->private_data;
 	p = (void __user *) arg;
 
 	switch (cmd) {
+	case TIOCSETD:
+		ret = get_user(attr, (unsigned int __user *) p);
+		if (!ret)
+			ret = inotify_attach_attribute_callback(dev, attr);
+		break;
 	case FIONREAD:
 		ret = put_user(dev->queue_size, (int __user *) p);
 		break;
@@ -583,14 +802,14 @@ asmlinkage long sys_inotify_init1(int flags)
 	struct user_struct *user;
 	struct file *filp;
 	int fd, ret;
+	unsigned int iflags = flags & ~(IN_CLOEXEC | IN_NONBLOCK);
+
+	flags &= IN_CLOEXEC | IN_NONBLOCK;
 
 	/* Check the IN_* constants for consistency.  */
 	BUILD_BUG_ON(IN_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(IN_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
-		return -EINVAL;
-
 	fd = get_unused_fd_flags(flags & O_CLOEXEC);
 	if (fd < 0)
 		return fd;
@@ -639,6 +858,9 @@ asmlinkage long sys_inotify_init1(int flags)
 	dev->max_events = inotify_max_queued_events;
 	dev->user = user;
 	atomic_set(&dev->count, 0);
+	dev->flags = iflags;
+	mutex_init(&dev->attribute_lock);
+	INIT_LIST_HEAD(&dev->attribute_list);
 
 	get_inotify_dev(dev);
 	atomic_inc(&user->inotify_devs);
diff --git a/fs/read_write.c b/fs/read_write.c
index 969a6d9..5c521c2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -335,7 +335,7 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		else
 			ret = do_sync_write(file, buf, count, pos);
 		if (ret > 0) {
-			fsnotify_modify(file->f_path.dentry);
+			fsnotify_modify(file->f_path.dentry, *pos - ret, ret);
 			add_wchar(current, ret);
 		}
 		inc_syscw(current);
@@ -628,7 +628,7 @@ out:
 		if (type == READ)
 			fsnotify_access(file->f_path.dentry);
 		else
-			fsnotify_modify(file->f_path.dentry);
+			fsnotify_modify(file->f_path.dentry, *pos - ret, ret);
 	}
 	return ret;
 }
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 00fbd5b..0c5171c 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -15,6 +15,9 @@
 #include <linux/inotify.h>
 #include <linux/audit.h>
 
+#define INOTIFY_DETAILS(det, __mask, __cookie, __name) \
+	struct inotify_details det = { .mask = __mask, .cookie = __cookie, .name = __name, }
+
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
  * Called with dcache_lock held.
@@ -42,7 +45,7 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 				 int isdir, struct inode *target, struct dentry *moved)
 {
 	struct inode *source = moved->d_inode;
-	u32 cookie = inotify_get_cookie();
+	INOTIFY_DETAILS(det, IN_MOVED_FROM|isdir, inotify_get_cookie(), old_name);
 
 	if (old_dir == new_dir)
 		inode_dir_notify(old_dir, DN_RENAME);
@@ -53,18 +56,22 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 
 	if (isdir)
 		isdir = IN_ISDIR;
-	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
-				  source);
-	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
-				  source);
+	inotify_inode_queue_event(old_dir, &det, source);
+	det.mask = IN_MOVED_TO|isdir;
+	det.name = (const unsigned char *)new_name;
+	inotify_inode_queue_event(new_dir, &det, source);
 
+	det.name = NULL;
+	det.cookie = 0;
 	if (target) {
-		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
+		det.mask = IN_DELETE_SELF;
+		inotify_inode_queue_event(target, &det, NULL);
 		inotify_inode_is_dead(target);
 	}
 
 	if (source) {
-		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
+		det.mask = IN_MOVE_SELF;
+		inotify_inode_queue_event(source, &det, NULL);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -74,10 +81,11 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
  */
 static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 {
+	INOTIFY_DETAILS(det, IN_DELETE|isdir, 0, dentry->d_name.name);
 	if (isdir)
 		isdir = IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
-	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
+	inotify_dentry_parent_queue_event(dentry, &det);
 }
 
 /*
@@ -85,7 +93,8 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
  */
 static inline void fsnotify_inoderemove(struct inode *inode)
 {
-	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
+	INOTIFY_DETAILS(det, IN_DELETE_SELF, 0, NULL);
+	inotify_inode_queue_event(inode, &det, NULL);
 	inotify_inode_is_dead(inode);
 }
 
@@ -94,7 +103,8 @@ static inline void fsnotify_inoderemove(struct inode *inode)
  */
 static inline void fsnotify_link_count(struct inode *inode)
 {
-	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+	INOTIFY_DETAILS(det, IN_ATTRIB, 0, NULL);
+	inotify_inode_queue_event(inode, &det, NULL);
 }
 
 /*
@@ -102,9 +112,9 @@ static inline void fsnotify_link_count(struct inode *inode)
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
+	INOTIFY_DETAILS(det, IN_CREATE, 0, dentry->d_name.name);
 	inode_dir_notify(inode, DN_CREATE);
-	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
-				  dentry->d_inode);
+	inotify_inode_queue_event(inode, &det, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 }
 
@@ -115,9 +125,9 @@ static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
  */
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
+	INOTIFY_DETAILS(det, IN_CREATE, 0, new_dentry->d_name.name);
 	inode_dir_notify(dir, DN_CREATE);
-	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
-				  inode);
+	inotify_inode_queue_event(dir, &det, inode);
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 }
@@ -127,9 +137,9 @@ static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
+	INOTIFY_DETAILS(det, IN_CREATE | IN_ISDIR, 0, dentry->d_name.name);
 	inode_dir_notify(inode, DN_CREATE);
-	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
-				  dentry->d_name.name, dentry->d_inode);
+	inotify_inode_queue_event(inode, &det, dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 }
 
@@ -139,30 +149,35 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_access(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_ACCESS;
+	INOTIFY_DETAILS(det, IN_ACCESS, 0, dentry->d_name.name);
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		det.mask |= IN_ISDIR;
 
 	dnotify_parent(dentry, DN_ACCESS);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, &det);
+	det.name = NULL;
+	inotify_inode_queue_event(inode, &det, NULL);
 }
 
 /*
  * fsnotify_modify - file was modified
  */
-static inline void fsnotify_modify(struct dentry *dentry)
+static inline void fsnotify_modify(struct dentry *dentry, loff_t start, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_MODIFY;
+	INOTIFY_DETAILS(det, IN_MODIFY, 0, dentry->d_name.name);
+
+	det.start = start;
+	det.size = size;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		det.mask |= IN_ISDIR;
 
 	dnotify_parent(dentry, DN_MODIFY);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, &det);
+	det.name = NULL;
+	inotify_inode_queue_event(inode, &det, NULL);
 }
 
 /*
@@ -171,13 +186,14 @@ static inline void fsnotify_modify(struct dentry *dentry)
 static inline void fsnotify_open(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_OPEN;
+	INOTIFY_DETAILS(det, IN_OPEN, 0, dentry->d_name.name);
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		det.mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, &det);
+	det.name = NULL;
+	inotify_inode_queue_event(inode, &det, NULL);
 }
 
 /*
@@ -187,15 +203,15 @@ static inline void fsnotify_close(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	const char *name = dentry->d_name.name;
-	fmode_t mode = file->f_mode;
-	u32 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
+	INOTIFY_DETAILS(det, (file->f_mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE,
+			0, dentry->d_name.name);
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		det.mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, &det);
+	det.name = NULL;
+	inotify_inode_queue_event(inode, &det, NULL);
 }
 
 /*
@@ -204,13 +220,14 @@ static inline void fsnotify_close(struct file *file)
 static inline void fsnotify_xattr(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_ATTRIB;
+	INOTIFY_DETAILS(det, IN_ATTRIB, 0, dentry->d_name.name);
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		det.mask |= IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
-	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+	inotify_dentry_parent_queue_event(dentry, &det);
+	det.name = NULL;
+	inotify_inode_queue_event(inode, &det, NULL);
 }
 
 /*
@@ -255,11 +272,13 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 	if (dn_mask)
 		dnotify_parent(dentry, dn_mask);
 	if (in_mask) {
+		INOTIFY_DETAILS(det, in_mask, 0, NULL);
 		if (S_ISDIR(inode->i_mode))
-			in_mask |= IN_ISDIR;
-		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
-		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
-						  dentry->d_name.name);
+			det.mask |= IN_ISDIR;
+		det.size = i_size_read(inode);
+		inotify_inode_queue_event(inode, &det, NULL);
+		det.name = dentry->d_name.name;
+		inotify_dentry_parent_queue_event(dentry, &det);
 	}
 }
 
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 37ea289..b610302 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -68,6 +68,33 @@ struct inotify_event {
 /* Flags for sys_inotify_init1.  */
 #define IN_CLOEXEC O_CLOEXEC
 #define IN_NONBLOCK O_NONBLOCK
+#define IN_ATTRS		0x00000001
+
+struct inotify_attribute
+{
+	unsigned int		id;
+	unsigned int		size;
+	unsigned char		data[0];
+};
+
+enum inotify_attribute_types {
+	/* Attach PID of the IO origin process to the event */
+	INOTIFY_ATTR_PID = 1,
+
+	/* Attach thread ID of the IO origin */
+	INOTIFY_ATTR_TID = 1,
+
+	/* Attach offset and size of the reported IO block */
+	INOTIFY_ATTR_IO,
+
+	/* Attach name of the object to be accessed */
+	INOTIFY_ATTR_NAME,
+};
+
+struct inotify_io_details
+{
+	u64		start, size;
+};
 
 #ifdef __KERNEL__
 
@@ -95,9 +122,17 @@ struct inotify_watch {
 	__u32			mask;	/* event mask for this watch */
 };
 
+struct inotify_details
+{
+	u32			mask, cookie;
+	const unsigned char	*name;
+	loff_t			start;
+	size_t			size;
+};
+
 struct inotify_operations {
-	void (*handle_event)(struct inotify_watch *, u32, u32, u32,
-			     const char *, struct inode *);
+	void (*handle_event)(struct inotify_watch *, u32,
+		struct inotify_details *, struct inode *);
 	void (*destroy_watch)(struct inotify_watch *);
 };
 
@@ -107,10 +142,10 @@ struct inotify_operations {
 
 extern void inotify_d_instantiate(struct dentry *, struct inode *);
 extern void inotify_d_move(struct dentry *);
-extern void inotify_inode_queue_event(struct inode *, __u32, __u32,
-				      const char *, struct inode *);
-extern void inotify_dentry_parent_queue_event(struct dentry *, __u32, __u32,
-					      const char *);
+extern void inotify_inode_queue_event(struct inode *, struct inotify_details *,
+				      struct inode *);
+extern void inotify_dentry_parent_queue_event(struct dentry *,
+		struct inotify_details *);
 extern void inotify_unmount_inodes(struct list_head *);
 extern void inotify_inode_is_dead(struct inode *);
 extern u32 inotify_get_cookie(void);
@@ -157,7 +192,8 @@ static inline void inotify_inode_queue_event(struct inode *inode,
 
 static inline void inotify_dentry_parent_queue_event(struct dentry *dentry,
 						     __u32 mask, __u32 cookie,
-						     const char *filename)
+						     const char *filename,
+						     void *data)
 {
 }
 

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
