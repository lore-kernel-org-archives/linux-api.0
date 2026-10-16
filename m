Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64A837755A
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161444; cv=none; b=IfFFu1I72SduOzGIGEzX/XUNDcrqst0R3YaPLeP+aZebTCygkWaaKZdxsB2JlBNABPbxZcCwwlg1kQhWl+1HVWtgGN2sQ2XfqJ6RBX6mQeqeTl7dI7YHzYq3sKzZSxbVg6mrcmuHrzkz7Og50wMzkPve3Yie1szBhjsCogJiNmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161444; c=relaxed/simple;
	bh=db3t3SLMaE5wUMdZy9nxNXDoVE66uYdw2Xc3Fqc26UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Ck7ngcOnhWXGZlK7Lo0FS6LdhUfULI8dSdh/1WFfOtz1Rkwm8PELmjwCDSiUw7/dBepUcwYEJ5m3nzqEYq92j7MTMbylP4aKOruJtMJ4wpt4KQ6ViYOcfFVLBLdmCQ1dS6uxLkGV4N+CP9LgzfMg7Bno9pGVzo6ykZIW36jSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=n3CyEnHV; arc=none smtp.client-ip=195.121.94.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="n3CyEnHV"
X-KPN-MessageId: 146e1159-c96f-11f1-9e93-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 146e1159-c96f-11f1-9e93-005056999439;
	Fri, 16 Oct 2026 16:37:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=D3EEWYYkwC8DyARDmtg/iTxbMv+cBjwnGlGgHxIhuRY=;
	b=n3CyEnHVoEIj2aRCkMXnA2cZ6PlSJCBQDr/HhWg/OOmf/iLwZBqKAPs1BcY6+a0z76oa3LM8x3cxr
	 8+tTUCcr12lN/70Rt3P00FeeY1Fk1kEqWJAvVjQ6iCRP1E6zkGlLsMSaP06Tbi2WSGqQ1np40kkit/
	 trtRPZXBuI9wyo4NegzaaCy9u06vKMQQqzPNFp4ja27D9TCgHTO8vThgpVlG/9GDVooUioqXAbPLcz
	 lIaIp1kSvxj3Vx4MowbVSdunvcpAp+UEpern4by3kBPLfJJVMpfSg4LwcoPWh0kDnimxvZws5t2wEW
	 y6amwSiYhtoWB2jSgTS00lUfg1HVeLQ==
X-KPN-MID: 33|3f2O/EKeGRHyCsYzof/BZFSZ18lEhlVz2DSJJ4Cef49cTBQLCeTY9QrJYqEtpeA
 +0AuSPdRLaI5AUocD86OTK25X6OompI9duRV6DPyQZ+I=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|MBu+FYC3YOBbhhyJF65R8mWgB32WSLOsRiu/ufWj0cMOnp2dyryktJfwDcgZQ0X
 L4VVUv41+D4HOUU5fOW96uA==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 142b6dc5-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:14 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>
Subject: [PATCH v7 07/12] kernfs: hold kernfs_iattr_rwsem when initializing a new inode
Date: Fri, 16 Oct 2026 16:38:01 +0200
Message-ID: <20261016143806.2946578-8-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
References: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kernfs_refresh_inode() copies the uid, gid, timestamps and nlink of a
kernfs_node into its VFS inode. Since commit 9caf69614225 ("kernfs:
Introduce separate rwsem to protect inode attributes.") these are
protected by kernfs_iattr_rwsem.

kernfs_init_inode() calls kernfs_refresh_inode(), but was not converted.
Its callers in turn hold kernfs_rwsem (kernfs_iop_lookup(),
kernfs_fill_super()) or no lock at all (__kernfs_fh_to_dentry()),
neither of which excludes a concurrent
kernfs_setattr()/kernfs_iop_setattr().

Take kernfs_iattr_rwsem for reading around the refresh in
kernfs_init_inode(). This nests inside kernfs_rwsem, which matches
kernfs_link_sibling() and kernfs_unlink_sibling().

Also, kernfs_get_inode() then does not need to hold kernfs_rwsem, so
drop it from kernfs_fill_super().

Fixes: 9caf69614225 ("kernfs: Introduce separate rwsem to protect inode attributes.")
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/kernfs/inode.c | 3 ++-
 fs/kernfs/mount.c | 3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index abb286bc3474..83f2007498db 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -204,7 +204,8 @@ static void kernfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	inode->i_generation = kernfs_gen(kn);
 
 	set_default_inode_attr(inode, kn->mode);
-	kernfs_refresh_inode(kn, inode);
+	scoped_guard(rwsem_read, &kernfs_root(kn)->kernfs_iattr_rwsem)
+		kernfs_refresh_inode(kn, inode);
 
 	/* initialize inode according to type */
 	switch (kernfs_type(kn)) {
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index a57399021c8b..202a5ca2bd34 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -283,7 +283,6 @@ struct dentry *kernfs_node_dentry(struct kernfs_node *kn,
 static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *kfc)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
-	struct kernfs_root *kf_root = kfc->root;
 	struct inode *inode;
 	struct dentry *root;
 
@@ -304,9 +303,7 @@ static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *k
 	sb->s_shrink->seeks = 0;
 
 	/* get root inode, initialize and unlock it */
-	down_read(&kf_root->kernfs_rwsem);
 	inode = kernfs_get_inode(sb, info->root->kn);
-	up_read(&kf_root->kernfs_rwsem);
 	if (!inode) {
 		pr_debug("kernfs: could not get root inode\n");
 		return -ENOMEM;
-- 
2.56.0

