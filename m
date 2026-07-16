Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ED642DA3C;
	Thu, 16 Jul 2026 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212452; cv=pass; b=MXKzY8KivUJAF3BY1o38DOcJ5PKWF74qG3/8E1uoMbrX9zxGN71rNqY7QgqMXYzvOwcKO4Ea8PxKTNa1TqMjyz4I5qXo6kX+WwJonwO4IRZX70NdFzrzs/zazNC9nmw8LOVBRNq09byQ7YZFnp1Z+2+7Q+fWAxnSv86vSYgCFLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212452; c=relaxed/simple;
	bh=N1/em5uG7PZ+OUMGS73vWLd7r1zEBl6ddjpVkRYH5pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1GZ7MAfsiwD8dgPgZSgyEcNHVzkm+ECBwUx/i8OYVKhW7yXOM10t3bfk9j8fUGsJVGaDr099/JDfafj8NIV+AbTr9fss/67vXtnVNZkrlGlFGtmttiBbGnDmg3amVKTFO9kZy5TGRqPocJ8X8OYzMyi8/P1cDE+mH4hPs7nuDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=QQNQb9T4; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="QQNQb9T4"
ARC-Seal: i=1; a=rsa-sha256; t=1784212356; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nonvSaIyCSTzbD9P3g5e1pzJYnJYHF8DJ0MfQLtZOfsLzYLfKeUKLqdaYAGqKyKQCIj+eZP3k2jMi/So92N8phqovTBI+z4z9xqlhMl+yP1MatS6eoc0j6bl3r0Bc/Tjt7Rf4UQZUTRhFP7w0BMTLA9OI/gv9BJh6qwQuZBhTVc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212356; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=u8MPSkeEXoEUBttnnhXtqn7icL18NVEhqR4kh84n23M=; 
	b=lQ4ol/fovBU1oPUkcYPEN6VJlz5o0ubYZEwslFVcPvux/9AZzgfW68+gc2NZ5NlWBj3WKdykuhuNrSz3vQ4WPJibfQ3wOZbvC3LjLtRnBPfKYTvx68RS6A6Khcenx8wmnJaBOOq/DxM0VZ64nV8RQuZCSfnwaoPFcI9Bwj4hOm4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212356;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=u8MPSkeEXoEUBttnnhXtqn7icL18NVEhqR4kh84n23M=;
	b=QQNQb9T47bra1c/5bj2A9ONcpperFj01d9a8pitGmBE0QFlPgiLmwBBI3+pw8Nw9
	tJ5qeRwA2nOA5wvT+nxm5hJa7R1OZdPkgQTsJUkgYdgqHVLW3d14RmFtGyg64OSlOHH
	QRvUwsmOiMZ87zD89hU7Tqb458YXmMBE73k5IHak=
Received: by mx.zohomail.com with SMTPS id 1784212353185462.13311224881875;
	Thu, 16 Jul 2026 07:32:33 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 02/24] libfs: allow custom validation of stashed inode data
Date: Thu, 16 Jul 2026 22:31:28 +0800
Message-ID: <32a639e0eed4fce9c68424748e46ec3b8f575b38.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

path_from_stashed() assumes that inode->i_private is identical to the
caller data used to find or create a dentry. That is too strict for an
inode whose stable identity can later resolve through another object.

Add an optional data_matches() callback to stashed_operations. Existing
users retain the pointer-identity check when no callback is provided.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/internal.h | 1 +
 fs/libfs.c    | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 174f063575558..71cc43e72b33e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -334,6 +334,7 @@ struct stashed_operations {
 				       struct dentry *dentry);
 	void (*put_data)(void *data);
 	int (*init_inode)(struct inode *inode, void *data);
+	bool (*data_matches)(const struct inode *inode, const void *data);
 };
 int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 		      struct path *path);
diff --git a/fs/libfs.c b/fs/libfs.c
index 5a0d276379d13..68cc1671b4699 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2260,7 +2260,10 @@ int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 	path->dentry = res;
 	path->mnt = mntget(mnt);
 	VFS_WARN_ON_ONCE(path->dentry->d_fsdata != stashed);
-	VFS_WARN_ON_ONCE(d_inode(path->dentry)->i_private != data);
+	if (sops->data_matches)
+		VFS_WARN_ON_ONCE(!sops->data_matches(d_inode(path->dentry), data));
+	else
+		VFS_WARN_ON_ONCE(d_inode(path->dentry)->i_private != data);
 	return 0;
 }
 
-- 
2.52.0

