Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310392;
	b=BfwqFK6oSNpBnLvV6BNgP12TQPu72vwzTqbUo/asmOBoQE1nkwDXJ0jdkPvpyZEdB70F
	 AhDm5ep5U905DQnw5GnMjaN0B8MhCWKA4WPuQJDQV2bwLYltt/GGqxhHX8G3TFMlFDSxw
	 D68LOSSwi53CashxRPbFJB2A7rjepBbgYfsyqiCKETAwjdZvNWsAUVMAMq6LgXuvai4IQ
	 ueXyCfUB2AkFBiQ5fqtUUNAgoXiEtKDLQGjsHpw+IDrU4R0X7gktAOr4rSVhVTPVkqWbs
	 Fx6HONQpVDmXi4gFO0haQjvxM/QFJUV54Uc2VEvwLKCGO4li4F4waM/6CZ47OyIWfVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TIPgrr20qThME/B4ztDpobgpWXK7j1eqlzMAWRvKnKw=;
	b=x8HptYFFnXixTxYTs7MFp1nzoVfTFYz8mvgoRp3XL/7hCS42G1DJQ/IqcmMYJfzI6922
	 yIdFVLc2+Q7GInIrd35Z9W+7hK/9BVxkBIJXFWHngryvjbAv43HNEx7ReRxozvSUsRgoC
	 uu7mksrox0S8XJF7yXMtdzLgbh8a6z0l9P0Qd3K78NPziCn5XCsgfG2Gr3EqgrS1Yyp/K
	 tTaJWhULik76C8+zZSpRswTzsDxipaGsjDxNb6WEwA+J/5jZjnJfYp98iH8hRalCyEWgY
	 WDd3sGiih4+mVsnRjsZa+hq2MRwgff0fkwbpqX5StYZiG+5/b+99K9ojoteOVmbfSNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1VCve+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A03B9606A33A;
	Sun, 22 Nov 2026 01:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1VCve+e
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CBB691F000D4;
	Sun, 22 Nov 2026 01:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310392;
	bh=TIPgrr20qThME/B4ztDpobgpWXK7j1eqlzMAWRvKnKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1VCve+erKOf45/nIxWvFWNngkecpsxl7xxxliFmPo0svHbR1reuTxcspUj4s/hX0
	 UsYnqTPk4NKr5TyNC8uv7wdlSLg3zEo9e8ht3OR6iahdbYJp0N+VsCKiolgjce3Ysq
	 vcyawplXD7pDeiX1T0PpqIdDBVeKfMhBkaBwUTRg5R7ZHMmN20UHRPqHslC97Co3XW
	 AeZFVs7/lzF1J/ofM2ldo19SQhhIZz1b8A6JXkBqdIcu4GLeXKojiP5Fz+zI29Rjtn
	 Yd5itrChtNLuQUuEDcuS0mS147TQVZzwchaveJO9UfUN5HkrxfUJ4F7PuP/AboFsF+
	 t1u5NWkPCndfw==
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
Subject: [RFC PATCH v6 24/26] docs: Document userland uAPI
Date: Sun, 22 Nov 2026 03:18:07 +0200
Message-ID: <20261122011809.2667684-25-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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

Add Documentation/userspace-api/userland.rst to include the kernel-doc
sections, ioctl descriptions, and system call reference from
kernel/userland.c, kernel/user_namespace.c,
include/uapi/linux/userland.h, include/uapi/linux/nsfs.h, fs/fsopen.c,
and fs/namespace.c, and register the userland ioctl magic in
ioctl-number.rst.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst         |  1 +
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 Documentation/userspace-api/userland.rst      | 73 +++++++++++++++++++
 3 files changed, 75 insertions(+)
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
index 000000000000..47d5c39ccb1c
--- /dev/null
+++ b/Documentation/userspace-api/userland.rst
@@ -0,0 +1,73 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+userland uAPI
+=============
+
+Overview
+========
+
+A userland is an anonymous-inode control object opened by ``userland_open()`` (not
+an ``nsfs`` namespace) that binds a detached namespace set, an initially empty
+mount namespace, an owning user namespace, and an init process lifecycle across
+build (``USERLAND_INIT``) and live (``USERLAND_RUNNING`` / ``USERLAND_DEAD``) phases.
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

