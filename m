From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: [PATCH v3] usb: devio: Add ioctl to disallow detaching kernel USB drivers.
Date: Thu,  4 Feb 2016 00:20:57 -0300
Message-ID: <1454556057-18956-1-git-send-email-emilio.lopez@collabora.co.uk>
References: <1453420476-26125-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453420476-26125-1-git-send-email-emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bjorn-yOkvZcmFvRU@public.gmane.org
Cc: reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntarily
relinquish the ability to issue other ioctls that may interfere with
other processes and drivers that have claimed an interface on the
device.

Signed-off-by: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>

---

Changes in v3:
- Switch ioctl to use a __u32 given the iface qty is capped at 32
- Reword comments as requested by Alan
- Allow callers to shrink the allowed interfaces mask

Changes in v2:
- Added a parameter to the ioctl, a mask of interfaces an unprivileged
  process is allowed to claim.
- Drop Tested-by's

 drivers/usb/core/devio.c          | 59 +++++++++++++++++++++++++++++++=
+++++---
 include/uapi/linux/usbdevice_fs.h |  1 +
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 59e7a33..3750255 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -77,6 +77,8 @@ struct usb_dev_state {
 	unsigned long ifclaimed;
 	u32 secid;
 	u32 disabled_bulk_eps;
+	bool privileges_dropped;
+	unsigned long interface_allowed_mask;
 };
=20
 struct async {
@@ -624,6 +626,10 @@ static int claimintf(struct usb_dev_state *ps, uns=
igned int ifnum)
 	if (test_bit(ifnum, &ps->ifclaimed))
 		return 0;
=20
+	if (ps->privileges_dropped
+	 && !test_bit(ifnum, &ps->interface_allowed_mask))
+		return -EACCES;
+
 	intf =3D usb_ifnum_to_if(dev, ifnum);
 	if (!intf)
 		err =3D -ENOENT;
@@ -861,7 +867,7 @@ static int usbdev_open(struct inode *inode, struct =
file *file)
 	int ret;
=20
 	ret =3D -ENOMEM;
-	ps =3D kmalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
+	ps =3D kzalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
 	if (!ps)
 		goto out_free_ps;
=20
@@ -889,16 +895,14 @@ static int usbdev_open(struct inode *inode, struc=
t file *file)
=20
 	ps->dev =3D dev;
 	ps->file =3D file;
+	ps->interface_allowed_mask =3D 0xFFFFFFFF; /* 32 bits */
 	spin_lock_init(&ps->lock);
 	INIT_LIST_HEAD(&ps->list);
 	INIT_LIST_HEAD(&ps->async_pending);
 	INIT_LIST_HEAD(&ps->async_completed);
 	init_waitqueue_head(&ps->wait);
-	ps->discsignr =3D 0;
 	ps->disc_pid =3D get_pid(task_pid(current));
 	ps->cred =3D get_current_cred();
-	ps->disccontext =3D NULL;
-	ps->ifclaimed =3D 0;
 	security_task_getsecid(current, &ps->secid);
 	smp_wmb();
 	list_add_tail(&ps->list, &dev->filelist);
@@ -1198,6 +1202,27 @@ static int proc_connectinfo(struct usb_dev_state=
 *ps, void __user *arg)
=20
 static int proc_resetdevice(struct usb_dev_state *ps)
 {
+	struct usb_host_config *actconfig =3D ps->dev->actconfig;
+	struct usb_interface *interface;
+	int i, number;
+
+	/* Don't allow a device reset if the process has dropped the
+	 * privilege to do such things and any of the interfaces are
+	 * currently claimed.
+	 */
+	if (ps->privileges_dropped && actconfig) {
+		for (i =3D 0; i < actconfig->desc.bNumInterfaces; ++i) {
+			interface =3D actconfig->interface[i];
+			number =3D interface->cur_altsetting->desc.bInterfaceNumber;
+			if (usb_interface_claimed(interface)) {
+				dev_warn(&ps->dev->dev,
+					"usbfs: interface %d claimed by %s while '%s' resets device\n",
+					number,	interface->dev.driver->name, current->comm);
+				return -EACCES;
+			}
+		}
+	}
+
 	return usb_reset_device(ps->dev);
 }
=20
@@ -1915,6 +1940,9 @@ static int proc_ioctl(struct usb_dev_state *ps, s=
truct usbdevfs_ioctl *ctl)
 	struct usb_interface    *intf =3D NULL;
 	struct usb_driver       *driver =3D NULL;
=20
+	if (ps->privileges_dropped)
+		return -EACCES;
+
 	/* alloc buffer */
 	size =3D _IOC_SIZE(ctl->ioctl_code);
 	if (size > 0) {
@@ -2067,6 +2095,9 @@ static int proc_disconnect_claim(struct usb_dev_s=
tate *ps, void __user *arg)
 	if (intf->dev.driver) {
 		struct usb_driver *driver =3D to_usb_driver(intf->dev.driver);
=20
+		if (ps->privileges_dropped)
+			return -EACCES;
+
 		if ((dc.flags & USBDEVFS_DISCONNECT_CLAIM_IF_DRIVER) &&
 				strncmp(dc.driver, intf->dev.driver->name,
 					sizeof(dc.driver)) !=3D 0)
@@ -2123,6 +2154,23 @@ static int proc_free_streams(struct usb_dev_stat=
e *ps, void __user *arg)
 	return r;
 }
=20
+static int proc_drop_privileges(struct usb_dev_state *ps, void __user =
*arg)
+{
+	u32 data;
+
+	if (copy_from_user(&data, arg, sizeof(data)))
+		return -EFAULT;
+
+	/* This is an one way operation. Once privileges are
+	 * dropped, you cannot regain them. You may however reissue
+	 * this ioctl to shrink the allowed interfaces mask.
+	 */
+	ps->interface_allowed_mask &=3D data;
+	ps->privileges_dropped =3D true;
+
+	return 0;
+}
+
 /*
  * NOTE:  All requests here that have interface numbers as parameters
  * are assuming that somehow the configuration has been prevented from
@@ -2311,6 +2359,9 @@ static long usbdev_do_ioctl(struct file *file, un=
signed int cmd,
 	case USBDEVFS_FREE_STREAMS:
 		ret =3D proc_free_streams(ps, p);
 		break;
+	case USBDEVFS_DROP_PRIVILEGES:
+		ret =3D proc_drop_privileges(ps, p);
+		break;
 	}
=20
  done:
diff --git a/include/uapi/linux/usbdevice_fs.h b/include/uapi/linux/usb=
device_fs.h
index 019ba1e..2fad9f85 100644
--- a/include/uapi/linux/usbdevice_fs.h
+++ b/include/uapi/linux/usbdevice_fs.h
@@ -187,5 +187,6 @@ struct usbdevfs_streams {
 #define USBDEVFS_DISCONNECT_CLAIM  _IOR('U', 27, struct usbdevfs_disco=
nnect_claim)
 #define USBDEVFS_ALLOC_STREAMS     _IOR('U', 28, struct usbdevfs_strea=
ms)
 #define USBDEVFS_FREE_STREAMS      _IOR('U', 29, struct usbdevfs_strea=
ms)
+#define USBDEVFS_DROP_PRIVILEGES   _IOR('U', 30, __u32)
=20
 #endif /* _UAPI_LINUX_USBDEVICE_FS_H */
--=20
2.5.0
