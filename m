Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219835;
	b=WIQ3Btm7vR4LC3wwU3VVpDmtjBnFQ63l9lV0a4KoEyM1HRr+0vdVHoAOEUHfGbKAvy5p
	 Yg4aW39Q/D+hAVHxsWn/gGiWAjUhv5mRfA7vv9OnKczDEHpb2BNbo+rJwcCS68XC7oOm8
	 HiTth/x801yIp+VHBdv3AqoWfLmkjQcncWGXn+2zJyNni6ACp+nkI7w0j7p1MsSKrDj3y
	 wfzt2H0/zstJTpY4IBoDTK/B7p3Cz6dzw+do+ywkcQY5s+f79bq/B5ESCHFso89GFZqbz
	 oUaVBYtF7EIGLYkt8kMgufMbloRBTan26BvPIFug0+b28FjPtLGeqnWCzQEj11cSCww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6Q7Qhps4lRxBhkSd6Kom85Mw9Dpsf9pUqdpKPK8/kYc=;
	b=uvdA6wJ31vwSlBl4kEWDVTW26J/K0rxwD2YoffR8MGII+MNUD4bi1cecjV/q48ccr4X7
	 nT98CAShxqh/7dTVLFAnUxNUgwYDInt7Txi0Nety1FiQ7GdeU0qbkr0KiBsuvRu6+kWrA
	 8BAHPV1zw40vX5hAE3w1rMY2VAKCi1soROZoHjOCrzOjc2ET/gBzT3Uta8zPlkOi7ULW5
	 G+pTXmK5I8e4DRfxgUrpv2UDvKZptPWZUAtzUiPLZSgFNptaeRXP2y9akI0ldZVyRmwDe
	 H0jPquhNzH2519skO/iOk7gfaZdewrnVg3gf9IW3/zNZHy5SpquSBFgIjYBPQZK0yZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJXqL47u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AEFDA606C3DB;
	Sat, 21 Nov 2026 00:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJXqL47u
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 322BC1F000C6;
	Sat, 21 Nov 2026 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219834;
	bh=6Q7Qhps4lRxBhkSd6Kom85Mw9Dpsf9pUqdpKPK8/kYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJXqL47uM2nuAkyXuX/WrsdOfWCmf8ItRmVzZem6KUkRCUxP25227080tQqnBLJHu
	 VYL/laPTxmBa5X70DiTE88IuBzetX7HPW4xhAPYYuHeIjEcp7bFoOD/Hv0yCGjkUeY
	 o+H/r1msu0Y/IPXR0zjZvPSyDhj/AJVSK8ThNIbAI32kMsc3w2WhzwH573c3SM99ml
	 U844otOTOoTQgp1hY/7NdmdcOU4nLvV2Cuz3FanBroxCulGHuL9BJXzamMvHQLSMZB
	 Z7sKkUjDnd8OCuyHN18Oi1rMtYlQLM5WZATUPr0ft1Z4HB2H6fdF/3bnN4CVs3XNZn
	 2b0wx0ay85CUQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 23/25] docs: Document root namespace uAPI
Date: Sat, 21 Nov 2026 02:08:42 +0200
Message-ID: <20261121000844.1863324-24-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
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

Userspace container managers need a clear specification of rootns state
transitions, control ioctls, mount-tree construction, user namespace ID
mapping, credential rules, and process creation semantics.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections, ioctl descriptions, and system call reference from
kernel/rootns.c, kernel/user_namespace.c, include/uapi/linux/rootns.h,
include/uapi/linux/nsfs.h, fs/fsopen.c, and fs/namespace.c, and register
the rootns ioctl magic in ioctl-number.rst.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/rootns.rst        | 65 +++++++++++++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 Documentation/userspace-api/rootns.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..56d0ac4eb087 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -17,6 +17,7 @@ System calls
    :maxdepth: 1
 
    unshare
+   rootns
    futex2
    ebpf/index
    ioctl/index
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index dbe462040999..d8dc926ea283 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,7 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xB9  00-0F  uapi/linux/rootns.h                                       Root namespace uAPI
 0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                        <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
diff --git a/Documentation/userspace-api/rootns.rst b/Documentation/userspace-api/rootns.rst
new file mode 100644
index 000000000000..ef18ed59ba4a
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,65 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+Root namespace uAPI
+===================
+
+Overview
+========
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: Overview
+
+Flags
+=====
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :identifiers: rootns_flags
+
+Ioctls
+======
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_GET_NSFD
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :identifiers: rootns_wait_args
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_WAIT
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+   :doc: ROOTNS_KILL
+
+System calls
+============
+
+.. kernel-doc:: kernel/rootns.c
+   :identifiers: sys_rootns
+
+Process creation
+================
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: CLONE_INTO_ROOTNS
+
+Filesystem configuration
+========================
+
+.. kernel-doc:: fs/fsopen.c
+   :doc: FSCONFIG_SET_ROOTNS
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
+   :identifiers: userns_idmap_extent userns_idmap_flags userns_idmap
+
+.. kernel-doc:: kernel/user_namespace.c
+   :identifiers: sys_userns_set_idmap
-- 
2.47.3

