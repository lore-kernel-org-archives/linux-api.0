Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376161;
	b=I/m/WknjkepquTHZzeigYfg3TxX3yHJGFeZfWf1fPwQLWNhCKsKr+E32Oo7UGqq4QW/T
	 a1F8fBZzwQnt/2Dfk+1mqjZXN8xadmAlIkhqLicWOm4/pNTAnXDwNoOFuHewaGTVYgWjR
	 tEMhkALAOzYh+RqGu9qR1msJyyoubRXP8sVr7CuKPPuNslN08qayV1z5BTRlUn/OOuMVh
	 Ipbx9lxEDBPF+0NOzjRv+dalwwHXdka3MBi2r+tC9cm35y3J/R0rajarHqWtGhpHscULz
	 x3yPOzXECz779wsn+Shs5CWicnWaDfcWHKGEjBU46yN/UwpiVrCgN5kKs4qfprSoAng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PxWsspzEioIIwUqnuiIeYKp1fTe5D8PzGx83Wd5XdHY=;
	b=uN4bDiJt4K/gBOp0Yn3/NndacLmnAE+IyoCelvck80qqMIZGAvvmyjvI8X88GN6rcruG
	 GRu2l5J0+29shwyprW+y2jRfMq83R80fA1GAQABpqRyC5EYBSCKenzGNOM8E+1MjsgALo
	 mdgmnk49UzvCAGa3JtAzCqzPkxOkuhReDQEpjgjiqfVddGOtZ82osQX3kVEVk1ylsz19M
	 MSkv/FXYiN30KJsLXbOfQaAqTu2EtgFnCPDWgUBHAe5Gnd2q8ImBS3zCjHQF3Hjto00dm
	 buovwfa83f7qkSZAhsBlb1ouPDfeGEAj/kkPU7Ia8zgByPmobEcXMcYcclxgmj3CcMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFiqTxJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 46200606A32C;
	Sun, 22 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFiqTxJB
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C697E1F000C0;
	Sun, 22 Nov 2026 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376160;
	bh=PxWsspzEioIIwUqnuiIeYKp1fTe5D8PzGx83Wd5XdHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFiqTxJBeq3OOH2VDJJY2sRb16klNa8m8RHt5Abh/YsPImOZ5nu0uM/UuMH+1ycLe
	 S+SXiQ9ZdkEJGKkPN8frshQVWuicTWsoG5qYiFtE16U0SbJ6N0d/pprgRSmcbMWB0L
	 0fc+vdB1MX5xOtwmvvCKQVbCxtNDWEr972W+bhnrLZB08bFuYj96P+xs8sX24UVzV5
	 vR6e0SgrDbPp5c3KER4nWHsM3H80dhGu3haKOn8CZtqET9eS+adDfRk0TJeYI2DcSh
	 DNDD/KxSNtFTnTtbxIpVpUpwPU2Jqbe3L0B6Jmlu7Ie34V9iCvX0vbkLcG4h/jk/TN
	 FUckdOsdfl/JQ==
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
Subject: [RFC PATCH v7 01/26] userns: Factor out idmap validation and commit helpers
Date: Sun, 22 Nov 2026 21:35:14 +0200
Message-ID: <20261122193539.3334213-2-jarkko@kernel.org>
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

map_write() and its permission helpers validate extent ranges, check
root and unprivileged self-mappings, translate parent ID ranges, sort
extents, and install the resulting map inline for procfs text writes,
preventing non-procfs callers from reusing the same validation and
commit path.

Extract idmap_maps_root(), unpriv_idmap_permitted(),
validate_and_insert_extent(), free_new_idmap(), resolve_new_idmap(), and
commit_new_idmap() with no functional change.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/user_namespace.c | 229 +++++++++++++++++++++-------------------
 1 file changed, 122 insertions(+), 107 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index cd748e1cbace..caba2ac33077 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -884,6 +884,22 @@ VISIBLE_IF_KUNIT int uid_gid_map_sort(struct uid_gid_map *map)
 }
 EXPORT_SYMBOL_IF_KUNIT(uid_gid_map_sort);
 
+static bool idmap_maps_root(const struct uid_gid_map *new_map)
+{
+	unsigned int idx;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		const struct uid_gid_extent *e;
+
+		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
+			e = &new_map->extent[idx];
+		else
+			e = &new_map->forward[idx];
+		if (e->lower_first == 0)
+			return true;
+	}
+	return false;
+}
 /**
  * verify_root_map() - check the uid 0 mapping
  * @file: idmapping file
@@ -900,22 +916,9 @@ static bool verify_root_map(const struct file *file,
 			    struct user_namespace *map_ns,
 			    struct uid_gid_map *new_map)
 {
-	int idx;
 	const struct user_namespace *file_ns = file->f_cred->user_ns;
-	struct uid_gid_extent *extent0 = NULL;
-
-	for (idx = 0; idx < new_map->nr_extents; idx++) {
-		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
-			extent0 = &new_map->extent[idx];
-		else
-			extent0 = &new_map->forward[idx];
-		if (extent0->lower_first == 0)
-			break;
-
-		extent0 = NULL;
-	}
 
-	if (!extent0)
+	if (!idmap_maps_root(new_map))
 		return true;
 
 	if (map_ns == file_ns) {
@@ -938,6 +941,103 @@ static bool verify_root_map(const struct file *file,
 	return true;
 }
 
+static int validate_and_insert_extent(struct uid_gid_map *new_map,
+				      struct uid_gid_extent *extent)
+{
+	if ((extent->first == (u32)-1) || (extent->lower_first == (u32)-1))
+		return -EINVAL;
+
+	if ((extent->first + extent->count) <= extent->first)
+		return -EINVAL;
+	if ((extent->lower_first + extent->count) <= extent->lower_first)
+		return -EINVAL;
+
+	if (mappings_overlap(new_map, extent))
+		return -EINVAL;
+
+	if (new_map->nr_extents >= UID_GID_MAP_MAX_EXTENTS)
+		return -EINVAL;
+
+	return uid_gid_map_insert_extent(new_map, extent);
+}
+
+static void free_new_idmap(struct uid_gid_map *new_map)
+{
+	if (new_map->nr_extents > UID_GID_MAP_MAX_BASE_EXTENTS) {
+		kfree(new_map->forward);
+		kfree(new_map->reverse);
+	}
+	memset(new_map, 0, sizeof(*new_map));
+}
+
+static int resolve_new_idmap(struct uid_gid_map *new_map,
+			     struct uid_gid_map *parent_map)
+{
+	unsigned int idx;
+
+	if (new_map->nr_extents == 0)
+		return -EINVAL;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		struct uid_gid_extent *e;
+		u32 lower_first;
+
+		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
+			e = &new_map->extent[idx];
+		else
+			e = &new_map->forward[idx];
+
+		lower_first = map_id_range_down(parent_map,
+						e->lower_first,
+						e->count);
+		if (lower_first == (u32)-1)
+			return -EPERM;
+
+		e->lower_first = lower_first;
+	}
+
+	return uid_gid_map_sort(new_map);
+}
+
+static void commit_new_idmap(struct uid_gid_map *map,
+			     struct uid_gid_map *new_map)
+{
+	if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS) {
+		memcpy(map->extent, new_map->extent,
+		       new_map->nr_extents * sizeof(new_map->extent[0]));
+	} else {
+		map->forward = new_map->forward;
+		map->reverse = new_map->reverse;
+	}
+	/*
+	 * Pairs with smp_rmb() in map_id_range_down(), map_id_range_up(),
+	 * and m_start().
+	 */
+	smp_wmb();
+	map->nr_extents = new_map->nr_extents;
+	memset(new_map, 0, sizeof(*new_map));
+}
+
+static bool unpriv_idmap_permitted(const struct user_namespace *ns,
+				   const struct cred *cred, int cap_setid,
+				   unsigned long ns_flags,
+				   const struct uid_gid_map *new_map)
+{
+	u32 id;
+
+	if (new_map->nr_extents != 1 || new_map->extent[0].count != 1 ||
+	    !uid_eq(ns->owner, cred->euid))
+		return false;
+
+	id = new_map->extent[0].lower_first;
+	if (cap_setid == CAP_SETUID)
+		return uid_eq(make_kuid(ns->parent, id), cred->euid);
+	if (cap_setid == CAP_SETGID)
+		return !(ns_flags & USERNS_SETGROUPS_ALLOWED) &&
+		       gid_eq(make_kgid(ns->parent, id), cred->egid);
+	return false;
+}
+
 /*
  * Parse the decimal u32 at *pos, up to the next whitespace or NUL, and
  * leave *pos pointing at that character.
@@ -966,8 +1066,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *map_ns = seq->private;
-	struct uid_gid_map new_map;
-	unsigned idx;
+	struct uid_gid_map new_map = {};
 	struct uid_gid_extent extent;
 	char *kbuf, *pos, *next_line;
 	ssize_t ret;
@@ -1002,8 +1101,6 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 */
 	mutex_lock(&userns_state_mutex);
 
-	memset(&new_map, 0, sizeof(struct uid_gid_map));
-
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
 	if (map->nr_extents != 0)
@@ -1052,98 +1149,28 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 		if (*pos != '\0')
 			goto out;
 
-		/* Verify we have been given valid starting values */
-		if ((extent.first == (u32) -1) ||
-		    (extent.lower_first == (u32) -1))
-			goto out;
-
-		/* Verify count is not zero and does not cause the
-		 * extent to wrap
-		 */
-		if ((extent.first + extent.count) <= extent.first)
-			goto out;
-		if ((extent.lower_first + extent.count) <=
-		     extent.lower_first)
-			goto out;
-
-		/* Do the ranges in extent overlap any previous extents? */
-		if (mappings_overlap(&new_map, &extent))
-			goto out;
-
-		if ((new_map.nr_extents + 1) == UID_GID_MAP_MAX_EXTENTS &&
-		    (next_line != NULL))
-			goto out;
-
-		ret = uid_gid_map_insert_extent(&new_map, &extent);
+		ret = validate_and_insert_extent(&new_map, &extent);
 		if (ret < 0)
 			goto out;
 		ret = -EINVAL;
 	}
-	/* Be very certain the new map actually exists */
+
 	if (new_map.nr_extents == 0)
 		goto out;
 
 	ret = -EPERM;
-	/* Validate the user is allowed to use user id's mapped to. */
 	if (!new_idmap_permitted(file, map_ns, cap_setid, &new_map))
 		goto out;
 
-	ret = -EPERM;
-	/* Map the lower ids from the parent user namespace to the
-	 * kernel global id space.
-	 */
-	for (idx = 0; idx < new_map.nr_extents; idx++) {
-		struct uid_gid_extent *e;
-		u32 lower_first;
-
-		if (new_map.nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
-			e = &new_map.extent[idx];
-		else
-			e = &new_map.forward[idx];
-
-		lower_first = map_id_range_down(parent_map,
-						e->lower_first,
-						e->count);
-
-		/* Fail if we can not map the specified extent to
-		 * the kernel global id space.
-		 */
-		if (lower_first == (u32) -1)
-			goto out;
-
-		e->lower_first = lower_first;
-	}
-
-	/*
-	 * If we want to use binary search for lookup, this clones the extent
-	 * array and sorts both copies.
-	 */
-	ret = uid_gid_map_sort(&new_map);
+	ret = resolve_new_idmap(&new_map, parent_map);
 	if (ret < 0)
 		goto out;
 
-	/* Install the map */
-	if (new_map.nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS) {
-		memcpy(map->extent, new_map.extent,
-		       new_map.nr_extents * sizeof(new_map.extent[0]));
-	} else {
-		map->forward = new_map.forward;
-		map->reverse = new_map.reverse;
-	}
-	smp_wmb();
-	map->nr_extents = new_map.nr_extents;
-
+	commit_new_idmap(map, &new_map);
 	*ppos = count;
 	ret = count;
 out:
-	if (ret < 0 && new_map.nr_extents > UID_GID_MAP_MAX_BASE_EXTENTS) {
-		kfree(new_map.forward);
-		kfree(new_map.reverse);
-		map->forward = NULL;
-		map->reverse = NULL;
-		map->nr_extents = 0;
-	}
-
+	free_new_idmap(&new_map);
 	mutex_unlock(&userns_state_mutex);
 	kfree(kbuf);
 	return ret;
@@ -1213,20 +1240,8 @@ static bool new_idmap_permitted(const struct file *file,
 	/* Don't allow mappings that would allow anything that wouldn't
 	 * be allowed without the establishment of unprivileged mappings.
 	 */
-	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
-	    uid_eq(ns->owner, cred->euid)) {
-		u32 id = new_map->extent[0].lower_first;
-		if (cap_setid == CAP_SETUID) {
-			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, cred->euid))
-				return true;
-		} else if (cap_setid == CAP_SETGID) {
-			kgid_t gid = make_kgid(ns->parent, id);
-			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
-			    gid_eq(gid, cred->egid))
-				return true;
-		}
-	}
+	if (unpriv_idmap_permitted(ns, cred, cap_setid, ns->flags, new_map))
+		return true;
 
 	/* Allow anyone to set a mapping that doesn't require privilege */
 	if (!cap_valid(cap_setid))
-- 
2.47.3

