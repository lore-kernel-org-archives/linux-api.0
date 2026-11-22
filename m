Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376259;
	b=MMZhef/T629x52jtCpAuqz1fa2VOnTRE98+CfYSLsRZ9ztthkWSnx0SH0WLISuoxDvc9
	 Fj+eR271g4ppLA7FGuLuYzZe23TcukBST+UlQM+xOYfYYAs2MGmN8xdUC0uB1qSNJXvLG
	 Mh158cQDCQRBHq9JA1bNooiOUqX0PB+9wt85VXu+UyaS80OLbFcr7b4HGDNDo8OWr3ZMq
	 cefkC95IBmEU5oivQSoD8kw2oCeJNoqhFOQj2NOIqi+OcYnuap+UApwlVHF2+XcG92D0p
	 e4OFyv5SRAUWsWmCYug4AW9UckutUrX5wYwZ9gZibbHW50WZmU1OUzidFGccY08XIkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lKuvDTI6FKXAAEbVhrzFDmxnTT5Wc4CNv/2+sIEwHRc=;
	b=kNT5Pbm94mW7Y+OmsJw+eGQUuDHnL2GURY7ckUXGETkICavsBm34f+S/y/xMGJhCJ3Qd
	 htbJXaN2IhpA9yNHZmFXe/yCmJNnnLkGyjXS5NKSLRR1AG18w3LKYQyOW7bLaO8EDRFB0
	 E0suIbZVCbkF/UecvKtjB2G1mF/xJr+aCb+pfXa3wSHMvDiFyx9COkEBsGvluxJfm2R+H
	 5Qy/4EozjR/blMHD4J6ESup4En+wMoQE3gbIeakFabsfShNVMIaa/xqeiclbaT2LPEoQU
	 ELXUX7KVIjF+Jr2zqUWNuqFgBesfdgdc1SyCxwliD9x6i+y57vZsDqKrz2EsFALfEsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrRw2VD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B0926606A6AA;
	Sun, 22 Nov 2026 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrRw2VD2
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B91A51F000C0;
	Sun, 22 Nov 2026 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376259;
	bh=lKuvDTI6FKXAAEbVhrzFDmxnTT5Wc4CNv/2+sIEwHRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrRw2VD2LDlpWWnJ443LaoyqYPi4WgdTpxgCBEg8S1X4e6IoUvfRHh2uCryPfjSrB
	 k49cshsGh1pQGyu8+ruFN5d5UZ84WoFrEgLMgZL33GuKh7Brduf4ZFFAMf8oJ5YeVe
	 P5+logxlr1Mggk49m8VIlSPaAsMgwtpUd84l2GYBXS4JQzhRmyU1kB+6TwZ/FwxxFP
	 TpBUzs/TXlv3gs+UJ16Cf0VGW6o7otugSJjLKPf51TNLQRNCN0a4c4ZxiL5bmTIcJA
	 2hkuAJmkIf2j7Bq11dWJG+6VxJu6M2HyIMMaJTql4BEoanz/MSQ6sg6sqBmAtBU/UV
	 E0hG4WNw5gekA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 24/26] docs: Document userland uAPI
Date: Sun, 22 Nov 2026 21:35:37 +0200
Message-ID: <20261122193539.3334213-25-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
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

Userspace orchestrators need a clear specification of what a userland
is, its build and live state transitions, USERLAND_GET_NSFD,
USERLAND_SHARE_NSFD, waitid(P_USERLAND), pidfd_send_signal(), mount-tree
construction, user namespace ID mapping, credential rules, and process
creation semantics.

Add Documentation/userspace-api/userland.rst including the kernel-doc
sections, type definitions, ioctl descriptions, and system call
reference from include/linux/userland.h, include/uapi/linux/userland.h,
include/uapi/linux/nsfs.h, kernel/userland.c, kernel/user_namespace.c,
fs/fsopen.c, and fs/namespace.c, and register the userland ioctl magic
in ioctl-number.rst.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/userland.rst      | 77 +++++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100644 Documentation/userspace-api/userland.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..ac665b8fea72 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -17,6 +17,7 @@ System calls
    :maxdepth: 1
 
    unshare
+   userland
    futex2
    ebpf/index
    ioctl/index
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..4cf194e7b648 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,7 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xB9  00-0F  uapi/linux/userland.h                                     userland uAPI
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
diff --git a/Documentation/userspace-api/userland.rst b/Documentation/userspace-api/userland.rst
new file mode 100644
index 000000000000..e32ea3501472
--- /dev/null
+++ b/Documentation/userspace-api/userland.rst
@@ -0,0 +1,77 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+userland uAPI
+=============
+
+Overview
+========
+
+.. kernel-doc:: kernel/userland.c
+   :doc: Overview
+
+Lifecycle
+=========
+
+.. kernel-doc:: include/linux/userland.h
+   :identifiers: userland_state
+
+Flags
+=====
+
+.. kernel-doc:: include/uapi/linux/userland.h
+   :identifiers: userland_flags
+
+Ioctls
+======
+
+.. kernel-doc:: include/uapi/linux/userland.h
+   :doc: USERLAND_GET_NSFD
+
+.. kernel-doc:: include/uapi/linux/userland.h
+   :doc: USERLAND_SHARE_NSFD
+
+System calls
+============
+
+.. kernel-doc:: kernel/userland.c
+   :identifiers: sys_userland_open
+
+Process creation
+================
+
+.. kernel-doc:: kernel/userland.c
+   :doc: CLONE_INTO_USERLAND
+
+Process waiting
+===============
+
+.. kernel-doc:: kernel/userland.c
+   :doc: P_USERLAND
+
+Signal delivery
+===============
+
+.. kernel-doc:: kernel/userland.c
+   :doc: pidfd_send_signal
+
+Filesystem configuration
+========================
+
+.. kernel-doc:: fs/fsopen.c
+   :doc: FSCONFIG_SET_USERLAND
+
+Mount tree installation
+=======================
+
+.. kernel-doc:: fs/namespace.c
+   :doc: MOVE_MOUNT_T_MNTNS
+
+User namespace ID mapping
+=========================
+
+.. kernel-doc:: include/uapi/linux/nsfs.h
+   :identifiers: userns_idmap_extent userns_flags userns_idmap
+
+.. kernel-doc:: kernel/user_namespace.c
+   :identifiers: sys_userns_set_idmap
-- 
2.47.3

