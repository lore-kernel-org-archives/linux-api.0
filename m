From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: [PATCH v5] usb: devio: Add ioctl to disallow detaching kernel USB drivers.
Date: Sun, 21 Feb 2016 18:38:01 -0300
Message-ID: <1456090681-5537-1-git-send-email-emilio.lopez@collabora.co.uk>
References: <20160221041643.GA29711@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160221041643.GA29711-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

The new USBDEVFS_DROP_PRIVILEGES ioctl allows a process to voluntarily
relinquish the ability to issue other ioctls that may interfere with
other processes and drivers that have claimed an interface on the
device.

This commit also includes a simple utility to be able to test the
ioctl, located at Documentation/usb/usbdevfs-drop-permissions.c

Example (with qemu-kvm's input device):

    $ lsusb
    ...
    Bus 001 Device 002: ID 0627:0001 Adomax Technology Co., Ltd

    $ usb-devices
    ...
    C:  #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D100mA
    I:  If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D02 =
Driver=3Dusbhid

    $ sudo ./usbdevfs-drop-permissions /dev/bus/usb/001/002
    OK: privileges dropped!
    Available options:
    [0] Exit now
    [1] Reset device. Should fail if device is in use
    [2] Claim 4 interfaces. Should succeed where not in use
    [3] Narrow interface permission mask
    Which option shall I run?: 1
    ERROR: USBDEVFS_RESET failed! (1 - Operation not permitted)
    Which test shall I run next?: 2
    ERROR claiming if 0 (1 - Operation not permitted)
    ERROR claiming if 1 (1 - Operation not permitted)
    ERROR claiming if 2 (1 - Operation not permitted)
    ERROR claiming if 3 (1 - Operation not permitted)
    Which test shall I run next?: 0

After unbinding usbhid:

    $ usb-devices
    ...
    I:  If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D02 =
Driver=3D(none)

    $ sudo ./usbdevfs-drop-permissions /dev/bus/usb/001/002
    ...
    Which option shall I run?: 2
    OK: claimed if 0
    ERROR claiming if 1 (1 - Operation not permitted)
    ERROR claiming if 2 (1 - Operation not permitted)
    ERROR claiming if 3 (1 - Operation not permitted)
    Which test shall I run next?: 1
    OK: USBDEVFS_RESET succeeded
    Which test shall I run next?: 0

After unbinding usbhid and restricting the mask:

    $ sudo ./usbdevfs-drop-permissions /dev/bus/usb/001/002
    ...
    Which option shall I run?: 3
    Insert new mask: 0
    OK: privileges dropped!
    Which test shall I run next?: 2
    ERROR claiming if 0 (1 - Operation not permitted)
    ERROR claiming if 1 (1 - Operation not permitted)
    ERROR claiming if 2 (1 - Operation not permitted)
    ERROR claiming if 3 (1 - Operation not permitted)

Signed-off-by: Reilly Grant <reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Signed-off-by: Emilio L=C3=B3pez <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>

---

Changes in v5:
- rebased on usb-next, changing the capability flag value to not collid=
e
- Added Alan's ack

Changes in v4:
- IOR -> IOW
- Explain the new ioctl on usb Docbook
- Small program to be able to test the new functionality
- New capability flag
- Allow people to reset devices if they are the only ones
  claiming interfaces, as suggested by Alan

Changes in v3:
- Switch ioctl to use a __u32 given the iface qty is capped at 32
- Reword comments as requested by Alan
- Allow callers to shrink the allowed interfaces mask

Changes in v2:
- Added a parameter to the ioctl, a mask of interfaces an unprivileged
  process is allowed to claim.
- Drop Tested-by's

 Documentation/DocBook/usb.tmpl                |  12 +++
 Documentation/usb/usbdevfs-drop-permissions.c | 120 ++++++++++++++++++=
++++++++
 drivers/usb/core/devio.c                      |  63 ++++++++++++--
 include/uapi/linux/usbdevice_fs.h             |   2 +
 4 files changed, 192 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/usb/usbdevfs-drop-permissions.c

diff --git a/Documentation/DocBook/usb.tmpl b/Documentation/DocBook/usb=
=2Etmpl
index 4cd5b2c..bc776be0 100644
--- a/Documentation/DocBook/usb.tmpl
+++ b/Documentation/DocBook/usb.tmpl
@@ -732,6 +732,18 @@ usbdev_ioctl (int fd, int ifno, unsigned request, =
void *param)
 		    or SET_INTERFACE.
 		    </para></warning></listitem></varlistentry>
=20
+		<varlistentry><term>USBDEVFS_DROP_PRIVILEGES</term>
+		    <listitem><para>This is used to relinquish the ability
+		    to do certain operations which are considered to be
+		    privileged on a usbfs file descriptor.
+		    This includes claiming arbitrary interfaces, resetting
+		    a device on which there are currently claimed interfaces
+		    from other users, and issuing USBDEVFS_IOCTL calls.
+		    The ioctl parameter is a 32 bit mask of interfaces
+		    the user is allowed to claim on this file descriptor.
+		    You may issue this ioctl more than one time to narrow
+		    said mask.
+		    </para></listitem></varlistentry>
 		</variablelist>
=20
 		</sect2>
diff --git a/Documentation/usb/usbdevfs-drop-permissions.c b/Documentat=
ion/usb/usbdevfs-drop-permissions.c
new file mode 100644
index 0000000..6b8da6e
--- /dev/null
+++ b/Documentation/usb/usbdevfs-drop-permissions.c
@@ -0,0 +1,120 @@
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <inttypes.h>
+#include <unistd.h>
+
+#include <linux/usbdevice_fs.h>
+
+/* For building without an updated set of headers */
+#ifndef USBDEVFS_DROP_PRIVILEGES
+#define USBDEVFS_DROP_PRIVILEGES		_IOW('U', 30, __u32)
+#define USBDEVFS_CAP_DROP_PRIVILEGES		0x40
+#endif
+
+void drop_privileges(int fd, uint32_t mask)
+{
+	int res;
+
+	res =3D ioctl(fd, USBDEVFS_DROP_PRIVILEGES, &mask);
+	if (res)
+		printf("ERROR: USBDEVFS_DROP_PRIVILEGES returned %d\n", res);
+	else
+		printf("OK: privileges dropped!\n");
+}
+
+void reset_device(int fd)
+{
+	int res;
+
+	res =3D ioctl(fd, USBDEVFS_RESET);
+	if (!res)
+		printf("OK: USBDEVFS_RESET succeeded\n");
+	else
+		printf("ERROR: reset failed! (%d - %s)\n",
+		       -res, strerror(-res));
+}
+
+void claim_some_intf(int fd)
+{
+	int i, res;
+
+	for (i =3D 0; i < 4; i++) {
+		res =3D ioctl(fd, USBDEVFS_CLAIMINTERFACE, &i);
+		if (!res)
+			printf("OK: claimed if %d\n", i);
+		else
+			printf("ERROR claiming if %d (%d - %s)\n",
+			       i, -res, strerror(-res));
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	uint32_t mask, caps;
+	int c, fd;
+
+	fd =3D open(argv[1], O_RDWR);
+	if (fd < 0) {
+		printf("Failed to open file\n");
+		goto err_fd;
+	}
+
+	/*
+	 * check if dropping privileges is supported,
+	 * bail on systems where the capability is not present
+	 */
+	ioctl(fd, USBDEVFS_GET_CAPABILITIES, &caps);
+	if (!(caps & USBDEVFS_CAP_DROP_PRIVILEGES)) {
+		printf("DROP_PRIVILEGES not supported\n");
+		goto err;
+	}
+
+	/*
+	 * Drop privileges but keep the ability to claim all
+	 * free interfaces (i.e., those not used by kernel drivers)
+	 */
+	drop_privileges(fd, -1U);
+
+	printf("Available options:\n"
+		"[0] Exit now\n"
+		"[1] Reset device. Should fail if device is in use\n"
+		"[2] Claim 4 interfaces. Should succeed where not in use\n"
+		"[3] Narrow interface permission mask\n"
+		"Which option shall I run?: ");
+
+	while (scanf("%d", &c) =3D=3D 1) {
+		switch (c) {
+		case 0:
+			goto exit;
+		case 1:
+			reset_device(fd);
+			break;
+		case 2:
+			claim_some_intf(fd);
+			break;
+		case 3:
+			printf("Insert new mask: ");
+			scanf("%x", &mask);
+			drop_privileges(fd, mask);
+			break;
+		default:
+			printf("I don't recognize that\n");
+		}
+
+		printf("Which test shall I run next?: ");
+	}
+
+exit:
+	close(fd);
+	return 0;
+
+err:
+	close(fd);
+err_fd:
+	return 1;
+}
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 39da166..52c4461 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -79,6 +79,8 @@ struct usb_dev_state {
 	unsigned long ifclaimed;
 	u32 secid;
 	u32 disabled_bulk_eps;
+	bool privileges_dropped;
+	unsigned long interface_allowed_mask;
 };
=20
 struct usb_memory {
@@ -748,6 +750,10 @@ static int claimintf(struct usb_dev_state *ps, uns=
igned int ifnum)
 	if (test_bit(ifnum, &ps->ifclaimed))
 		return 0;
=20
+	if (ps->privileges_dropped &&
+			!test_bit(ifnum, &ps->interface_allowed_mask))
+		return -EACCES;
+
 	intf =3D usb_ifnum_to_if(dev, ifnum);
 	if (!intf)
 		err =3D -ENOENT;
@@ -985,7 +991,7 @@ static int usbdev_open(struct inode *inode, struct =
file *file)
 	int ret;
=20
 	ret =3D -ENOMEM;
-	ps =3D kmalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
+	ps =3D kzalloc(sizeof(struct usb_dev_state), GFP_KERNEL);
 	if (!ps)
 		goto out_free_ps;
=20
@@ -1013,17 +1019,15 @@ static int usbdev_open(struct inode *inode, str=
uct file *file)
=20
 	ps->dev =3D dev;
 	ps->file =3D file;
+	ps->interface_allowed_mask =3D 0xFFFFFFFF; /* 32 bits */
 	spin_lock_init(&ps->lock);
 	INIT_LIST_HEAD(&ps->list);
 	INIT_LIST_HEAD(&ps->async_pending);
 	INIT_LIST_HEAD(&ps->async_completed);
 	INIT_LIST_HEAD(&ps->memory_list);
 	init_waitqueue_head(&ps->wait);
-	ps->discsignr =3D 0;
 	ps->disc_pid =3D get_pid(task_pid(current));
 	ps->cred =3D get_current_cred();
-	ps->disccontext =3D NULL;
-	ps->ifclaimed =3D 0;
 	security_task_getsecid(current, &ps->secid);
 	smp_wmb();
 	list_add_tail(&ps->list, &dev->filelist);
@@ -1324,6 +1328,28 @@ static int proc_connectinfo(struct usb_dev_state=
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
+			if (usb_interface_claimed(interface) &&
+					!test_bit(number, &ps->ifclaimed)) {
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
@@ -2090,6 +2116,9 @@ static int proc_ioctl(struct usb_dev_state *ps, s=
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
@@ -2215,7 +2244,8 @@ static int proc_get_capabilities(struct usb_dev_s=
tate *ps, void __user *arg)
 	__u32 caps;
=20
 	caps =3D USBDEVFS_CAP_ZERO_PACKET | USBDEVFS_CAP_NO_PACKET_SIZE_LIM |
-			USBDEVFS_CAP_REAP_AFTER_DISCONNECT | USBDEVFS_CAP_MMAP;
+			USBDEVFS_CAP_REAP_AFTER_DISCONNECT | USBDEVFS_CAP_MMAP |
+			USBDEVFS_CAP_DROP_PRIVILEGES;
 	if (!ps->dev->bus->no_stop_on_short)
 		caps |=3D USBDEVFS_CAP_BULK_CONTINUATION;
 	if (ps->dev->bus->sg_tablesize)
@@ -2242,6 +2272,9 @@ static int proc_disconnect_claim(struct usb_dev_s=
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
@@ -2298,6 +2331,23 @@ static int proc_free_streams(struct usb_dev_stat=
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
@@ -2486,6 +2536,9 @@ static long usbdev_do_ioctl(struct file *file, un=
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
index ecbd176..a8653a6 100644
--- a/include/uapi/linux/usbdevice_fs.h
+++ b/include/uapi/linux/usbdevice_fs.h
@@ -135,6 +135,7 @@ struct usbdevfs_hub_portinfo {
 #define USBDEVFS_CAP_BULK_SCATTER_GATHER	0x08
 #define USBDEVFS_CAP_REAP_AFTER_DISCONNECT	0x10
 #define USBDEVFS_CAP_MMAP			0x20
+#define USBDEVFS_CAP_DROP_PRIVILEGES		0x40
=20
 /* USBDEVFS_DISCONNECT_CLAIM flags & struct */
=20
@@ -188,5 +189,6 @@ struct usbdevfs_streams {
 #define USBDEVFS_DISCONNECT_CLAIM  _IOR('U', 27, struct usbdevfs_disco=
nnect_claim)
 #define USBDEVFS_ALLOC_STREAMS     _IOR('U', 28, struct usbdevfs_strea=
ms)
 #define USBDEVFS_FREE_STREAMS      _IOR('U', 29, struct usbdevfs_strea=
ms)
+#define USBDEVFS_DROP_PRIVILEGES   _IOW('U', 30, __u32)
=20
 #endif /* _UAPI_LINUX_USBDEVICE_FS_H */
--=20
2.5.0
