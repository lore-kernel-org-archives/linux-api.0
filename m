Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B794E9C28
	for <linux-api@vger.kernel.org>; Fri,  9 Oct 2026 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560373; cv=none; b=MY9usw+4tqgAF4dWS2WYF4W0U/GZRjhWJ5oT7LFGD4H0QzKjddgWFHcHZNu0fb7KjpY8WorLxRUbjGTV56rFvNrmtikxyGlcKxc0iiQoTmgeYEDxi7jakv2lHwa4nsGbQQw87ljU6K9xRATlXskgy6tT/Eg9eoY4QN7kDOzQy+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560373; c=relaxed/simple;
	bh=GbihQDT60TkSUyG8sRpe6wSrJ+mv6j+gTgXLREuoT34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awXC2FhrtMbE5fvXPwarsMgYG3ZTeiAnXlNWnG+X9jiTFCZuQfAFEwESyvhhEJOXCNHQ5u7V5K3c/z5+6JlfW6xrxMTHX7WqLymPAeJCbhMkT6NWVfNjX1eScTpqg614fZYhL/GodAmxQDxtB+ljtvjf2veEGiqczVfJIj/kWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFOlrWbV; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFOlrWbV"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc4c7fab7b6so4502734a12.0
        for <linux-api@vger.kernel.org>; Fri, 09 Oct 2026 08:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791560370; x=1792165170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oc43EGm7NUZeK/eRaBYRasWqtzt/BRe/LMfh582Cs/s=;
        b=gFOlrWbVchPXW7Fv1lrAWM7LwrJzN6r4LFXrTby/IRpy2rTuTYO4/E0iVyV8m92wWV
         fzzFTFSI2cCRmzkblMtob7vTQLRW3rRuS25RAPWXFoa5mqRD97SGCNV0WP4THCJMLvhM
         aMxRlvGLV2W2JuwHVhsHJcbyw978meTN4JbPTjj/u/E9RsP5JkOKdBu3zJ/2tf4mer3v
         OFiZdGBUwjgTvyC8K+YAlBdOJ6+6W1QaMJOC8bL4ue1eU+0gsQfwwIrtUjCdLQ503jPH
         V3IlyjfKfwtLsavmygJA43G4vrXhYr6QNzEFgVOqROopUemQPCxhY5pxFsg6K85XqDn3
         qvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791560370; x=1792165170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oc43EGm7NUZeK/eRaBYRasWqtzt/BRe/LMfh582Cs/s=;
        b=SHAocm5KweM11pT1gYOTH5Im0IT3gPPHaPr+ryflSSHs8p32lkTVaZ4eow8pvpFO1c
         CfFe3GyuQBhxFnPo6Z2kclS/DVBnWhiyRkdNEifUqu/IPw8MaXHWEVXulx2K4EgfoEmG
         9gaEsb8DMCPsbgFmrcaWSQrdA8e1mPq48zrQee4cxlIqWO9TBAQd4IAZ9IirnQwj1Rp/
         glDMW3hKVubzPpNRIVW7NzL3qBxIm/JmmUL2h0bcP14rDZYy3YSATsQ1WeEjGLcNm0Ev
         9VYAEzxqeIUDU8f0wQnQ4Wk3t3nJ869N89gHR+l96tRCC7HC4pXEZabB5rlV9d4g84aC
         oMCg==
X-Forwarded-Encrypted: i=1; AKwUvBw02AHWJ/RCjpxizDWl1OyH/76Jk5SpQzyQQA2NY6bfm15+Dq6fngryJKIMuQtBRah1dqPtbZMRwMM=@vger.kernel.org
X-Gm-Message-State: AFq9FYLt3i1iJ9v8QSBMEJFKL2BPuLqr/LUjLvw8zPeRX+OlsRY4ZSCb
	LD3bxbrC1GRqVzvpWMctaiOYBmZ9lQ9M7uJI4UK3Cf4Z9wwi84Iaob8j
X-Gm-Gg: AYBFou09CtGbR2927Zw4NaukHbLpzd6kaxmoOdLk/ufaaD2KBjUvbmNDrMd+C2j6juI
	yFFpYNi5srE/EoPqrDT53sLnO1vFFvir5qMMcIMPDxXcxOUUDWG1/AgyiDmFUMrr6upqrAaoob4
	ejxYFnSRANYNjxme17AZNt4S/C39/r46CBNy4lQREhvy/9z87fKdDzLPbXElkrwy+sgVpzW2wSY
	vU2r0Gu5A2rxz312TY9iKOn2ygGJnYOmB5qy651iks3uJ8yhuXHTuEQeMxpfQCpLnOU21Vp8DQZ
	TRD0Xmyg+REhTh9xrb6bsMvYuydJnTf1ekC8odUJD/SIDEfBq1n5fBL6g8W1JdH+A3vcqAhA0x3
	2klTKUhmZ2Lg008nDht4TXlq0eWOU2lGBF2G3uf0l2F+wk0Kbs+BD9liTSW4bts6e47CqpUzwHH
	M+f0uPg4SbephrhNZFLs7sF5byHl5wQXEurB4nCtQBsVVe8ewyjiNj8JIhmLUsaI47QVIc4qEv8
	GYTrFc=
X-Received: by 2002:a17:902:d50a:b0:2e3:1bb4:610d with SMTP id d9443c01a7336-2e842f31562mr21457435ad.50.1791560370363;
        Fri, 09 Oct 2026 08:39:30 -0700 (PDT)
Received: from mincom1 ([14.67.155.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421ae999sm11847705ad.31.2026.10.09.08.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 08:39:29 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] docs: hwmon: Document the uhwmon userspace interface
Date: Sat, 10 Oct 2026 00:38:44 +0900
Message-ID: <c02aeee5b7e7a5d159d4df5baabe925e16814e94.1791559095.git.hurryman2212@gmail.com>
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

Document the uhwmon UAPI for developers implementing userspace hwmon
drivers. Cover device registration, request handling, notifications
and device lifetime.

Assisted-by: Codex:gpt-6-astra
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 Documentation/hwmon/index.rst  |   1 +
 Documentation/hwmon/uhwmon.rst | 141 +++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)
 create mode 100644 Documentation/hwmon/uhwmon.rst

diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
index 9955a525436a..88c6388e7c5c 100644
--- a/Documentation/hwmon/index.rst
+++ b/Documentation/hwmon/index.rst
@@ -12,6 +12,7 @@ Hardware Monitoring
    submitting-patches
    sysfs-interface
    userspace-tools
+   uhwmon
 
 Hardware Monitoring Kernel Drivers
 ==================================
diff --git a/Documentation/hwmon/uhwmon.rst b/Documentation/hwmon/uhwmon.rst
new file mode 100644
index 000000000000..155f1a965d16
--- /dev/null
+++ b/Documentation/hwmon/uhwmon.rst
@@ -0,0 +1,141 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+Userspace hardware monitoring
+=============================
+
+Copyright (C) 2026 Jihong Min <hurryman2212@gmail.com>
+
+``uhwmon`` connects userspace drivers to ``hwmon_ops`` through the control
+device ``/dev/uhwmon``. The hwmon core creates and formats sysfs attributes.
+The daemon supplies values in the units defined by :doc:`sysfs-interface`.
+
+Enable ``CONFIG_HWMON`` and ``CONFIG_SENSORS_UHWMON`` and load ``uhwmon``.
+Include ``<linux/uhwmon.h>``.
+
+Register a device
+-----------------
+
+Open ``/dev/uhwmon`` with ``O_RDWR`` for each device. Zero-initialize all
+UAPI structures.
+
+Call ``UHWMON_CREATE`` with the NUL-terminated chip name, attribute array and
+its count in ``struct uhwmon_create``. Each ``struct uhwmon_attribute`` contains:
+
+* ``type``, ``attr``: hwmon enum IDs, not ``HWMON_*`` bitmasks.
+* ``channel``: zero-based index; zero for chip attributes.
+* ``mode``: nonzero permissions using only bits from 0644.
+* ``flags``: zero, or ``UHWMON_ATTR_CONSTANT`` for read-only constants.
+* ``value``: a constant number, otherwise zero.
+* ``text``: pointer to a constant label, otherwise zero.
+* ``size``: NUL-inclusive label capacity from 1 to ``PAGE_SIZE``; zero
+  for numbers.
+
+Labels are read-only, NUL-terminated and omit the trailing newline.
+
+Handle requests
+---------------
+
+Read a ``struct uhwmon_request`` and write a ``struct uhwmon_reply`` on the
+owning file. Request and reply headers are 24 bytes. Only successful label
+replies append ``size`` bytes of text. Buffers smaller than the message are
+rejected with ``EINVAL``.
+
+``struct uhwmon_request``:
+
+* ``id``: request identifier; copy it into the reply.
+* ``attr``: index in the registered attribute array.
+* ``op``: ``UHWMON_READ`` or ``UHWMON_WRITE``.
+* ``value``: number to apply for a write; zero for a read.
+
+``struct uhwmon_reply``:
+
+* ``id``: the request's identifier.
+* ``status``: zero on success or a negative errno; use ``-ENODATA`` for
+  unavailable or stale readings. Return ``-EINTR`` only before applying a write.
+* ``reserved``: zero.
+* ``value``: successful numeric read result; ignored otherwise.
+* ``text``: NUL-terminated result of a successful label read; absent otherwise.
+
+Numbers use signed 64-bit fields and must fit the kernel's ``long``,
+except for energy64 reads.
+Discard replies rejected with ``ESTALE`` (canceled request).
+
+This example registers ``temp1_input`` and ``temp1_enable`` and reports
+42000 millidegrees Celsius while enabled:
+
+.. code-block:: c
+
+	struct uhwmon_attribute attrs[] = {
+		{ .type = hwmon_temp, .attr = hwmon_temp_input, .mode = 0444 },
+		{ .type = hwmon_temp, .attr = hwmon_temp_enable, .mode = 0644 },
+	};
+	struct uhwmon_create create = {
+		.name = (uintptr_t)"example",
+		.attrs = (uintptr_t)attrs,
+		.num_attrs = 2,
+	};
+	struct uhwmon_request req;
+	struct uhwmon_reply reply = {};
+	int enabled = 1;
+
+	if (ioctl(fd, UHWMON_CREATE, &create) < 0)
+		return;
+
+	for (;;) {
+		if (read(fd, &req, sizeof(req)) < 0) {
+			if (errno == EINTR)
+				continue;
+			break;
+		}
+		reply.id = req.id;
+		reply.status = -EINVAL;
+		if (req.attr == 0 && req.op == UHWMON_READ) {
+			reply.value = 42000;
+			reply.status = enabled ? 0 : -ENODATA;
+		} else if (req.attr == 1 && req.op == UHWMON_READ) {
+			reply.value = enabled;
+			reply.status = 0;
+		} else if (req.attr == 1 && req.op == UHWMON_WRITE &&
+			   (req.value == 0 || req.value == 1)) {
+			enabled = req.value;
+			reply.status = 0;
+		}
+		if (write(fd, &reply, sizeof(reply)) < 0 && errno != ESTALE)
+			break; // Fatal error.
+	}
+
+Disconnect and reconnect
+------------------------
+
+Sysfs requests can be interrupted or restarted before delivery to the daemon.
+After delivery, they wait for a reply or disconnection; only fatal signals
+can interrupt this wait. Completed replies take precedence over signals.
+
+Releasing the last control file reference disconnects the daemon: dynamic
+reads return ``ENODATA``, writes return ``ENODEV``, and constants remain readable.
+Closing an fd does not cancel I/O in another thread; duplicated fds retain
+ownership. Interrupt blocked control reads or use ``UHWMON_DESTROY``.
+
+The device persists after disconnection. To reconnect, open a new control fd
+and register the same name and attribute array, including constant values.
+
+``UHWMON_DESTROY`` removes the device. Close and reopen the control file
+before registering another device.
+
+Notify changes
+--------------
+
+The kernel cannot detect changes to values held by the daemon. After changing
+a value, call ``UHWMON_NOTIFY`` with its 32-bit attribute index. This wakes
+sysfs pollers waiting for ``POLLPRI`` and sends a ``KOBJ_CHANGE`` uevent with
+``NAME=<attribute>``. Applications read the attribute again from offset 0 to
+get the new value. The notification carries no value and does not replace a
+read reply.
+
+For example, after changing ``enabled``, notify listeners of ``temp1_enable``:
+
+.. code-block:: c
+
+	__u32 index = 1; /* attrs[1]: temp1_enable */
+	if (ioctl(fd, UHWMON_NOTIFY, &index) < 0)
+		return;
