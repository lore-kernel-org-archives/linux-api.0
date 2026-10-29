Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291362;
	b=UTBxLh8ssNqOoYnoMmxpvT/K+Lzq9YZmVC+QPSaWKCbEhrICBbNhwqgD2B0Mw0GXy/VP
	 0yaAASr84cedCk8dhVNok3Tf3p2/jeGqdLgADTNIfDKgxcPY6iB8bgDbqJS9gDQ8mhvNP
	 cD/JygrPJGUjJJ+EzHqADjuToh1xmOH7K7lnQVxki+Z/FbvAV2ESbsaZzcPc1VW/WRFYt
	 QghS0AgN/dyxBhroMGC5pc17m/5fBNIRfyYyDUX53DIh1X7lUdzdLLXOLO/32WaJCK0Q+
	 O/BhcsSQz/NrJMVNkJ5c2k6FBfamCcnz5HBnPcDz//XuENfGCZq/grvO7xQ7GdgNbeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291362;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=93xDr8w82b19+okAmBRAJJIEwEanVvAKuiNDWCkwccU=;
	b=zOvNDX/KAQHN4wkZWehRDEwxQkHAiFg8J5uzy9JRGtuaCpKbXhzxOoAnO5TyBzQeuWLG
	 H218XfBHBjqovMhpa6h607kS0Wh5pkMYps48E3VbKW1dSTJa0ka1JoOG+B7tuqx96GMzr
	 x88KC4G39SlppXw4CcGIzuVDUzRwkxqCyjD7f4tTcYdvpcahgD6D23ofMJ2kW0wqUNqTv
	 QYiasBFwNg9NbVhRlu5P/NIrQAGcdVO+rWWLYagCIL6M/JCh+I/rhCF8xKPsXZsAeQEZP
	 Nw4rD959b1MFH5Cb1aPVmRAy7rHixIwoAC5nmfVmQo1agVjw3G1aqsInVXAdWsboq3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JV6VxyNn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508FC606A31A;
	Thu, 29 Oct 2026 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JV6VxyNn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460A61F01816;
	Thu, 29 Oct 2026 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793291361;
	bh=93xDr8w82b19+okAmBRAJJIEwEanVvAKuiNDWCkwccU=;
	h=From:Date:Subject:To:Cc;
	b=JV6VxyNnWjqmNfds/4LUOXe2jzMABiRnDaKVUlmw8r+MF6vIciFzR9yD+uurFZqbh
	 LkNdeYviciSyVf5rECzuje5TQmB3qZuBHNawqdrTd3tjIz2bvQ+WnQUsvCtSYt+UYc
	 grLJFm9BZxsqbjppIB8KqxvN04daxTI6qiJCWE4KRr77ksqJLpqRNsyUDXgfymLPr/
	 r6HuoSWXnHnjFw2pVYw6ez3wz2V8zRAhEU8X1JmmMBJFaMH84HAxypRhdQFGhoNO6m
	 6Do4hSpaZEpxxaZzzuI6kkdUipDO2OMtaB40dbU1dBoupqg59dLmkWhTJLayTsEF/5
	 GrYMLP4UNOG4Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 29 Oct 2026 12:28:16 -0400
Subject: [PATCH] statx: add STATX_ATTR_MULTIGRAIN_TIMESTAMP
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyNL3dz0kszcVN3iksSSCl0js0QjI8s0y2TjJBMloJaCotS0zAqwcdG
 xtbUAKYGiuF4AAAA=
X-Change-ID: 20261029-mgtime-statx-26a229f9c3b4
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2097; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=oP2L+9LClokU54StxbsCJCbiCwIJ6fU+GF/E/fV4FoI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq43RgzWEmuVIIKB54jXWJNr5QYNdiZaozWwMsN
 XgR4HDlSg+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauN0YAAKCRAADmhBGVaC
 FTOdD/4rxg0XwgVuFc9lFXsGxeMYI6lwWI5J1dCyUFLV0j1qsVC92V4J4sx0AZnLYbaSlUxER+T
 PAsn9tD5RaAZmDzB+2ywDVRI1a/NUodorSOescDyukg/NqA1ee3d+TEmteEG/UeGkwPL1b7VltU
 kn8GmqvHmhzKD3IhWap+0L0A+72uq2UTQRd0F4NFpBXGdYc4yQZ2Q5gn/nj1Z3wnGmWdAtJeQaA
 vpUW45sOhpV5dwQ8M028D+CpwNYa6TXFecw2LNMuSplYgemQtdBiKfg8ll+4N78MKG01KhtSdOH
 JXIbbYrqdJPjEQjf1avwI8eQ34yek7XUmOgl7vqzuW/aWE+tTvi3nyJd6y6rHnedSmcRMGzuaj9
 a74oEcU0ML1Mck9nc/azjsD1twDbaXgIanRzXc7vQky/T+Ojb18fZJr8yPJD7SDGh7NmSYm61XC
 djI7gWnwlx+DpEgjZydqsCsFnrl1Ft9E4C+4zjaF404DkwP4NJ60CGNRfwgaRGjvTZqzlKIaKaJ
 QSLG4LPnFtLRVhuwjEXY9ddOokeP/77xgjxd82b5zv5RY1Hgi0o8MQjM9ZYfVky5c4y7JOJ+LQ/
 h/ve+bKCOzSJt2KIoYTvxpeN/eZp6jEUa9m8L4J+kyzop6WQB0tTfSfNB3MAtoG0A+MGI3CPu9T
 kFcS2YPwFtzxXBw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Userland has no way to tell whether a file's timestamps are multigrain,
i.e. whether successive changes after a query are guaranteed to yield
distinct timestamps.

Add STATX_ATTR_MULTIGRAIN_TIMESTAMP and set it in vfs_getattr_nosec()
when is_mgtime() is true (IOP_MGTIME is set from FS_MGTIME at inode
init). Always advertise it in attributes_mask.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
HCH suggested this when I posted the fstest for multigrain timestamps. I
think it makes sense. If this looks good, I'll plan to send a manpage
update for statx(2).
---
 fs/stat.c                 | 6 +++++-
 include/uapi/linux/stat.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index a2e63c6c45b7..67b9f1784b23 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -206,9 +206,13 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	if (IS_VERITY(inode))
 		stat->attributes |= STATX_ATTR_VERITY;
 
+	if (is_mgtime(inode))
+		stat->attributes |= STATX_ATTR_MULTIGRAIN_TIMESTAMP;
+
 	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
 				  STATX_ATTR_DAX |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_VERITY |
+				  STATX_ATTR_MULTIGRAIN_TIMESTAMP);
 
 	idmap = mnt_idmap(path->mnt);
 	if (inode->i_op->getattr) {
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 1686861aae20..b978860590b1 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -255,6 +255,7 @@ struct statx {
 #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
 #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
 #define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
+#define STATX_ATTR_MULTIGRAIN_TIMESTAMP	0x00800000 /* File uses multigrain timestamps */
 
 
 #endif /* _UAPI_LINUX_STAT_H */

---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261029-mgtime-statx-26a229f9c3b4

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

