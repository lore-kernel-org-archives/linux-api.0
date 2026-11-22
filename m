Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306154;
	b=zZwDJEukmQC/V6OBjhwetM5Sie59H25oZcgZ4jRd2dkRno2pvyzVVyB5CQjwqFgIPFh+
	 anPepsMg0UrzTy2ZRt/RAUlQij5B2TiG/tQp/aj0oiEzJiMnXLoDhC7ekR4sdrEXacMKg
	 DJ3583LYlcrAXzYEPv+AcLqt7pNuwOHxuHElMmWGBEAzpsHdBp5mqI12Rvdo9ZC/zUrEM
	 ze1F1biO2hlwNQYBh11EilaszUBTqXXuBBUjrtXE4QvJgFb0A3FeamIl+BZm52WbYbCM9
	 cP+NSbVzbHLNDfB5QdYtZXACZ4gyFqerc2yqSE2a6/fP+5vdxcvEVmSjF2a/OvzeVNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306154;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=m+aU85cIm+C4zcua0cgiJZNThrvCIO+uOHsPRDd+6Js=;
	b=qmzeZ6Qw+BBSC2jdDhLXVxGfHIlWcUUuDcOqs6Wa6QL39uxxJer7zzguM3LmToMDuxdX
	 7rswquK1cQeXeF68JyJWoe6c3Mhw0OyAqShf88dH/c2OtSy6KLLa1WuCbgb/fvykIrq0y
	 CM0DVr6fZqVA0KPWxFgB0/ryF9V4bH1xLRn26HvvOcNt91H8FkoAExYBYW4VwGwn+1f/Q
	 mOxO03GB3TNTh4Kytfncdc5D3vGmgZwL1BxSVla87MDnG9GQtN40B8Yv90LyILxQoCMib
	 wvkrOKYnnDq6QNDzGgVFn7vdjferOpsNxdXAFHHu6wvbkY42YxfXUmW76doOMqOHu9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uPs1eFKA;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B46D606A333
	for <linux-api@vger.kernel.org>; Sun, 22 Nov 2026 00:09:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B46D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uPs1eFKA
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso1527126f8f.0
        for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 16:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306152; x=1795910952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m+aU85cIm+C4zcua0cgiJZNThrvCIO+uOHsPRDd+6Js=;
        b=uPs1eFKARZ3CMN/dT8oiRSxugGoFsYDdKXUnYIxGeix5KMAnxe4Q/d3FUpwvXWQNDW
         o3jCvaS8IC75goOsIwb2FpTZGzUiWy+pD/MtACLf4+8QxBVD1zUb/CcM10TR+oe7hIC9
         ju7ZcTGtcQjR3mityRZLNrZ/e9JBOUbyO3B5/RTwvvo9luBkMORWvPlVla22R7BogrFZ
         HP9hMHhopm0Wdj5qdfeTfiAo6V158aCiuK7tgveO6P9LdGfRfXXr6qiA6kvyFiQQ6kN6
         rFHku0ETJBqZYY8cG6bhmTTz4YY9ztpesuz0kc57HvDPn26dQ8CY/N7rAhgU5MWJTDT4
         9x0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306152; x=1795910952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m+aU85cIm+C4zcua0cgiJZNThrvCIO+uOHsPRDd+6Js=;
        b=Sfuuo/9SJFc6ZaQnAVy4657R4ICTYPyws1vgwjGvRYQc7vL0zhsmcMDr2kpAy1CYjg
         G/plRMNNKW8hIS9WY+w3/0TNomY5gbPhfUC7KeHV04byrotIsQQyJ6QayUagq6IbZEio
         fJFOvx9S0ecrSy3oeGoTxccNAhbCpR9AVg68qkldGnVkMclubape7WX0TP1sgT+d5cr1
         g2TB9V/O4k6iLNhppbCl2Rlub7ptz+t5IHmFCAYL/cA7QAypiXFta2iAUQiJUwpSdj2f
         GvgzoY7gyOydAaACZZ07G2m5+t5CQcrxNR3z+o1Hcuqoh0+yRKsb9A4dW8+ROiLkUdoB
         MA8g==
X-Forwarded-Encrypted: i=1; AL+hErGwisLfy6c+JJBt0WJSy2WbxBV1TnVmcck9aV/wRC3isUv1tQBsNx2madlkj16NhXrbDf+KY4T6ug0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/q7DO6ptR6M6zG+AHwrSrFpUjU9w+Hco6lEUNME1vGzsQ+4i5y
	+vefMm3a+RY1sBP1ENhuuNdpl1IwMvc+7OR7bDgR/xY6WpeTHVAKf4uw
X-Gm-Gg: AZFdTZcxWaJXK8IHP8RQqMEaguk6dBtq9Fq3cdx8gtk5xJ4rxEKCMU6kTpoeBwCpUJI
	3CyXLNkeYDusdxkLTPz1K6IVgKXUhHMdvK3teME/DnSpRZIBt5fWcLtx5/8ZreJsUfms5d8I1hc
	+doe3pyKocOXA6Gi57s8IrVsKJ8JjcGYG5EqknfVc2OGRN37/vo/YtVjNIBjXVdPMcRbdTCnXrO
	ERZqk9dGnOUTG2HuxSCDcdDe/1XcsfelLT6n9A6UtyNaIlhiD3hOSB/eDPVyRBGWzJXuO7zVBNV
	x9wBJcX8jCQrhfLOUSzz2oi92TNbrAVwgJl+9UqQ1jJEa9HmGpAknxhaemXWC77qsR0AYN+DJ/C
	nMZl8Cj6sElsDhl5iG0RUYApbuGNCUJoofQzS/KB8Fwy5t2RZCbXDOvwV7lIXjf8hkEZBCbbiys
	989jNtBoZtJ5fqWX65ItxoHWUUaZSYB+X+QijeLRT0eRRrQrvXxKsRuSIdfStPfKv8cg1tfxHKM
	g/rv26OIguZR8G2Ylvg8TvFMKMzi7/S9kxip++EhCHMvWBGDfpZUHrI5GbxVekrFiTLzMKO6ecU
	a55c31+5nufrw2D0mOZF0YcSsw==
X-Received: by 2002:adf:e011:0:10b0:48d:f99d:a0d2 with SMTP id ffacd0b85a97d-4abb2168f53mr10514425f8f.15.1795306152315;
        Sat, 21 Nov 2026 16:09:12 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:10 -0800 (PST)
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
Subject: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr API
Date: Sun, 22 Nov 2026 01:08:53 +0100
Message-ID: <20261122000856.536902-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
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

This is a follow up patch series stemmed from [1] and [2], splitting the
_mask change for the fileattr API into its own separate patch.

The first patch is a preparatory patch so that the code in the patch
after can be formatted better.

The second patch is the actual implementation, which introduces:
- fa_xflags_{rw,ro}_mask fields to struct file_attr
- fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_kattr

These masks have the following semantics:
- rw_mask:
  * for filesystems: advertise which xflags they support changing
  * for userspace: specify which xflags it wants to modify
- ro_mask:
  * for filesystems: advertise which xflags they support only reading
  * for userspace: ignored

(ro_mask for userspace was also proposed as a "verification mask"[3] but
I left out that semantic to keep this patch series more contained, and
can be added later if needed.)

This allows userspace to not have to do a RMW cycle when using the
file_[gs]etattr() syscalls, avoiding possible race conditions and
simplifying their usage.

Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
programs like chattr can leverage the new mask API.
FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
will be used moving forward for any new xflag (like the one proposed in [2]).

Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
filesystem drivers too.

The series has been tested across NTFS, ext4 (with project quotas), XFS
(project quotas and extent size hints), and Btrfs.

Thanks,
koraynilay

[1]: https://lore.kernel.org/CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com/
[2]: https://lore.kernel.org/CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com/
[3]: https://lore.kernel.org/CAOQ4uxjCN-ekd18R-soD8tkGFnXjK0S1VdSNhq9b3Ev6y8K9jQ@mail.gmail.com/

koraynilay (3):
  vfs: use goto out on error in vfs_fileattr_set()
  vfs: add xflags mask to fileattr API
  ntfs: switch to the new xflags fileattr API

 fs/file_attr.c           | 179 ++++++++++++++++++++++++++++++++-------
 fs/ntfs/file.c           |  63 +++++++-------
 include/linux/fileattr.h |  13 ++-
 include/uapi/linux/fs.h  |   9 +-
 4 files changed, 197 insertions(+), 67 deletions(-)


base-commit: 3857587d9d6fa44d40d1c73bde6a39f6f7a5216c
prerequisite-patch-id: 7af19117a27af492e3e525774310fb3a76700ffa
-- 
2.56.0

