From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez@collabora.co.uk>
Subject: [PATCH v1] usb: devio: Add ioctl to disallow detaching kernel USB drivers.
Date: Wed, 25 Nov 2015 12:45:34 -0300
Message-ID: <1448466334-21346-2-git-send-email-emilio.lopez@collabora.co.uk>
References: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, kborer@gmail.com
Cc: reillyg@chromium.org, keescook@chromium.org, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jorgelo@chromium.org, dan.carpenter@oracle.com, =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez@collabora.co.uk>
List-Id: linux-api@vger.kernel.org

=46rom: Reilly Grant <reillyg@chromium.org>

The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntarily
relinquish the ability to issue other ioctls that may interfere with
other processes and drivers that have claimed an interface on the
device.

Signed-off-by: Reilly Grant <reillyg@chromium.org>
Reviewed-by: Jorge Lucangeli Obes <jorgelo@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
[emilio.lopez: fix build for v4.4-rc2 and adjust patch title prefix]
Signed-off-by: Emilio L=C3=B3pez <emilio.lopez@collabora.co.uk>

---

 drivers/usb/core/devio.c          | 50 +++++++++++++++++++++++++++++++=
++++----
 include/uapi/linux/usbdevice_fs.h |  1 +
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 38ae877c..a5ccc50 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -77,6 +77,7 @@ struct usb_dev_state {
 	unsigned long ifclaimed;
 	u32 secid;
 	u32 disabled_bulk_eps;
+	bool privileges_dropped;
 };
=20
 struct async {
@@ -878,7 +879,7 @@ static int usbdev_open(struct inode *inode, struct =
file *file)
 	int ret;
=20
 	ret =3D -ENOMEM;
-	ps =3D kmalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
+	ps =3D kzalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
 	if (!ps)
 		goto out_free_ps;
=20
@@ -911,11 +912,8 @@ static int usbdev_open(struct inode *inode, struct=
 file *file)
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
@@ -1215,6 +1213,35 @@ static int proc_connectinfo(struct usb_dev_state=
 *ps, void __user *arg)
=20
 static int proc_resetdevice(struct usb_dev_state *ps)
 {
+	if (ps->privileges_dropped) {
+		struct usb_host_config *actconfig =3D ps->dev->actconfig;
+
+		/* Don't touch the device if any interfaces are claimed. It
+		 * could interfere with other drivers' operations and this
+		 * process has dropped its privileges to do such things.
+		 */
+		if (actconfig) {
+			int i;
+
+			for (i =3D 0; i < actconfig->desc.bNumInterfaces; ++i) {
+				if (usb_interface_claimed(
+					actconfig->interface[i])) {
+					dev_warn(&ps->dev->dev,
+						"usbfs: interface %d claimed by"
+						" %s while '%s'"
+						" resets device\n",
+						actconfig->interface[i]
+							->cur_altsetting
+							->desc.bInterfaceNumber,
+						actconfig->interface[i]
+							->dev.driver->name,
+						current->comm);
+					return -EACCES;
+				}
+			}
+		}
+	}
+
 	return usb_reset_device(ps->dev);
 }
=20
@@ -1922,6 +1949,9 @@ static int proc_ioctl(struct usb_dev_state *ps, s=
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
@@ -2084,6 +2114,9 @@ static int proc_disconnect_claim(struct usb_dev_s=
tate *ps, void __user *arg)
 					sizeof(dc.driver)) =3D=3D 0)
 			return -EBUSY;
=20
+		if (ps->privileges_dropped)
+			return -EACCES;
+
 		dev_dbg(&intf->dev, "disconnect by usbfs\n");
 		usb_driver_release_interface(driver, intf);
 	}
@@ -2130,6 +2163,12 @@ static int proc_free_streams(struct usb_dev_stat=
e *ps, void __user *arg)
 	return r;
 }
=20
+static int proc_drop_privileges(struct usb_dev_state *ps)
+{
+	ps->privileges_dropped =3D true;
+	return 0;
+}
+
 /*
  * NOTE:  All requests here that have interface numbers as parameters
  * are assuming that somehow the configuration has been prevented from
@@ -2318,6 +2357,9 @@ static long usbdev_do_ioctl(struct file *file, un=
signed int cmd,
 	case USBDEVFS_FREE_STREAMS:
 		ret =3D proc_free_streams(ps, p);
 		break;
+	case USBDEVFS_DROP_PRIVILEGES:
+		ret =3D proc_drop_privileges(ps);
+		break;
 	}
=20
  done:
diff --git a/include/uapi/linux/usbdevice_fs.h b/include/uapi/linux/usb=
device_fs.h
index 019ba1e..99c296b 100644
--- a/include/uapi/linux/usbdevice_fs.h
+++ b/include/uapi/linux/usbdevice_fs.h
@@ -187,5 +187,6 @@ struct usbdevfs_streams {
 #define USBDEVFS_DISCONNECT_CLAIM  _IOR('U', 27, struct usbdevfs_disco=
nnect_claim)
 #define USBDEVFS_ALLOC_STREAMS     _IOR('U', 28, struct usbdevfs_strea=
ms)
 #define USBDEVFS_FREE_STREAMS      _IOR('U', 29, struct usbdevfs_strea=
ms)
+#define USBDEVFS_DROP_PRIVILEGES   _IO('U', 30)
=20
 #endif /* _UAPI_LINUX_USBDEVICE_FS_H */
--=20
2.5.0
