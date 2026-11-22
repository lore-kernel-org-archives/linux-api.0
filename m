Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306156;
	b=BhWPTBzkGfo1PiH4SpyQx1fxnML6HuhWlSY0XiXO3JvNp3uzDP1xTm75GmTVICePPdYz
	 ILaGV3mAvJjjBd8sxN05IOOtQeYGLxv8En4Ipm0IMXMg3VBWtx6JhJPRjWTui3kygFr+Y
	 d8AU67jdQquRUfVFDjxZLXyY6SL6aq09m9X22El+4fbLD+Z+ei+4kWCsEptySQW6kbKWX
	 NeG07EKIw7U9WLo6K7GcZlVnL2M1fWaza0yifANyNi+DYn6Vdyx+0UA8NORR6a6RVQCir
	 iSTd6d6dRaWnXC3kkayVYmV2X3tMZ/Gu6/oCL0qnhwi3oHdNVPAKEYZ/vhRqvgDD6IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306156;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
	b=HM5+6IyQUlX5ROIKyvKfyfuCngktOJtBaLdAq7qHIZ7OCz6IqNFQWf7UCZVXQxamr4jq
	 B8rBdiS6aYwMXaYEyMioGaiHV8PTIyB1SzK6pkXNliy2fjdEvTkNmTXwOLM47htg8JG9Z
	 vvHY5SeI0xgG3gXJ1/hD4S92dGFeMXxv/PQ9/QonqbPMZqjOW4sljcw4xNEJbXsgY+AFV
	 p61QUyZ3re9HHlU56tkhDktv36nQ3td3yYGRJyYCWimr0q0lDvdnzIA2pIKTj4XeUhJ8m
	 lEWsZNmewsu73jho62VLWDjbLahL9lqWPGlOaUBApfy6iitqUiFaDGmcxWUaPIYAjbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pxx4MEVM;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491AB606A339
	for <linux-api@vger.kernel.org>; Sun, 22 Nov 2026 00:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 491AB606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pxx4MEVM
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4ad6219f7d8so1360611f8f.0
        for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 16:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306155; x=1795910955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
        b=pxx4MEVM3F9ewoA+cmrYZ5iJ7GG66cT5YEMw/9bSw+32AQdbNaeyaZM+3JoC/dwApz
         UTXTyt2hP1yxywMm4hNVJePOeGz0MGnOqeDT59BoZmGM0iHtv3qvQDqcKJ75ZctYftXA
         kPEmslanb0UMiXCiyaAj65FLQcg9cH55lzNF2rhCJTB0VVD4RlJR8bfx34szlVVEKDaC
         /SQf4GCr0GacL1gTvq3QehD9mb/pXaJT0DU0oIq9fiin+wEYVcS/rJt2xmbLSEz1RYGY
         zZWz6FecCb/clp9mCPrinCaau+nYvOhVOjDICs76X+KNwZWPsk1GaY5WrM54lZtPqKFa
         teuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306155; x=1795910955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
        b=y8DUa8kfdwdoILyWTfxrYWtEDJzZEdmlYAwJ/5REo3ebk6MNZD86f2ZIjcXVPn9ksh
         4LB6WI/7hHzsnpp/517e6fS8vsv23A+uN/NEVlS7qRjmn62SCi/DsIOmzrmfn8mcQn3l
         ozQtPeRRtUl57DqsgE8qsZmzZ6FnM1LiMsQipeANQdQ+V9KFL/44NvdPYAGE6AwCT199
         Ov+QQHN0rtY49X7OFRDYVPSIYnlfPP2s98v1rUbG6stgcfRxUcGxPeyr95KO32R8ZT8y
         uKQvx7R1JN3JvSdLGTpObDZi6V1zJ3FC480xrFH3Va7Cqy91LJzVQ2LhSJh2amXludAh
         unhQ==
X-Forwarded-Encrypted: i=1; AL+hErHNhAsbXAQb0Le5+jQBhIeVQ7f/QqucAlbDf0i7Pc3vmaq5v9i1fxR37Xg4rFhkC8DHeufEuyrxjeo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8WQdGnRyREuKxSejNBjMpW+Av4V87K2ZraGVz9hOlAK3T4LdHf
	eAtdv1z+idYDPu2VWocp0wCEN1/an3HKlNn5wWqarHcY3gCYSZ5O4NBh
X-Gm-Gg: AZFdTZenxZTuvbiw/MMDfcW8mRM75Q62ksfJXrktpSaoWLe6gU2qTE6Bk76Ik3DspZ0
	9q/LPFWKfNMoX8bKOpoRohbOjHpzJpL73UxG22qq5N1xiGPABojG5mc2QtB3aulFAJgyXw4a3aU
	ivCYhuqM3s2zn/s2ArVz8hEe4iMYD8oUfkhmK4M+A3rJ1d/a75NyUjVQf6uQjmDen1/pOKJOhQL
	3YoW+Bq7zru9aZBIQ0ATzeHxCkIXygu77/KmbgwMyMHpdQE+k6fckCoVeIuY0hCYcH4jAy0KsyL
	dg7FCNyrwsC4aq9dN7wZyh8qi2h8rhLF2bTO8l3LU7dUiA0Vbi5QET6+gji4KB0nKsoJ53VFL25
	1Qw+xvI5QWHOUPPklxTsBDIfHZWKtPgW24fOmA2Ehlllw+3pm3/pmHtcP+3yjloWHr+xUarwBAh
	xq9RDoyKy3K9r5yAzfI5gnclYrOpj00npCWvQqFrNzhTn8zlB3o5ns+gjz5Dzb6oiKrffg5tItf
	xRmDQPBx8LkztDZc0MG4/kIg8ocPlF5zpSRnImeelktHZ7aAH6Mtx0nEuTIsc4HUgteKAKCp1Wt
	NDuOrAcifSmhYSQOFw2XQ/BDH9BjZ+sMx/QDTa6mcciqyg==
X-Received: by 2002:a5d:5f4c:0:b0:48e:5d33:da5c with SMTP id ffacd0b85a97d-4abad5aca65mr14743143f8f.1.1795306154599;
        Sat, 21 Nov 2026 16:09:14 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:13 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
Subject: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
Date: Sun, 22 Nov 2026 01:08:54 +0100
Message-ID: <20261122000856.536902-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
References: <20261122000856.536902-1-koray.fra@gmail.com>
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

