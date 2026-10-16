Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C8E4D2EE4
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161444; cv=none; b=PKcNG5LBVVHRWElHnFZ8HDFi69TfZ4v1X2zYo4rcMxhdau/2vVZIaBV6iWcha7B5fj4JkNgfi3j9BGYvgiXUpjk4P1yBh+4czIHAMU1QRQP8u2W/a3c2dfDz7t0N8m5RrnAbf9kIWGrkdrFUFSKm8FDOsxPqxj9R/ZbXDdk5ce0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161444; c=relaxed/simple;
	bh=kI4CvoBqwq+FfW3CQYO5fcVPpk7JpfRW+eBNodHBGN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEI7EqAhJQIC2/TMWwlrazHghpW4AewPDzdT3CwjF4u30wmAT6hg+SifoRQLEJCT7UVTAcf62reVY2I164GHpEsU/K3KFcn3LZpidv3YA0b39VSiDRFIEJGQGwwd8QPwVg7RcYqav2cekMjmYmmJGPMEwxLhtlmvLmqeh6aNyU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=pTzJznn2; arc=none smtp.client-ip=195.121.94.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="pTzJznn2"
X-KPN-MessageId: 10948f38-c96f-11f1-9e93-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 10948f38-c96f-11f1-9e93-005056999439;
	Fri, 16 Oct 2026 16:37:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=3mm/w1EXXI67RyDCAz9DR5/sv5ocQ8avN+Cr+GA9AaA=;
	b=pTzJznn2EgyUzXXXATR96AGaRVggULpumTvsFhGXh3B/G6sVEyvfeHmqMJ0DZ3TZHg7bSDRsUjO0A
	 KXW1CyKkQCPdZA+6C1zMArs9R+iPNicCJ1zzitgTjdC8u4kkwwAUGkfMDp/Ha4VD4zPZkpKUucTxq9
	 cFg3U5b6YrBt3bL1N1d824Q3tw+30e1RJD7VIjXVfvvCaEnSC+jj/Vi91pyt4OKA45wr7czmHWTDmS
	 T/UQWKsEaZDITup5xz/N57sVKg/9tT3G+5yCRUUJ81sTCfn1wKk9l3MA4m6HAjFs0b8Ri1z15BEya8
	 sWUzUZ0XU+8K3KoCq9ne4hklviF/5Hg==
X-KPN-MID: 33|LscIXE6pUo/OESTC534fUFqQIsGB5zcoDUbDwjcCAdB+KMQxaVZOUPLmZdMAe4J
 kFdn0UFV+jbJK0xPvMlEAIIjOtSbxQJwq5d742NS9Ue8=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|YCdb5T4qjy7hPExlGFDuXVKIRp4oWANuPRBgRiEmwyDdlr2C/oRS/8GDMBGdpLo
 r32w734PqkfRkRe5XEROEog==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 104fe31d-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:08 +0200 (CEST)
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
Subject: [PATCH v7 05/12] vfs: lookup_open(): use vfs_create_no_perm()
Date: Fri, 16 Oct 2026 16:37:59 +0200
Message-ID: <20261016143806.2946578-6-jkoolstra@xs4all.nl>
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

We can replace the code in the no create_error/negative dentry found
from lookup case in lookup_open() with the vfs_create_no_perm() helper.

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 000d8841a8ec..b864aa426102 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4459,8 +4459,14 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 		}
 		dput(dentry);
 		dentry = ERR_PTR(error);
+	} else {
+		if (file->f_mode & FMODE_CREATED)
+			fsnotify_create(dir_inode, dentry);
+		if (file->f_mode & FMODE_OPENED)
+			fsnotify_open(file);
 	}
 
+
 	return dentry;
 }
 
@@ -4610,22 +4616,12 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 		goto out_dput;
 	}
 
-	error = try_break_deleg(dir_inode, LEASE_BREAK_DIR_CREATE, &delegated_inode);
-	if (error)
-		goto out_dput;
-
-	error = dir_inode->i_op->create(idmap, dir_inode, dentry, mode);
+	error = vfs_create_no_perm(idmap, dentry, mode, &delegated_inode);
 	if (error)
 		goto out_dput;
 
 	file->f_mode |= FMODE_CREATED;
 out:
-	if (!IS_ERR(dentry)) {
-		if (file->f_mode & FMODE_CREATED)
-			fsnotify_create(dir_inode, dentry);
-		if (file->f_mode & FMODE_OPENED)
-			fsnotify_open(file);
-	}
 	if ((open_flag & O_CREAT) || create_error)
 		inode_unlock(dir_inode);
 	else
@@ -5245,13 +5241,6 @@ struct file *dentry_create(struct path *path, int flags, umode_t mode,
 			/* Drop the extra reference */
 			dput(orig_dentry);
 
-		if (!error) {
-			if (file->f_mode & FMODE_CREATED)
-				fsnotify_create(dir->d_inode, dentry);
-			if (file->f_mode & FMODE_OPENED)
-				fsnotify_open(file);
-		}
-
 		path->dentry = dentry;
 
 	} else {
-- 
2.56.0

