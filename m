Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194428;
	b=nyQ++AUNp761+ha+gVdyfifoYZhY0UmsDPfbQtJS34eHJsxQEa39khyqo5xkf0PPkAuo
	 AKGZFWoYC4odYvrmcC6Y+ime63ZMY9n2/bkcakLoNNKJlfU96nUJIKd1UZuw4c95m5uG3
	 2ac3EpJ/Qet4ZeVIGlN/P1m6KPO4x4I1O4BQgpByot5fKJbm3sKPkioAheimAi8idJ6os
	 F6i5opZ7Jb7tSHQSmPm/e5y9arJP79FrUDgMhpg9yZpjMFTeS9iZcmhzBnugffDujT7OW
	 mKJ73+0DNzrmLqCg8uuLSqldEv/dYuLdjzUu/JH6qAnp4nw1N+kESjnlufQCjfCJmSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194428;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+wz7Leq4nFjqOE9KC7e5Otj4MgLZaT46cKb2sR2czA=;
	b=fwtwOehy5aFRLoL24uczlfa84Ifa9qc3QtTL6kZDQpYoRlWbVkguX0BTM/+NSaJBCcXg
	 fJHWF8sntuxuoPhytTljN0/d69ZO92JKut2U5KGD7bOc71PB5byNlo4d0EdzKD9V0T/+T
	 pJScE3q2WQR4w7H4hwVaWrneYvJaidg6LCfrOoootJ+UxVHDSSSByBvmxnKpeZcA2G8Pn
	 3CQFvWMUz4IAHEXAJiPXFB19j94jazyzwD/6WMEhjWYKUMTSvcQcxog5jCzeABucDPOlX
	 DV4HMKRIfGeBEsqYaZNdAmZaYTCcJkgcmjxl+ximLaAZZb9TNUNpqXH9MuLGEbyNaxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nvn2UM8f;
	arc=none smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC953606A32D
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 13:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC953606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nvn2UM8f
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-679a2297c55so1106906d50.1
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 06:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1793194427; x=1793799227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3+wz7Leq4nFjqOE9KC7e5Otj4MgLZaT46cKb2sR2czA=;
        b=nvn2UM8fkoDKuFgvvJtImFE+AEzbKvmAVQMM2dtP7yzT4zbmYFFu1Fs9/0o/0Jj9yt
         JhS1/aKg5+TxQrysx3EmTqcLw2MeFqywsxl0si9Ca5Ic8X037ESk6klQLQh4Lg1LoJXK
         V7UM6uQUJ4X9LwLIs8R3BV31/pwzBnCDbTt6BdLSaMNGrX3WfYVYaGlNFMSczcb+4JjX
         v+/yLmLSYquBb0Bc4/9DzCdrpG12geilahT0VwC6YsjK3GtD0BglKcXvw2rm/tefDvC9
         9tnx/7Jlj94aLYjg7uodr31ptlzuidd/IYxUVNFhpbZoQ7ybb67q6QAywQxMPn4ulXB4
         qF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194427; x=1793799227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3+wz7Leq4nFjqOE9KC7e5Otj4MgLZaT46cKb2sR2czA=;
        b=dWjV3qZ52cZ03tGWiioxfHc5mEd5l4tw0GCBFnhebnPRcrneB3CPPPsMhbAlQR/11l
         TUf0K5JjpF3RyC3IAnWKOn6nxBf6L3OGQDpEDHJb9264GRwTlnpsFoalu9rxDGRszROE
         os7zUEJCHEgtPOrYXZcwQzC88fLACaMEAzj9X1kgZHrtnD+n4j9fEh3YZvUl+3JESUVZ
         0u/IlnVJ+UY2n4y6Ks74fxLfJmNxLBdqGwLwzJc9b7X7Rzvu0Hxk+cCg9cN+VYongpcR
         s5gebcXRcaGDIJ83N1Ruu1rElRKNZD7BzP0RpR6uxhpfipGgCqVUZsMquePoS66O+Idn
         xN0A==
X-Forwarded-Encrypted: i=1; AKwUvBxXDBld+yT326FbnFzcNtMTIkmDgHsVBg2X2+zl17pYh4Qf+eYh3Rxh5FNb0dA/DbghwY9vaWbnlD8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIMtgCjb0ophMELEryATy9GgLrIx0a+aciiH6uoRPd2R2meAuIo
	rMWr/Sh7WUtk1ehH0/6lADBvxXqLFD0HeFYEIh1/KC2mrBiW8BmMHvj0/Q20ufFQ5zWL
X-Gm-Gg: AYBFou3wRa0j2acI1RFdojOyuVfZhXSrXAYLf3Z3im5W0H6e8lUMoZDP7Jz6f4iqccV
	TVcZymkaK5pzHZsF1b18aFq8FKJ73nvQdOllIppGToiPOKjJmc8z3hA7zyzDZ+AvrgceBxzgUm+
	SHLqNcjmceHDwQo9fFrb4ZNUmq0LKvqE2H/MF9iSjVj4PLhwiKmu0MgaeCKlT97WEThuak2R5/Z
	po6dctI4tYSZ4zVPO4k3OXQ/gT6wCrRImP5ONlJ4YmYl+E0gOTCVMIH1cmPt5V2RKiZOPXXShza
	YMUVtERft1nitfVVZ3oeuUYAKQHPClTR3g/NR+ntOjz/I2FGV8fO49nioq1Dj0xYWcMWqeoNP4W
	aeLTylkCG4VoJOobeB51NYQUaKqp92EbiFKaFZUiKJMKPDtga2PyMJAiPwImVg49WpoEuPUzGrM
	Q1gDlqOeGCTlzROOQTrRNXN6ux8B8iwhFHRo//3yNhT84oVsMLijTGLYH/U0g//+1fIzkeg48ZD
	2Y6FVY5rv/UaKnL+hMRGnLy5g2zHFcli+trubBMYmrbkJ97vjDcITrHEnzO7XIefABlAmCCQ9Oy
	IjUceiMtrP6/SE7h25M7s+cN35gFhYzUNgKbh0x1lp5aHFrBb02hO/py36N/XFxcL33oiCCuamY
	Vqc/D+M16eSAwxQfirsifPWaXDf/OPjp7uNAkEhZNJuO8cq6dp2gIbW2nFnRn/4167g8B
X-Received: by 2002:a05:690e:11c2:b0:679:a58:148c with SMTP id 956f58d0204a3-67a7b97f33dmr2080396d50.7.1793194426605;
        Wed, 28 Oct 2026 06:33:46 -0700 (PDT)
Received: from CC-KJQTV599DQ.attlocal.net ([2600:1702:7b5a:ab90:103d:30e1:1f09:a9ae])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a79f38dfesm1694911d50.1.2026.10.28.06.33.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 06:33:46 -0700 (PDT)
From: Ketan Bhardwaj <ketan@armoriq.io>
To: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	linux-kernel@vger.kernel.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>,
	Ketan Bhardwaj <ketan@armoriq.io>
Subject: [RFC PATCH v2 1/6] docs: security: Describe the Kernel Assurance Plane design
Date: Wed, 28 Oct 2026 09:33:30 -0400
Message-ID: <20261028133335.75899-2-ketan@armoriq.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261028133335.75899-1-ketan@armoriq.io>
References: <20261028133335.75899-1-ketan@armoriq.io>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe the Kernel Assurance Plane (KAP) design.

Agents and other long-running tasks act on behalf of an objective that a
user approved. Linux decides whether a task may perform an operation,
but not whether the operation still belongs to that objective. Seccomp,
LSM profiles, namespaces and cgroups cannot hold several objectives apart
inside one environment, or revoke one objective's authority while its
task runs.

KAP introduces objective-scoped authority as a kernel subsystem. The
document covers Intent Lineage Groups, the authority model and the
control plane under /sys/kernel/security/kap, where igroups are created
with mkdir as cgroups are. For each design decision it lists the
alternatives considered, and it ends with the questions on which
maintainer feedback is wanted.

Assisted-by: Claude
Co-developed-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Assisted-by: Codex
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
---
 Documentation/ABI/testing/securityfs-kap | 111 +++++++++++
 Documentation/security/index.rst         |   1 +
 Documentation/security/kap.rst           | 236 +++++++++++++++++++++++
 3 files changed, 348 insertions(+)
 create mode 100644 Documentation/ABI/testing/securityfs-kap
 create mode 100644 Documentation/security/kap.rst

diff --git a/Documentation/ABI/testing/securityfs-kap b/Documentation/ABI/testing/securityfs-kap
new file mode 100644
index 0000000..066de0b
--- /dev/null
+++ b/Documentation/ABI/testing/securityfs-kap
@@ -0,0 +1,111 @@
+What:		/sys/kernel/security/kap/
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Kernel Assurance Plane control directory in securityfs.
+		The ABI is experimental and intended for RFC review.
+
+What:		/sys/kernel/security/kap/kap.default
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write "open" or "closed". When closed, a task
+		outside the initial PID namespace that is bound to no igroup
+		cannot start a program.
+
+What:		/sys/kernel/security/kap/igroups/
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Directory of Intent Lineage Groups. Create an igroup with
+		mkdir, as a cgroup is created.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.install
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Write the lineage root, authority epoch, optional expiry and
+		transition, and the authority as one key=value document in a
+		single write. The fields commit together or not at all.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.procs
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Write a pid to bind that process, with all of its threads,
+		to the igroup. Reads return the pids written.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.lineage_root
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the opaque lineage root for the igroup.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority_epoch
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the current authority epoch. A lower value is
+		refused, and a write clears revoked mode. Bound tasks whose
+		recorded epoch is stale fail KAP checks closed.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the authority document for the igroup, in a
+		strict subset of JSON, with a "predicates" array, each predicate having a
+		"kind" and "allow" and "deny" arrays of patterns. The
+		Kernel Assurance Plane design document lists the kinds and
+		how patterns match.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.expires_at
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the authority expiry in seconds since the Unix
+		epoch, or 0 for none. An expiry already in the past is
+		refused. Once it passes, every check for the igroup fails
+		closed.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.transition
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Write a transition record whose sequence number is higher
+		than the last one, to prevent replay. Reads return the last
+		sequence number.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.mode
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write igroup mode. Supported values are "enforce" and
+		"revoked". A revoked igroup refuses every operation.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.events
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read recent KAP decisions as JSON lines with the fields
+		ts_ns, igroup, decision, operation, target, reason, epoch,
+		root and pid.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.igfd
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read the igroup's name, epoch and lineage root on one line.
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index 00650dc..937193b 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -18,6 +18,7 @@ Security Documentation
    siphash
    tpm/index
    digsig
+   kap
    landlock
    secrets/index
    ipe
diff --git a/Documentation/security/kap.rst b/Documentation/security/kap.rst
new file mode 100644
index 0000000..22c2729
--- /dev/null
+++ b/Documentation/security/kap.rst
@@ -0,0 +1,236 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+Kernel Assurance Plane
+======================
+
+Kernel Assurance Plane (KAP) introduces objective-scoped authority as a kernel
+subsystem. Intent Lineage Groups (igroups) are its core kernel object, LSM hooks
+are its enforcement mechanism, and securityfs is its control-plane interface.
+
+This document describes the design for review. It lists the alternatives that
+were considered for each decision and the questions on which maintainer feedback
+is wanted.
+
+Motivation
+==========
+
+A task increasingly runs on behalf of an objective that a user approved, for
+example an AI agent asked to fix a failing test. Over hours it starts programs,
+reads and writes files and opens connections. Linux decides whether the task
+may perform each operation. It does not decide whether the operation still
+belongs to the objective the task was started for.
+
+Existing mechanisms cover parts of this. Seccomp filters syscalls but cannot see
+paths or objectives. LSM profiles, such as AppArmor or SELinux, are attached to
+programs or labels, not to an objective, and cannot be narrowed for one task
+while it runs. Namespaces and cgroups partition resources rather than
+authority. None of them lets several objectives run in one environment, each
+held to its own authority, or fails a task closed the moment its authority is
+revoked.
+
+Model
+=====
+
+``igroup``
+  Intent Lineage Group, the unit KAP enforces. An igroup owns an authority
+  snapshot, a lineage root, the current epoch, an optional expiry, a transition
+  sequence, its bound tasks and an event log. A process is bound by writing its
+  pid to the igroup, which binds all of its threads. Children inherit the
+  binding, and it is kept across exec and setns.
+
+``authority snapshot``
+  The predicate set for one igroup epoch, with typed ``allow`` and ``deny``
+  arrays for exec, file, network connect, credential, IPC, namespace,
+  descriptor, procfs, executable memory, BPF, ptrace and io_uring checks. File
+  predicates also govern rename, link, unlink, mkdir, rmdir, mknod, symlink and
+  truncate, so a file cannot be moved into a denied path. A deny wins over an
+  allow, and an operation no predicate allows is refused. The snapshot is
+  compiled once when it is installed.
+
+  In this RFC the snapshot is a document in a strict subset of JSON, with no
+  whitespace around the ``"predicates"`` and ``"kind"`` keys and no escaped
+  quotes::
+
+    {"predicates":[{"kind":"file","allow":["/srv/work"],"deny":["/srv/work/keys"]},
+                   {"kind":"exec","allow":["/usr/bin/*"],"deny":[]}]}
+
+  The kinds are ``exec``, ``file``, ``net``, ``cred``, ``ipc``, ``namespace``,
+  ``descriptor``, ``procfs``, ``execmem``, ``bpf``, ``ptrace`` and
+  ``io_uring``. File, descriptor and procfs patterns match a path and
+  everything below it. Other patterns match exactly, or by prefix when they
+  end in ``*``. A program is allowed by the path it resolves to, and refused
+  by a deny on either that path or the name it was started with.
+
+  Each kind is matched against a target string:
+
+  * ``exec``, ``file``, ``descriptor``, ``procfs``: a path. A rename, link or
+    other path operation is checked as its parent directory plus its name.
+  * ``execmem``: the path of the mapped file, or ``anonymous``.
+  * ``net``: the destination address and port, as in ``192.0.2.1:443``, or
+    ``family:N`` for an address family other than IPv4 and IPv6. A connect
+    with ``AF_UNSPEC`` is not checked; ``AF_UNIX`` is checked as ``ipc``.
+  * ``cred``: ``uid=U,euid=U,suid=U,fsuid=U``, ``gid=G,egid=G,sgid=G,fsgid=G``,
+    ``groups`` or ``capset``.
+  * ``ipc``: ``unix:stream_connect``, ``unix:may_send`` or ``sysv:flag=N``.
+  * ``namespace``: ``TYPE:OPERATION`` for clone, unshare and setns, where
+    TYPE is ``mount``, ``pid``, ``net``, ``user``, ``uts``, ``ipc``,
+    ``cgroup`` or ``time``; ``user`` for creating a user namespace; and
+    ``mount:mount:FSTYPE:PATH``, ``mount:umount:PATH``,
+    ``mount:pivotroot:OLD:NEW`` and ``mount:move:FROM:TO`` for mounts.
+  * ``ptrace``: ``same-igroup``, ``igroup=NAME`` or ``unconfined``, for the
+    other task.
+  * ``bpf``: ``cmd=N``, with ``map_type=N`` or ``prog_type=N`` when creating
+    a map or loading a program.
+  * ``io_uring``: ``override_creds``, ``sqpoll`` or ``uring_cmd``.
+
+``epoch``
+  Monotonic authority generation. Installing a higher epoch fails every task
+  still bound to an older one closed from its next check.
+
+``lineage root``
+  Opaque identifier supplied by userspace that ties the installed authority to
+  a committed execution lineage.
+
+The kernel does not parse planning or policy languages. A privileged userspace
+runtime validates those artifacts and installs kernel-ready state. Tasks that
+are bound to no igroup are not checked, except for the exec check that
+``kap.default`` enables.
+
+Control plane
+=============
+
+KAP state lives under ``/sys/kernel/security/kap``::
+
+  /sys/kernel/security/kap/
+    kap.default
+    igroups/            created with mkdir, as cgroups are
+      <igroup>/
+        kap.install
+        kap.procs
+        kap.lineage_root
+        kap.authority_epoch
+        kap.authority
+        kap.expires_at
+        kap.transition
+        kap.mode
+        kap.events
+        kap.igfd
+
+``kap.default``
+  ``open`` (the default) or ``closed``. When closed, a task outside the initial
+  PID namespace that is bound to no igroup cannot start a program, so a bind
+  that failed cannot leave a workload running without authority.
+
+``kap.install``
+  Write the lineage root, epoch, optional expiry and transition, and the
+  authority as one ``key=value`` document in a single write. They commit
+  together or not at all.
+
+``kap.procs``
+  Write a pid to bind that process, with all of its threads, to the igroup.
+  Reads return the pids written.
+
+``kap.lineage_root``, ``kap.authority``
+  Read or write the lineage root or the authority document. A write to
+  ``kap.authority`` is compiled before it replaces the current authority; a
+  document that does not compile leaves it unchanged.
+
+``kap.authority_epoch``, ``kap.expires_at``
+  Read or write the epoch, or the expiry in seconds since the Unix epoch (0 for
+  none). A lower epoch, or an expiry already in the past, is refused. Writing
+  an epoch, or installing authority, also clears revoked mode.
+
+``kap.transition``
+  Write a transition record whose sequence number is higher than the last one.
+  Reads return the last sequence number.
+
+``kap.mode``
+  ``enforce`` or ``revoked``. A revoked igroup refuses every operation.
+
+``kap.events``
+  Read recent decisions as JSON lines with the fields ``ts_ns``, ``igroup``,
+  ``decision``, ``operation``, ``target``, ``reason``, ``epoch``, ``root``
+  (the lineage root) and ``pid``.
+
+``kap.igfd``
+  Read the igroup's name, epoch and lineage root on one line. The name is
+  reserved for future igroup file descriptors.
+
+Design decisions
+================
+
+Where the control plane lives
+-----------------------------
+
+Igroups are created and destroyed by userspace, so the control plane needs
+directories that userspace can create. securityfs does not allow userspace
+mkdir.
+
+Considered:
+
+* A dedicated filesystem mounted at ``/sys/fs/kap``, the prototype's first
+  interface. It works, but puts security state outside securityfs, where the
+  other LSMs keep theirs.
+* securityfs with control files, for example writing a name to a ``create`` file
+  to make an igroup. This keeps everything in securityfs but replaces mkdir and
+  rmdir with a private protocol that every tool has to learn.
+
+Chosen: a small internal filesystem that the kernel mounts itself and links
+under securityfs, the approach AppArmor uses for policy namespaces
+(``apparmorfs``, linked as ``/sys/kernel/security/apparmor/policy``). Users only
+see paths under securityfs, and an igroup is created with mkdir, the way a
+cgroup is.
+
+Igroups rather than a cgroup controller
+---------------------------------------
+
+Considered: making KAP a cgroup controller, since igroups are created like
+cgroups and follow the process tree.
+
+Chosen: a separate hierarchy. A container usually places all of its tasks in
+one cgroup, while several objectives can run inside it, each needing its own
+authority. Tying authority to resource partitioning would prevent that, and
+authority must also follow setns, which cgroup membership does not.
+
+A static LSM rather than BPF LSM programs
+-----------------------------------------
+
+Considered: implementing the checks as BPF LSM programs.
+
+Chosen: a built-in LSM. Igroup membership, epochs and inheritance across fork,
+exec and setns are kernel object state with fixed semantics that reviewers can
+audit in one place. BPF LSM also needs ``CONFIG_BPF_LSM`` and BTF, which many
+minimal kernels do not enable.
+
+Policy stays in userspace
+-------------------------
+
+Considered: parsing a policy language in the kernel.
+
+Chosen: the kernel accepts only a compiled predicate snapshot. Planning,
+policy validation and signature checks stay in privileged userspace, and the
+snapshot is compiled into per-kind pattern sets once at install time.
+
+Questions for maintainers
+=========================
+
+1. Is an internal filesystem linked under securityfs, as AppArmor does,
+   acceptable for a control plane that needs userspace mkdir?
+2. Should igroup removal follow cgroups, with rmdir allowed once no task is
+   bound?
+3. Is a separate igroup hierarchy the right call, or should this be a cgroup
+   controller despite the cases above?
+4. The predicate format is a JSON document and experimental. Is a binary
+   format preferred, or reuse of an existing ruleset format such as
+   Landlock's?
+5. unshare and setns have no LSM hook, so the series calls KAP from them
+   directly. Would a hook for namespace transitions be acceptable, or is there
+   an existing one that should be used instead?
+6. The LSM ID is provisional and should be confirmed.
+
+RFC status
+==========
+
+This interface is experimental. The RFC is intended to make the authority and
+lineage model reviewable, not to freeze the userspace ABI.
-- 
2.51.0

