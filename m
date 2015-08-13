From: Amit Pundir <amit.pundir@linaro.org>
Subject: [RFC][PATCH 2/2] usb: gadget: configfs: notify userspace of usb state changes
Date: Fri, 14 Aug 2015 00:42:20 +0530
Message-ID: <1439493140-22207-3-git-send-email-amit.pundir@linaro.org>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>, Benoit Goby <benoit@android.com>, Colin Cross <ccross@android.com>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Peter Oh <poh@broadcom.com>, Greg Hackmann <ghackmann@google.com>, Badhri Jagan Sridharan <Badhri@google.com>, Android Kernel Team <kernel-team@android.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Yegor Yefremov <yegorslists@googlemail.com>, Philippe Reynes <tremyfr@gmail.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org

This is more of an RFC than an actual submission. There are few
scattered #ifdefs..#endifs here and there which still need to be
taken care of before going for actual submission.

Currently there is no way with the upstream ConfigFS gadget to
communicate state changes (connected, disconnected, configured), at
the gadget level. Instead such state changes are handled function by
function independently I presume. This is problematic, because some
coordination between the functions, across the state changes, may be
desired at the userspace level. Thus to address this issue, this
patch send uevents to allow userspace to be notified of these usb
state changes, allowing userspace to respond and configure the
configfs gadget appropriately.

This patch is based on an Android patchset originaly authored by
Badhri Jagan Sridharan <Badhri@google.com> to send uevent notifications
to Android userpace for USB state changes. I've folded his patches
together and modified it enough that I don't want him to be blamed for
any mistakes I've made condensing his patches down.

This patch introduces USB_CONFIGFS_UEVENT Kconfig to handle userspace
notifications of usb state changes, and add setup and disconnect
functions to intercept the setup requests from the usb_core. It also
creates a sysfs device class entry and a device attribute (state) to
read and respond to gadget's current state from userspace. As of now
this sysfs device class (/sys/class/android_usb) and gadget device
(/sys/class/android_usb/android0) with state attribute
(/sys/class/android_usb/android0/state) are strictly tied up to
facilitate Android userspace requests. But going forward we may want
to bring all function devices (hid, printer etc) under a unified usb
gadget device class e.g. /sys/class/usb_gadget/g_{func0,func1} etc..

Also I think it make sense to add this state attribute to the configfs
usb gadget itself i.e. have something like /config/usb_gadget/g1/state
to read USB gadget's current state. Since it is going to be consistent
throughout all the functions tied up to that gadget.

Again this is just an initial RFC, thoughts and feedback would be
greatly appreciated.

Cc: Mike Lockwood <lockwood@android.com>
Cc: Benoit Goby <benoit@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Peter Oh <poh@broadcom.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Badhri Jagan Sridharan <Badhri@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Philippe Reynes <tremyfr@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 drivers/usb/gadget/Kconfig    |   8 ++
 drivers/usb/gadget/configfs.c | 201 ++++++++++++++++++++++++++++++++++=
+++++++-
 2 files changed, 207 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 65d110d..e1d1fc1 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -464,6 +464,14 @@ config USB_CONFIGFS_F_MTP
 	  the file level. Thus exposing the relevant content but hiding
 	  the system/restricted files.
=20
+config USB_CONFIGFS_UEVENT
+	bool "Uevent notification of Gadget state"
+	depends on USB_CONFIGFS
+	help
+	  Enable uevent notifications to userspace when the gadget
+	  state changes. The gadget can be in any of the following
+	  three states: "CONNECTED/DISCONNECTED/CONFIGURED"
+
 source "drivers/usb/gadget/legacy/Kconfig"
=20
 endchoice
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configf=
s.c
index 289e201..1575343 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -9,6 +9,15 @@
 #include "u_f.h"
 #include "u_os_desc.h"
=20
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+#include <linux/platform_device.h>
+#include <linux/kdev_t.h>
+#include <linux/usb/ch9.h>
+
+static struct class *usb_gadget_class;
+static struct device *usb_gadget_device;
+#endif
+
 int check_user_usb_string(const char *name,
 		struct usb_gadget_strings *stringtab_dev)
 {
@@ -63,6 +72,12 @@ struct gadget_info {
 	bool use_os_desc;
 	char b_vendor_code;
 	char qw_sign[OS_STRING_QW_SIGN_LEN];
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	bool connected;
+	bool sw_connected;
+	struct work_struct work;
+	struct device *dev;
+#endif
 };
=20
 struct config_usb_cfg {
@@ -1444,13 +1459,143 @@ static void configfs_composite_unbind(struct u=
sb_gadget *gadget)
 	set_gadget_data(gadget, NULL);
 }
=20
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+static ssize_t state_show(struct device *pdev, struct device_attribute=
 *attr,
+			char *buf)
+{
+	struct gadget_info *dev =3D dev_get_drvdata(pdev);
+	struct usb_composite_dev *cdev;
+	char *state =3D "DISCONNECTED";
+	unsigned long flags;
+
+	if (!dev)
+		goto out;
+
+	cdev =3D &dev->cdev;
+
+	if (!cdev)
+		goto out;
+
+	spin_lock_irqsave(&cdev->lock, flags);
+	if (cdev->config)
+		state =3D "CONFIGURED";
+	else if (dev->connected)
+		state =3D "CONNECTED";
+	spin_unlock_irqrestore(&cdev->lock, flags);
+out:
+	return sprintf(buf, "%s\n", state);
+}
+
+static DEVICE_ATTR(state, S_IRUGO, state_show, NULL);
+
+static struct device_attribute *cfs_usb_attributes[] =3D {
+	&dev_attr_state,
+	NULL
+};
+
+static void cfs_uevent_work(struct work_struct *data)
+{
+	struct gadget_info *gi =3D container_of(data, struct gadget_info, wor=
k);
+	struct usb_composite_dev *cdev =3D &gi->cdev;
+	char *disconnected[2] =3D { "USB_STATE=3DDISCONNECTED", NULL };
+	char *connected[2]    =3D { "USB_STATE=3DCONNECTED", NULL };
+	char *configured[2]   =3D { "USB_STATE=3DCONFIGURED", NULL };
+	/* 0-connected 1-configured 2-disconnected*/
+	bool status[3] =3D { false, false, false };
+	unsigned long flags;
+	bool uevent_sent =3D false;
+
+	spin_lock_irqsave(&cdev->lock, flags);
+	if (cdev->config)
+		status[1] =3D true;
+
+	if (gi->connected !=3D gi->sw_connected) {
+		if (gi->connected)
+			status[0] =3D true;
+		else
+			status[2] =3D true;
+		gi->sw_connected =3D gi->connected;
+	}
+	spin_unlock_irqrestore(&cdev->lock, flags);
+
+	if (status[0]) {
+		kobject_uevent_env(&usb_gadget_device->kobj,
+					KOBJ_CHANGE, connected);
+		pr_info("%s: sent uevent %s\n", __func__, connected[0]);
+		uevent_sent =3D true;
+	}
+
+	if (status[1]) {
+		kobject_uevent_env(&usb_gadget_device->kobj,
+					KOBJ_CHANGE, configured);
+		pr_info("%s: sent uevent %s\n", __func__, configured[0]);
+		uevent_sent =3D true;
+	}
+
+	if (status[2]) {
+		kobject_uevent_env(&usb_gadget_device->kobj,
+					KOBJ_CHANGE, disconnected);
+		pr_info("%s: sent uevent %s\n", __func__, disconnected[0]);
+		uevent_sent =3D true;
+	}
+
+	if (!uevent_sent) {
+		pr_info("%s: did not send uevent (%d %d %p)\n", __func__,
+			gi->connected, gi->sw_connected, cdev->config);
+	}
+}
+
+static int cfs_uevent_setup(struct usb_gadget *gadget,
+			const struct usb_ctrlrequest *c)
+{
+	struct usb_composite_dev *cdev =3D get_gadget_data(gadget);
+	unsigned long flags;
+	struct gadget_info *gi =3D container_of(cdev, struct gadget_info, cde=
v);
+	int value =3D -EOPNOTSUPP;
+
+	spin_lock_irqsave(&cdev->lock, flags);
+	if (!gi->connected) {
+		gi->connected =3D 1;
+		schedule_work(&gi->work);
+	}
+	spin_unlock_irqrestore(&cdev->lock, flags);
+
+	value =3D composite_setup(gadget, c);
+
+	spin_lock_irqsave(&cdev->lock, flags);
+	if (c->bRequest =3D=3D USB_REQ_SET_CONFIGURATION &&
+						cdev->config) {
+		schedule_work(&gi->work);
+	}
+	spin_unlock_irqrestore(&cdev->lock, flags);
+
+	return value;
+}
+
+static void cfs_uevent_disconnect(struct usb_gadget *gadget)
+{
+	struct usb_composite_dev *cdev =3D get_gadget_data(gadget);
+	struct gadget_info *gi =3D container_of(cdev, struct gadget_info, cde=
v);
+
+	gi->connected =3D 0;
+	schedule_work(&gi->work);
+	composite_disconnect(gadget);
+}
+#endif
+
 static const struct usb_gadget_driver configfs_driver_template =3D {
 	.bind           =3D configfs_composite_bind,
 	.unbind         =3D configfs_composite_unbind,
=20
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	.setup          =3D cfs_uevent_setup,
+	.reset          =3D cfs_uevent_disconnect,
+	.disconnect     =3D cfs_uevent_disconnect,
+#else
 	.setup          =3D composite_setup,
 	.reset          =3D composite_disconnect,
 	.disconnect     =3D composite_disconnect,
+#endif
=20
 	.suspend	=3D composite_suspend,
 	.resume		=3D composite_resume,
@@ -1462,16 +1607,21 @@ static const struct usb_gadget_driver configfs_=
driver_template =3D {
 	},
 };
=20
+
 static struct config_group *gadgets_make(
 		struct config_group *group,
 		const char *name)
 {
 	struct gadget_info *gi;
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	struct device_attribute **attrs;
+	struct device_attribute *attr;
+	int err;
+#endif
=20
 	gi =3D kzalloc(sizeof(*gi), GFP_KERNEL);
 	if (!gi)
 		return ERR_PTR(-ENOMEM);
-
 	gi->group.default_groups =3D gi->default_groups;
 	gi->group.default_groups[0] =3D &gi->functions_group;
 	gi->group.default_groups[1] =3D &gi->configs_group;
@@ -1507,9 +1657,26 @@ static struct config_group *gadgets_make(
 	gi->composite.gadget_driver.function =3D kstrdup(name, GFP_KERNEL);
 	gi->composite.name =3D gi->composite.gadget_driver.function;
=20
-	if (!gi->composite.gadget_driver.function)
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	INIT_WORK(&gi->work, cfs_uevent_work);
+	usb_gadget_device =3D device_create(usb_gadget_class, NULL,
+				MKDEV(0, 0), NULL, "android0");
+	if (IS_ERR(usb_gadget_device))
 		goto err;
=20
+	dev_set_drvdata(usb_gadget_device, gi);
+
+	attrs =3D cfs_usb_attributes;
+	while ((attr =3D *attrs++)) {
+		err =3D device_create_file(usb_gadget_device, attr);
+		if (err)
+			goto err1;
+	}
+#endif
+
+	if (!gi->composite.gadget_driver.function)
+		goto err1;
+
 #ifdef CONFIG_USB_OTG
 	gi->otg.bLength =3D sizeof(struct usb_otg_descriptor);
 	gi->otg.bDescriptorType =3D USB_DT_OTG;
@@ -1519,13 +1686,31 @@ static struct config_group *gadgets_make(
 	config_group_init_type_name(&gi->group, name,
 				&gadget_root_type);
 	return &gi->group;
+
+err1:
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	attrs =3D cfs_usb_attributes;
+	while ((attr =3D *attrs++))
+		device_remove_file(usb_gadget_device, attr);
+	device_destroy(usb_gadget_device->class, usb_gadget_device->devt);
 err:
+#endif
 	kfree(gi);
 	return ERR_PTR(-ENOMEM);
 }
=20
 static void gadgets_drop(struct config_group *group, struct config_ite=
m *item)
 {
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	struct device_attribute **attrs;
+	struct device_attribute *attr;
+
+	attrs =3D cfs_usb_attributes;
+	while ((attr =3D *attrs++))
+		device_remove_file(usb_gadget_device, attr);
+	device_destroy(usb_gadget_device->class, usb_gadget_device->devt);
+#endif
+
 	config_item_put(item);
 }
=20
@@ -1564,6 +1749,13 @@ static int __init gadget_cfs_init(void)
 	config_group_init(&gadget_subsys.su_group);
=20
 	ret =3D configfs_register_subsystem(&gadget_subsys);
+
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	usb_gadget_class =3D class_create(THIS_MODULE, "android_usb");
+	if (IS_ERR(usb_gadget_class))
+		return PTR_ERR(usb_gadget_class);
+#endif
+
 	return ret;
 }
 module_init(gadget_cfs_init);
@@ -1571,5 +1763,10 @@ module_init(gadget_cfs_init);
 static void __exit gadget_cfs_exit(void)
 {
 	configfs_unregister_subsystem(&gadget_subsys);
+#ifdef CONFIG_USB_CONFIGFS_UEVENT
+	if (!IS_ERR(usb_gadget_class))
+		class_destroy(usb_gadget_class);
+#endif
+
 }
 module_exit(gadget_cfs_exit);
--=20
1.9.1
