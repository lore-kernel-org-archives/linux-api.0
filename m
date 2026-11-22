Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376178;
	b=cfZ5VP5YrDl5rvD7i1OnKCmrAzK2ElSvta4uR8TkAlo74jFT736GBEJlMaDLtcIDSNe7
	 V91GF+L6YCMu270p2qYWeSa02auv4W/gfBQ5oSgXWN1eWcCm5wA5mVkslaPY5WQNo19pZ
	 8+sKG3NKkzCYo6YADFueMDZb5g7qBDnxB/YULTckAatXfSOge1mIoTEr9sVM2Ry50zqI2
	 aLYXJADbPb4HHehMgo1LRWr742p0fE+QS3QJ8CPx4ZY1PFnNCC8RMHu6qXdgoEHg46CPU
	 lgNa9TiK45eLxB92jbWM31rLSMf1lktqlgkc+RhJihxTsWZ+XJj/vPSOj6KuKe+DvJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=l3BxF7eKc8H9WX2SeKI00rPkbSvVT1UJBee/DhqmTQQ=;
	b=vmDTZwG+RhcSQKOw8TIXiezwWtR7qcjeWdVLqcFxx4IX6zHW/hUqiJJh/n09m7Ar1f0l
	 LnZDwzfHiaS1O+t7KFXr6cInCHZ4Z7cfygy5202px2RvBmzobwFTCHTOTymK1M57RAxb2
	 x8AIKO6kWvfrebzx4MR2Zfg6KmxMsr1kXpkqo//zVNykhSdK+NcamVjAisr3UjWf6tGZ6
	 fLv1/WNyDhxhQmS8Tv3JOoF8Vrggp7sgOnLAmKxc0iB6ep0sIRW4BE/vNbpMU8tnRUFCD
	 VeyhlvPYkiudhsTxSFKkCLXhVCP9v5scLSBN/nD3HQxTJQlvvd5MWfSy/3OapS2x9JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="T28tb/dn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2C522606A320;
	Sun, 22 Nov 2026 19:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T28tb/dn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 09FC71F000EB;
	Sun, 22 Nov 2026 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376177;
	bh=l3BxF7eKc8H9WX2SeKI00rPkbSvVT1UJBee/DhqmTQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T28tb/dnYShrqpGI2ZILYjzh72RVEHrrezyrm54oR6Obd86v3PTs376d9kZmGiJB+
	 MUaqau3YQxX+z/GWr+9RG0JDb6bK1vqUMm9l/H8m/RqGDXDxO5ShNJ6WPrcOKQFN72
	 Lp2v8MzuVi6Nq52IkFkGidmWcugTYAZverSueVjAgR2lsfg4eHz5f+C9qJscWQmP91
	 UvSv7pZiNTWpbNmSdj6YKT2dG8l982i7je4+oLgBuBdSEu85qs20Ob4lOnj9/OCG2z
	 aSfS6cai0B+r+urHqmyerKvW0s6us7upbOBQhpzjuP6094eRFGxT0XybG4NqwQpfnw
	 74hvHOnQ9kYMw==
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
Subject: [RFC PATCH v7 05/26] mount: Enforce mount_too_revealing() for foreign mntns
Date: Sun, 22 Nov 2026 21:35:18 +0200
Message-ID: <20261122193539.3334213-6-jarkko@kernel.org>
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
 fs/namespace.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 781380945d78..1bb9f90a6523 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6580,7 +6580,7 @@ bool current_chrooted(void)
 
 static bool mnt_already_visible(struct mnt_namespace *ns,
 				const struct super_block *sb,
-				int *new_mnt_flags)
+				int *new_mnt_flags, bool foreign_ns)
 {
 	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
@@ -6606,11 +6606,16 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
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
@@ -6629,7 +6634,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(child->mnt.mnt_flags & MNT_LOCKED))
+			if (!foreign_ns && !(READ_ONCE(child->mnt.mnt_flags) & MNT_LOCKED))
 				continue;
 			/* Is the directory permanently empty? */
 			if (!is_empty_dir_inode(inode))
@@ -6649,14 +6654,19 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	const unsigned long required_iflags = SB_I_NOEXEC | SB_I_NODEV;
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	unsigned long s_iflags;
-
-	if (ns->user_ns == &init_user_ns)
-		return false;
+	bool foreign_ns;
 
 	/* Can this filesystem be too revealing? */
 	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
 		return false;
 
+	foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
+	if (ns->user_ns == &init_user_ns && !foreign_ns)
+		return false;
+
+	if (foreign_ns && current_chrooted())
+		return true;
+
 	s_iflags = sb->s_iflags;
 	if ((s_iflags & required_iflags) != required_iflags) {
 		WARN_ONCE(1, "Expected s_iflags to contain 0x%lx\n",
@@ -6671,7 +6681,7 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	if (s_iflags & SB_I_RESTRICTED_VARIANT)
 		return false;
 
-	return !mnt_already_visible(ns, sb, new_mnt_flags);
+	return !mnt_already_visible(ns, sb, new_mnt_flags, foreign_ns);
 }
 
 bool mnt_may_suid(struct vfsmount *mnt)
-- 
2.47.3

