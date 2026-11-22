Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310319;
	b=cncYPy8OPnxwvFYUCIdgZflWmpXIiwwVCmmSKEwMPYOuW9PB59ZVcO1Eb3a87q7JGLAj
	 UpIXEvK115gnMSmUbbOPpF1KZGySRRJ+kZGddKb9bk4oo8Y8ocZVmFVfnFZ+yRDOVKQ1n
	 CCvtOwAS2aI/5TxNJ6k+492DEI0URm5Nz0/Y9gj3E7JRI1AEGUSpGTWHnn1Frh33glUaz
	 SOuoydBUeK7BwkyuOb7SBTUOXnIYhOlVSvAzVmd7jRA2IkHuaJ4Xr6d3TrnKfyUn0Hrxy
	 Ku6i+JAbCbxc+lTNZ9tGvAUjOymt2YClDV+a/gt76w07hWdDvyjOdNfY9Q6P+i9MYqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	b=hJpaQPOnIhtc32ozIvO45Ch7KLoTIFN09kyAzMvQZ9ItVADxd4CVSa/alK1morh4sR/j
	 CsWq8wrxvL2ITcrJU6T/liZ9/EyQ/05F/u+UaypUVRzHnCWQrmrlM1CLJ2W9KuD7p9fkH
	 0yJMUDAzwO5kQW15CmS7OEK+O2+e6wFLJFZXZ4YmzREAFBWU8W643oUfv6b2wrZ11yz7C
	 9L8C+jrAYCyz8sQw+QR4PXG4WiVPmmZr58RCcoC5qlL8uhf7/Gy2Bwc4H5BtXjxvBNREz
	 G4Tdt+zcy2jIDfpccyIwUyRDObhrlwV+W+ZACMCsQGFZT6CjCChD2fT9c+idMDVakEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kgP/2/6s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8D471606A330;
	Sun, 22 Nov 2026 01:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgP/2/6s
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4EEED1F000CF;
	Sun, 22 Nov 2026 01:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310319;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgP/2/6s7spLqnf+9wMSyz4rEEZTRyT+B+YkDBhkt50gtPY+vgrIGcVhtKCrkLRFD
	 0f2TJ3D7eb/66eUajBQSuTi/fbl8VRvUv25a5lt8QxW+oq/QqpzAMtr3BhPptZ0j5i
	 3kW5sabhvAZySVfrnN6bJyajveSB6ITeCvGTqK5veb2w1g2xbX4xKOGMMc4+GYvvr8
	 EMRR/HfWrBOhDIla3WYo95eeveTxI0eMLnSe03JMHIIvWFMZ8OIizWNrWwv+7r/z/D
	 KlSGsb410AtNh5e/TSaDB78vVeHXyRexH3UeeV5hcfhavPGsM91d/HPvOkbt6OMZDE
	 HiqUj0/wbi5cg==
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
Subject: [RFC PATCH v6 05/26] mount: Enforce mount_too_revealing() for foreign mntns
Date: Sun, 22 Nov 2026 03:17:48 +0200
Message-ID: <20261122011809.2667684-6-jarkko@kernel.org>
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

mount_too_revealing() skips visibility checks whenever
current->nsproxy->mnt_ns belongs to init_user_ns, assuming the caller
holds CAP_SYS_ADMIN in its current mount namespace. That assumption does
not hold when an unprivileged caller creates mounts for a child user
namespace while running in init_mnt_ns or another foreign mount
namespace.

Require CAP_SYS_ADMIN in init_user_ns before bypassing
mount_too_revealing() for init_mnt_ns, reject chrooted callers lacking
CAP_SYS_ADMIN in their current mount namespace, and treat existing
mounts and child overmounts in a foreign mount namespace as locked
during mnt_already_visible() checks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 781380945d78..b2dc84c0d0d6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6582,6 +6582,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 				const struct super_block *sb,
 				int *new_mnt_flags)
 {
+	bool foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
 	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
 
@@ -6606,11 +6607,16 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 			continue;
 
 		/* A local view of the mount flags */
-		mnt_flags = mnt->mnt.mnt_flags;
+		mnt_flags = READ_ONCE(mnt->mnt.mnt_flags);
 
 		/* Don't miss readonly hidden in the superblock flags */
 		if (sb_rdonly(mnt->mnt.mnt_sb))
 			mnt_flags |= MNT_LOCK_READONLY;
+		if (foreign_ns) {
+			if (mnt_flags & MNT_READONLY)
+				mnt_flags |= MNT_LOCK_READONLY;
+			mnt_flags |= MNT_LOCK_ATIME;
+		}
 
 		/* Verify the mount flags are equal to or more permissive
 		 * than the proposed new mount.
@@ -6629,7 +6635,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(child->mnt.mnt_flags & MNT_LOCKED))
+			if (!foreign_ns && !(READ_ONCE(child->mnt.mnt_flags) & MNT_LOCKED))
 				continue;
 			/* Is the directory permanently empty? */
 			if (!is_empty_dir_inode(inode))
@@ -6650,13 +6656,18 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	unsigned long s_iflags;
 
-	if (ns->user_ns == &init_user_ns)
-		return false;
-
 	/* Can this filesystem be too revealing? */
 	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
 		return false;
 
+	if (ns->user_ns == &init_user_ns &&
+	    ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+		return false;
+
+	if (!ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) &&
+	    current_chrooted())
+		return true;
+
 	s_iflags = sb->s_iflags;
 	if ((s_iflags & required_iflags) != required_iflags) {
 		WARN_ONCE(1, "Expected s_iflags to contain 0x%lx\n",
-- 
2.47.3

