Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765856;
	b=Hh8AF6nnGiF1ycdZC/cJv7/zIyIMM25p7vzdAJK4jxDG9zkP/FIK8In6La9MEn8uw6Wg
	 jfgdfd/3UF5JDoxKjsoSnOrCtg0rRcTy8g8SwQXD5kwEDp6yhm1PZnRJLzk7TWE+gwKJU
	 i8Il+IfsRWoAnRSjIN1OiLg/5roe5GNcETy0PoMItiXsmaRxz/a45zNPrJnjsmAWGsX5W
	 B0YHRxo0hooBb//GYEB6mzzuS16cHGklHDhc/QKIoeXYYjSogU3/8XgfQI6hzqts3WbKw
	 H9qHgS01mdSLb5B+zdHRiCXF73inArTPIepi0DU2zL45FaiSPwNYy2QwwwpfpHU6lKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xB0aGae+0N7Qh6IxNBA7KeNJxluraojMhTHNGzXsPds=;
	b=mdat3TCc2Ky8Rpt6Ckii/4JTgswRzGmCwb5cDRLYd/Fkm3Z34eeuIbJr/8TFCRdkjVs+
	 PdjKWqgRVkdGAp7krrAyBzbB4G5d5hzYUXv06SM5aZ09YO5GjyV80VorZDYRLTvMHPNtt
	 G6vp/8onZ+ztz/hH387usxy+6H5lUehAJHS0kGMKfrigVxe/fHCVgZL+Lz1x0S46hnucD
	 IBGLcPV3hdi7IYkydRYDfb2qgeYlSah0T00Szo7qdw7epKW7wxVtBOfklYzHwYQeZhIz8
	 WyrDWmiPLbt78SfrPLvH3k2p3hGjSbguGfaYcAp7/aW2SCQjqOnGROkYQOJPGiQ8QNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BaP5GLCO;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438D060A5BDC
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 18:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 438D060A5BDC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BaP5GLCO
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-49465892f7bso2255063f8f.1
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 10:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765855; x=1795370655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xB0aGae+0N7Qh6IxNBA7KeNJxluraojMhTHNGzXsPds=;
        b=BaP5GLCOzZs6hrpMCjo6a/iFP3AhAS9vV6ZBcuz5EHHTRGZk1uUFDljCWDlo9MVxn9
         UYJvbEa8R7HIndjUFJ3j0ZDsVx2xCpBgdHvpYmYmWXKWuRdXVw3wJ8rOaASPso9uGk8v
         IDJJIxaKcUnTuOfjP49Iv6Z885rhJl2eJhR6Y95L8RE8Cb9RYGHFiS5a00kX40wfzgk8
         HEE5WD84/qx62WDedaX4VvT2eSJZgtfrI1dRYI8q64jg2KnZQx3I6xVGyQITD9+fiZo+
         lZlKXI3a+n3CpDd5okvNK/t0O3p6HEOj+PmzLxoY1qyy3r4G9cIR1IR9yk7o9qKY32WT
         lGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765855; x=1795370655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xB0aGae+0N7Qh6IxNBA7KeNJxluraojMhTHNGzXsPds=;
        b=D2wU6bekkLvV0MqinHj+4dOwSIddIxOjBBvS5toE3TWXPT05Hamnxg7Y4xcSMn6Lxo
         VxLwya6nRdfbXxcFswqRvbs0AQk9/oXYXGzlec2TGSIb3ltOeA/5ygVfOhb//kt1CVRb
         WCoMmH5Ju7jcUXFyE0p8u2cSX6ciPAs1ode4xbim0RnXRXp6hAJ6V96sdbCYk15Kxf2p
         amTKN+8nK+DmeOwYnCnDQocZBtUZcL8/2XM0jsomLyzMjq4qafhM5SCYj8Wt4NQ8YEl+
         tmLXEmYqPsPyBZz/p0XoX6+8NkHo7oV0rigVjqk0/T8Oq7UWv28XEF1NqWS2j85M/ccP
         QTBw==
X-Forwarded-Encrypted: i=1; AL+hErFuCtixedg4j4HFS9BhbgBw9Pe7czGY1Z4mW0aLS149Q/ZO3PmneEpGb/89X1K7OBcS8Ls707pfYVA=@vger.kernel.org
X-Gm-Message-State: APuU4Z+crak9RicvD1On01/6aPWuJmrJDh9tChQRrpROPC+7ft4MBUH7
	uU4iKIK6khpjcYz/FQcb3tOs8tzx1REjbKu2W2scm7FZEcfPaVB7xby+
X-Gm-Gg: AYBFou1gCDA7RKVzCq3A06MAZk5gdC9/7HsJ8I9FI2dviWQvwHDjyzM4HmhHADhVnun
	pafDZRNmhsN6eNmt9bQJvwZakhhTpihnCIW0ApfhNm9/totSlHcp5pSduAttTVik/ca/0veE4uf
	u4YVMtdvrZ72nuwkIs5HUsLzPUXZuD1uqSp68NMYxvNYhwAyvXJ6JRTVDoM0yLZms13ldEinlpU
	irvCP7aePref7i51NZaS6MbgOhTE9xSkMH1uzM+vOIwpHnc2vXmu08tD4G8xogn/or18W+p9mbO
	g5d5OlcRojzG457Y8bX9M4W4bqZHu4Cv5PY5NmFGSUUYvBsKV+EJAdNR+Ka8rbXr+KyE8xJExvf
	2SFxyv9pH7r3sSM/1RIOU/PD9rtO715VhoMdA0uTEpbOE2SZ8UHRrSOqcGiIgF9SHWTp4yHycgW
	qufKLihS/woXWqrYzL2G1b8uTIrj+WQhNKL0s7kn9735zFvWZLTzI0gHMCb14+bNkk5NNEyhSB5
	QNhTRGuc4nklxryjLuF7Ddy94zkpfTfV5tcePMoSORjdBx/59TrauKd0ism8bPgt8j764nj3qeE
	gu8XWUGOvglFIg5XXvbaeisTKhMha6GBjKMAYovMzF/zvw==
X-Received: by 2002:a5d:5f90:0:b0:48e:7e15:406d with SMTP id ffacd0b85a97d-49c70de3563mr18264821f8f.11.1794765854474;
        Sun, 15 Nov 2026 10:04:14 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:13 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Chris Mason <mason@kernel.org>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
Date: Sun, 15 Nov 2026 19:03:40 +0100
Message-ID: <20261115180343.576773-8-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115180343.576773-1-koray.fra@gmail.com>
References: <20261115180343.576773-1-koray.fra@gmail.com>
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

Implement provenance time (ptime) in NFSD, as introduced in a
previous commit ("vfs: add provenance time (ptime)").

Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
CREATE, OPEN and SETATTR compounds.

If the underlying filesystem supports it, use __vfs_fileattr_set_locked()
to set it, returning -EOPNOTSUPP in case it's not supported (i.e. when
__vfs_fileattr_set_locked() returns -ENOIOCTLCMD).

When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
STATX_BTIME, preferring ptime over btime if available, and advertise
FATTR4_TIME_CREATE support if either ptime or btime is available.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/nfsd/nfs4proc.c |  9 +++++++++
 fs/nfsd/nfs4xdr.c  | 40 +++++++++++++++++++++++++---------------
 fs/nfsd/vfs.c      | 17 +++++++++++++++++
 fs/nfsd/vfs.h      |  4 +++-
 fs/nfsd/xdr4.h     |  3 +++
 5 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3a82af381a8d..06074a7f213e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -322,6 +322,9 @@ nfsd4_create_file(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	__be32 status, create_status;
 	int want_write_err;
 
+	if (open->op_bmval[1] & FATTR4_WORD1_TIME_CREATE)
+		attrs.na_time_create = &open->op_time_create;
+
 	if (name_is_dot_dotdot(open->op_fname, open->op_fnamelen))
 		return nfserr_exist;
 	if (!(iap->ia_valid & ATTR_MODE))
@@ -929,6 +932,9 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	__be32 status;
 	dev_t rdev;
 
+	if (create->cr_bmval[1] & FATTR4_WORD1_TIME_CREATE)
+		attrs.na_time_create = &create->cr_time_create;
+
 	fh_init(&resfh, NFS4_FHSIZE);
 
 	status = fh_verify(rqstp, &cstate->current_fh, S_IFDIR, NFSD_MAY_NOP);
@@ -1347,6 +1353,9 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	__be32 status = nfs_ok;
 	int err;
 
+	if (setattr->sa_bmval[1] & FATTR4_WORD1_TIME_CREATE)
+		attrs.na_time_create = &setattr->sa_time_create;
+
 	deleg_attrs = setattr->sa_bmval[2] & (FATTR4_WORD2_TIME_DELEG_ACCESS |
 					      FATTR4_WORD2_TIME_DELEG_MODIFY);
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 84161dbecd1c..faca3b9b58b8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -509,7 +509,8 @@ static __be32
 nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 		    struct iattr *iattr, struct nfs4_acl **acl,
 		    struct xdr_netobj *label, int *umask,
-		    struct posix_acl **dpaclp, struct posix_acl **paclp)
+		    struct posix_acl **dpaclp, struct posix_acl **paclp,
+		    struct timespec64 *time_create)
 {
 	unsigned int starting_pos;
 	u32 attrlist4_count;
@@ -603,11 +604,10 @@ nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 		}
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_CREATE) {
-		struct timespec64 ts;
+		if (!time_create)
+			return nfserr_bad_xdr;
 
-		/* No Linux filesystem supports setting this attribute. */
-		bmval[1] &= ~FATTR4_WORD1_TIME_CREATE;
-		status = nfsd4_decode_nfstime4(argp, &ts);
+		status = nfsd4_decode_nfstime4(argp, time_create);
 		if (status)
 			return status;
 	}
@@ -1013,7 +1013,8 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, union nfsd4_op_u *u)
 				    ARRAY_SIZE(create->cr_bmval),
 				    &create->cr_iattr, &create->cr_acl,
 				    &create->cr_label, &create->cr_umask,
-				    &create->cr_dpacl, &create->cr_pacl);
+				    &create->cr_dpacl, &create->cr_pacl,
+				    &create->cr_time_create);
 	if (status)
 		return status;
 
@@ -1165,7 +1166,8 @@ nfsd4_decode_createhow4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open
 					     ARRAY_SIZE(open->op_bmval),
 					     &open->op_iattr, &open->op_acl,
 					     &open->op_label, &open->op_umask,
-					     &open->op_dpacl, &open->op_pacl);
+					     &open->op_dpacl, &open->op_pacl,
+					     &open->op_time_create);
 		if (status)
 			return status;
 		break;
@@ -1184,7 +1186,8 @@ nfsd4_decode_createhow4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open
 					     ARRAY_SIZE(open->op_bmval),
 					     &open->op_iattr, &open->op_acl,
 					     &open->op_label, &open->op_umask,
-					     &open->op_dpacl, &open->op_pacl);
+					     &open->op_dpacl, &open->op_pacl,
+					     &open->op_time_create);
 		if (status)
 			return status;
 		break;
@@ -1512,7 +1515,7 @@ nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, union nfsd4_op_u *u)
 				   ARRAY_SIZE(setattr->sa_bmval),
 				   &setattr->sa_iattr, &setattr->sa_acl,
 				   &setattr->sa_label, NULL, &setattr->sa_dpacl,
-				   &setattr->sa_pacl);
+				   &setattr->sa_pacl, &setattr->sa_time_create);
 }
 
 static __be32
@@ -3646,7 +3649,14 @@ static __be32 nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
 static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xdr,
 					      const struct nfsd4_fattr_args *args)
 {
-	return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
+	const struct timespec64 *ts;
+
+	if (args->stat.result_mask & STATX_PTIME)
+		ts = &args->stat.ptime;
+	else
+		ts = &args->stat.btime;
+
+	return nfsd4_encode_nfstime4(xdr, ts);
 }
 
 /*
@@ -4089,8 +4099,8 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	}
 
 	err = vfs_getattr(&path, &args.stat,
-			  STATX_BASIC_STATS | STATX_BTIME | STATX_CHANGE_COOKIE,
-			  AT_STATX_SYNC_AS_STAT);
+			  STATX_BASIC_STATS | STATX_BTIME | STATX_PTIME |
+			  STATX_CHANGE_COOKIE, AT_STATX_SYNC_AS_STAT);
 	if (dp) {
 		struct nfs4_cb_fattr *ncf = &dp->dl_cb_fattr;
 
@@ -4113,8 +4123,8 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	if (err)
 		goto out_nfserr;
 
-	if (!(args.stat.result_mask & STATX_BTIME))
-		/* underlying FS does not offer btime so we can't share it */
+	if (!(args.stat.result_mask & (STATX_BTIME | STATX_PTIME)))
+		/* underlying FS does not offer ptime or btime so we can't share it */
 		attrmask[1] &= ~FATTR4_WORD1_TIME_CREATE;
 	if ((attrmask[0] & (FATTR4_WORD0_FILES_AVAIL | FATTR4_WORD0_FILES_FREE |
 			FATTR4_WORD0_FILES_TOTAL | FATTR4_WORD0_MAXNAME)) ||
@@ -4434,7 +4444,7 @@ nfsd4_setup_notify_entry4(struct notify_entry4 *ne, struct xdr_stream *xdr,
 		if (!setup_notify_fhandle(dentry, dp, nf, &args))
 			attrmask[0] &= ~FATTR4_WORD0_FILEHANDLE;
 
-		if (!(args.stat.result_mask & STATX_BTIME))
+		if (!(args.stat.result_mask & (STATX_PTIME | STATX_BTIME)))
 			attrmask[1] &= ~FATTR4_WORD1_TIME_CREATE;
 	}
 	attrmask[2] = 0;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 56c49b5bc5bb..286ed7c98d91 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -621,6 +621,23 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (attr->na_seclabel && attr->na_seclabel->len)
 		attr->na_labelerr = security_inode_setsecctx(dentry,
 			attr->na_seclabel->data, attr->na_seclabel->len);
+
+	if (attr->na_time_create) {
+		struct file_kattr fa = {
+			.fsx_valid = true,
+			.fsx_xflags = FS_XFLAG_PTIME,
+			.fsx_xflags_mask = FS_XFLAG_PTIME,
+			.fsx_ptime = *attr->na_time_create,
+		};
+
+		host_err = __vfs_fileattr_set_locked(&nop_mnt_idmap, dentry, &fa);
+		if (host_err) {
+			if (host_err == -ENOIOCTLCMD)
+				host_err = -EOPNOTSUPP;
+			goto out_fill_attrs;
+		}
+	}
+
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && attr->na_dpacl) {
 		if (!S_ISDIR(inode->i_mode))
 			attr->na_dpaclerr = -EINVAL;
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 38f7d36bd4da..24c2c22b3e72 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -100,6 +100,7 @@ struct nfsd_attrs {
 	struct xdr_netobj	*na_seclabel;	/* input */
 	struct posix_acl	*na_pacl;	/* input */
 	struct posix_acl	*na_dpacl;	/* input */
+	struct timespec64	*na_time_create; /* input */
 
 	int			na_labelerr;	/* output */
 	int			na_dpaclerr;	/* output */
@@ -118,7 +119,8 @@ static inline bool nfsd_attrs_valid(struct nfsd_attrs *attrs)
 
 	return (iap->ia_valid || (attrs->na_seclabel &&
 		attrs->na_seclabel->len) ||
-		attrs->na_pacl || attrs->na_dpacl);
+		attrs->na_pacl || attrs->na_dpacl ||
+		attrs->na_time_create);
 }
 
 struct nfsd_net;
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index ec198993429e..a495a20e5889 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -123,6 +123,7 @@ struct nfsd4_create {
 	struct posix_acl *cr_dpacl;
 	struct posix_acl *cr_pacl;
 	struct xdr_netobj cr_label;
+	struct timespec64 cr_time_create;
 };
 #define cr_datalen	u.link.datalen
 #define cr_data		u.link.data
@@ -277,6 +278,7 @@ struct nfsd4_open {
 	struct posix_acl *op_dpacl;
 	struct posix_acl *op_pacl;
 	struct xdr_netobj op_label;
+	struct timespec64 op_time_create;
 	struct svc_rqst *op_rqstp;
 };
 
@@ -378,6 +380,7 @@ struct nfsd4_setattr {
 	struct xdr_netobj sa_label;
 	struct posix_acl *sa_dpacl;
 	struct posix_acl *sa_pacl;
+	struct timespec64 sa_time_create;
 };
 
 struct nfsd4_setclientid {
-- 
2.56.0

