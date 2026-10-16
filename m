Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A803E40E3
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161428; cv=none; b=NJox+Ar4WAhdbi9yiax3nqil73E5QHxJljzAma0SN4ylUTKAXz7mp6rnD9SpqwZjHuf/jPb1EG5pHBJBmVmEBzX3QIHQhcR/NpfXy+2+cDPV6qIaXa/NVpulk0mPbdikgSE2oOHTwEMNlVYpucAPnlraO/VHVJKVNVZikiMFkgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161428; c=relaxed/simple;
	bh=wwls92PitzLmDhbKssKKIVWrw2H8a8z4bnHLZa+rdMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5EZDRzlikC0iQLCwjG5KPkWWOlYnYKAU0mI4vRhMie/x8lcTqTAC5Ft+/8M3zZ9QoiL/VA59MZhsFIiRT7kHwA6LyxSz//XZH3+DcBycNesGCaIinJlMGMj09hWFSf85FsIvUGxPkyP4nnadqVm1ifReGF/dohxIw+3oGHbiEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=dzika6LT; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="dzika6LT"
X-KPN-MessageId: 090f8e1f-c96f-11f1-bfc1-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 090f8e1f-c96f-11f1-bfc1-00505699b430;
	Fri, 16 Oct 2026 16:36:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=rzTiTkvseb0XHWvj+0sWDRmMWlm2vYd7SdITT0Nc0O0=;
	b=dzika6LTS9lQMctq+NWvGksyDhCdGT13QXkLmU/XTGvglXUp/CiwqdNU4/JVfE+stqdMxPeQ3AeOf
	 VoVz89CxjPG2UinHquHBX9OuiQA1cQhHNwv2ASxEtO2GRozJ7bTrxa2cpbRxAlll4INSxHJPN4SaHs
	 EsrAZfcMdCFyALipDrWcZrDdPCOo7Ij/OzO/cMJvdZp2TRIdtgxXzYWTlNHytEa8amttF5OlgLiR2c
	 I1NURbyiq3dMrtsnaa1JiXEpgsorNIhpgMIeOkmCXCikd5BQWSoZnLhZwve3VDSGXJ3cwLq06QFzpq
	 UTmZMynfEKafArYN26CiOsbAAsbrixA==
X-KPN-MID: 33|X0ViaWWBENgXXh7BgleSwB+IIWrZgrEil+2ZrpJqyEtQ7vDN8j53ecFlVoJAeHI
 Aca6UBmrsj6D9iJkJ1kwbKULyVxvpm8Kzj1IIac5ogHo=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|x56zy5WImxZoRdPvOXX1zd7ltVaNatg3DKe1ebeDjOJY5ibnvskIg3c1HmeVuMl
 3ZL5+qPOa84vbxCk5Z3vIhg==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 08cb7528-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:36:55 +0200 (CEST)
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
Subject: [PATCH v7 01/12] fs/namei.c: use trailing_slashes()
Date: Fri, 16 Oct 2026 16:37:55 +0200
Message-ID: <20261016143806.2946578-2-jkoolstra@xs4all.nl>
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

There are several places in fs/namei.c that can use the
trailing_slashes() function to improve context. To allow this broader
use its signature is changed to take a struct qstr instead of a struct
nameidata.

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c87c14ee1a25..839258260ad5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2810,9 +2810,16 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	return s;
 }
 
+static inline bool trailing_slashes(const struct qstr *last)
+{
+	/* last->len is set by hash_name() to the length of the current
+	 * component ->name, terminating with '/' or a NUL character. */
+	return (bool)last->name[last->len];
+}
+
 static inline const char *lookup_last(struct nameidata *nd)
 {
-	if (nd->last_type == LAST_NORM && nd->last.name[nd->last.len])
+	if (nd->last_type == LAST_NORM && trailing_slashes(&nd->last))
 		nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 
 	return walk_component(nd, WALK_TRAILING);
@@ -4724,17 +4731,12 @@ struct file *vfs_lookup_open(struct path *parent, struct qstr *last,
 }
 EXPORT_SYMBOL_FOR_MODULES(vfs_lookup_open, "nfsd");
 
-static inline bool trailing_slashes(struct nameidata *nd)
-{
-	return (bool)nd->last.name[nd->last.len];
-}
-
 static struct dentry *lookup_fast_for_open(struct nameidata *nd, int open_flag)
 {
 	struct dentry *dentry;
 
 	if (open_flag & O_CREAT) {
-		if (trailing_slashes(nd))
+		if (trailing_slashes(&nd->last))
 			return ERR_PTR(-EISDIR);
 
 		/* Don't bother on an O_EXCL create */
@@ -4742,7 +4744,7 @@ static struct dentry *lookup_fast_for_open(struct nameidata *nd, int open_flag)
 			return NULL;
 	}
 
-	if (trailing_slashes(nd))
+	if (trailing_slashes(&nd->last))
 		nd->flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 
 	dentry = lookup_fast(nd);
@@ -5116,7 +5118,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	 * Do the final lookup.  Suppress 'create' if there is a trailing
 	 * '/', and a directory wasn't requested.
 	 */
-	if (last.name[last.len] && !want_dir)
+	if (trailing_slashes(&last) && !want_dir)
 		create_flags &= ~LOOKUP_CREATE;
 	dentry = start_dirop(path->dentry, &last, reval_flag | create_flags);
 	if (IS_ERR(dentry))
@@ -5732,7 +5734,7 @@ int filename_unlinkat(int dfd, struct filename *name)
 		goto exit_drop_write;
 
 	/* Why not before? Because we want correct error value */
-	if (unlikely(last.name[last.len])) {
+	if (unlikely(trailing_slashes(&last))) {
 		if (d_is_dir(dentry))
 			error = -EISDIR;
 		else
@@ -6334,16 +6336,16 @@ int filename_renameat2(int olddfd, struct filename *from,
 	if (flags & RENAME_EXCHANGE) {
 		if (!d_is_dir(rd.new_dentry)) {
 			error = -ENOTDIR;
-			if (new_last.name[new_last.len])
+			if (trailing_slashes(&new_last))
 				goto exit_unlock;
 		}
 	}
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
 	if (!d_is_dir(rd.old_dentry)) {
 		error = -ENOTDIR;
-		if (old_last.name[old_last.len])
+		if (trailing_slashes(&old_last))
 			goto exit_unlock;
-		if (!(flags & RENAME_EXCHANGE) && new_last.name[new_last.len])
+		if (!(flags & RENAME_EXCHANGE) && trailing_slashes(&new_last))
 			goto exit_unlock;
 	}
 
-- 
2.56.0

