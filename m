Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219756;
	b=Vcl0s/TxsW02pAMm4bskhetYN8IkrgzSwzvWoheuqzNH6cTlgFtrpeIMr8mY+0JHuIO4
	 QYuGsrov4QkDlDfePkOJsmgA7lAdOpr4RhHNcuht+ayWOvS3HtyvhZdFLLVK1rtBiW+FE
	 1FKYtTDk046ofMlEnNZHsnRhTOp0RNhs3V76zucNhU2yVEeA2otCjH37l53ExHrRuHk5C
	 xIuuTVPOsYe/FWnBzHKVSkWXc3nZej3Ki9F0/naZpvoCJU+bynORuxGl/Z69JYZ8GOkWd
	 GLTFXBFecJMWQcxu5pxoP+iOjldUfZ2Jktl+e7uj6buViOfQT2rZ2rbSiMRpuziN0Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	b=OWLDCHnokASgnYDYROSOvaJTicRasXJxFR+dTadEKqZkzFJMmXNFbbibFxhDCn9KWDhh
	 l0EfHPiE0dpQqCzKYy3b+4IXW/1GSOhY9kgFDiCFDcbZb/FfiwBrNYxZyIRgc2bg0F1iE
	 dfJn/TLyCukJzq8pdw/YV3R8rOMC7sOY3HVUh/IFQqmyYJUmAKPS44sBURzT13oRzML3I
	 N4GaDGc1fP5LbGIEYekyYquQwbCFh6C4kGsWNXUH6kD1QN0KOx59TTeY3LumLMFX6iQUT
	 lmpmtcplqnBHyGypkPFk87EZjFn/SOOtQvsXERaOebbv9D7lFHmuCsc8ZKtaQHLpKfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6eFWkLN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9491F606A688;
	Sat, 21 Nov 2026 00:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6eFWkLN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CF171F00A3D;
	Sat, 21 Nov 2026 00:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219756;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6eFWkLNbxYCdzsPwOHpyhJa3fnhM106kVy1noUevOAjD4VRTNpQprlWqpZx0fk9F
	 fPF3K1sj4lenh8sHolhHTqIM36IyPEf7cGQaODb5Y53NPblxs29R7VON//kvE2qbEM
	 wuHini2ovvVt2ou18JLHSOqfANgPURVWLcJYlVH4INaiuK/4LLRT5vgtkoxte5VySt
	 uv6RrE3r94o1hWJa+cPjqvsAuL9r+veLWGak6PzpxNj1rZ/bjsM88K8eeetMSJh9YM
	 vLhBUKAbIqBW4k2jHWIO76idMrVIlAHOeHbBjv3v6XSHe54WGSo4QcA1pSR9LfCA3/
	 sPQCkmMFn0LvQ==
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
Subject: [RFC PATCH v5 05/25] mount: Enforce mount_too_revealing() for foreign mntns
Date: Sat, 21 Nov 2026 02:08:24 +0200
Message-ID: <20261121000844.1863324-6-jarkko@kernel.org>
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

