Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524A14E9C0B
	for <linux-api@vger.kernel.org>; Fri,  9 Oct 2026 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560373; cv=none; b=Llv3aiHY2eebUaTG57g0cYmmfjY2omNAm5h5sXMukXnn/gznW1fJLcED22qhuQGvn+GJBV6s1fL2qJy/L+1iqR1KHPUx3Wr6pYLJOnpAgVWelz2sXVHTOJk+KygwbyCQE4RYFvIHTYr1MWOBL/pOrE5dXs9pb+XjOBaoRI0Eagg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560373; c=relaxed/simple;
	bh=xGWpb/lkBat3eWhP5ZRFOCS2gI7SF+uyWvzpAVwNA6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avx5g8yqh6/QXkS3LyCJJFF1hNBfnwVi1ihZ/qTV6SbCIiKtopTHCl3osEtaK4t6MrqaYC3XV0IgZUEaKnJM5gE4YGdeVTO7M6j3PWR1fcnPy0wF72Z7o+JE4M3c1LmPxngcABgrQhFPkEPX4Y7amPDhKe0ZUHdcAyo5/l3MNvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VbNXYIq+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VbNXYIq+"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e5fb79ce82so18631775ad.0
        for <linux-api@vger.kernel.org>; Fri, 09 Oct 2026 08:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791560370; x=1792165170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FoWTJY06X/AAZGql0WgAB5YbSdxgGLMTHV7M003KBKw=;
        b=VbNXYIq+NLCDgG3q5gaz48z0G25InC0IwSfD6wadvR3cnjsKdTt2c0CfNGfJNXqoui
         ksBCSCw1BA3bZPC+wCL9+RTde0hVuaHhxA5hwKQCym/bWKLREwrEPhPUJhiBJKjKr5Gi
         +nBqA4zxH6m85mA0Z6aeA3exSaqq/37L+eTtAMdurINqi2liTFHZPUIANIMpxVTE9cg8
         Ka4JN2j7g+JrXoUCSm5uYNTattWSUYKO+rg7qoZenn4GC3OMkRFIZqzpfseXkDzZ2mDN
         n/RiMUgBZbbR8QXdyum72qRSDMvwlpHfCSImTF+WsaaKMkpQAOzirbookI91w0qAcosY
         PHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791560370; x=1792165170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FoWTJY06X/AAZGql0WgAB5YbSdxgGLMTHV7M003KBKw=;
        b=cM1TnMIz/wZSChsP4wrluxkskiS5KBTPnfX6o289SEQmNUD42sSvmMayjwtPddPzd1
         g1b3nK2PTKIucKQZruxAFPCKi3Ui8mBjGXV58uNiNAPvvgXfJBPnzswFWZk2mNnVNhUw
         FqlySfPwPTKI43m/BK6zvplf2PoEdzueIZnwH7nNhZk74fAToRA3n7up9FkS15T1xifh
         vcgO5gka3t7FUqVcvjNo/whGxgf96HmaeKgR34gAJaaknlJdkO/sSDjE522j7kFiXYPc
         HuxLq5brNush6nWbO1T81jgY2YrJVQFcsaXrYaW7wxvMTMSEKMFA3U/DlycgSbUBDhKp
         LtyA==
X-Forwarded-Encrypted: i=1; AKwUvBwo3PSH3Tz1ILGeZ6SW8KMgU2/vG78hHa/b1h53dpR2RNyr87ieExVcuwlgWUH2AGBCCYSHmfJDGAs=@vger.kernel.org
X-Gm-Message-State: AFq9FYKTrWjy1l3qJXNS+NREVljxmAf2wfXrYdZsA1PJrq17QKDvpe2M
	RTZqkw8DP+njhuq5nH5k0/qTYRuaGLTvcoNIGG+5JwrTH0uB9eHhffRr
X-Gm-Gg: AYBFou1f6KAG9K2NnKrixT+tZXsgowhyRQk/spVplO/ypa5OmCMYrhpr9NR9Wi/owfv
	2Pb7wRUA4+JmDWvEATJGPwDYQbYsKIPJNaqb1WLHB+KiDQ7t+jusdPoNjNaIAkpWw95aeE//iKP
	GEuVX0Q8A9Egf5i0HLK2gG2BRXwZ1sOUUxdMLWbN8V4Z9O/mTj2iYHh/57VmoPIMNlij1diqBOl
	orvbcMwLDQwlU503zIywnr2UmBEBBHN3E1cxOfZTks7IYaInEV4MtybpsiOnPjuW9yaTswQIkpR
	6Nov9Ppu3gtlGgYa3GvIEpPMz/UY4TeONHgjkW4++JDWvkHE/vPj7wYz7zMqWtQXz1Y/mbK87oF
	FMuwocQItHx0Dkx2EQddlCpBeKJ6RLOCGFHiH1FZW1K5gUkNdYoapNXK5HIwAtCW+4+Xn/66T7J
	WeII92s83OosT5UOcZzVHHNvWZNpvlirgBiGl9FoW2yhTlyEv9kd9xBfY8PHMMdpJGLWyN
X-Received: by 2002:a17:902:e74f:b0:2e8:1929:c8e4 with SMTP id d9443c01a7336-2e842f13e34mr20113555ad.60.1791560364898;
        Fri, 09 Oct 2026 08:39:24 -0700 (PDT)
Received: from mincom1 ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421ae999sm11847705ad.31.2026.10.09.08.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:39:24 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] hwmon: Add a generic interface for userspace implementations
Date: Sat, 10 Oct 2026 00:38:42 +0900
Message-ID: <27071a389536dfbc35b628a50e90636ce012c21f.1791559095.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791531025.git.hurryman2212@gmail.com>
References: <cover.1791531025.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add /dev/uhwmon so userspace drivers can expose standard hwmon
attributes. Use the shared hwmon identifiers directly and forward
numeric values or labels through read and write requests.

Reuse hwmon sysfs formatting and notifications. Preserve devices across
daemon disconnects and support reconnection or explicit removal.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |   1 +
 drivers/hwmon/Kconfig                         |   9 +
 drivers/hwmon/Makefile                        |   1 +
 drivers/hwmon/uhwmon.c                        | 641 ++++++++++++++++++
 include/uapi/linux/uhwmon.h                   |  64 ++
 6 files changed, 717 insertions(+)
 create mode 100644 drivers/hwmon/uhwmon.c
 create mode 100644 include/uapi/linux/uhwmon.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 2fc53093752d..76126b74ebb7 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -384,6 +384,7 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xB9  00-02  uapi/linux/uhwmon.h                                       Userspace hardware monitoring
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
diff --git a/MAINTAINERS b/MAINTAINERS
index f3f0292832bb..fb9d9233a8d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11493,6 +11493,7 @@ F:	drivers/hwmon/
 F:	include/linux/hwmon*.h
 F:	include/trace/events/hwmon*.h
 F:	include/uapi/linux/hwmon.h
+F:	include/uapi/linux/uhwmon.h
 K:	(devm_)?hwmon_device_(un)?register(|_with_groups|_with_info)
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index fecff8610ea8..dbff7bff035f 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -2537,6 +2537,15 @@ config SENSORS_TSC1641
 	  This driver can also be built as a module. If so, the module
 	  will be called tsc1641.
 
+config SENSORS_UHWMON
+	tristate "Userspace hardware monitoring devices"
+	help
+	  Provide a standard interface for userspace hwmon drivers through
+	  /dev/uhwmon.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called uhwmon.
+
 config SENSORS_VEXPRESS
 	tristate "Versatile Express"
 	depends on VEXPRESS_CONFIG
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 1229b6b3996d..27baa01d8d0f 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -242,6 +242,7 @@ obj-$(CONFIG_SENSORS_TMP421)	+= tmp421.o
 obj-$(CONFIG_SENSORS_TMP464)	+= tmp464.o
 obj-$(CONFIG_SENSORS_TMP513)	+= tmp513.o
 obj-$(CONFIG_SENSORS_TSC1641)	+= tsc1641.o
+obj-$(CONFIG_SENSORS_UHWMON)	+= uhwmon.o
 obj-$(CONFIG_SENSORS_VEXPRESS)	+= vexpress-hwmon.o
 obj-$(CONFIG_SENSORS_VIA_CPUTEMP)+= via-cputemp.o
 obj-$(CONFIG_SENSORS_VIA686A)	+= via686a.o
diff --git a/drivers/hwmon/uhwmon.c b/drivers/hwmon/uhwmon.c
new file mode 100644
index 000000000000..1855c87f06d9
--- /dev/null
+++ b/drivers/hwmon/uhwmon.c
@@ -0,0 +1,641 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Generic hwmon interface for userspace implementations.
+ *
+ * Copyright (C) 2026 Jihong Min <hurryman2212@gmail.com>
+ */
+
+#include <linux/fs.h>
+#include <linux/hwmon.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/overflow.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/uhwmon.h>
+
+struct uhwmon_attr {
+	struct uhwmon_attribute spec;
+	char *text;
+};
+
+struct uhwmon_pending {
+	struct uhwmon_request request;
+	s64 *value;
+	int result;
+	bool done;
+};
+
+struct uhwmon_device {
+	struct list_head node;
+	struct device *hwmon;
+	char *name;
+	struct uhwmon_attr *attrs;
+	struct hwmon_chip_info chip;
+	struct hwmon_channel_info channels[hwmon_max];
+	const struct hwmon_channel_info *info[hwmon_max + 1];
+	char *text;
+	u32 num_attrs;
+	/* Protects connection and request state. Never held while waiting. */
+	struct mutex lock;
+	bool online;
+	struct uhwmon_pending *pending;
+	u64 next_id;
+	wait_queue_head_t wait;
+	bool readable;
+	bool destroyed;
+};
+
+static DEFINE_MUTEX(uhwmon_control_lock);
+static LIST_HEAD(uhwmon_devices);
+
+static int uhwmon_find_attr(const struct uhwmon_device *data,
+			    enum hwmon_sensor_types type, u32 attr, int channel)
+{
+	unsigned int i;
+
+	for (i = 0; i < data->num_attrs; i++) {
+		const struct uhwmon_attribute *spec = &data->attrs[i].spec;
+
+		if (spec->type == type && spec->attr == attr &&
+		    spec->channel == channel)
+			return i;
+	}
+	return -ENOENT;
+}
+
+static int uhwmon_request(struct uhwmon_device *data, unsigned int index,
+			  u32 op, s64 *value)
+{
+	struct uhwmon_pending pending = {
+		.request = {
+			.attr = index,
+			.op = op,
+			.value = op == UHWMON_WRITE ? *value : 0,
+		},
+		.value = value,
+	};
+	int ret;
+
+	mutex_lock(&data->lock);
+	if (!data->online) {
+		ret = op == UHWMON_READ ? -ENODATA : -ENODEV;
+		goto out;
+	}
+	/* hwmon serializes callbacks, including consumption of read_string(). */
+	pending.request.id = ++data->next_id;
+	data->pending = &pending;
+	data->readable = true;
+	mutex_unlock(&data->lock);
+	wake_up_all(&data->wait);
+
+	ret = wait_event_interruptible(data->wait, READ_ONCE(pending.done));
+	mutex_lock(&data->lock);
+	if (!pending.done && !data->readable) {
+		/* Once delivered, only fatal signals may abort the wait. */
+		mutex_unlock(&data->lock);
+		ret = wait_event_killable(data->wait, READ_ONCE(pending.done));
+		mutex_lock(&data->lock);
+	}
+	if (pending.done)
+		ret = pending.result;
+	data->pending = NULL;
+	data->readable = false;
+out:
+	mutex_unlock(&data->lock);
+	return ret;
+}
+
+static umode_t uhwmon_is_visible(const void *drvdata,
+				 enum hwmon_sensor_types type, u32 attr,
+				 int channel)
+{
+	const struct uhwmon_device *data = drvdata;
+	int index = uhwmon_find_attr(data, type, attr, channel);
+
+	return index < 0 ? 0 : data->attrs[index].spec.mode;
+}
+
+static int uhwmon_read_value(struct device *dev, enum hwmon_sensor_types type,
+			     u32 attr, int channel, long *val)
+{
+	struct uhwmon_device *data = dev_get_drvdata(dev);
+	int index = uhwmon_find_attr(data, type, attr, channel);
+	s64 value;
+	int ret;
+
+	if (index < 0)
+		return index;
+	value = data->attrs[index].spec.value;
+	if (!(data->attrs[index].spec.flags & UHWMON_ATTR_CONSTANT)) {
+		ret = uhwmon_request(data, index, UHWMON_READ, &value);
+		if (ret)
+			return ret;
+	}
+	if (type == hwmon_energy64) {
+		*(s64 *)val = value;
+		return 0;
+	}
+	if (value < LONG_MIN || value > LONG_MAX)
+		return -ERANGE;
+	*val = value;
+	return 0;
+}
+
+static int uhwmon_read_string(struct device *dev, enum hwmon_sensor_types type,
+			      u32 attr, int channel, const char **str)
+{
+	struct uhwmon_device *data = dev_get_drvdata(dev);
+	int index = uhwmon_find_attr(data, type, attr, channel);
+	int ret;
+
+	if (index < 0)
+		return index;
+	if (data->attrs[index].spec.flags & UHWMON_ATTR_CONSTANT) {
+		*str = data->attrs[index].text;
+		return 0;
+	}
+	ret = uhwmon_request(data, index, UHWMON_READ, NULL);
+	if (!ret)
+		*str = data->text;
+	return ret;
+}
+
+static int uhwmon_write_value(struct device *dev, enum hwmon_sensor_types type,
+			      u32 attr, int channel, long val)
+{
+	struct uhwmon_device *data = dev_get_drvdata(dev);
+	int index = uhwmon_find_attr(data, type, attr, channel);
+	s64 value = val;
+
+	if (index < 0)
+		return index;
+	return uhwmon_request(data, index, UHWMON_WRITE, &value);
+}
+
+static const struct hwmon_ops uhwmon_ops = {
+	.is_visible = uhwmon_is_visible,
+	.read = uhwmon_read_value,
+	.read_string = uhwmon_read_string,
+	.write = uhwmon_write_value,
+};
+
+static void uhwmon_free(struct uhwmon_device *data)
+{
+	unsigned int i;
+
+	for (i = 0; i < data->num_attrs; i++)
+		kfree(data->attrs[i].text);
+	for (i = 0; i < hwmon_max; i++)
+		kfree(data->channels[i].config);
+	kvfree(data->attrs);
+	kfree(data->text);
+	kfree(data->name);
+	kfree(data);
+}
+
+static bool uhwmon_same_schema(struct uhwmon_device *a, struct uhwmon_device *b)
+{
+	unsigned int i;
+
+	if (a->num_attrs != b->num_attrs)
+		return false;
+	for (i = 0; i < a->num_attrs; i++) {
+		struct uhwmon_attr *x = &a->attrs[i], *y = &b->attrs[i];
+
+		if (memcmp(&x->spec, &y->spec, sizeof(x->spec)) ||
+		    (x->text && strcmp(x->text, y->text)))
+			return false;
+	}
+	return true;
+}
+
+static void uhwmon_disconnect(struct uhwmon_device *data)
+{
+	mutex_lock(&data->lock);
+	data->online = false;
+	data->readable = false;
+	if (data->pending && !data->pending->done) {
+		data->pending->result =
+			data->pending->request.op == UHWMON_READ ? -ENODATA :
+								   -ENODEV;
+		data->pending->done = true;
+	}
+	mutex_unlock(&data->lock);
+	wake_up_all(&data->wait);
+}
+
+static void uhwmon_unregister(struct uhwmon_device *data)
+{
+	uhwmon_disconnect(data);
+	hwmon_device_unregister(data->hwmon);
+	data->destroyed = true;
+}
+
+static struct miscdevice uhwmon_misc;
+
+static int uhwmon_create(struct file *file, void __user *arg)
+{
+	struct uhwmon_device *data, *existing;
+	struct uhwmon_attribute *spec = NULL;
+	struct uhwmon_create create;
+	u32 counts[hwmon_max] = {}, text_size = 0;
+	unsigned int i, j, n = 0;
+	int ret, total = 0;
+
+	if (file->private_data)
+		return -EBUSY;
+	if (copy_from_user(&create, arg, sizeof(create)))
+		return -EFAULT;
+	if (!create.num_attrs || create.reserved)
+		return -EINVAL;
+	if (create.num_attrs >= INT_MAX)
+		return -EOVERFLOW;
+	data = kzalloc_obj(*data);
+	if (!data)
+		return -ENOMEM;
+	mutex_init(&data->lock);
+	init_waitqueue_head(&data->wait);
+	data->name = strndup_user(u64_to_user_ptr(create.name), NAME_MAX + 1);
+	if (IS_ERR(data->name)) {
+		ret = PTR_ERR(data->name);
+		data->name = NULL;
+		goto out;
+	}
+	ret = -EINVAL;
+	if (!*data->name)
+		goto out;
+	for (i = 0; data->name[i]; i++)
+		if (hwmon_is_bad_char(data->name[i]))
+			goto out;
+	data->attrs =
+		kvcalloc(create.num_attrs, sizeof(*data->attrs), GFP_KERNEL);
+	if (!data->attrs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	data->num_attrs = create.num_attrs;
+	spec = memdup_array_user(u64_to_user_ptr(create.attrs),
+				 create.num_attrs, sizeof(*spec));
+	if (IS_ERR(spec)) {
+		ret = PTR_ERR(spec);
+		spec = NULL;
+		goto out;
+	}
+	for (i = 0; i < data->num_attrs; i++) {
+		struct uhwmon_attr *attr = &data->attrs[i];
+		u32 type;
+		bool string;
+
+		ret = -EINVAL;
+		if (spec[i].attr >= 32 ||
+		    !hwmon_is_valid_attr(spec[i].type, spec[i].attr) ||
+		    !spec[i].mode || spec[i].mode & ~0644 ||
+		    spec[i].flags & ~UHWMON_ATTR_CONSTANT)
+			goto out;
+		if (spec[i].type == hwmon_chip && spec[i].channel)
+			goto out;
+		/*
+		 * N is a zero-based channel index: channels 0..N need at least
+		 * N + 1 attribute slots, plus a NULL terminator. The core uses
+		 * int counts, so N + 2 <= INT_MAX. The full count is checked below.
+		 */
+		if (spec[i].channel > INT_MAX - 2) {
+			ret = -EOVERFLOW;
+			goto out;
+		}
+		string = hwmon_is_string_attr(spec[i].type, spec[i].attr);
+		if (string) {
+			if (!spec[i].size || spec[i].size > PAGE_SIZE ||
+			    spec[i].mode & 0222 || spec[i].value)
+				goto out;
+		} else if (spec[i].size || spec[i].text) {
+			goto out;
+		}
+		if (spec[i].flags & UHWMON_ATTR_CONSTANT) {
+			if (spec[i].mode & 0222)
+				goto out;
+			if (string) {
+				attr->text = strndup_user(
+					u64_to_user_ptr(spec[i].text),
+					spec[i].size);
+				if (IS_ERR(attr->text)) {
+					ret = PTR_ERR(attr->text);
+					attr->text = NULL;
+					goto out;
+				}
+			} else if (spec[i].type != hwmon_energy64 &&
+				   (spec[i].value < LONG_MIN ||
+				    spec[i].value > LONG_MAX)) {
+				ret = -ERANGE;
+				goto out;
+			}
+		} else {
+			if (spec[i].value || spec[i].text)
+				goto out;
+			if (string)
+				text_size = max(text_size, spec[i].size);
+		}
+		type = spec[i].type == hwmon_energy64 ? hwmon_energy :
+							spec[i].type;
+		for (j = 0; j < i; j++) {
+			u32 other_type = spec[j].type == hwmon_energy64 ?
+						 hwmon_energy :
+						 spec[j].type;
+
+			if (type == other_type &&
+			    spec[i].attr == spec[j].attr &&
+			    spec[i].channel == spec[j].channel)
+				goto out;
+		}
+		attr->spec = spec[i];
+		attr->spec.text = 0;
+		counts[spec[i].type] =
+			max(counts[spec[i].type], spec[i].channel + 1);
+	}
+	list_for_each_entry(existing, &uhwmon_devices, node) {
+		if (strcmp(existing->name, data->name))
+			continue;
+		ret = -EBUSY;
+		if (existing->online)
+			goto out;
+		ret = -EINVAL;
+		if (!uhwmon_same_schema(existing, data))
+			goto out;
+		mutex_lock(&existing->lock);
+		existing->online = true;
+		mutex_unlock(&existing->lock);
+		/* Publish initialized state to concurrent read/write/poll calls. */
+		smp_store_release(&file->private_data, existing);
+		ret = 0;
+		goto out;
+	}
+	for (i = 0; i < hwmon_max; i++) {
+		u32 *config;
+
+		if (!counts[i])
+			continue;
+		config = kcalloc(counts[i] + 1, sizeof(*config), GFP_KERNEL);
+		if (!config) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		data->channels[i].type = i;
+		data->channels[i].config = config;
+		data->info[n++] = &data->channels[i];
+		for (j = 0; j < data->num_attrs; j++)
+			if (spec[j].type == i)
+				config[spec[j].channel] |= BIT(spec[j].attr);
+		for (j = 0; j < counts[i]; j++) {
+			/* Zero terminates the array; is_visible() hides gaps. */
+			if (!config[j])
+				config[j] = BIT(0);
+			if (check_add_overflow(total, hweight32(config[j]),
+					       &total) ||
+			    total == INT_MAX) {
+				ret = -EOVERFLOW;
+				goto out;
+			}
+		}
+	}
+	if (text_size) {
+		data->text = kmalloc(text_size, GFP_KERNEL);
+		if (!data->text) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+	data->chip.ops = &uhwmon_ops;
+	data->chip.info = data->info;
+	data->hwmon = hwmon_device_register_with_info(
+		uhwmon_misc.this_device, data->name, data, &data->chip, NULL);
+	if (IS_ERR(data->hwmon)) {
+		ret = PTR_ERR(data->hwmon);
+		goto out;
+	}
+	list_add(&data->node, &uhwmon_devices);
+	mutex_lock(&data->lock);
+	data->online = true;
+	mutex_unlock(&data->lock);
+	/* Publish initialized state to concurrent read/write/poll calls. */
+	smp_store_release(&file->private_data, data);
+	kfree(spec);
+	return 0;
+out:
+	kfree(spec);
+	uhwmon_free(data);
+	return ret;
+}
+
+static ssize_t uhwmon_read(struct file *file, char __user *buf, size_t count,
+			   loff_t *offset)
+{
+	/* Paired with CREATE's publication of the initialized device. */
+	struct uhwmon_device *data = smp_load_acquire(&file->private_data);
+	int ret;
+
+	if (!data)
+		return -ENODEV;
+	if (count < sizeof(struct uhwmon_request))
+		return -EINVAL;
+	for (;;) {
+		if (mutex_lock_interruptible(&data->lock))
+			return -ERESTARTSYS;
+		if (!data->online) {
+			ret = -ENODEV;
+			goto out;
+		}
+		if (data->readable)
+			break;
+		mutex_unlock(&data->lock);
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		ret = wait_event_interruptible(
+			data->wait,
+			!READ_ONCE(data->online) || READ_ONCE(data->readable));
+		if (ret)
+			return ret;
+	}
+	ret = -EFAULT;
+	if (copy_to_user(buf, &data->pending->request,
+			 sizeof(data->pending->request)))
+		goto out;
+	data->readable = false;
+	ret = sizeof(data->pending->request);
+out:
+	mutex_unlock(&data->lock);
+	return ret;
+}
+
+static ssize_t uhwmon_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *offset)
+{
+	/* Paired with CREATE's publication of the initialized device. */
+	struct uhwmon_device *data = smp_load_acquire(&file->private_data);
+	struct uhwmon_pending *pending;
+	struct uhwmon_reply reply;
+	size_t size, length;
+	ssize_t ret;
+
+	if (!data)
+		return -ENODEV;
+	if (count < sizeof(reply))
+		return -EINVAL;
+	if (copy_from_user(&reply, buf, sizeof(reply)))
+		return -EFAULT;
+	if (reply.reserved || reply.status > 0 || reply.status <= -ERESTARTSYS)
+		return -EINVAL;
+	mutex_lock(&data->lock);
+	pending = data->pending;
+	ret = -ENODEV;
+	if (!data->online)
+		goto out;
+	ret = -ESTALE;
+	if (!pending || pending->request.id != reply.id)
+		goto out;
+	ret = -EALREADY;
+	if (pending->done)
+		goto out;
+	ret = -EINVAL;
+	if (data->readable)
+		goto out;
+	size = data->attrs[pending->request.attr].spec.size;
+	if (!reply.status && pending->request.op == UHWMON_READ) {
+		if (size) {
+			if (count < sizeof(reply) + size)
+				goto out;
+			ret = -EFAULT;
+			if (copy_from_user(data->text, buf + sizeof(reply),
+					   size))
+				goto out;
+			length = strnlen(data->text, size);
+			ret = -EINVAL;
+			if (length == size)
+				goto out;
+		} else {
+			*pending->value = reply.value;
+		}
+	} else {
+		size = 0;
+	}
+	pending->result = reply.status;
+	pending->done = true;
+	ret = sizeof(reply) + size;
+out:
+	mutex_unlock(&data->lock);
+	wake_up_all(&data->wait);
+	return ret;
+}
+
+static __poll_t uhwmon_poll(struct file *file, poll_table *wait)
+{
+	/* Paired with CREATE's publication of the initialized device. */
+	struct uhwmon_device *data = smp_load_acquire(&file->private_data);
+	__poll_t events = 0;
+
+	if (!data)
+		return EPOLLERR;
+	poll_wait(file, &data->wait, wait);
+	guard(mutex)
+		(&data->lock);
+	if (!data->online)
+		return EPOLLHUP | EPOLLERR;
+	if (data->readable)
+		events |= EPOLLIN | EPOLLRDNORM;
+	return events;
+}
+
+static long uhwmon_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct uhwmon_device *data;
+	const struct uhwmon_attribute *attr;
+	u32 index;
+
+	guard(mutex)
+		(&uhwmon_control_lock);
+	data = file->private_data;
+	if (cmd == UHWMON_CREATE)
+		return uhwmon_create(file, (void __user *)arg);
+	if (cmd != UHWMON_DESTROY && cmd != UHWMON_NOTIFY)
+		return -ENOTTY;
+	if (!data || data->destroyed)
+		return -ENODEV;
+	if (cmd == UHWMON_DESTROY) {
+		uhwmon_unregister(data);
+		list_del(&data->node);
+		return 0;
+	}
+	if (copy_from_user(&index, (void __user *)arg, sizeof(index)))
+		return -EFAULT;
+	if (index >= data->num_attrs)
+		return -EINVAL;
+	attr = &data->attrs[index].spec;
+	return hwmon_notify_event(data->hwmon, attr->type, attr->attr,
+				  attr->channel);
+}
+
+static int uhwmon_open(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return stream_open(inode, file);
+}
+
+static int uhwmon_release(struct inode *inode, struct file *file)
+{
+	struct uhwmon_device *data;
+
+	guard(mutex)
+		(&uhwmon_control_lock);
+	data = file->private_data;
+	if (data) {
+		uhwmon_disconnect(data);
+		if (data->destroyed)
+			uhwmon_free(data);
+	}
+	return 0;
+}
+
+static const struct file_operations uhwmon_fops = {
+	.owner = THIS_MODULE,
+	.open = uhwmon_open,
+	.release = uhwmon_release,
+	.read = uhwmon_read,
+	.write = uhwmon_write,
+	.poll = uhwmon_poll,
+	.unlocked_ioctl = uhwmon_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
+};
+
+static struct miscdevice uhwmon_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "uhwmon",
+	.fops = &uhwmon_fops,
+	.mode = 0600,
+};
+
+static int __init uhwmon_init(void)
+{
+	return misc_register(&uhwmon_misc);
+}
+
+static void __exit uhwmon_exit(void)
+{
+	struct uhwmon_device *data, *next;
+
+	misc_deregister(&uhwmon_misc);
+	list_for_each_entry_safe(data, next, &uhwmon_devices, node) {
+		uhwmon_unregister(data);
+		list_del(&data->node);
+		uhwmon_free(data);
+	}
+}
+
+module_init(uhwmon_init);
+module_exit(uhwmon_exit);
+
+MODULE_AUTHOR("Jihong Min <hurryman2212@gmail.com>");
+MODULE_DESCRIPTION("Generic hwmon interface for userspace implementations");
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/uhwmon.h b/include/uapi/linux/uhwmon.h
new file mode 100644
index 000000000000..8bc499646f49
--- /dev/null
+++ b/include/uapi/linux/uhwmon.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2026 Jihong Min <hurryman2212@gmail.com>
+ */
+
+#ifndef _UAPI_LINUX_UHWMON_H
+#define _UAPI_LINUX_UHWMON_H
+
+#include <linux/hwmon.h>
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define UHWMON_ATTR_CONSTANT (1U << 0)
+
+/*
+ * type and attr are hwmon enum identifiers, not HWMON_* bitmasks. channel is
+ * zero-based. Numeric attributes use size = 0; labels use a NUL-inclusive size
+ * in 1..PAGE_SIZE and omit the sysfs newline. Only constants set value or text.
+ */
+struct uhwmon_attribute {
+	__u32 type;
+	__u32 attr;
+	__u32 channel;
+	__u32 mode;
+	__u32 flags;
+	__u32 size;
+	__aligned_s64 value;
+	__aligned_u64 text;
+};
+
+/* name points to a NUL-terminated chip name; reserved must be zero. */
+struct uhwmon_create {
+	__aligned_u64 name;
+	__aligned_u64 attrs;
+	__u32 num_attrs;
+	__u32 reserved;
+};
+
+#define UHWMON_READ 1
+#define UHWMON_WRITE 2
+
+/* attr indexes the registration array; value carries a numeric write. */
+struct uhwmon_request {
+	__aligned_u64 id;
+	__u32 attr;
+	__u32 op;
+	__aligned_s64 value;
+};
+
+/* Only successful label reads append size bytes of NUL-terminated text. */
+struct uhwmon_reply {
+	__aligned_u64 id;
+	__s32 status;
+	__u32 reserved;
+	__aligned_s64 value;
+	char text[];
+};
+
+/* CREATE also reconnects an identical, currently unowned device. */
+#define UHWMON_CREATE _IOW(0xb9, 0, struct uhwmon_create)
+#define UHWMON_NOTIFY _IOW(0xb9, 1, __u32)
+#define UHWMON_DESTROY _IO(0xb9, 2)
+
+#endif /* _UAPI_LINUX_UHWMON_H */
