Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66464480324
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161433; cv=none; b=r40OwB6f4qDpshJfZK8o6oB7VIZT1Yw44Mh9ENtlO5OXKpJgAMhM0TGirTHh8Y7S4omeyfKUyB/JruVj1Y2JzXCgWQVYoFLsdxCYvKSl7PM4ZhUzTZ0t7a+iSC8KxPoxS3ITMqJ5JGE1ck1hXOgLFjn3Z77ICwkCwHjb0zkJ1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161433; c=relaxed/simple;
	bh=HAO6TzvCRY7EGjqcHce8xi34wFH+CbW4ixjUA56bdbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJFFWdpufJRe0LT+6b3SvCDRJE+V/UhbYwRsADT2cuGMOdH8bxa59E3osDESU/6B1QOjzXu6RQu8iL4ueeb8+j1LTqmeybPyFPbTEuTKkznGRku6PnyTF2YQt/Ls6DgK9KhebFB29ngcrmziUf62NEqIDdsk8ngz9Dy+sYvny8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=Dl7BvItL; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="Dl7BvItL"
X-KPN-MessageId: 0c7f151c-c96f-11f1-bfc1-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 0c7f151c-c96f-11f1-bfc1-00505699b430;
	Fri, 16 Oct 2026 16:37:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=VZUFJsc1kCjQaLXn45AAgQ/9akDuiqVRlR2VgCgMTWg=;
	b=Dl7BvItLsBOHxoGH+QAKKtTXHimud6WLLqdVuvXNfN8neQH9c5LVkcAWvqqY9OkjcQdagvOcyir9P
	 UlD40A+MRatdAioZF7Hhj1zMvayE4VTMfLKXi0qB3/uN7uMX56uSjv1vrgqyXo9vcoSwtaoeoX777b
	 qqAs8jDs6r8ofKkD+gU1rJGymnnjeSnyS1R2db2l8nkXU9C9c5F4JghEw0fuTsM/KDasOWgFEsvn7B
	 7cdYeg7JgVtrp0JtCFMomzQFJ2bNCknbK/3ietPh9tNB/uxLiPwpW21GOdb7yMaqfJr1K6bnRbnaGI
	 Sk94wICgWsq1s/l3SvirCr0zn33RF2Q==
X-KPN-MID: 33|dEAr+WgoWrfzM/OHvKHeFCObYltbtt11xMvoLxZ6UAk1NOM2qaOxyBUaCwYmZhz
 KgNdrc6QPLaBH/aeEKRDd+gRjO6l+hs25xthBQEtRh2c=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|i7+L0wxSpD/H4A44CFVXZSwZ0PR4p3MOaFx5Mb6i4cpmZbwPrhXaMs5equ4e4EY
 W2NIBuNDnqXIx+rPmX8CLxg==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 0c3dffe9-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:01 +0200 (CEST)
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
Subject: [PATCH v7 03/12] vfs: lookup_open(): move setting FMODE_CREATED down
Date: Fri, 16 Oct 2026 16:37:57 +0200
Message-ID: <20261016143806.2946578-4-jkoolstra@xs4all.nl>
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

In preparation for using vfs_create_no_perm() in lookup_open() we need
to move setting FMODE_CREATED on the file mode to either before or after
that call, as currently it is in the middle. If try_break_deleg() fails
it is currently not set, but vfs_create_no_perm() includes a
try_break_deleg().

Going up the call chain of lookup_open() we see that it is only used in
open_last_lookups() if no error is returned from lookup_open(), so we
can safely move it to after the filesystem create() call. This also
makes more sense when reading the code as you don't have to wonder what
the implications are of setting FMODE_CREATED before the create() call.

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index ab09dd7f7475..a979488c2167 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4609,7 +4609,6 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	if (error)
 		goto out_dput;
 
-	file->f_mode |= FMODE_CREATED;
 	if (!dir_inode->i_op->create) {
 		error = -EACCES;
 		goto out_dput;
@@ -4618,6 +4617,8 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	error = dir_inode->i_op->create(idmap, dir_inode, dentry, mode);
 	if (error)
 		goto out_dput;
+
+	file->f_mode |= FMODE_CREATED;
 out:
 	if (!IS_ERR(dentry)) {
 		if (file->f_mode & FMODE_CREATED)
-- 
2.56.0

