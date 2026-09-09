Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB40D3F0A81
	for <linux-api@vger.kernel.org>; Wed,  9 Sep 2026 20:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788984965; cv=none; b=asAM505YI7RP2k7GNXWW/dnirkrTU9Sl+ML7SiLGKhzfxYwtLlt/i76VPa+dlsUxxR7L5JSnWekfrt3+FD3jFgODhjB7SAY0WESdRCipUTHtUmeloV7NZNPlvUg1O4moVYvH5P01JP61cG5vUefXgC9clKizNCmYfs1rZFk+Qk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788984965; c=relaxed/simple;
	bh=4f9WXJrGACSoRfWfmDdQfiuL33rNdpDW7ZZ2saQBwEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OXrmEmDJzExl/+K/aEPdPWNRz1KQc7QOHdMbrb96HPsgSKScQBfYpVTeIjwAI63WyKPim/fq5Y9+PwqDu5oODM44yzhU9zHIvaXMdC0/+7zb4ere2nYMgYg9QaopCWpjQHikornNv7f9oLaBQNe4Qi8a2GVhr7rXpK6ovSDo8LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDOtgOUV; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDOtgOUV"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b5so9555535e9.2
        for <linux-api@vger.kernel.org>; Wed, 09 Sep 2026 13:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788984957; x=1789589757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3KNv7wIM1MF7xlWRrWLDFY40dez7yS5qgAfsmZNA6N4=;
        b=JDOtgOUVqRYGxbPx1C3D2xVmzA+Hj3u30ofqWm1vcKvJQQloI4YcYefSgpAe8MMCtL
         djwFdvMmkOj1bq78xgvli4mEg/URSIQF51Wb8qvNqUQmOlNlfYF1yI/kuJlopuauEoY+
         xb2P74nNEHFbalb/0pByG5my5Dv112SKQz2rfGuu4ZDE3bYIZpadjnvQpMaRbcljyht6
         nCUD+22HffHW3dPm/cFoQ91rAP+QbA/HJkU15QjlgvFH1cTDfxQfvjnZ7AAHHeKtrRkC
         xmuGyCAX5PLOji4mIVOIfrpnnXjC9Z9NZCkm4o7Kp03xxtjG2X29fZdJd3rApzouDIx+
         CVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788984957; x=1789589757;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3KNv7wIM1MF7xlWRrWLDFY40dez7yS5qgAfsmZNA6N4=;
        b=JWEi7vN6VQDhsJSbMBdwLy3Vw14XV7y5Pit4nFVSPu0C6sb2LROjPDeN1Qx4M8ZY6F
         jTDSz50SwzRwIy26xBdHCkfBqPvzpE87btL9Upj1F4kJAd2fdN05HzPn8paAgKi/kdR3
         Zk5HKNTX1aUnrIE52LU+4LAYrTdzRsnOaIdKEI6Kis4QbI24Gbdb+cXvHIC2+N++Fvxs
         VMIvorZDxuFio1VwNNxpewm2g7h07JdNnIOWi8BRAYtxAWbhwYvumlUordTTkBvbytIp
         1QcAJFfVi9HPpCQ/k6fxyjbeXE7TVtDvf6bL3ZB684uJw58Wv/7Widtgs9JtgpmShUHd
         LOZA==
X-Forwarded-Encrypted: i=1; AKwUvBwcBEAYt0sFjr18ez1bJqCS7bRnfuekthg1DkaX5zj3zbr9GfJpovGkr15XESt6reghFFtLtVHrRh0=@vger.kernel.org
X-Gm-Message-State: AFuF++n2HGwPE1SY9ZYLRFyd4ujog3sJiZCVRtyor+bQHHEOCtCIaxh/
	A7vnrNE86fkcQArNU7g1UJuXoDheToHxiDhi5CiCObmKCfq0dhpyTN3S
X-Gm-Gg: AYBFou3BU1KCSBdy9/MwpiAmi4S2+bh8Kd/umSu5IerKGCOSL4VJnPPjrhMJOPfIzTM
	qRREgyz/lGb5kTXcLBn/yLxMaCONjD+Gf+JIrgBmPuR1eEePYJ3rtXGqv57yKvNReWXSMT2rOkw
	VeW+quG9htkqBi/hmS+6yPaE8taQfrS5hP59Ey1jHzzqz2i076/yJyFOc8OwWShl5hK3F58uL14
	KPlzeL1zKO6fbave20l9KYKHmFdWMWM0fxqLoTv2nE3Vus40DUvj8W2UMjs/XftLhH+a/r9CNj4
	9KADNnXSsaERu+NTPE+9cEP6mZEZseLuPpTDLGTGlzGyYdGqc7oEnXcl+aIEqJE4IM9rLZRCmcI
	bhdpQ0gv/RaW237Jwprq2SvtOrTLW6GagqQsDCwm23syN/mzrYKB0G44hLgZV+2A7FD732uBEuz
	wB1w4iq0LmU+EN8yMv5mV3augtEbxNfv9PGMm8gB52RJO65qrv3sLTTcjRWuaik3bPxSAaRVSIj
	BhNLOsJNTP0xjy/zQ==
X-Received: by 2002:a05:600c:b93:b0:499:8174:9f39 with SMTP id 5b1f17b1804b1-49d1f0af3d1mr114547755e9.0.1788984956165;
        Wed, 09 Sep 2026 13:15:56 -0700 (PDT)
Received: from localhost.localdomain ([82.215.83.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c494basm13507025e9.12.2026.09.09.13.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 13:15:55 -0700 (PDT)
From: Andrey Erokhin <language.lawyer@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Keith Packard <keithp@keithp.com>,
	Simon Ser <contact@emersion.fr>,
	linux-api@vger.kernel.org
Subject: [RFC PATCH v3] drm/lease: optionally expose leases as device nodes
Date: Thu, 10 Sep 2026 01:15:36 +0500
Message-ID: <20260908191149.bbcbf3ae04fc-rfc-v3-language.lawyer@gmail.com>
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
Make the device a child of the primary node with DEVTYPE=drm_lease.

Give each open of the exposed node an independent DRM file context,
with its own client capabilities, GEM and syncobj handle namespaces,
event queues, and driver-private state.
Reuse the physical driver's file operations and the common DRM open
and release paths without introducing a proxy driver.
Use the physical device's shared address space for mappings.

Share the lessee's DRM master and leased resources among these clients.
Each client holds a reference to the original anonymous lease file,
keeping the lease alive without sharing its per-file state.
Closing an independently opened client does not revoke the lease;
the node remains while references to the original file exist.
Revocation clears the resource set but leaves the node registered.
Unregistering the physical DRM device removes its exposed lease nodes
and prevents new opens, even if existing clients still hold references.

Arbitrate modesetting access between independent opens of each lease.
An open acquires a free local master role if the lessor is current master.
SET_MASTER acquires a free role explicitly; DROP_MASTER releases it.
Dropping master preserves both the lease and the client's file context.
Closing the active client also releases the role.

Retain the usual master permission checks.
Serialize local ownership changes with the existing master_mutex.
This lets logind hand modesetting access between sessions on one lease
without changing the physical master or other leases' active clients.

The original anonymous lease file remains outside this arbitration
and retains its existing authority.
Keep this file with the trusted lease broker.
All clients still depend on the lessor being current master.

Mirror DRM hotplug uevents to exposed leases so that a display server
monitoring its assigned node observes connector changes.

Userspace can identify these nodes through DEVTYPE=drm_lease.
Udev rules should tag lease nodes as seat masters.
Since they inherit the physical device's ID_PATH,
lease nodes should be excluded from ordinary DRM card by-path symlinks.

Assisted-by: LLM
Signed-off-by: Andrey Erokhin <language.lawyer@gmail.com>
---
AI disclosure:

Most of the coding for this revision was done by an AI coding assistant
(ChatGPT/Codex), including the per-open contexts and lease-local master
arbitration. I have read through the resulting code myself.
The assistant also helped with test programs, QEMU testing and debugging.

Changes since v2:

  * Give each exposed-node open its own drm_file instead of sharing
    private_data with the original anonymous lease file.
    Client capabilities, handles, events and driver-private state are
    now per open, with ordinary DRM/driver cleanup on release.
  * Add lease-local SET_MASTER/DROP_MASTER arbitration for these opens.
    Keep the broker's original anonymous lease file outside this scheme.
  * Reuse the physical driver's fops directly, without a copied fops
    table or custom release wrapper, and use the common DRM open path
    with the physical device's shared address space.
  * Serialize publication, lookup and teardown with a dedicated mutex,
    retain get_file_active() for pinning the original lease file,
    and use the locking XArray operations for allocation and removal.
    New opens cannot access a node before publication completes.
  * Unpublish exposed nodes when the physical DRM device unregisters.
    Retain their minor reservations until lease destruction.
  * Register and allocate the full MINORBITS minor range for the
    exposed-lease character device, rather than the 256-minor range.
  * Rename the nodes to cardN-lease-ID and make them children of cardN,
    rather than siblings named cardN-lessee-ID.
  * Update the UAPI documentation, lifetime comments and helper names.

v2: https://lore.kernel.org/dri-devel/20260902180846.2753456-1-language.lawyer@gmail.com/
v1: https://lore.kernel.org/dri-devel/20260831200047.2533572-1-language.lawyer@gmail.com/

Userspace setup:

A broker must own the physical DRM master, create all leases from that
lessor, and retain the physical and original anonymous lease descriptors.
Session clients open the exposed nodes, normally through logind.
They must not receive the broker's original anonymous lease descriptors,
which retain their existing authority outside local master arbitration.

The stand starts the broker on the card0 udev event
and orders the display manager after drm-lease-broker.service.
The physical card is reserved for the broker;
lease nodes and separate input devices are assigned to seat0 and seat1.

The minimal example broker is available at:
https://gist.github.com/languagelawyer/cfe02f4a0d9ba9726a86f74ecb73f990

The two-head virtio-gpu configuration used:

    /root/release /dev/dri/card0 [ 40 39 ] [ 47 46 ]

    lease 1 / seat0: connector 40 (Virtual-1), CRTC 39
    lease 2 / seat1: connector 47 (Virtual-2), CRTC 46

The corresponding primary/cursor plane IDs are 35/36 and 42/43.
These IDs are specific to the stand; a real broker must enumerate them.
The example does not enable DRM_CLIENT_CAP_UNIVERSAL_PLANES,
so DRM adds the compatible planes implicitly.
With that capability enabled, plane IDs must be included explicitly.

The systemd/udev rule changes are available at:
https://github.com/languagelawyer/systemd/commit/93c15122fad4d7017d4c914eb0c1b925e4696c87
This userspace change is not part of the kernel patch.
It tags lease nodes as seat masters and excludes them from card by-path
symlinks.

With LightDM running, logind reports a graphical session on each seat:

    # loginctl show-seat seat0 -p Id -p ActiveSession -p Sessions -p CanGraphical
    Id=seat0
    ActiveSession=c64
    CanGraphical=yes
    Sessions=c64

    # loginctl show-seat seat1 -p Id -p ActiveSession -p Sessions -p CanGraphical
    Id=seat1
    ActiveSession=c63
    CanGraphical=yes
    Sessions=c63

Testing and limitations:

Initial tests used an Arch guest with two virtio-gpu heads,
separate input devices, logind, lockdep and CONFIG_VT disabled.
Per-open capability, GEM/syncobj handle and event isolation passed,
as did close/reopen, lease lifetime, revoke and local-master handover tests.
Concurrent SET_MASTER stress found no overlapping local owners;
this is not a proof that every ownership or teardown race is covered.

Two Xorg servers work concurrently, one on each lease.
In that non-VT setup, switching users on one lease failed end to end.
The LightDM setup initially launched Xorg outside a logind session.
With Xorg launched in proper PAM/logind sessions, master handover worked,
but Xorg did not restore its scanout mode automatically on resume
and also reported input re-enable failures.
An explicit xrandr mode change restored the intended output mode.

A follow-up with CONFIG_VT enabled passed 20/20 switches between two
Xorg 21.1.21 sessions on seat0, using separate VTs and proper PAM sessions.
Each resumed server automatically restored its 1024x768 or 800x600 mode
and received tablet input, without corrective xrandr mode changes.
The Xorg on the other lease retained its active 800x600 mode and input.
Checks used kernel CRTC state and X input valuators; all servers survived.
No kernel source or Xorg source changes were needed for this follow-up.
LightDM's own switching workflow was not validated by that test.

Repeating the test on seat1, where Xorg does not use a VT,
reproduced the scanout/input recovery failure despite CONFIG_VT=y.
Across six activations, logind switched sessions and local master moved,
but A did not restore 1024x768 over B's 800x600 scanout.
Both resumed servers failed injected tablet and keyboard checks;
the control Xorg on seat0 retained its mode and input.
A separate explicit mode change succeeded after the switching test.

Weston was used for end-to-end session-switching tests without VT.
Unmodified Weston 15.0.1 and main at 9669073fe8f4 (16.0.90) could stall
DRM recovery after a hotplug event while the session was inactive:
recovery deferred future repaints even though no recovery repaint
had been scheduled. The session regained master but stopped rendering.
A controlled event for the lease's own connector reproduced the problem.

The following existing Weston MR resolved the tested failure:
https://gitlab.freedesktop.org/wayland/weston/-/merge_requests/2095

With its full diff from f8f49eac61d9 applied to main at 9669073fe8f4:

  * 10/10 pause -> own-connector hotplug -> resume cycles passed.
  * 20/20 switches between two users on one lease passed,
    alternating 1024x768 and 800x600, while the other lease kept rendering.
  * Tests checked actual CRTC modes and continuing page flips,
    not merely that the compositor process survived or held master.

The switching test also observed genuine kernel HOTPLUG=1 events,
without CONNECTOR, on the physical card and both exposed leases.

Pixman and software GL/llvmpipe rendering were exercised on the leases.
This does not cover hardware-accelerated rendering or other GPU drivers.

RFC questions:

  * Is O_CREAT acceptable for requesting exposure, or should this use
    a DRM-specific flag?
  * Does this per-open context and lease-local master model fit DRM's
    ownership rules, particularly driver callbacks and paths that
    inspect is_master directly?

 Documentation/gpu/drm-uapi.rst |  65 +++++++++
 drivers/gpu/drm/drm_auth.c     |  61 ++++++++-
 drivers/gpu/drm/drm_drv.c      |   6 +
 drivers/gpu/drm/drm_file.c     |  79 +++++++----
 drivers/gpu/drm/drm_internal.h |   9 ++
 drivers/gpu/drm/drm_lease.c    | 237 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/drm_sysfs.c    |   2 +
 include/drm/drm_auth.h         |  11 ++
 include/drm/drm_file.h         |  15 ++-
 include/uapi/drm/drm_mode.h    |   7 +-
 10 files changed, 458 insertions(+), 34 deletions(-)

diff --git a/Documentation/gpu/drm-uapi.rst b/Documentation/gpu/drm-uapi.rst
index 93df92c4ac8c..0833a9c5c2bd 100644
--- a/Documentation/gpu/drm-uapi.rst
+++ b/Documentation/gpu/drm-uapi.rst
@@ -48,6 +48,71 @@ DRM Display Resource Leasing
 .. kernel-doc:: drivers/gpu/drm/drm_lease.c
    :doc: drm leasing
 
+Exposing a lease as a device
+----------------------------
+
+By default, lease creation returns an anonymous file descriptor.
+Passing ``O_CREAT`` in ``drm_mode_create_lease.flags``
+also registers the lease as a DRM class device.
+The libdrm wrapper can be used as follows::
+
+    uint32_t lessee_id;
+    int lease_fd;
+
+    lease_fd = drmModeCreateLease(lessor_fd, object_ids, object_count,
+                                  O_CLOEXEC | O_CREAT, &lessee_id);
+    if (lease_fd < 0)
+            /* Handle the error. */
+
+The device is a child of the primary DRM device.
+Its name contains the primary node and the lessee ID.
+For example, lessee 1 of ``card0`` is exposed as ``/dev/dri/card0-lease-1``.
+Its uevent contains ``DEVTYPE=drm_lease``,
+allowing device managers to distinguish it from a DRM primary node.
+
+Opening the device creates an independent DRM file context for the same lease.
+Client capabilities, GEM and sync object handles, and event queues
+are private to each open and are cleaned up when that file is released.
+The DRM master and leased display resources are shared.
+Each open device file keeps the original lease file alive,
+and closing an independently opened client does not revoke the lease.
+The node remains until the last reference to the lease file is closed.
+Revoking the lease removes its objects,
+but leaves the device registered while references remain open.
+If the underlying DRM device is unregistered,
+the lease device node is removed immediately.
+Existing opens retain their usual DRM unplug semantics.
+
+Only one independently opened client can be current master of a lease.
+The first open becomes master if the lessor is current master.
+``DROP_MASTER`` relinquishes this role without revoking the lease,
+and ``SET_MASTER`` acquires it if no other client holds it.
+Closing the active client also relinquishes the role;
+existing clients must use ``SET_MASTER`` to acquire it.
+The usual master permission checks apply.
+This arbitration does not change the physical device's master
+or the active clients of other leases.
+
+The original anonymous lease file retains its existing master semantics
+and does not participate in this arbitration.
+It must remain with the trusted lease broker rather than being handed
+to a session that needs suspendable modesetting access.
+All clients still depend on the lessor being current master.
+
+Connector hotplug changes generate ``HOTPLUG=1`` change uevents
+for both the exposed lease and primary node.
+A device manager can expose it for seat assignment with a rule such as::
+
+    SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_lease", \
+      ENV{ID_FOR_SEAT}="drm-lease-$kernel", TAG+="seat", \
+      TAG+="master-of-seat"
+
+An exposed lease inherits the physical device's path information.
+Its name also matches ``card*``.
+Rules which create ``dri/by-path/*-card`` links
+should therefore require ``DEVTYPE=drm_minor``,
+so that a lease does not replace its primary node's link.
+
 Open-Source Userspace Requirements
 ==================================
 
diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index e5013b870ba0..9cab17392b44 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -55,6 +55,11 @@
  * implicitly through closing/opening the primary device node. See also
  * drm_is_current_master().
  *
+ * Independently opened clients of an exposed lease share its &drm_master.
+ * Only &drm_master.lease_master is current within that lease, provided the
+ * lessor is current on the physical device. The original anonymous lease
+ * file retains its existing authority outside this local arbitration.
+ *
  * Clients can authenticate against the current master (if it matches their own)
  * using the GETMAGIC and AUTHMAGIC IOCTLs. Together with exchanging masters,
  * this allows controlled access to the device for an entire group of mutually
@@ -66,7 +71,13 @@ static bool drm_is_current_master_locked(struct drm_file *fpriv)
 	lockdep_assert_once(lockdep_is_held(&fpriv->master_lookup_lock) ||
 			    lockdep_is_held(&fpriv->minor->dev->master_mutex));
 
-	return fpriv->is_master && drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
+	if (!fpriv->is_master)
+		return false;
+	if (fpriv->lease_file &&
+	    READ_ONCE(fpriv->master->lease_master) != fpriv)
+		return false;
+
+	return drm_lease_owner(fpriv->master) == fpriv->minor->dev->master;
 }
 
 /**
@@ -242,6 +253,23 @@ drm_master_check_perm(struct drm_device *dev, struct drm_file *file_priv)
 	return 0;
 }
 
+static int drm_set_lease_master(struct drm_file *file_priv)
+{
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_master *master = file_priv->master;
+
+	lockdep_assert_held_once(&dev->master_mutex);
+
+	if (drm_lease_owner(master) != dev->master)
+		return -EINVAL;
+	if (master->lease_master && master->lease_master != file_priv)
+		return -EBUSY;
+
+	WRITE_ONCE(master->lease_master, file_priv);
+	file_priv->was_master = true;
+	return 0;
+}
+
 int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file_priv)
 {
@@ -253,6 +281,9 @@ int drm_setmaster_ioctl(struct drm_device *dev, void *data,
 	if (ret)
 		return ret;
 
+	if (file_priv->lease_file)
+		return drm_set_lease_master(file_priv);
+
 	if (drm_is_current_master_locked(file_priv))
 		return ret;
 
@@ -296,6 +327,13 @@ int drm_dropmaster_ioctl(struct drm_device *dev, void *data,
 	if (ret)
 		return ret;
 
+	if (file_priv->lease_file) {
+		if (file_priv->master->lease_master != file_priv)
+			return -EINVAL;
+		WRITE_ONCE(file_priv->master->lease_master, NULL);
+		return 0;
+	}
+
 	if (!drm_is_current_master_locked(file_priv))
 		return -EINVAL;
 
@@ -323,7 +361,17 @@ int drm_master_open(struct drm_file *file_priv)
 	 * any master object for render clients
 	 */
 	guard(mutex)(&dev->master_mutex);
-	if (!dev->master) {
+	if (file_priv->lease_file) {
+		struct drm_file *lease_priv = file_priv->lease_file->private_data;
+
+		spin_lock(&file_priv->master_lookup_lock);
+		file_priv->master = drm_master_get(lease_priv->master);
+		file_priv->is_master = true;
+		file_priv->authenticated = true;
+		spin_unlock(&file_priv->master_lookup_lock);
+		/* Busy or inactive leases can still be opened as non-master. */
+		drm_set_lease_master(file_priv);
+	} else if (!dev->master) {
 		ret = drm_new_set_master(dev, file_priv);
 	} else {
 		spin_lock(&file_priv->master_lookup_lock);
@@ -344,13 +392,20 @@ void drm_master_release(struct drm_file *file_priv)
 	if (file_priv->magic)
 		idr_remove(&file_priv->master->magic_map, file_priv->magic);
 
+	if (file_priv->lease_file) {
+		if (master->lease_master == file_priv)
+			WRITE_ONCE(master->lease_master, NULL);
+		goto out;
+	}
+
 	if (!drm_is_current_master_locked(file_priv))
 		goto out;
 
 	if (dev->master && dev->master == file_priv->master)
 		drm_drop_master(dev, file_priv);
 out:
-	if (drm_core_check_feature(dev, DRIVER_MODESET) && file_priv->is_master) {
+	if (drm_core_check_feature(dev, DRIVER_MODESET) &&
+	    file_priv->is_master && !file_priv->lease_file) {
 		/* Revoke any leases held by this or lessees, but only if
 		 * this is the "real" master
 		 */
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index c808958a2188..1cdc38c00815 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -1168,6 +1168,7 @@ EXPORT_SYMBOL(drm_dev_register);
 void drm_dev_unregister(struct drm_device *dev)
 {
 	dev->registered = false;
+	drm_lease_unpublish_exposed(dev);
 
 	drm_client_sysrq_unregister(dev);
 	drm_panic_unregister(dev);
@@ -1250,6 +1251,7 @@ static void drm_core_exit(void)
 	drm_privacy_screen_lookup_exit();
 	drm_panic_exit();
 	accel_core_exit();
+	drm_lease_cleanup();
 	unregister_chrdev(DRM_MAJOR, "drm");
 	drm_debugfs_remove_root();
 	drm_sysfs_destroy();
@@ -1283,6 +1285,10 @@ static int __init drm_core_init(void)
 
 	drm_panic_init();
 
+	ret = drm_lease_init();
+	if (ret < 0)
+		goto error;
+
 	drm_privacy_screen_lookup_init();
 
 	ret = drm_ras_genl_family_register();
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index ec820686b302..bf6d6ea55598 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -268,6 +268,9 @@ void drm_file_free(struct drm_file *file)
 
 	drm_prime_destroy_file_private(&file->prime);
 
+	if (file->lease_file)
+		fput(file->lease_file);
+
 	WARN_ON(!list_empty(&file->event_list));
 
 	put_pid(rcu_access_pointer(file->pid));
@@ -308,12 +311,15 @@ static int drm_cpu_valid(void)
  *
  * \param filp file pointer.
  * \param minor acquired minor-object.
+ * \param lease_file original lease file, or NULL for an ordinary open.
  * \return zero on success or a negative number on failure.
  *
  * Creates and initializes a drm_file structure for the file private data in \p
  * filp and add it into the double linked list in \p dev.
  */
-int drm_open_helper(struct file *filp, struct drm_minor *minor)
+static int drm_open_helper_with_lease(struct file *filp,
+				      struct drm_minor *minor,
+				      struct file *lease_file)
 {
 	struct drm_device *dev = minor->dev;
 	struct drm_file *priv;
@@ -336,6 +342,8 @@ int drm_open_helper(struct file *filp, struct drm_minor *minor)
 	if (IS_ERR(priv))
 		return PTR_ERR(priv);
 
+	if (lease_file)
+		priv->lease_file = get_file(lease_file);
 	if (drm_is_primary_client(priv)) {
 		ret = drm_master_open(priv);
 		if (ret) {
@@ -354,6 +362,48 @@ int drm_open_helper(struct file *filp, struct drm_minor *minor)
 	return 0;
 }
 
+int drm_open_helper(struct file *filp, struct drm_minor *minor)
+{
+	return drm_open_helper_with_lease(filp, minor, NULL);
+}
+
+/* Consumes the minor reference, including on error. */
+static int drm_open_minor(struct file *filp, struct drm_minor *minor,
+			  struct file *lease_file)
+{
+	struct drm_device *dev = minor->dev;
+	int ret;
+
+	if (drm_dev_needs_global_mutex(dev))
+		mutex_lock(&drm_global_mutex);
+
+	atomic_fetch_inc(&dev->open_count);
+	filp->f_mapping = dev->anon_inode->i_mapping;
+
+	ret = drm_open_helper_with_lease(filp, minor, lease_file);
+	if (ret)
+		atomic_dec(&dev->open_count);
+
+	if (drm_dev_needs_global_mutex(dev))
+		mutex_unlock(&drm_global_mutex);
+	if (ret)
+		drm_minor_release(minor);
+
+	return ret;
+}
+
+int drm_open_lease(struct file *filp, struct file *lease_file)
+{
+	struct drm_file *lease_priv = lease_file->private_data;
+	struct drm_minor *minor;
+
+	minor = drm_minor_acquire(&drm_minors_xa, lease_priv->minor->index);
+	if (IS_ERR(minor))
+		return PTR_ERR(minor);
+
+	return drm_open_minor(filp, minor, lease_file);
+}
+
 /**
  * drm_open - open method for DRM file
  * @inode: device inode
@@ -368,38 +418,13 @@ int drm_open_helper(struct file *filp, struct drm_minor *minor)
  */
 int drm_open(struct inode *inode, struct file *filp)
 {
-	struct drm_device *dev;
 	struct drm_minor *minor;
-	int retcode;
 
 	minor = drm_minor_acquire(&drm_minors_xa, iminor(inode));
 	if (IS_ERR(minor))
 		return PTR_ERR(minor);
 
-	dev = minor->dev;
-	if (drm_dev_needs_global_mutex(dev))
-		mutex_lock(&drm_global_mutex);
-
-	atomic_fetch_inc(&dev->open_count);
-
-	/* share address_space across all char-devs of a single device */
-	filp->f_mapping = dev->anon_inode->i_mapping;
-
-	retcode = drm_open_helper(filp, minor);
-	if (retcode)
-		goto err_undo;
-
-	if (drm_dev_needs_global_mutex(dev))
-		mutex_unlock(&drm_global_mutex);
-
-	return 0;
-
-err_undo:
-	atomic_dec(&dev->open_count);
-	if (drm_dev_needs_global_mutex(dev))
-		mutex_unlock(&drm_global_mutex);
-	drm_minor_release(minor);
-	return retcode;
+	return drm_open_minor(filp, minor, NULL);
 }
 EXPORT_SYMBOL(drm_open);
 
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index f893b1e3a596..f635784cef86 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -101,6 +101,14 @@ int drm_prime_add_buf_handle(struct drm_prime_file_private *prime_fpriv,
 void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv,
 				 uint32_t handle);
 
+/* drm_file.c */
+int drm_open_lease(struct file *filp, struct file *lease_file);
+
+/* drm_lease.c */
+int drm_lease_init(void);
+void drm_lease_cleanup(void);
+void drm_lease_unpublish_exposed(struct drm_device *dev);
+
 /* drm_managed.c */
 void drm_managed_release(struct drm_device *dev);
 void drmm_add_final_kfree(struct drm_device *dev, void *container);
@@ -171,6 +179,7 @@ void drm_sysfs_connector_remove_early(struct drm_connector *connector);
 void drm_sysfs_connector_remove(struct drm_connector *connector);
 
 void drm_sysfs_lease_event(struct drm_device *dev);
+void drm_lease_uevent(struct drm_device *dev, char *envp[]);
 
 /* drm_gem.c */
 int drm_gem_init(struct drm_device *dev);
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724cbd7..abca4d9d94e5 100644
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
@@ -71,6 +74,12 @@
 
 static uint64_t drm_lease_idr_object;
 
+#define DRM_EXPOSED_LEASE_MINORS (MINORMASK + 1)
+
+static int drm_exposed_lease_major;
+static DEFINE_XARRAY_ALLOC(drm_exposed_lease_minors_xa);
+static DEFINE_MUTEX(drm_exposed_lease_lock);
+
 struct drm_master *drm_lease_owner(struct drm_master *master)
 {
 	while (master->lessor != NULL)
@@ -263,10 +272,172 @@ static struct drm_master *drm_lease_create(struct drm_master *lessor, struct idr
 	return ERR_PTR(error);
 }
 
+struct drm_exposed_lease {
+	struct device kdev;
+	struct file *lease_file;
+	struct drm_master *lessee;
+	bool published;
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
+		mutex_lock(&drm_exposed_lease_lock);
+		while ((exposed = xa_find(&drm_exposed_lease_minors_xa, &minor,
+					  DRM_EXPOSED_LEASE_MINORS - 1,
+					  XA_PRESENT))) {
+			minor++;
+			if (exposed->published && exposed->lessee->dev == dev) {
+				kdev = get_device(&exposed->kdev);
+				break;
+			}
+		}
+		mutex_unlock(&drm_exposed_lease_lock);
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
+static int drm_expose_lease(struct file *lease_file,
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
+	exposed->lease_file = lease_file;
+	exposed->lessee = lessee;
+
+	drm_kdev = lessee->dev->primary->kdev;
+	kdev = &exposed->kdev;
+
+	device_initialize(kdev);
+	kdev->class = drm_kdev->class;
+	kdev->type = &drm_exposed_lease_device_type;
+	kdev->parent = drm_kdev;
+	kdev->release = drm_exposed_device_release;
+	ret = dev_set_name(kdev, "%s-lease-%d", dev_name(drm_kdev),
+			   lessee->lessee_id);
+	if (ret < 0)
+		goto device_put;
+
+	mutex_lock(&drm_exposed_lease_lock);
+	if (!lessee->dev->registered) {
+		ret = -ENODEV;
+		goto mutex_unlock;
+	}
+	ret = xa_alloc(&drm_exposed_lease_minors_xa, &minor, exposed,
+		       XA_LIMIT(0, DRM_EXPOSED_LEASE_MINORS - 1), GFP_KERNEL);
+	if (ret < 0)
+		goto mutex_unlock;
+
+	kdev->devt = MKDEV(drm_exposed_lease_major, minor);
+	ret = device_add(kdev);
+	if (ret < 0)
+		goto minor_free;
+	exposed->published = true;
+	mutex_unlock(&drm_exposed_lease_lock);
+
+	return 0;
+
+minor_free:
+	xa_erase(&drm_exposed_lease_minors_xa, minor);
+
+mutex_unlock:
+	mutex_unlock(&drm_exposed_lease_lock);
+
+device_put:
+	put_device(kdev);
+
+	return ret;
+}
+
+/**
+ * drm_unexpose_lease - Tear down a lease's exposed device
+ * @master: Lessee master being destroyed
+ *
+ * Remove the exposed device, if any, from minor lookup
+ * and drop the device reference acquired by device_initialize().
+ * If drm_lease_unpublish_exposed() already removed it from the device model,
+ * only put_device() remains; otherwise device_unregister() performs both steps.
+ * Other device references may defer freeing the containing drm_exposed_lease.
+ */
+static void drm_unexpose_lease(struct drm_master *master)
+{
+	unsigned long minor;
+	struct drm_exposed_lease *exposed = NULL;
+
+	mutex_lock(&drm_exposed_lease_lock);
+	xa_for_each(&drm_exposed_lease_minors_xa, minor, exposed) {
+		if (exposed->lessee == master)
+			break;
+	}
+	if (exposed) {
+		xa_erase(&drm_exposed_lease_minors_xa, minor);
+		if (exposed->published)
+			device_unregister(&exposed->kdev);
+		else
+			put_device(&exposed->kdev);
+	}
+	mutex_unlock(&drm_exposed_lease_lock);
+}
+
+/**
+ * drm_lease_unpublish_exposed - Unpublish a DRM device's exposed lease nodes
+ * @dev: DRM device being unregistered
+ *
+ * Remove the nodes from the device model with device_del() and reject new opens.
+ * Keep their minor reservations, XArray entries and initial device references
+ * until drm_unexpose_lease() runs at lessee master destruction.
+ * This does not revoke the leases or release existing clients.
+ */
+void drm_lease_unpublish_exposed(struct drm_device *dev)
+{
+	struct drm_exposed_lease *exposed;
+	unsigned long minor;
+
+	mutex_lock(&drm_exposed_lease_lock);
+	xa_for_each(&drm_exposed_lease_minors_xa, minor, exposed) {
+		if (exposed->published && exposed->lessee->dev == dev) {
+			device_del(&exposed->kdev);
+			exposed->published = false;
+		}
+	}
+	mutex_unlock(&drm_exposed_lease_lock);
+}
+
 void drm_lease_destroy(struct drm_master *master)
 {
 	struct drm_device *dev = master->dev;
 
+	if (master->lessee_id != 0)
+		drm_unexpose_lease(master);
+
 	mutex_lock(&dev->mode_config.idr_mutex);
 
 	drm_dbg_lease(dev, "drm_lease_destroy %d\n", master->lessee_id);
@@ -491,7 +662,7 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
 
-	if (cl->flags && (cl->flags & ~(O_CLOEXEC | O_NONBLOCK))) {
+	if (cl->flags && (cl->flags & ~(O_CLOEXEC | O_NONBLOCK | O_CREAT))) {
 		drm_dbg_lease(dev, "invalid flags\n");
 		return -EINVAL;
 	}
@@ -566,6 +737,14 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
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
 
@@ -730,3 +909,59 @@ int drm_mode_revoke_lease_ioctl(struct drm_device *dev,
 
 	return ret;
 }
+
+static int drm_lease_open(struct inode *inode, struct file *filp)
+{
+	struct drm_exposed_lease *exposed;
+	struct file *lease_file = NULL;
+	const struct file_operations *fops = NULL;
+	int ret;
+
+	mutex_lock(&drm_exposed_lease_lock);
+	exposed = xa_load(&drm_exposed_lease_minors_xa, iminor(inode));
+	if (exposed && exposed->published && exposed->lease_file) {
+		lease_file = get_file_active(&exposed->lease_file);
+		if (lease_file)
+			fops = fops_get(lease_file->f_op);
+	}
+	mutex_unlock(&drm_exposed_lease_lock);
+
+	if (!lease_file)
+		return -ENODEV;
+	if (!fops) {
+		fput(lease_file);
+		return -ENODEV;
+	}
+
+	replace_fops(filp, fops);
+	ret = drm_open_lease(filp, lease_file);
+	fput(lease_file);
+
+	return ret;
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
+	ret = __register_chrdev(0, 0, DRM_EXPOSED_LEASE_MINORS,
+				"drm_lease", &drm_lease_fops);
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
+		__unregister_chrdev(drm_exposed_lease_major, 0,
+				    DRM_EXPOSED_LEASE_MINORS, "drm_lease");
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
 
diff --git a/include/drm/drm_auth.h b/include/drm/drm_auth.h
index 50131383ed81..8b33acbfd389 100644
--- a/include/drm/drm_auth.h
+++ b/include/drm/drm_auth.h
@@ -80,6 +80,17 @@ struct drm_master {
 	 */
 	struct drm_master *lessor;
 
+	/**
+	 * @lease_master:
+	 *
+	 * Active independently opened client of an exposed lease, or NULL.
+	 * The original anonymous lease file does not participate in this
+	 * arbitration. Protected by &drm_device.master_mutex, with READ_ONCE()
+	 * for current-master checks. This pointer is only compared, never
+	 * dereferenced, and is cleared before the client is freed.
+	 */
+	struct drm_file *lease_master;
+
 	/**
 	 * @lessee_id:
 	 *
diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
index 6ee70ad65e1f..bbf965e99b3f 100644
--- a/include/drm/drm_file.h
+++ b/include/drm/drm_file.h
@@ -228,8 +228,9 @@ struct drm_file {
 	/**
 	 * @is_master:
 	 *
-	 * This client is the creator of @master. Protected by struct
-	 * &drm_device.master_mutex.
+	 * This client is the creator of @master,
+	 * or an independently opened client of an exposed lease.
+	 * Protected by struct &drm_device.master_mutex.
 	 *
 	 * See also the :ref:`section on primary nodes and authentication
 	 * <drm_primary_node>`.
@@ -323,6 +324,16 @@ struct drm_file {
 	/** @filp: Pointer to the core file structure. */
 	struct file *filp;
 
+	/**
+	 * @lease_file:
+	 *
+	 * Reference to the original lease file for an independently opened
+	 * exposed lease client. Keeps the lease alive without sharing its
+	 * per-file resources. This client must not revoke the lease on close.
+	 * NULL for ordinary DRM files, including the original lease file.
+	 */
+	struct file *lease_file;
+
 	/**
 	 * @driver_priv:
 	 *
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
-- 
2.55.0
