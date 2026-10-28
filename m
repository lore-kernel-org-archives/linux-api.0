Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194425;
	b=XGjQ/RmdtWjqjww11EzYgUKs+1zRyq0ILMFqwZl4ooP7OZHJlS8Z3V2z9UUP0HlLgQs/
	 fSlJh3XPfphm+MKJmPXf1bbs0rM8sOBx0DGekPkAjqaufLLBbioansLP4k0WzEcCzggii
	 3gGKpUguMKyiKvjOKjV1JSk0MDz7xuILhOHMRpqa8S5BKkmk5LAaK/wOtJ+yEsBKSN+07
	 BMwiRo8rduNRslUB2Uo+WVwm4khdeu/J4O77NB2eTm7C3NXJXxTuwZ1MYajz5cVeTy7Lw
	 1GLV+Z1UP2ynr3aPjtbACcmJ1JzfLt3tPZNWBESY0P9e4bugVvhZN4Ugs1r/XswQJKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5qhrixXgJz9/TxX0zDeSD+7uwhcTAxtkmvISQ/Cf0T4=;
	b=B5bIEvSua6oq1xlmr8V3ZI5QzgcqiCNCPE+IFXhWPgbApcUI1Jdh9DJV+ccZL39FEMgY
	 BrrCd4eAdE69SF8yax6hy6+vV3/nFMbfgbI0N4QeUV0/P5UvWPvdsLjOPBi59J8oiH4Mv
	 kLhTLLlsx03Pf/DGuCnvfocKnDJFYOxdd7zLZB7FoKCipKRRu8z8RRLdPzJgVdMBbGONL
	 YQLgEDugsOtjxSn7rQDDqZZaoLCBYg7KNof4t5XfphJqf6iVtB73k+Huvpsl7MnkWLRHc
	 MRz8cAgiMZz+cmtFjE8Q/I0CtXzjjCq8Bj4gp9y44uVbS51tT8xm73Uf6uWvdogE/fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Mtr5tjUV;
	arc=none smtp.remote-ip=74.125.224.53
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84098606A325
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 13:33:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84098606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Mtr5tjUV
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6798d4ab549so1084768d50.0
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1793194423; x=1793799223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5qhrixXgJz9/TxX0zDeSD+7uwhcTAxtkmvISQ/Cf0T4=;
        b=Mtr5tjUVjoKiIImb9L4oKa8STy6M7NVSE5j5eKs2c8PgmvCmlhe4fn7vJ/1E/4EruS
         JW7u5L0CGZjitr4ykSHPAt7O+oMIZoaRQRRugRVl9edYbk9v42CC8JsoMWx9XcuaZZm3
         c0toqQt4eN1nj2krHPrj1HEBCzqfwnfIAyuYYgE5AZ4LiTuJVm07xIkRD6euYgRkdRI/
         i3pP+ommLCOjbrhFOKo0d2yggDakHwnyiHTaqjF+9bgDiS+Fw9EtN7yQ7JPUfValqAnb
         D7Wpo8J36xOMHBOpI2+7Xvs8WYCEotXh+Tyj9//QlNgt94R15xvcRHCGZxVhzy3K/FsM
         T9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194423; x=1793799223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5qhrixXgJz9/TxX0zDeSD+7uwhcTAxtkmvISQ/Cf0T4=;
        b=zS4BWewtEqlJT1vVEofpzZVmW109BLBAy0p/J5Lty3Z3L7C6q7xrcYXa1Kv0B7vtNG
         THmQ/4jwQeU9fEIRqhZNhTZ8IPWNkkrP4UM6aO4tJEFCaDOdpVK4+RNS9PmTzRZIHy3c
         fa5YIo7PiiOVKBuOa9HTsz4Tog3J4k0RVnM/M7aDEZLXPzyRG6GBsgquiMQUfl/Bfsk6
         P0mvyzFJEZh9+c2+R+ODhPCBC4rp2kiYWvRc84YBgUBgILzP2/0B/EsbVTsFDvzTS5sO
         5Kzg78FhsBiwcg1QWvOGwK16i5R7hwpxr0zUCFikG5QVwvnQW9xxqEza1uJyU9nQGZz8
         1xsQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjIXiIqx/IDDuRuEmWJWY31zjGf6p5fq5dN0V7hfSl2eM1Tl/+zWr7ujO4TPBLQj+mwU7TQZt/i3U=@vger.kernel.org
X-Gm-Message-State: AFq9FYK5B0146UYlYat/sIRIWHmT/f+yRbfJe4oRZVNWh7LE6tAoRAus
	z8L8azDVPlpPasLca+jhY/gQj3759BXD2SdBW02Nj5MlvqWD5qrYCgUpnsMnLMCaxudPFyDigEy
	m2szGy/Hp
X-Gm-Gg: AYBFou0bObQXcP/r8ogTme0hjkhHT2sHlLDOkTivCWv6/7NQjUlk06wlCcE4J08j2Xl
	5OENb9QCPPO5vfIivfR8WEplBh49/7l7CTOAOdRg0yKyXqHTRCHN4P6HqEifRVuOM5FAP3odUgy
	L4Wgp471faC6111sILXBgJW6jFUYLpCWf/Znnz8GmD20Yjq7hzmHhLw9aRJpXPcGCqyWilBhWgL
	MVxXST7wqod3SBDaFQz9jKnl7zV8LUa5bsqVdxBJlQsfak5J7O0EOKGhbYiIPNoOc5lKcj1ucar
	KoV6rX2o6n0YvFVDN6Td7F6cGFb0tSmSDXm1uAfCOiwca9cLso484amwcLT1sruwZr6mNmpIIZD
	EiTWdq0hMYziTeQCf4+cu0S0d0+h6Kkcx5R3v3uzdapQURw2p1v+a1vFjoVFunG6J/D12mga4y3
	m/ZqwZDiUEbA0vqQZOckLM2ln1kq94mzLfY2uq0tm6PGx+vOcRhF0aQiJKAFEu+s6Y/sTwRjxrf
	xb82PdrU0S6HevkiHwuOiyfaGFoOnAbNpw7zn4DKKNqhuc1fDO4a5UL7EtIsKzjsf1aJM4olLJA
	tVzkxbQUquUbTRUPFfIfMxy7h5YtGv+8s0aHdfm+jsd3Gw1apO46nhKP9b6kqI4uiOhiu3MQN8q
	CKP0u/rw++H4Cy5kIO3nh8Dn3aFoeAVx4yGA5Im9Sm2CV+Pw=
X-Received: by 2002:a05:690e:4808:b0:679:9bc4:cc03 with SMTP id 956f58d0204a3-67a7bcf715fmr1382145d50.69.1793194423425;
        Wed, 28 Oct 2026 06:33:43 -0700 (PDT)
Received: from CC-KJQTV599DQ.attlocal.net ([2600:1702:7b5a:ab90:103d:30e1:1f09:a9ae])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a79f38dfesm1694911d50.1.2026.10.28.06.33.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 06:33:42 -0700 (PDT)
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
Subject: [RFC PATCH v2 0/6] security: introduce Kernel Assurance Plane
Date: Wed, 28 Oct 2026 09:33:29 -0400
Message-ID: <20261028133335.75899-1-ketan@armoriq.io>
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

Kernel Assurance Plane (KAP) introduces objective-scoped authority as a kernel
subsystem. Intent Lineage Groups (igroups) are its core kernel object, LSM hooks
are its enforcement mechanism, and securityfs is its control-plane interface.

Linux decides whether a task may perform an operation. It does not decide
whether the operation still belongs to the objective the task was started for,
which matters once long-running agents start programs, edit files and open
connections on a user's behalf. KAP binds a task and its descendants to an
igroup holding the authority compiled for that objective, and refuses
operations outside it at existing LSM hooks. Planning and policy validation
stay in privileged userspace.

v1 [1] was the design document alone. This version adds the implementation it
describes. An earlier revision of this code runs on Linux 6.18 as the guest
kernel of Kata microVMs. There, under nested virtualization and in a single
run, running the same binary unbound and then bound, enforcement added 154 ns
to a read and 787 ns to an open, while the unhooked getpid control did not
move. This version has not been measured yet.

Changes since v1:

* Add the implementation: the LSM and its igroup decision engine (3/6), the
  securityfs control plane (4/6), and checks on unshare and setns (5/6).
* Documentation: drop the admin-guide/LSM index entry, which pointed at a
  page that does not exist (Randy Dunlap). Describe the authority format,
  kap.igfd, kap.transition and the event fields as implemented, and drop
  "It does not add code".
* Add a MAINTAINERS entry (6/6).

The control plane follows the shape discussed for v1: /sys/kernel/security/kap
holds kap.default and an igroups link to a small internal filesystem, as
AppArmor publishes its policy namespaces, so an igroup is created with mkdir as
a cgroup is.

Known gaps, where feedback is welcome:

* The authority format is a strict subset of JSON and is experimental.
* Decisions are serialized by one spinlock, and those that resolve a path
  allocate a PATH_MAX buffer before taking it. Both are prototype choices.
* igroups cannot be removed yet, and kap.procs keeps the pids written to it
  after those tasks exit. A task's binding lives in its task blob and is
  released with it.
* A thread created while its process is being bound can miss the binding.
  cgroups closes the same race with cgroup_threadgroup_rwsem; KAP does not
  yet.
* Control writes need CAP_SYS_ADMIN. CAP_MAC_ADMIN may be the better fit.
* unshare and setns call KAP directly because they have no LSM hook
  (question 5 in the document).
* There are no selftests in this series yet. It was built with and without
  KAP and with networking, namespaces and io_uring disabled, and boot tested
  in QEMU with lock debugging: the control plane, file and exec decisions,
  epoch revocation of a running task and kap.default.
* The LSM ID is provisional and is for the LSM maintainers to confirm.

[1] https://lore.kernel.org/linux-security-module/20261021165748.19304-1-ketan@armoriq.io/

Base commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907 (Linux 7.3-rc7)

Ketan Bhardwaj (6):
  docs: security: Describe the Kernel Assurance Plane design
  security: kap: add the LSM ID and internal headers
  security: add the Kernel Assurance Plane LSM
  security: kap: add the securityfs control plane
  kernel: add KAP checks for unshare and setns
  MAINTAINERS: add an entry for the Kernel Assurance Plane

 Documentation/ABI/testing/securityfs-kap | 111 +++
 Documentation/security/index.rst         |   1 +
 Documentation/security/kap.rst           | 236 ++++++
 MAINTAINERS                              |  10 +
 include/linux/kap.h                      |  16 +
 include/linux/lsm_count.h                |   9 +-
 include/uapi/linux/lsm.h                 |   1 +
 kernel/fork.c                            |   4 +
 kernel/nsproxy.c                         |   5 +
 security/Kconfig                         |   1 +
 security/Makefile                        |   1 +
 security/kap/Kconfig                     |  14 +
 security/kap/Makefile                    |   2 +
 security/kap/igroup.c                    | 945 +++++++++++++++++++++++
 security/kap/kap.h                       | 159 ++++
 security/kap/kap_lsm.c                   | 866 +++++++++++++++++++++
 security/kap/kapfs.c                     | 524 +++++++++++++
 17 files changed, 2904 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/securityfs-kap
 create mode 100644 Documentation/security/kap.rst
 create mode 100644 include/linux/kap.h
 create mode 100644 security/kap/Kconfig
 create mode 100644 security/kap/Makefile
 create mode 100644 security/kap/igroup.c
 create mode 100644 security/kap/kap.h
 create mode 100644 security/kap/kap_lsm.c
 create mode 100644 security/kap/kapfs.c


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.51.0

