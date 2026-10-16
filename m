Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB24C9DFF
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161439; cv=none; b=TnskBSWED1M1DDhsYopQ9JgqfuYAejmoX3XS5ir4iEMY1gArqJMl9imcBiAoIBCBhWuz1lfUmofbukuJoNQV66Tu9w/M8D2B/FFtrKmPzW31mg/BTzfUUR17KqaYMU0LiSEbyfWq6tz+HMRW3oNv8aueLjAZ3PXZJnBPJRM+cLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161439; c=relaxed/simple;
	bh=1GpYfRkDvCo697Ayqy5BKo0AlYuWmRIIblWo+bKrQb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+cQk1TRwueWWWBTUJJ+DWJEqLz5SptzPQfq7rimbmzuAH/BqcNr+lb2XCNB5WbfyMpmt2gcgP9fVfu8N8zGqK+n6QDeSXIrm8Kv0r+/REqQlyz/tpKgDEjuZRvFhZ7ziARhZwxM8ICHxIBe8gEc8hEImRSvH5exeJ/87g8ORXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=Ij3UbPhX; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="Ij3UbPhX"
X-KPN-MessageId: 0e550fd2-c96f-11f1-8f57-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 0e550fd2-c96f-11f1-8f57-005056992ed3;
	Fri, 16 Oct 2026 16:37:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=tKlOSKPjzi9PWtJvacQZVYlsb28fZgj7yGkWVNWDnEQ=;
	b=Ij3UbPhXjP7v5Oy8zlsBUenRk46LDB+dK9MJCsvP4rwxpXUmNMzuse+Hg5u0W1cb9vP1hYwezqpIo
	 uMyqWQsIuNGdK5zUlXPDF3aDPq/GsOA4hxpuPPajkoaOrkjaBQPcN8ETsZa0UIWXePp7mpsHcNXUtC
	 L9LXM8bVNfh1NPx30wzEOdiDWwLW4LlxEbTkGVU8V50T9htO3O5KhUbHjx5j+/UIgQzFuEmBjAg9jL
	 bWCG9fPQJ9jKkc9OKyx/IRckNEAVX6fC4pG6WP8mIw8PTDyLekwV/RaswrtGd+HIAEZ7dUhOIykHgy
	 V69wzRa2tg4wuJVtxGL1M2ftvmbV/JA==
X-KPN-MID: 33|zejER3ainzwZi+0NPqlRn50ZvNjl59tmo6QhdvM3nXnoTDPRYHdJJ9q2J2mX11z
 bfW2zlY0uGuSV27LzazJU6Jt9/qU07kxfJ2C5c3yuMLk=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|7gE7OkAYpSW82HbC27tO+jeKoHHpeldKM07y9KVUt1vgQBeRJ6rKiKQT9kXlyeK
 DcB1+5s4/BhWipARtW2+Rtw==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 0e135b0d-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:04 +0200 (CEST)
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
Subject: [PATCH v7 04/12] vfs: move ->create check in lookup_open() to before try_break_deleg()
Date: Fri, 16 Oct 2026 16:37:58 +0200
Message-ID: <20261016143806.2946578-5-jkoolstra@xs4all.nl>
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

The i_op->create check in lookup_open() takes place after the
try_break_deleg() call. This does not match the order when doing a
regular file create via mknod(2). There the call order is:

	filename_mknodat()
	vfs_create()
	i_op->create check
	try_break_deleg()

Move the i_op->create check to before try_break_deleg() in
lookup_open().

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a979488c2167..000d8841a8ec 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4605,15 +4605,15 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 		goto out_dput;
 	}
 
-	error = try_break_deleg(dir_inode, LEASE_BREAK_DIR_CREATE, &delegated_inode);
-	if (error)
-		goto out_dput;
-
 	if (!dir_inode->i_op->create) {
 		error = -EACCES;
 		goto out_dput;
 	}
 
+	error = try_break_deleg(dir_inode, LEASE_BREAK_DIR_CREATE, &delegated_inode);
+	if (error)
+		goto out_dput;
+
 	error = dir_inode->i_op->create(idmap, dir_inode, dentry, mode);
 	if (error)
 		goto out_dput;
-- 
2.56.0

