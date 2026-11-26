Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710709;
	b=IgklnB8McqfrRi7zhTtwKXiAB4JpTP0ohWicnoNKd+FM0HLIrUdGBfaMG9vv7Nl5EewL
	 JCgQhI5+XQW2jI/D5HVAUZEoLxhEIqQK2XIs8pk6SSywm+biLbsdYF3UkilVOTUkmVvQC
	 ZWRhZZg7KCNq6MlMQ36alFT8bodzyOhlmkFbu7QoNl4V5Wja79gwzKFtPgr2Mc3Te6Stt
	 LV5ZdhJgE9PEfO/3Ig8/v5eaIRgbu991Z+TApxrr0aI/7JfeVIVP+DlHACcofUWAZ6GzH
	 A8ahtgIRh7sUZ3m0vNWI32U5v3tI3GXJUal5HV6w9mTcKoORQ1zSb+eKiziDIYqgWRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710709;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
	b=StnrElK9tBCdSLcYG8EU+L9W8I0QFODLgHZe3Er8yDM+v29Z+sEpmnLOV6BeNvDjl7Sk
	 Z88FHzM+Uro51ZSIzO34La94q0u0X1rOgImKQUQN/79Is6JuFntU3Zd0yqZIgXyjU2GYH
	 lBocNenCZ+qsik2SmYF4pI/qA8eT55cOUwUNCVOqSDf36TEnfYFW+Qv+izytgTYvVgdhJ
	 n1/L0PHzMBariciCLBvXtwC6qSkx2TSFc5LhtdfqkBQWLCQREBIl1/Q3DfwfFi0qyGv0y
	 sCDbJ9lkkcVt88fjCI0rGeyRrfwEcAQraRxeZ2i5mZmTBrUJWbpfPTsygJsvUuUwRJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xc+MkwdP;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E4C606A336
	for <linux-api@vger.kernel.org>; Thu, 26 Nov 2026 16:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46E4C606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xc+MkwdP
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so73940825e9.3
        for <linux-api@vger.kernel.org>; Thu, 26 Nov 2026 08:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795710707; x=1796315507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
        b=xc+MkwdP2qSHhRJs8tqp0gJVAbhLaJGgxK7Lgcrjfgi+poNIcrpekreyQIw8Wa2ubw
         JTYEYjzBQHqXA+RCGlkMim5rWjlpg2Rc8MJ45f9iuFGrYnTeolSe9vBS2bLSeX5T5fZf
         SZX2nx4eSzWBYUFb1yi9O/TFdM/MA3MAnAw6/ApHrCpLQQihkBD0TTWOQKPnQ28uZTYE
         XpRkIhDzQqfntphSLOtItZuJswRxPc5PSDPlBmuNOaDHAcf8EMQ3hdeMUxJAM4CSuDyL
         mqwH8JHptswvYdfZEoqv6ChJC6m67PYPkI1mpROJ+wyATfnVNkfzJA1ri8ZRyz6/FKyk
         ZCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710707; x=1796315507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mfpEhfbyhPi8fEOS+N1QHzNJFz4cU/NZgKWTwuKYJ+M=;
        b=Vz7rCe9QX6QdmrQ0G/i64iqyuz//zik2i41r4gRygpabe7VtMQlv8yhuMiMLnwy5KZ
         Q5N6lhEiS1yyOiEbsrLvIFref6KNxX5jAdjhNAl2BJipRvbKOIHQO5K/jKaKYQebDLfr
         wyCCK5VLL9Ur0FMVPjKKFBLquUotW7NnCQlF4uC3hVyD2wgo18iXpFuXrcalv7cDUC1O
         MMdxk6+Hlo8TN6dz4TaI1JcCx7y+FOHwh5yDybIY26xadi4I9A0cP7mId45fWpY1rS14
         t+GTpvuHtYnJWO8iz3NInmauPBD28b/Z5CCAdXg8Vh9CUpRlCWwBZ6F9nx6YOwkSHivP
         LMsg==
X-Forwarded-Encrypted: i=1; AL+hErEc+nufTpHq+Wn+0Zbi3nLDUs/bB85Y6DEWd9zSY4QORqBgOtMaaIq2b2wn//69CCgRBwIgHGERnug=@vger.kernel.org
X-Gm-Message-State: APuU4Z9AX7KRix74iQ1bR48/7s1Wu68xjqlDkE8CsyKiTB2r60aj3r3i
	DiVjtTCFe+GSTam1nujtwoe7oiP4lTyeJK1T4PXiOE0fMp75YQfhTM3o
X-Gm-Gg: AZFdTZcLdk9aW80Xlb4SJejPoPPkL0NfMQOTYFixy9YgqGxp+aZDwONrOM3h13MaCm0
	BcKWrtLNmU/N+4l/TaafH8QYsBi7ndoZ7ouRyWT5dvxGYu2VMeFUjBc5OJGtujKV1wXcimQO+qA
	+v2UI6j7c374aFud7HMnkVDDvtfIhyoZH0dFFa/XqY30KON+/OrKEkqjzEFUEaZhO9bVlUHtK1O
	k4/UhBn1SjWDtAVeIcvi+sfEfhkwny5hBC035KtykNQBiKjL+wGYvFosmeX4G7EDG8U+ls4Zqf3
	PCHokesx+p7i11CAJLfXJg0Xb2+u2YgYVQzhTrIS0LMyGJ+mUMXZagqcuTBSuEWX9bTN4qRB06x
	tlX0dhmIRA9t+6GdFSq2n5nf5gBDhHLin0oGCtLuNMcLtpcjNC8ZHP3pEISZzXXHJOVZrPJZ3fO
	KJOdSQ3oFl0NxBPy3SIttBvzWipw7BktBkNKr7eQz866zYbpZ/8cI8Wh12FLJYbUQv43oR/HmXg
	UKjLirZCWYjnFlAXux26TV0jXWm4gVzL368GOjAtnBKT5o8qnPHBM6IV5MwjycJTEWNGkJNE0p3
	d+elm6ioWVnB45aD3LZRepNW
X-Received: by 2002:a05:600c:4e0c:b0:4bb:875b:f23f with SMTP id 5b1f17b1804b1-4bb88827f0bmr416764955e9.33.1795710706373;
        Thu, 26 Nov 2026 08:31:46 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm721964995e9.11.2026.11.26.08.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:45 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Aring <alex.aring@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 1/4] vfs: use goto out on error in vfs_fileattr_set()
Date: Thu, 26 Nov 2026 17:31:11 +0100
Message-ID: <20261126163114.403846-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>
References: <20261126163114.403846-1-koray.fra@gmail.com>
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

Switch from using if (!err) { ... } to the cleaner if (err) goto out;
in the main body of vfs_fileattr_set().

Signed-off-by: koraynilay <koray.fra@gmail.com>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..40d6518f1d8e 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -285,30 +285,31 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 	inode_lock(inode);
 	err = vfs_fileattr_get(dentry, &old_ma);
-	if (!err) {
-		/* initialize missing bits from old_ma */
-		if (fa->flags_valid) {
-			fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
-			fa->fsx_extsize = old_ma.fsx_extsize;
-			fa->fsx_nextents = old_ma.fsx_nextents;
-			fa->fsx_projid = old_ma.fsx_projid;
-			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
-		} else {
-			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
-		}
-
-		err = fileattr_set_prepare(inode, &old_ma, fa);
-		if (err)
-			goto out;
-		err = security_inode_file_setattr(dentry, fa);
-		if (err)
-			goto out;
-		err = inode->i_op->fileattr_set(idmap, dentry, fa);
-		if (err)
-			goto out;
-		fsnotify_xattr(dentry);
+	if (err)
+		goto out;
+
+	/* initialize missing bits from old_ma */
+	if (fa->flags_valid) {
+		fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
+		fa->fsx_extsize = old_ma.fsx_extsize;
+		fa->fsx_nextents = old_ma.fsx_nextents;
+		fa->fsx_projid = old_ma.fsx_projid;
+		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+	} else {
+		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
 	}
 
+	err = fileattr_set_prepare(inode, &old_ma, fa);
+	if (err)
+		goto out;
+	err = security_inode_file_setattr(dentry, fa);
+	if (err)
+		goto out;
+	err = inode->i_op->fileattr_set(idmap, dentry, fa);
+	if (err)
+		goto out;
+	fsnotify_xattr(dentry);
+
 out:
 	inode_unlock(inode);
 	return err;
-- 
2.56.0

