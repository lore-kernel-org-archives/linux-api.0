From: Zhuang Jin Can <jin.can.zhuang@intel.com>
Subject: [PATCH] usb: core: add usb3 lpm sysfs
Date: Sun, 19 Apr 2015 11:46:12 +0800
Message-ID: <20150419034612.GA31576@intel.com>
Reply-To: jin.can.zhuang@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com, stern@rowland.harvard.edu, dan.j.williams@intel.com, pmladek@suse.cz, peter.chen@freescale.com, jwerner@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Some usb3 devices may not support usb3 lpm well.
The patch adds a sysfs to enable/disable u1 or u2 of the port.The
settings apply to both before and after device enumeration.
Supported values are "0" - u1 and u2 are disabled, "u1" - only u1 is
enabled, "u2" - only u2 is enabled, "u1_u2" - u1 and u2 are enabled.

The interface is useful for testing some USB3 devices during
development, and provides a way to disable usb3 lpm if the issues can
not be fixed in final products.

Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-usb |   10 ++++
 drivers/usb/core/hub.c                  |   16 +++++-
 drivers/usb/core/hub.h                  |    4 ++
 drivers/usb/core/port.c                 |   89 ++++++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/testing/sysfs-bus-usb
index e5cc763..32fc689 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb
+++ b/Documentation/ABI/testing/sysfs-bus-usb
@@ -179,3 +179,13 @@ Description:
 		Supported values are 0 - 15.
 		More information on how besl values map to microseconds can be found in
 		USB 2.0 ECN Errata for Link Power Management, section 4.10)
+
+What:		/sys/bus/usb/devices/.../(hub interface)/portX/usb3_lpm
+Date:		March 2015
+Contact:	Zhuang Jin Can <jin.can.zhuang@intel.com>
+Description:
+		Some USB3.0 devices may not support usb3 lpm well.
+		usb3_lpm attribute allows enabling/disabling usb3 lpm of the port.
+		It takes effect both before and after a usb device is enumerated.
+		Supported values are "0" if u1 and u2 are disabled, "u1" if only u1 is
+		enabled, "u2" if only u2 is enabled, "u1_u2" if u1 and u2 are enabled.
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d7c3d5a..7732a41 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3996,6 +3996,8 @@ EXPORT_SYMBOL_GPL(usb_unlocked_disable_lpm);
 void usb_enable_lpm(struct usb_device *udev)
 {
 	struct usb_hcd *hcd;
+	struct usb_hub *hub;
+	struct usb_port *port_dev;
 
 	if (!udev || !udev->parent ||
 			udev->speed != USB_SPEED_SUPER ||
@@ -4015,8 +4017,18 @@ void usb_enable_lpm(struct usb_device *udev)
 	if (udev->lpm_disable_count > 0)
 		return;
 
-	usb_enable_link_state(hcd, udev, USB3_LPM_U1);
-	usb_enable_link_state(hcd, udev, USB3_LPM_U2);
+	hub = usb_hub_to_struct_hub(udev->parent);
+	if (!hub) {
+		dev_err(&udev->dev, "can't enable lpm, usb_hub is null.\n");
+		return;
+	}
+	port_dev = hub->ports[udev->portnum - 1];
+
+	if (port_dev->u1_is_enabled)
+		usb_enable_link_state(hcd, udev, USB3_LPM_U1);
+
+	if (port_dev->u2_is_enabled)
+		usb_enable_link_state(hcd, udev, USB3_LPM_U2);
 }
 EXPORT_SYMBOL_GPL(usb_enable_lpm);
 
diff --git a/drivers/usb/core/hub.h b/drivers/usb/core/hub.h
index 688817f..1ae060e 100644
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -92,6 +92,8 @@ struct usb_hub {
  * @status_lock: synchronize port_event() vs usb_port_{suspend|resume}
  * @portnum: port index num based one
  * @is_superspeed cache super-speed status
+ * @u1_is_enabled: whether u1 should be enabled.
+ * @u2_is_enabled: whether u2 should be enabled.
  */
 struct usb_port {
 	struct usb_device *child;
@@ -104,6 +106,8 @@ struct usb_port {
 	struct mutex status_lock;
 	u8 portnum;
 	unsigned int is_superspeed:1;
+	unsigned int u1_is_enabled:1;
+	unsigned int u2_is_enabled:1;
 };
 
 #define to_usb_port(_dev) \
diff --git a/drivers/usb/core/port.c b/drivers/usb/core/port.c
index 2106183..7f4e6c7 100644
--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -50,6 +50,72 @@ static ssize_t connect_type_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(connect_type);
 
+static ssize_t usb3_lpm_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct usb_port *port_dev = to_usb_port(dev);
+	const char *p;
+
+	if (port_dev->u1_is_enabled) {
+		if (port_dev->u2_is_enabled)
+			p = "u1_u2";
+		else
+			p = "u1";
+	} else {
+		if (port_dev->u2_is_enabled)
+			p = "u2";
+		else
+			p = "0";
+	}
+
+	return sprintf(buf, "%s\n", p);
+}
+
+static ssize_t usb3_lpm_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct usb_port *port_dev = to_usb_port(dev);
+	struct usb_device *udev = port_dev->child;
+	struct usb_hcd *hcd;
+
+	if (!strncmp(buf, "u1_u2", 5)) {
+		port_dev->u1_is_enabled = 1;
+		port_dev->u2_is_enabled = 1;
+
+	} else if (!strncmp(buf, "u1", 2)) {
+		port_dev->u1_is_enabled = 1;
+		port_dev->u2_is_enabled = 0;
+
+	} else if (!strncmp(buf, "u2", 2)) {
+		port_dev->u1_is_enabled = 0;
+		port_dev->u2_is_enabled = 1;
+
+	} else if (!strncmp(buf, "0", 1)) {
+		port_dev->u1_is_enabled = 0;
+		port_dev->u2_is_enabled = 0;
+	} else
+		return -EINVAL;
+
+	/* If device is connected to the port, disable & enable lpm
+	 * to make new u1 u2 setting take effect immediately
+	 */
+	if (udev) {
+		hcd = bus_to_hcd(udev->bus);
+		if (!hcd)
+			return -EINVAL;
+		usb_lock_device(udev);
+		mutex_lock(hcd->bandwidth_mutex);
+		if (!usb_disable_lpm(udev))
+			usb_enable_lpm(udev);
+		mutex_unlock(hcd->bandwidth_mutex);
+		usb_unlock_device(udev);
+	}
+
+	return count;
+}
+static DEVICE_ATTR_RW(usb3_lpm);
+
 static struct attribute *port_dev_attrs[] = {
 	&dev_attr_connect_type.attr,
 	NULL,
@@ -64,6 +130,21 @@ static const struct attribute_group *port_dev_group[] = {
 	NULL,
 };
 
+static struct attribute *port_dev_usb3_attrs[] = {
+	&dev_attr_usb3_lpm.attr,
+	NULL,
+};
+
+static struct attribute_group port_dev_usb3_attr_grp = {
+	.attrs = port_dev_usb3_attrs,
+};
+
+static const struct attribute_group *port_dev_usb3_group[] = {
+	&port_dev_attr_grp,
+	&port_dev_usb3_attr_grp,
+	NULL,
+};
+
 static void usb_port_device_release(struct device *dev)
 {
 	struct usb_port *port_dev = to_usb_port(dev);
@@ -401,6 +482,7 @@ static void find_and_link_peer(struct usb_hub *hub, int port1)
 int usb_hub_create_port_device(struct usb_hub *hub, int port1)
 {
 	struct usb_port *port_dev;
+	struct usb_device *hdev = hub->hdev;
 	int retval;
 
 	port_dev = kzalloc(sizeof(*port_dev), GFP_KERNEL);
@@ -417,7 +499,12 @@ int usb_hub_create_port_device(struct usb_hub *hub, int port1)
 	port_dev->portnum = port1;
 	set_bit(port1, hub->power_bits);
 	port_dev->dev.parent = hub->intfdev;
-	port_dev->dev.groups = port_dev_group;
+	if (hub_is_superspeed(hdev)) {
+		port_dev->u1_is_enabled = 1;
+		port_dev->u2_is_enabled = 1;
+		port_dev->dev.groups = port_dev_usb3_group;
+	} else
+		port_dev->dev.groups = port_dev_group;
 	port_dev->dev.type = &usb_port_device_type;
 	port_dev->dev.driver = &usb_port_driver;
 	if (hub_is_superspeed(hub->hdev))
-- 
1.7.9.5
