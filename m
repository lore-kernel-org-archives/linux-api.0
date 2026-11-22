Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310303;
	b=uOD4aw9V+8vwcGbkv83hmrcrn49D+fz5OxxFkf73zKUA5gzqvEe6ZKoyBR5MMwmoi8aO
	 ErKiszlu41HvFoD366+6YyR2YXh0eGZHRjtIX3Luu1+YW+61VkLzJU+NiBcJQyD2/5qD+
	 E7RhmKiqiFkGyf0TCGtEsy1mkJqt6XLfH3OKDIx14EuBYorQa7u2fL22II0vAzef1UQmL
	 3poCkIs8AjZxQ1TQEUXQxDODGOXJxzsT3G+JBkRLOb8xULZryheEEJrg47RyjmfFy4oHs
	 2/7KucqGYxdzjmeJxWhGQ2BpQDyWK7Ont/5WMakKzvZfJsNR0c6PYDZRZpjnx3ZlpFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HMiFFGmw0v9nxAge20cDn397wiErWOHZ9jOEttk4raU=;
	b=xafJ4zx6oGoGCvrJT09P7toy1SehiELXx55PNc9B2RIh9QuRx6Xv06faISncLGoOJPQz
	 Djs4DDL5SG1eZ2H0odV5bSF122yhUBJhuazhuvb9hv0bT6Ul5BTSvJogBhTFpjP6BqaX3
	 wAM4AWCYXJ4qTXhqpbOhH2xAj7BIT/pcnmK5iE8QTeaa41RhzD/271atwoBZOyZMv4gcR
	 GEorMheGS/brhn4pFZqbVeLAOWblmjsU81kZFiOUfuncVIrK/mwwW4EEhJZByQuqfuWji
	 qEtl8kD6An1bkwj+IbbLVWHCGqohsQBV3B7EMve+x8CF+mhBL49Ol3WwQVKjZqC8iCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+j1UvVg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C6C5E606A337;
	Sun, 22 Nov 2026 01:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+j1UvVg
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C33471F000D8;
	Sun, 22 Nov 2026 01:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310303;
	bh=HMiFFGmw0v9nxAge20cDn397wiErWOHZ9jOEttk4raU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+j1UvVgDWtOAPt8XWSNPgtEmRheZe6p/Zxa5yvM0BnC7U/nigoPkIixtcmaJImOi
	 3bKXBQ3MOJIzEnifXGq/e4j6MycalZFXvzccUFfqe9dI1TGndLSr5PGcnFIe8Jje/c
	 Q45wK8DaPan0bFAhyCLTJ/VugRrIdKTx7SsBmubhLWb71wBhFL+FmC770a6SWMn0p7
	 rb7BVXLInShRYT1vDUWHFaI4l9Zhn+nYRWiuTjtW7hVb3sLAee7jcAxJ9Dsg14rE2M
	 cYT2ig/iuchjBheqZ2yuUXfTO8JDZcnPGiCXGoh2ZP8TLIoxv2Uv3+q/r0KUsU+iO4
	 JD2osQs1N+zog==
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
Subject: [RFC PATCH v6 01/26] userns: Factor out idmap validation and commit helpers
Date: Sun, 22 Nov 2026 03:17:44 +0200
Message-ID: <20261122011809.2667684-2-jarkko@kernel.org>
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

map_write() validates extent ranges, translates parent ID ranges, sorts
extents, and installs the resulting map inline for procfs text writes,
preventing non-procfs callers from reusing the same validation and
commit path.

Extract validate_and_insert_extent(), free_new_idmap(),
resolve_new_idmap(), and commit_new_idmap() out of map_write() with no
functional change.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/user_namespace.c | 159 ++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 79 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index cd748e1cbace..6b9673dcdc67 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -938,6 +938,80 @@ static bool verify_root_map(const struct file *file,
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
+	/* Pairs with smp_rmb() in map_id_range_down() / map_id_up(). */
+	smp_wmb();
+	map->nr_extents = new_map->nr_extents;
+	memset(new_map, 0, sizeof(*new_map));
+}
+
 /*
  * Parse the decimal u32 at *pos, up to the next whitespace or NUL, and
  * leave *pos pointing at that character.
@@ -966,8 +1040,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *map_ns = seq->private;
-	struct uid_gid_map new_map;
-	unsigned idx;
+	struct uid_gid_map new_map = {};
 	struct uid_gid_extent extent;
 	char *kbuf, *pos, *next_line;
 	ssize_t ret;
@@ -1002,8 +1075,6 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 */
 	mutex_lock(&userns_state_mutex);
 
-	memset(&new_map, 0, sizeof(struct uid_gid_map));
-
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
 	if (map->nr_extents != 0)
@@ -1052,98 +1123,28 @@ static ssize_t map_write(struct file *file, const char __user *buf,
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
-- 
2.47.3

