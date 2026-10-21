Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601872;
	b=CgUv4skoJHa2I3O1AmW2M8qoLG9AEH8Qyx7NNnkB3DPY4drr4fA2U3Ewety/j0hoSulB
	 4rUQ8vNCuUamfzCkcL5G/5B+8ZmLw0EQURHs0jsZNeXWCdDYTr2Zv4JKrsdwM4yrf5x6P
	 1ReH7jxnSpZgI4/uU16wVEZoQ/qLQmRrMtIaeYwU9qpKN172ffPeQwhhVPryZSV8jyR6e
	 PAFxzRZVNfEbpc2P1nnqv+Tm5Ky4mGzIS3Syj3K6/NYf38iAVEUBcJZk/4xvxebkRp7S/
	 B040uDaEDRdaOQ47WostLr3QhPMlJyc5DA3cv+j+qk7ke6vP7ASInTht2aGorguGxJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601872;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Wrl1hkgNQocQ50RbdUgeab14QR/zpMpNR80bbfzJVRw=;
	b=QYBhxDaOw+5jTqk4KzYliU5nUkp3rTAul4ieXrSbX63xpPC0w2+5YKEbbuF5EJtyzvCD
	 NDDIXvMhTm9Z7YuKcuql+JPlKu9p5HwCIBcyEUp4ytw2+KVO+k2uenQo0X39j7lP9VzSi
	 CWFNYq3jnSAuUYuV45kTR+7MfadBYFolxegx347VlkVNPXWR9eWDkouK5d1ea1Qj9FK3f
	 DMx0wXk9g4uJIaLsTto68tV4F1Qv08j8bccdlLMF2XSzcQdzdjHNpIYL/SzmsEgkNsj98
	 5/hypRlTwmgoGoPcWi52bmgBNcwcpur3WA95Su2o6zILMxfx4WJyZBx8YtDLe20NjuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20251104.gappssmtp.com header.i=@armoriq-io.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="ecJ3/BLc";
	arc=none smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD62606A319
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 16:57:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FD62606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20251104.gappssmtp.com header.i=@armoriq-io.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=ecJ3/BLc
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67489c8202cso829738d50.3
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 09:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20251104.gappssmtp.com; s=20251104; t=1792601870; x=1793206670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wrl1hkgNQocQ50RbdUgeab14QR/zpMpNR80bbfzJVRw=;
        b=ecJ3/BLcdDo0hwe0Voqxkj3GWbMNNB3JG/+deM/4A6R1lB+aqx3TOsTX4SwKd2qCIG
         Intc+zHP0tWLWS/4iuS5mDzvKXyBtThLWW0jk5mlS+JFn6KYQo5Zh7Jn0zErvRI3iDlv
         uUH1IympoPSBiVpg1oW7LwKZ20LH7yCXH55AHNyfPUsCopVCDOfBuhjarDYHIUMaTblC
         tuceB/MqKnLVpWi77wXHPM1MULmllyXIf5CtoI5lChe94DPnzkgGzSwsHom3w9n7AdxM
         rGjBzt5jXz26IeIaOjsLq0ZT0lgnEn7O8dxWuWNsQt+Pe1mhafkzidya3X+O9xNehjFr
         CbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601870; x=1793206670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wrl1hkgNQocQ50RbdUgeab14QR/zpMpNR80bbfzJVRw=;
        b=H4OzWFx27JWuzCrbitp1TygWo0RGKcUIiidz6nmaM6FZEwU26f4tadQNSNNGdjkG08
         kVuxEjiVgrPbBQQyGE1n2d13WCAy4hrTyrV7Xhp9AxK8mMenTGZuNze73Nvp8TZkGPEj
         4wBHthSKJJ/0kj52NXK50bbGbJVCsHrSEyHAU7O1sV7KRDwHn+XoQjAsBs7UzT7CJjcR
         WEcszOzn5r74Y/kRMyuRXhz9SQeJqNu9CV0hFzk8fa0N9onfNnPWZmqKnsv6Vk7mU/9x
         5ybCIgiT+vXu8ibVNQFz2amB6w8NB1kC387dYWE0FLaexiGPee7b4rbftPZDHpegJuOM
         tWvw==
X-Forwarded-Encrypted: i=1; AKwUvBwFqMry/Fl9HmEoyRoOQApcJsYHC2Zdb+ACV3ZeX9PC90vOVu7+0i8GBHjrjf8i05U9bMnZ5Y/3qBQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7S0xct+sB1aJk6gYT7uY1AEawF4iIUB23pNjlZhuRT/6rJoMT
	bEH4Xd744+DiN28LqEevKA72z9JCTWmLnrQ9DYAvPGL/IFWSs2E0ZScRegWGfkxB6AdE
X-Gm-Gg: AYBFou0p1TDiNdzqRfogq6z7C4A788Ij6/LCgmOy2Y4HOQ6essl8odEWuFdfRHYQBsu
	sRAsxZTzt/q2M+zFeF8wc+SrgavfHCBnY6UVUuM91tnlVlL8FT27WgKi3pfQWqsbD2NlJmhw89I
	AKcsWBxfvKhPESEkzq0fM88AhVGMO2RRiiy3nEdEvdN0iPQnbT9l2NydYitfX/YOkmV0LYk5T71
	J7azHDbfLXmpzltUirTjdJQ/jpVMZJS0j5r6bCJNrLmW5KTgubRMmv0wAy/aZ9zNr0GT/I+tqWC
	DrERmnElXnWvi16kfCZ/RVOXRWmXcHd3l5oNhEeAgso4YGG1WcH7F6T+2LgoVriP8vyEexAoicb
	6paVA/cX9gBscBRoxAtFNiHieavqjcQSvv8ppYuZetIelnSjRQUUAOKERgq/5MdB+vt6S4ASVDu
	sgEiYEQzrDajrXBrFHdlC/eoEL+PR+yWSMFjiGD7FWeLhmAoQGEBGJqPzMWigXG+D0m7Jms+TNk
	Kzfj7I921bbp7oi66EoesHpausE7aapclaZKJSWSkH6mcnbWEsR0qRoMvvgEqmtgBMqqqRRQa50
	3EfD9SOUjQF6UBdoVElYSOORA6DUe3ILgpviItWzUuLOruyCMRXxvn8q+ROY6oESacUSYbCU
X-Received: by 2002:a05:690e:4395:b0:679:b87d:6f7b with SMTP id 956f58d0204a3-67a0e4d43a7mr1148532d50.42.1792601869931;
        Wed, 21 Oct 2026 09:57:49 -0700 (PDT)
Received: from CC-KJQTV599DQ.lawn.gatech.edu ([2610:148:205a:0:adab:fd33:8207:cba3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1301045a3sm14277117b3.28.2026.10.21.09.57.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 09:57:49 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>,
	Ketan Bhardwaj <ketan@armoriq.io>
Subject: [RFC PATCH] docs: security: Describe the Kernel Assurance Plane design
Date: Wed, 21 Oct 2026 12:57:48 -0400
Message-ID: <20261021165748.19304-1-ketan@armoriq.io>
X-Mailer: git-send-email 2.51.0
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

Describe the Kernel Assurance Plane (KAP) design for review, with no code.

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
maintainer feedback is wanted. Code follows once the design has been
discussed.

Assisted-by: Claude
Co-developed-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
Assisted-by: Codex
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
---
 Documentation/ABI/testing/securityfs-kap |  99 ++++++++++++
 Documentation/admin-guide/LSM/index.rst  |   1 +
 Documentation/security/index.rst         |   1 +
 Documentation/security/kap.rst           | 191 +++++++++++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 Documentation/ABI/testing/securityfs-kap
 create mode 100644 Documentation/security/kap.rst

diff --git a/Documentation/ABI/testing/securityfs-kap b/Documentation/ABI/testing/securityfs-kap
new file mode 100644
index 00000000..89223a93
--- /dev/null
+++ b/Documentation/ABI/testing/securityfs-kap
@@ -0,0 +1,99 @@
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
+		Write a pid to bind a task to the igroup. Reads return bound
+		pids.
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
+		refused. Bound tasks whose recorded epoch is stale fail KAP
+		checks closed.
+
+What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority
+Date:		October 2026
+KernelVersion:	RFC
+Contact:	Ketan Bhardwaj <ketan@armoriq.io>
+Description:
+		Read or write the compiled authority snapshot for the igroup.
+		The RFC prototype accepts a text predicate payload with typed
+		allow and deny arrays.
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
+		Write transition records. Sequence numbers must increase
+		monotonically to prevent replay.
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
+		Read recent KAP decisions as JSON lines.
diff --git a/Documentation/admin-guide/LSM/index.rst b/Documentation/admin-guide/LSM/index.rst
index b44ef68f..4a299993 100644
--- a/Documentation/admin-guide/LSM/index.rst
+++ b/Documentation/admin-guide/LSM/index.rst
@@ -48,4 +48,5 @@ subdirectories.
    Yama
    SafeSetID
    ipe
+   kap
    landlock
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index 00650dcf..937193b1 100644
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
index 00000000..43099a5a
--- /dev/null
+++ b/Documentation/security/kap.rst
@@ -0,0 +1,191 @@
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
+This document describes the design for review. It does not add code. It lists
+the alternatives that were considered for each decision and the questions on
+which maintainer feedback is wanted.
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
+  sequence, its bound tasks and an event log. A task is bound by writing its pid
+  to the igroup, and membership follows fork, exec and setns.
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
+are bound to no igroup are not affected, and every KAP check returns early for
+them.
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
+  Write a pid to bind a task to the igroup. Reads return bound pids.
+
+``kap.lineage_root``, ``kap.authority``
+  Read or write the lineage root or the compiled authority snapshot.
+
+``kap.authority_epoch``, ``kap.expires_at``
+  Read or write the epoch, or the expiry in seconds since the Unix epoch (0 for
+  none). A lower epoch, or an expiry already in the past, is refused.
+
+``kap.transition``
+  Write transition records with monotonically increasing sequence numbers.
+
+``kap.mode``
+  ``enforce`` or ``revoked``. A revoked igroup refuses every operation.
+
+``kap.events``
+  Read recent decisions as JSON lines, each with the decision, operation,
+  target, reason, igroup, epoch and lineage root.
+
+``kap.igfd``
+  Reserved for future igroup file descriptors.
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
+* A dedicated filesystem mounted at ``/sys/fs/kap``. This was the v1 interface.
+  It works, but puts security state outside securityfs, where the other LSMs
+  keep theirs.
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
+minimal guest kernels used for sandboxed agents do not enable.
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
+4. The predicate format is text and experimental. Is a binary format preferred,
+   or reuse of an existing ruleset format such as Landlock's?
+5. The series adds hooks on namespace and io_uring paths that existing LSM
+   hooks do not fully cover. Are those acceptable, or are there existing hooks
+   that should be used instead?
+6. The LSM ID is provisional and should be confirmed.
+
+RFC status
+==========
+
+This interface is experimental. The RFC is intended to make the authority and
+lineage model reviewable, not to freeze the userspace ABI.

base-commit: f47d223627f80cb7a1eb14c585fe6cb35de5e984
-- 
2.51.0

