Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8438CFFA
	for <linux-api@vger.kernel.org>; Wed,  2 Sep 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788372545; cv=none; b=VI17ykZ3CegyJnpB8t4fIo2GUsuPTV9k+4Zg7YyvOjNOD6sE+9dY/RxABQzUAK69k+h+DVhQtGwy5hNFcy93Cnessq4KSY3JXivytL3AvHjWkClxjTBYNdL5VYKOaVi20CMxPPc9ORGXzeR35CgTHmvhgsmWAplPAVQUm8TmKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788372545; c=relaxed/simple;
	bh=WXxwcCYw97oxDuP+nMoaLP9XSoxZzH11XGEjJMJnfUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a1PCP7yVUTQ3ldkuIkWYUYbFkNCLq8EarEY7+HNne1zRST20modkuPP+b8McGbV8pjLI2ccrmr+EhlhabJfARwuOoP1c5pvJ9nmLf4Ff/EYal9ccOcwspcN3/OlZPnf1lOaKjK9aa2BdMMkxCNpc7pyluDIfulTU8OfhN/YarxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mp+iq6xP; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mp+iq6xP"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so9295105e9.1
        for <linux-api@vger.kernel.org>; Wed, 02 Sep 2026 11:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788372541; x=1788977341; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8mrh727DmKGYnR2t4ytHyxVhBLyWCC6xD4CyXfsx+O4=;
        b=mp+iq6xP38ODzRFTwpAmG176D+Bvl9nk9swMLrhTSNwzaI6Ot5DP+rVUp4ZV4yxPI/
         Wr9NznkU7Sa3Cmg8Vr6uQujIKkNpjhuHIL5EIyGMDHo0Hq1fosiV1qMKnTx15gnzhOiV
         aqGEIk8/UqUOHzNXz+wRomJavVhpUYOHQ6LTSbk16oFsw790im2FlwvpMUSFXjXEIH/m
         H0J7sOjfykgaehcQpEnc1AxuqzpNw1MJgPtSqbYJZPDMhp7nadHq1FgLTfOaS1Q67/MM
         +l+Kfy5o7zu9KliFBg+a2/TQLbwP4sCDzqDCsbi6eV+kF14JZjBIo5D0MgdmwiD4x/LA
         ytnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788372541; x=1788977341;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8mrh727DmKGYnR2t4ytHyxVhBLyWCC6xD4CyXfsx+O4=;
        b=Lah8/fjrDtSH/4c/Q74YhUjbuEYL3wFY5rZzFK+H2QYPsNBX7sA6HJjHb2y7DELjts
         R6xEVW8j3Hm/Eigd9LlYSQN6FO7ucGu6TJtXh5Z4vAJa+24yYBdL8l3GvBV54Otx7p6p
         lyQEulxP6KUMb1orCvBalccr4C+e7NVlTjV9lDMtUZPEAFFs0c9eURXzpW2fhFhHwdRs
         NESxGoiFpiGlYwk6hhghI+2pklXQ1VZkO1BAzQy4YoqNHVrS5AE9vWe2F8j9t9de9zgp
         DTaD2cl78GVaAfjCcEp/ZxKzIb7lJV87xJRfbu8HUNY/bSyBD2NpqlRmGZMrRB61w32y
         DVTg==
X-Forwarded-Encrypted: i=1; AKwUvBx/RjGCF455fNne7Ov5uWUa8C08g81x9q3VsVPmJ0HCQUHeMAp5qxmYaD46+zrcdtS7RSCyaHSEDHo=@vger.kernel.org
X-Gm-Message-State: AFuF++kyX9Vy7qWScM8FNg9P8H7S0pEyKdwe0TN+AaK2DbII7/IYNC8i
	3hs3Ie8vTfRi8sd+HWRpJTW6h1WcCNPTpDJi7g6QPn9rvFPMqrWR0S0G
X-Gm-Gg: AYBFou39D0BBc5m+PIeIZHK+a/57p+mN+NYlEDyDOxRB9F4hWSRzfSEX4+YMVe2ctl8
	Sa/PsR3WJ1fPlOhC1EUBkNX5/1szybOPQCFjzHD1bBZg46KWvi+kIH1Wj7B/S9fJiS8SkGSmOdf
	p7Ic8CIOsb9kSe++Y5B0AngLloFEyBErlblS7kd/hWKXyZiGYC2vOtwQhK0WBbS+W48T5TbBwCM
	UrJ6ydYb8C3SfV1nPRuDawZ8kHnNx0JZumoHFAc9AwBplJXkunh6/2pK1Ml04gBP02yTNsvMOq9
	K/3qkvpL1VpNWkXCTcnwkhAw/mckeO9ZI6HQN5/FnSR5Q5Hfj3t8WGJ0g1uQGo586tCxZ3u0WU0
	IDvLO/jUdyknVh/0Lj1Wh/L05hCdfgTqrAZvangOrWE68jESFD33HM0DdG8T7o2FMJTnpdGK1Gx
	Yn8W7fvHVcjqG8q6jGi8c0/Ok6nDClpt4Y7POGNJ19ieV58qJd5DqrXcENn/qiDZ+jsxx6pxJ57
	Q==
X-Received: by 2002:a05:600c:5653:b0:49c:ed94:cdd8 with SMTP id 5b1f17b1804b1-49ced94cdf3mr45838165e9.6.1788372540980;
        Wed, 02 Sep 2026 11:09:00 -0700 (PDT)
Received: from user-HP.inango.loc ([82.215.83.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d476esm10188125e9.1.2026.09.02.11.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:09:00 -0700 (PDT)
From: Andrey Erokhin <language.lawyer@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Keith Packard <keithp@keithp.com>,
	Simon Ser <contact@emersion.fr>,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v2] drm/lease: optionally expose leases as device nodes
Date: Wed,  2 Sep 2026 23:08:46 +0500
Message-ID: <20260902180846.2753456-1-language.lawyer@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

DRM leases are only returned as anonymous file descriptors.
Device managers such as udev and logind cannot discover these leases,
assign them to seats, or hand them to sessions via their device APIs.

Accept O_CREAT in DRM_IOCTL_MODE_CREATE_LEASE to expose the lease
as a DRM class device named after its primary node and lessee ID.
Make the device a sibling of the primary node with DEVTYPE=drm_lease.

The exposed node deliberately reuses the anonymous lease file's state,
including its private data and file operations.
This keeps DRM and driver ioctl handling on the original lessee
without introducing a proxy driver.
The anonymous lease file remains alive while the exposed node is open.
The device is unregistered when the lease is destroyed.

Mirror DRM hotplug uevents to exposed leases so that a display server
monitoring its assigned node observes connector changes.

Userspace can identify these nodes through DEVTYPE=drm_lease.
Udev rules should tag lease nodes as seat masters.
Since they inherit the physical device's ID_PATH,
lease nodes should be excluded from ordinary DRM card by-path symlinks.

Signed-off-by: Andrey Erokhin <language.lawyer@gmail.com>
---
Changes in v2:

  * Restrict exposed-lease minor allocation and hotplug iteration to the
    256 minors covered by register_chrdev().
  * Replace get_file_rcu() with get_file_active() when pinning the
    anonymous lease file.
  * Pin the copied file operations under the XArray lock and copy
    f_mapping from the anonymous lease file.
  * Reorder device setup and error unwinding so the XArray entry is
    removed before the final device reference is dropped.
  * Remove the stale <linux/idr.h> include and reformat the commit
    message.

v1: https://lore.kernel.org/dri-devel/20260831200047.2533572-1-language.lawyer@gmail.com/

RFC questions:

  * Is using O_CREAT to request device-node exposure acceptable UAPI,
    or should this use a DRM-specific flag?
  * Are there lifetime or locking constraints missed by sharing the
    anonymous lease file's private_data and copied file operations?

The kernel only exposes the lease device; a userspace broker is still
needed. For a static multiseat configuration the broker must run before
logind. It opens the physical DRM node, acquires DRM master, creates all
leases from the same lessor, and keeps the lessor and returned lease
file descriptors open. The QEMU test setup used this logind.service
drop-in:

    [Unit]
    Requires=drm-lease-broker.service
    After=drm-lease-broker.service

The QEMU virtio-gpu resources used for the two leases were:

    lease 1 / seat0:
      connector 40 (Virtual-1)
      CRTC 39
      primary plane 35 and cursor plane 36 (implicitly included)

    lease 2 / seat1:
      connector 47 (Virtual-2)
      CRTC 46
      primary plane 42 and cursor plane 43 (implicitly included)

The minimal broker used for this test is available at:
https://gist.github.com/languagelawyer/cfe02f4a0d9ba9726a86f74ecb73f990
Its invocation and output were:

    [root@archlinux ~]# /root/release /dev/dri/card0 [ 40 39 ] [ 47 46 ]
    Created lease 1 for group 1: 40 39
    Created lease 2 for group 2: 47 46

These IDs are specific to this QEMU configuration; a real broker must
enumerate the resources dynamically. DRM_CLIENT_CAP_UNIVERSAL_PLANES was
not enabled, so the compatible planes were added implicitly by DRM. With
that client capability enabled, the broker must include the plane IDs
explicitly.

With the lease devices and separate input devices assigned through udev,
logind reported:

    [root@archlinux ~]# loginctl seat-status seat0
    seat0
    Devices: n/a
             ├─/sys/devices/pci0000:00/0000:00:02.0/drm/card0-lessee-1
             │ [MASTER] drm:card0-lessee-1
             ├─/sys/devices/pci0000:00/0000:00:07.0/virtio6/input/input3
             │ input:input3 "QEMU Virtio Tablet"
             ├─/sys/devices/platform/LNXPWRBN:00/input/input0
             │ input:input0 "Power Button"
             ├─/sys/devices/platform/i8042/serio0/input/input4
             │ input:input4 "AT Translated Set 2 keyboard"
             └─/sys/devices/platform/i8042/serio1/input/input6
               input:input6 "ImExPS/2 Generic Explorer Mouse"
    [root@archlinux ~]# loginctl seat-status seat1
    seat1
    Devices: n/a
             ├─/sys/devices/pci0000:00/0000:00:02.0/drm/card0-lessee-2
             │ [MASTER] drm:card0-lessee-2
             ├─/sys/devices/pci0000:00/0000:00:03.0/virtio2/input/input1
             │ input:input1 "QEMU Virtio Keyboard"
             └─/sys/devices/pci0000:00/0000:00:04.0/virtio3/input/input2
               input:input2 "QEMU Virtio Tablet"

Two Xorg servers ran concurrently with different modes:

    Virtual-1 connected primary 1024x768+0+0
    Virtual-2 connected primary 800x600+0+0

The corresponding systemd/udev change is available at
https://github.com/languagelawyer/systemd/commit/9781cf0be05f6bcec9bd428db86f37e7d3030570
It tags drm_lease devices as seat masters and prevents them from
replacing the physical card's by-path symlink.
It is not part of this kernel patch.

 Documentation/gpu/drm-uapi.rst |  41 +++++++
 drivers/gpu/drm/drm_drv.c      |   5 +
 drivers/gpu/drm/drm_internal.h |   5 +
 drivers/gpu/drm/drm_lease.c    | 205 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/drm_sysfs.c    |   2 +
 include/uapi/drm/drm_mode.h    |   7 +-
 6 files changed, 263 insertions(+), 2 deletions(-)

diff --git a/Documentation/gpu/drm-uapi.rst b/Documentation/gpu/drm-uapi.rst
index 93df92c4ac8c..52f36946874d 100644
--- a/Documentation/gpu/drm-uapi.rst
+++ b/Documentation/gpu/drm-uapi.rst
@@ -48,6 +48,47 @@ DRM Display Resource Leasing
 .. kernel-doc:: drivers/gpu/drm/drm_lease.c
    :doc: drm leasing
 
+Exposing a lease as a device
+----------------------------
+
+By default, :c:macro:`DRM_IOCTL_MODE_CREATE_LEASE` only returns an anonymous
+file descriptor. Passing ``O_CREAT`` in ``drm_mode_create_lease.flags`` also
+registers the lease as a DRM class device. The libdrm wrapper can be used as
+follows::
+
+    uint32_t lessee_id;
+    int lease_fd;
+
+    lease_fd = drmModeCreateLease(lessor_fd, object_ids, object_count,
+                                  O_CLOEXEC | O_CREAT, &lessee_id);
+    if (lease_fd < 0)
+            /* Handle the error. */
+
+The device is a sibling of the primary DRM device and is named after the
+primary node and the lessee ID. For example, lessee 1 of ``card0`` is exposed
+as ``/dev/dri/card0-lessee-1``. Its uevent contains ``DEVTYPE=drm_lease`` so
+that device managers can distinguish it from a DRM primary node.
+
+Opening the device accesses the same lease as the anonymous file descriptor.
+In particular, all opens share the lessee's DRM file private data, including
+its DRM master state, client capabilities and GEM handle namespace. Each open
+device file keeps the lease alive. The device is unregistered after the last
+reference to the lease file is closed. Revoking the lease removes its objects
+but does not unregister the device while references remain open.
+
+Connector hotplug changes generate ``HOTPLUG=1`` change uevents for the
+exposed lease as well as for the primary node. A device manager can make an
+exposed lease available for seat assignment with a rule such as::
+
+    SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_lease", \
+      ENV{ID_FOR_SEAT}="drm-lease-$kernel", TAG+="seat", \
+      TAG+="master-of-seat"
+
+An exposed lease inherits the physical device's path information. Rules which
+create ``dri/by-path/*-card`` links should therefore restrict those links to
+``DEVTYPE=drm_minor`` so that a lease does not replace its primary node's
+link.
+
 Open-Source Userspace Requirements
 ==================================
 
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index c808958a2188..add36fbf693f 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -1250,6 +1250,7 @@ static void drm_core_exit(void)
 	drm_privacy_screen_lookup_exit();
 	drm_panic_exit();
 	accel_core_exit();
+	drm_lease_cleanup();
 	unregister_chrdev(DRM_MAJOR, "drm");
 	drm_debugfs_remove_root();
 	drm_sysfs_destroy();
@@ -1283,6 +1284,10 @@ static int __init drm_core_init(void)
 
 	drm_panic_init();
 
+	ret = drm_lease_init();
+	if (ret < 0)
+		goto error;
+
 	drm_privacy_screen_lookup_init();
 
 	ret = drm_ras_genl_family_register();
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index f893b1e3a596..1d72dd7419b6 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -101,6 +101,10 @@ int drm_prime_add_buf_handle(struct drm_prime_file_private *prime_fpriv,
 void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv,
 				 uint32_t handle);
 
+/* drm_lease.c */
+int drm_lease_init(void);
+void drm_lease_cleanup(void);
+
 /* drm_managed.c */
 void drm_managed_release(struct drm_device *dev);
 void drmm_add_final_kfree(struct drm_device *dev, void *container);
@@ -171,6 +175,7 @@ void drm_sysfs_connector_remove_early(struct drm_connector *connector);
 void drm_sysfs_connector_remove(struct drm_connector *connector);
 
 void drm_sysfs_lease_event(struct drm_device *dev);
+void drm_lease_uevent(struct drm_device *dev, char *envp[]);
 
 /* drm_gem.c */
 int drm_gem_init(struct drm_device *dev);
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724cbd7..fdd706530d7c 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -2,8 +2,11 @@
 /*
  * Copyright © 2017 Keith Packard <keithp@keithp.com>
  */
+#include <linux/device.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/xarray.h>
 
 #include <drm/drm_auth.h>
 #include <drm/drm_crtc.h>
@@ -71,6 +74,11 @@
 
 static uint64_t drm_lease_idr_object;
 
+#define DRM_EXPOSED_LEASE_MINORS 256
+
+static int drm_exposed_lease_major;
+static DEFINE_XARRAY_ALLOC(drm_exposed_lease_minors_xa);
+
 struct drm_master *drm_lease_owner(struct drm_master *master)
 {
 	while (master->lessor != NULL)
@@ -263,10 +271,144 @@ static struct drm_master *drm_lease_create(struct drm_master *lessor, struct idr
 	return ERR_PTR(error);
 }
 
+struct drm_exposed_lease {
+	struct file *lessee_file;
+	struct drm_master *lessee;
+	struct file_operations fops;
+	struct device kdev;
+};
+
+static const struct device_type drm_exposed_lease_device_type = {
+	.name = "drm_lease",
+};
+
+void drm_lease_uevent(struct drm_device *dev, char *envp[])
+{
+	struct device *kdev;
+	unsigned long minor = 0;
+
+	for (;;) {
+		struct drm_exposed_lease *exposed;
+
+		kdev = NULL;
+		xa_lock(&drm_exposed_lease_minors_xa);
+		while ((exposed = xa_find(&drm_exposed_lease_minors_xa, &minor,
+					  DRM_EXPOSED_LEASE_MINORS - 1,
+					  XA_PRESENT))) {
+			minor++;
+			if (exposed->lessee->dev == dev) {
+				kdev = get_device(&exposed->kdev);
+				break;
+			}
+		}
+		xa_unlock(&drm_exposed_lease_minors_xa);
+
+		if (!kdev)
+			return;
+
+		kobject_uevent_env(&kdev->kobj, KOBJ_CHANGE, envp);
+		put_device(kdev);
+	}
+}
+
+static void drm_exposed_device_release(struct device *dev)
+{
+	kfree(container_of(dev, struct drm_exposed_lease, kdev));
+}
+
+static int drm_exposed_lease_release(struct inode *inode, struct file *filp)
+{
+	struct drm_exposed_lease *exposed;
+	struct file *lessee_file = NULL;
+
+	xa_lock(&drm_exposed_lease_minors_xa);
+	exposed = xa_load(&drm_exposed_lease_minors_xa, iminor(inode));
+	if (exposed && exposed->lessee_file)
+		lessee_file = exposed->lessee_file;
+	xa_unlock(&drm_exposed_lease_minors_xa);
+
+	if (lessee_file)
+		fput(lessee_file);
+
+	return 0;
+}
+
+static int drm_expose_lease(struct file *lessee_file,
+			    struct drm_master *lessee)
+{
+	int ret = 0;
+	u32 minor;
+	struct drm_exposed_lease *exposed;
+	struct device *drm_kdev;
+	struct device *kdev;
+
+	exposed = kzalloc_obj(*exposed);
+	if (!exposed)
+		return -ENOMEM;
+
+	exposed->lessee_file = lessee_file;
+	exposed->lessee = lessee;
+	exposed->fops = *lessee_file->f_op;
+	exposed->fops.release = drm_exposed_lease_release;
+
+	drm_kdev = lessee->dev->primary->kdev;
+	kdev = &exposed->kdev;
+
+	device_initialize(kdev);
+	kdev->class = drm_kdev->class;
+	kdev->type = &drm_exposed_lease_device_type;
+	kdev->parent = drm_kdev->parent;
+	kdev->release = drm_exposed_device_release;
+	ret = dev_set_name(kdev, "%s-lessee-%d", dev_name(drm_kdev), lessee->lessee_id);
+	if (ret < 0)
+		goto device_put;
+
+	ret = xa_alloc(&drm_exposed_lease_minors_xa, &minor, exposed,
+		       XA_LIMIT(0, DRM_EXPOSED_LEASE_MINORS - 1), GFP_KERNEL);
+	if (ret < 0)
+		goto device_put;
+
+	kdev->devt = MKDEV(drm_exposed_lease_major, minor);
+	ret = device_add(kdev);
+	if (ret < 0)
+		goto minor_free;
+
+	return 0;
+
+minor_free:
+	xa_erase(&drm_exposed_lease_minors_xa, minor);
+
+device_put:
+	put_device(kdev);
+
+	return ret;
+}
+
+static void drm_hide_lease(struct drm_master *master)
+{
+	unsigned long minor;
+	struct drm_exposed_lease *exposed = NULL;
+
+	xa_lock(&drm_exposed_lease_minors_xa);
+	xa_for_each(&drm_exposed_lease_minors_xa, minor, exposed) {
+		if (exposed->lessee == master)
+			break;
+	}
+	if (exposed)
+		__xa_erase(&drm_exposed_lease_minors_xa, minor);
+	xa_unlock(&drm_exposed_lease_minors_xa);
+
+	if (exposed)
+		device_unregister(&exposed->kdev);
+}
+
 void drm_lease_destroy(struct drm_master *master)
 {
 	struct drm_device *dev = master->dev;
 
+	if (master->lessee_id != 0)
+		drm_hide_lease(master);
+
 	mutex_lock(&dev->mode_config.idr_mutex);
 
 	drm_dbg_lease(dev, "drm_lease_destroy %d\n", master->lessee_id);
@@ -491,7 +633,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
 
-	if (cl->flags && (cl->flags & ~(O_CLOEXEC | O_NONBLOCK))) {
+	if (cl->flags && (cl->flags & ~(O_CLOEXEC | O_NONBLOCK | O_CREAT))) {
 		drm_dbg_lease(dev, "invalid flags\n");
 		return -EINVAL;
 	}
@@ -566,6 +708,14 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	cl->fd = fd;
 	cl->lessee_id = lessee->lessee_id;
 
+	if (cl->flags & O_CREAT) {
+		ret = drm_expose_lease(lessee_file, lessee);
+		if (ret) {
+			fput(lessee_file);
+			goto out_leases;
+		}
+	}
+
 	/* Hook up the fd */
 	fd_install(fd, lessee_file);
 
@@ -730,3 +880,56 @@ int drm_mode_revoke_lease_ioctl(struct drm_device *dev,
 
 	return ret;
 }
+
+static int drm_lease_open(struct inode *inode, struct file *filp)
+{
+	struct drm_exposed_lease *exposed;
+	struct file *lessee_file = NULL;
+	const struct file_operations *fops = NULL;
+
+	xa_lock(&drm_exposed_lease_minors_xa);
+	exposed = xa_load(&drm_exposed_lease_minors_xa, iminor(inode));
+	if (exposed && exposed->lessee_file) {
+		lessee_file = get_file_active(&exposed->lessee_file);
+		if (lessee_file)
+			fops = fops_get(&exposed->fops);
+	}
+	xa_unlock(&drm_exposed_lease_minors_xa);
+
+	if (!lessee_file)
+		return -ENODEV;
+	if (!fops) {
+		fput(lessee_file);
+		return -ENODEV;
+	}
+
+	replace_fops(filp, fops);
+	filp->f_mapping = lessee_file->f_mapping;
+	filp->private_data = lessee_file->private_data;
+
+	return 0;
+}
+
+static const struct file_operations drm_lease_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_lease_open,
+};
+
+int drm_lease_init(void)
+{
+	int ret;
+
+	ret = register_chrdev(0, "drm_lease", &drm_lease_fops);
+	if (ret < 0)
+		return ret;
+
+	drm_exposed_lease_major = ret;
+
+	return 0;
+}
+
+void drm_lease_cleanup(void)
+{
+	if (drm_exposed_lease_major > 0)
+		unregister_chrdev(drm_exposed_lease_major, "drm_lease");
+}
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index ef4e923a8728..63a2c6c035b2 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -449,6 +449,7 @@ void drm_sysfs_hotplug_event(struct drm_device *dev)
 	drm_dbg_kms(dev, "generating hotplug event\n");
 
 	kobject_uevent_env(&dev->primary->kdev->kobj, KOBJ_CHANGE, envp);
+	drm_lease_uevent(dev, envp);
 }
 EXPORT_SYMBOL(drm_sysfs_hotplug_event);
 
@@ -474,6 +475,7 @@ void drm_sysfs_connector_hotplug_event(struct drm_connector *connector)
 		    connector->base.id, connector->name);
 
 	kobject_uevent_env(&dev->primary->kdev->kobj, KOBJ_CHANGE, envp);
+	drm_lease_uevent(dev, envp);
 }
 EXPORT_SYMBOL(drm_sysfs_connector_hotplug_event);
 
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index bd435effdcee..9bc69bca891c 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -1436,7 +1436,12 @@ struct drm_mode_create_lease {
 	__u64 object_ids;
 	/** @object_count: Number of object ids */
 	__u32 object_count;
-	/** @flags: flags for new FD (O_CLOEXEC, etc) */
+	/**
+	 * @flags: Flags for the new file descriptor.
+	 *
+	 * O_CLOEXEC and O_NONBLOCK control the returned file descriptor.
+	 * O_CREAT additionally exposes the lease as a DRM class device.
+	 */
 	__u32 flags;
 
 	/** @lessee_id: Return: unique identifier for lessee. */

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.55.0
