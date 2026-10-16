Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306F43A784E
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161450; cv=none; b=QRtRsLrEOexCq741HzUCHs0Cdlou98uJ6ID7rW0SXyPF3Yo6G22B/kpCpkq5HMLawNrS7PCZZyHyaMGsY00dAMYr2beY1ZzvZ4e+nU99b4F6j8c3BjErT/Z8oLwLYwl+/VE4vDW8rXQrlBBing490XxTTkGIZ24FQTHhocO9BSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161450; c=relaxed/simple;
	bh=knN/WO8T2DJVGdQnjMzzoMHPSNEorim/xkjdAhCKYg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjH32NHWhx6xBhiroocPZ08XVNtB3GHe+WBvqHEdwAEQVHJ+5dL1sTQOYcLWUUwNPB6egglQzGk1vFSbjPgQ1DRd78fqj1W3Z5hXv85en2AJNYUiLTB8tnxMtYlji6W0qUxYJAMHVm5Y4dylNCm85/GTHcNEez+1IJEBE9XQH4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=I0qauHB0; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="I0qauHB0"
X-KPN-MessageId: 19a1b8ce-c96f-11f1-8f57-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 19a1b8ce-c96f-11f1-8f57-005056992ed3;
	Fri, 16 Oct 2026 16:37:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=Zh+0cDXvPBYGqWRWAkoqsDVPqqGBZbu+XPuazUehe0c=;
	b=I0qauHB08sX76mkp1m3zKEwNR9GecPA7pLzXyD9LdAe8B+ozbRvQ8Jv1rU2kXl4dMH7u8MbtfUPGi
	 TweZNDG8TEOdI1/+NUwVLsJVCuZyFwXwxBJrNTfX8f0n38BzCDbRSY1zI6984t6bKc4iYpCoAWY+U5
	 Pb1h0yTsZjvIer2YNbRA2U2Y8ZdpvfjGWXh3N7d9e+ievaFbrSP88wcPArTqTqhc9m/y1FyOKA0Aos
	 eIDzEh8ApHj3FcP/8js+/Ul71ZTxyu35AcCcz0HcDbCLbrg0hVZe9kdl0vM3AvAILH5MqjNJxJ3ugZ
	 JIunhHqdckOUT8ks5nUG48eAOFzxg8w==
X-KPN-MID: 33|rQUINPHakDusw10tbpHEJzMgI72v1wSdKldnJ1J1vO0ipeLdz9FdZLvDNWppVO8
 EVlF0wQa/DH2nes5eYHbaHU9MuoDI09ioBuhXuTFmk4w=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|VsIKehK9vLPV5SnugEKHxHU+oe/hxWNwOwBfesGk+cY9mQBBIs4tHRXIvTQeXfH
 Bt6iqks5v58F8CzRx2zgGGw==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 196720f1-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:23 +0200 (CEST)
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
Subject: [PATCH v7 09/12] vfs: use finish_lookup() helper in __lookup_slow() and lookup_open()
Date: Fri, 16 Oct 2026 16:38:03 +0200
Message-ID: <20261016143806.2946578-10-jkoolstra@xs4all.nl>
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

The same code around calling ->lookup() on an in-lookup dentry is
open-coded in both __lookup_slow() and lookup_open(). lookup_open() is
becoming quite unwieldy so factor this out.

No functional change intended.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 51 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c16150965041..e7d3d28f3fd7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1889,12 +1889,34 @@ static struct dentry *lookup_fast(struct nameidata *nd)
 	return dentry;
 }
 
+/*
+ * If @dentry is in-lookup, look it up in @dir through ->lookup().  Returns
+ * the dentry to use from now on: @dentry itself, or the dentry or ERR_PTR()
+ * that ->lookup() returned instead, in which case @dentry is dropped.
+ */
+static struct dentry *finish_lookup(struct inode *dir, struct dentry *dentry,
+				unsigned int flags)
+{
+	struct dentry *res;
+
+	if (!d_in_lookup(dentry))
+		return dentry;
+
+	res = dir->i_op->lookup(dir, dentry, flags);
+	d_lookup_done(dentry);
+	if (unlikely(res)) {
+		dput(dentry);
+		return res;
+	}
+	return dentry;
+}
+
 /* Fast lookup failed, do it the slow way */
 static struct dentry *__lookup_slow(const struct qstr *name,
 				    struct dentry *dir,
 				    unsigned int flags)
 {
-	struct dentry *dentry, *old;
+	struct dentry *dentry;
 	struct inode *inode = dir->d_inode;
 
 	/* Don't go there if it's already dead */
@@ -1913,17 +1935,10 @@ static struct dentry *__lookup_slow(const struct qstr *name,
 				goto again;
 			}
 			dput(dentry);
-			dentry = ERR_PTR(error);
-		}
-	} else {
-		old = inode->i_op->lookup(inode, dentry, flags);
-		d_lookup_done(dentry);
-		if (unlikely(old)) {
-			dput(dentry);
-			dentry = old;
+			return ERR_PTR(error);
 		}
 	}
-	return dentry;
+	return finish_lookup(inode, dentry, flags);
 }
 
 static noinline struct dentry *lookup_slow(const struct qstr *name,
@@ -4614,19 +4629,9 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 		goto out;
 	}
 
-	if (d_in_lookup(dentry)) {
-		struct dentry *res = dir_inode->i_op->lookup(dir_inode, dentry,
-							     nd->flags);
-		d_lookup_done(dentry);
-		if (unlikely(res)) {
-			if (IS_ERR(res)) {
-				error = PTR_ERR(res);
-				goto out_dput;
-			}
-			dput(dentry);
-			dentry = res;
-		}
-	}
+	dentry = finish_lookup(dir_inode, dentry, nd->flags);
+	if (IS_ERR(dentry))
+		goto out;
 
 	if (dentry->d_inode || !(op->open_flag & O_CREAT)) {
 		/*
-- 
2.56.0

