From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Thu, 15 Jan 2015 11:49:49 -0800
Message-ID: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>, Johan Hovold <johan@kernel.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org, Soren Brinkmann <soren.brinkmann@xilinx.com>
List-Id: linux-api@vger.kernel.org

Add an attribute 'wakeup' to the GPIO sysfs interface which allows
marking/unmarking a GPIO as wake IRQ.
The file 'wakeup' is created in each exported GPIOs directory, if an IR=
Q
is associated with that GPIO and the irqchip implements set_wake().
Writing 'enabled' to that file will enable wake for that GPIO, while
writing 'disabled' will disable wake.
Reading that file will return either 'disabled' or 'enabled' depening o=
n
the currently set flag for the GPIO's IRQ.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
---
Hi Linus, Johan,

I rebased my patch. And things look good. But the 'is_visible' things d=
oes not
behave the way I expected it to. It seems to be only triggered on an ex=
port but
not when attributes change. Hence, in my case, everything was visiible =
since the
inital state matches that, but even when changing the direction or thin=
gs like
that, attributes don't disappear. Is that something still worked on? Ex=
pected
behavior?

	Thanks,
	S=C3=B6ren

v4:
 - rebased onto gpio/fixes
   - fit into the new attribute framework
   - extend is_visible to limit the wakeup attributes visibility
     according to usability
v3:
 - add documentation
v2:
 - fix error path to unlock mutex before return
---
 Documentation/ABI/testing/sysfs-gpio |  1 +
 Documentation/gpio/sysfs.txt         |  8 +++++
 drivers/gpio/gpiolib-sysfs.c         | 62 ++++++++++++++++++++++++++++=
++++++++
 3 files changed, 71 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-gpio b/Documentation/ABI/t=
esting/sysfs-gpio
index 80f4c94c7bef..4cc7f4b3f724 100644
--- a/Documentation/ABI/testing/sysfs-gpio
+++ b/Documentation/ABI/testing/sysfs-gpio
@@ -20,6 +20,7 @@ Description:
 	    /value ... always readable, writes fail for input GPIOs
 	    /direction ... r/w as: in, out (default low); write: high, low
 	    /edge ... r/w as: none, falling, rising, both
+	    /wakeup ... r/w as: enabled, disabled
 	/gpiochipN ... for each gpiochip; #N is its first GPIO
 	    /base ... (r/o) same as N
 	    /label ... (r/o) descriptive, not necessarily unique
diff --git a/Documentation/gpio/sysfs.txt b/Documentation/gpio/sysfs.tx=
t
index c2c3a97f8ff7..f703377d528f 100644
--- a/Documentation/gpio/sysfs.txt
+++ b/Documentation/gpio/sysfs.txt
@@ -97,6 +97,14 @@ and have the following read/write attributes:
 		for "rising" and "falling" edges will follow this
 		setting.
=20
+	"wakeup" ... reads as either "enabled" or "disabled". Write these
+		strings to set/clear the 'wakeup' flag of the IRQ associated
+		with this GPIO. If the IRQ has the 'wakeup' flag set, it can
+		wake the system from sleep states.
+
+		This file exists only if the pin can generate interrupts and
+		the driver implements the required infrastructure.
+
 GPIO controllers have paths like /sys/class/gpio/gpiochip42/ (for the
 controller implementing GPIOs starting at #42) and have the following
 read-only attributes:
diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.=
c
index f62aa115d79a..14b34d15e61c 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -286,6 +286,58 @@ found:
=20
 static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
=20
+static ssize_t gpio_wakeup_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t			status;
+	const struct gpio_desc	*desc =3D dev_get_drvdata(dev);
+	int			irq =3D gpiod_to_irq(desc);
+	struct irq_desc		*irq_desc =3D irq_to_desc(irq);
+
+	mutex_lock(&sysfs_lock);
+
+	if (irqd_is_wakeup_set(&irq_desc->irq_data))
+		status =3D sprintf(buf, "enabled\n");
+	else
+		status =3D sprintf(buf, "disabled\n");
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static ssize_t gpio_wakeup_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	int			ret;
+	unsigned int		on;
+	struct gpio_desc	*desc =3D dev_get_drvdata(dev);
+	int			irq =3D gpiod_to_irq(desc);
+
+	mutex_lock(&sysfs_lock);
+
+	if (sysfs_streq("enabled", buf)) {
+		on =3D true;
+	} else if (sysfs_streq("disabled", buf)) {
+		on =3D false;
+	} else {
+		mutex_unlock(&sysfs_lock);
+		return -EINVAL;
+	}
+
+	ret =3D irq_set_irq_wake(irq, on);
+
+	mutex_unlock(&sysfs_lock);
+
+	if (ret)
+		pr_warn("%s: failed to %s wake\n", __func__,
+				on ? "enable" : "disable");
+
+	return size;
+}
+
+static DEVICE_ATTR(wakeup, 0644, gpio_wakeup_show, gpio_wakeup_store);
+
 static int sysfs_set_active_low(struct gpio_desc *desc, struct device =
*dev,
 				int value)
 {
@@ -361,6 +413,7 @@ static umode_t gpio_is_visible(struct kobject *kobj=
, struct attribute *attr,
 {
 	struct device *dev =3D container_of(kobj, struct device, kobj);
 	struct gpio_desc *desc =3D dev_get_drvdata(dev);
+	struct irq_chip *irqchip =3D desc->chip->irqchip;
 	umode_t mode =3D attr->mode;
 	bool show_direction =3D test_bit(FLAG_SYSFS_DIR, &desc->flags);
=20
@@ -372,6 +425,14 @@ static umode_t gpio_is_visible(struct kobject *kob=
j, struct attribute *attr,
 			mode =3D 0;
 		if (!show_direction && test_bit(FLAG_IS_OUT, &desc->flags))
 			mode =3D 0;
+	} else if (attr =3D=3D &dev_attr_wakeup.attr) {
+		if (gpiod_to_irq(desc) < 0)
+			mode =3D 0;
+		if (!show_direction && test_bit(FLAG_IS_OUT, &desc->flags))
+			mode =3D 0;
+		if (!test_bit(IRQCHIP_SKIP_SET_WAKE, &irqchip->flags) &&
+				!irqchip->irq_set_wake)
+			mode =3D 0;
 	}
=20
 	return mode;
@@ -382,6 +443,7 @@ static struct attribute *gpio_attrs[] =3D {
 	&dev_attr_edge.attr,
 	&dev_attr_value.attr,
 	&dev_attr_active_low.attr,
+	&dev_attr_wakeup.attr,
 	NULL,
 };
=20
--=20
2.2.1.1.gb42cc81

