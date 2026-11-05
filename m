Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907476;
	b=HGyHLIu9PtrtuRteX+1jIrY/u7vzQdhBWPlGMFXj8fgc8jbEKhMKhc/atyij00Ab1kPJ
	 DIqoheIj6bNwhf0ndC95qAn7tfi0a2X3n6jOdDjIqel2WItKKWKxVqrkSb9huZBrufzd+
	 OzwRsmH8+E3tdtSboT/Zm/VCIvVwADXgK9772Jxgjssad7cYMys838jrM1wR+9hewkFb2
	 AiBSPjaBljyyBrUC5gb0ezLBQmFDwXGTg1gN+Hr37tK2uPsf1gYOLSN/bervmkEzgORDd
	 ldfoG0ou1rMqjd2aZhFPONRiYSQsFQvxxQLCJ5gWxD7qty+bqtTZ+FfcN7U91vR0PkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3ALiLRgUIlPUP7r35NUTeM7wiuqIXdzicUpxLmxb19E=;
	b=TUGKAhhf5kvR8S2/MNGjkBIO8lPi6SjWFockRjHZu+wRbSpriNq643DCU6knfbNeFe+O
	 MOYU6X745A+CPQtTbWM+7W4u2OVeyNGBDrK4Gn/7EAAHOhdoSVWRoLkgAbpxKgmxGbXFy
	 BSe3uhjtjwz4BZ+wS5bXUzfan3f9UE2XC6ameatvidC1B1N4yLtBhZsuFNm3UtNF4BB+j
	 0hhfgb6lqvRmjkT/Bm62dc1auxQXWB4WAqUIUqVVc3MuQQ40BfDjDyiuiVCAJLToregpZ
	 Q/z3hYSyS2PH6hx54xHTmJYkkfqrME0Po3xqEzwBd/ESjJrTkWMifsLPfnLkayYj6Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=CtJWa3tE;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5042606C8A6
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 19:37:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5042606C8A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=CtJWa3tE
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36d6765756fso2917130eec.1
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 11:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793907474; x=1794512274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3ALiLRgUIlPUP7r35NUTeM7wiuqIXdzicUpxLmxb19E=;
        b=CtJWa3tEL/dQ/RdyYOmPv2dc/ZxWSmCzdkel6b5w4cFqUR8L8Yi6Jqvw3+gCKmj1Wb
         8F2PKydr3mpYlrF8QH3i7YW/bayrWHul9bNjqh+POZbqKFiRA8ayJ67ofnOCXF+sQIcp
         mYJ3+ovEP8dkI6pcu9/gDn0ViYnsz86zDwEZdGq/yHQDWuWIqJN+tcZFgE8J/4OINklC
         A3S8WWTFwSLWNOiYD0tjjK366TSXcc98utBOaoeROKpMMcYhCu2LFzpCHZWbEUJoLF8+
         hpvZa1olcHLdvPqnS1eJtevWQK3BISF3T9V9gHs6DqgAFfkmwshhrXpzShEuswdCN2pq
         U8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907474; x=1794512274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3ALiLRgUIlPUP7r35NUTeM7wiuqIXdzicUpxLmxb19E=;
        b=1X3dWtxD0Mco3rvDzUBYMzZUFtx5QPvoksriLH45QDrvvXLkA6VLFbETC4boc2hAWG
         2SlI0i8rxL3bBrG4agv8FE85Tx8ZvqhrgXHaoQ1uYpRjyMs4qByzjfzF9B4AvdOQelHu
         LN8Skoyi+iTvU/YNgxd7pxv3J0mPv6cBNkXy55wvbzzfOSJPrO6ORhHH6Whm+CXLUUwV
         mvxrfeIvy6g4EMnMYX5rUTyv+4z/Lx4+yXVrUlwW08lSieakuu5hCj9jBC2xYEIasVzZ
         K05WlX4EajoSqYRXEQFcMwKDE40EUz/PTQJRkAjTLkiDGWmlZVriP54M53Ms7OnMYLjG
         c8Kg==
X-Forwarded-Encrypted: i=1; AKwUvBw3f2IZQsoM5WyuTKPJyG2oqhm4jBCcAZttr9rL2HeOhDlcnMsdQOvqtCiItz34laekDPjE8vRqEYg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9oYbXvmnoL62/I/1ruiWfMpCDP0MP9ks9nts91dlCZU7KBPoxQ
	yrqJ3lVALRaE6YmM4eqhsG3P8STyUtcAyBVhzzlJJetvmK6K/G2pvw7Fb+dtfow9TA==
X-Gm-Gg: AYBFou2erz4EZ/A5ox5aa+CHz0wtumMb5MrtCdU3YHcFb7xwKpBy3jXGx6G99VuSiBI
	u8qy51u6lxnS+hqFCrcLOWImAaPcRpPZMYRWVeWmqUtGKAWCWDkbzR9S7H2BelFnRGsouW11HL2
	Rx1h69PAwU9vrf0Rp4aGg2fdJs8OEbA+rhcj5+wb0KGEUZXlEXAcq3aC2A6lpZb5br0b5EVyd13
	uvOA9b4suik5lQ+8kIALOFzB+RRhmqt98BnS7Ewu8lRfZlsqv1FgTOl/ylqMPvBFDIsy31bxBWR
	oEg/HKFD1/sD+jb8vmUbAE14l6znF1f9OemRS5YOmkFrsD1LXSlxElRD4OYUkDa0ZKSFk2YSfxW
	UtLdxwGzqmkAtJvhSSEtJKk0npZNukhoRRNyx6siJKh9laoVBp7R+u0TGwkn6k3YM5xpoY1R6Sp
	D/wheeAxZaFjgUD+MunyARojXuHXZ1ePcfSLE34ORplzGLU2NuvYQNcwD4fnMntwSvLXV8GwRvB
	0+jj3iX0zdxuAKBq0E5JsoKISJvzlqnEI/670kqiYr3BTpJ3+0TVAYWo53zGW5W7SaQLYOmxAEu
	aUwWBMdndYIljjyVvMZ19xr2d/B5NCocpIBBEdaFgrWb7S9gKZdBspup2/hYpbAnrCXzn0SEMLI
	OvyybTFIAZLw8xhajXmo4tbg=
X-Received: by 2002:a05:693c:40c8:b0:36d:2b02:86a6 with SMTP id 5a478bee46e88-36f72cc1ae3mr274930eec.4.1793907473472;
        Thu, 05 Nov 2026 11:37:53 -0800 (PST)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72ec8a02sm326134eec.11.2026.11.05.11.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:37:53 -0800 (PST)
From: Danny Hu <dannyhu@arista.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Victor Kamensky <kamensky@cisco.com>,
	Taras Kondratiuk <takondra@cisco.com>,
	Zheng Zengkai <zhengzengkai@huawei.com>,
	zhangguangzhi <zhangguangzhi3@huawei.com>,
	Danny Hu <dannyhu@arista.com>,
	Jason Yan <yanaijie@huawei.com>,
	silviu.vlasceanu@huawei.com,
	hpa@zytor.com,
	arnd@arndb.de,
	james.w.mcmechan@gmail.com,
	niveditas98@gmail.com,
	pierre@arista.com,
	julien@arista.com,
	kbharathi@arista.com,
	alexandr.lobakin@intel.com,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bug-cpio@gnu.org
Subject: [PATCH v6 0/4] initramfs: add support for xattrs in the initial ram disk
Date: Thu,  5 Nov 2026 11:37:39 -0800
Message-ID: <20261105193743.2654656-1-dannyhu@arista.com>
X-Mailer: git-send-email 2.51.0
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

This patch set aims at solving the following use case: appraise files from
the initial ram disk. To do that, IMA checks the signature/hash from the
security.ima xattr. Unfortunately, this use case cannot be implemented
currently, as the CPIO format does not support xattrs.

This proposal consists in including file metadata as additional files named
METADATA!!!, for each file added to the ram disk. The CPIO parser in the
kernel recognizes these special files from the file name, and calls the
appropriate parser to add metadata to the previously extracted file. It has
been proposed to use bit 17:16 of the file mode as a way to recognize files
with metadata, but both the kernel and the cpio tool declare the file mode
as unsigned short.

The changes in v6 address issues identified by the Sashiko AI review.
v5 revision:
https://lore.kernel.org/linux-fsdevel/20261030210944.2143778-1-dannyhu@arista.com/.
The major difference from v5 is that this revision introduces a new state
in the initramfs parser that specifically handles buffering metadata entries
in memory. This has the benefit of preventing a metadata file from being
created in the rootfs, eliminating the need for a metadata flag and
separates metadata collection from do_copy. Sashiko identified the lack of
support for POSIX ACL xattr restoration; while this is true, the primary
use case of this feature is restoration of the security.ima xattr for IMA.
Therefore, POSIX ACL xattr restoration is out of scope for this patchset
and can be implemented later on when needed. This revision also adds xattr
length validation, bounds checks that prevent overflow, improvements to
tracking of the metadata target and fixes to gen_init_cpio to handle a
NULL ptr and to define the __packed macro.

This v5 revives Roberto Sassu's v4 series posted on May 23, 2019
(https://lkml.org/lkml/2019/5/23/415). The github issue tracking the
revival of this patchset is here
(https://github.com/linux-integrity/linux/issues/11).
This revision incorporates unpublished changes
from other contributors that can be found in
(https://github.com/linux-integrity/linux/tree/initramfs-xattr-v1-devel-v1)
and adapts the implementation to newer kernel interfaces. Compared with
v4, this revision adds an IMA deadlock fix for restoring security.ima
xattrs during initramfs unpacking, switches to a Kconfig choice for
metadata type selection, and updates gen_initramfs.sh to pass source
paths to gen_init_cpio for nonregular entries, allowing their xattrs to be
read from the correct source object that will be included in the archive.
This revision also includes various improvements to error path cleanup,
debug output and tool documentation.

The difference from v2, v3 (https://lkml.org/lkml/2019/5/9/230,
https://lkml.org/lkml/2019/5/17/466) is that file metadata are stored in
separate files instead of a single file. Given that files with metadata
must immediately follow the files metadata will be added to, image
generators have to be modified in this version.

The difference from v1 (https://lkml.org/lkml/2018/11/22/1182) is that
all files have the same name. The file metadata are added to is always the
previous one, and the image generator in user space will make sure that
files are in the correct sequence.

The difference with another proposal
(https://lore.kernel.org/patchwork/cover/888071/) is that xattrs can be
included in an image without changing the image format. Files with metadata
will appear as regular files. It will be task of the parser in the kernel
to process them.

This patch set extends the format of data defined in patch 9/15 of the last
proposal. It adds header version and type, so that new formats can be
defined and arbitrary metadata types can be processed.

The changes introduced by this patch set don't cause any compatibility
issue: kernels without the metadata parser simply extract the special files
and don't process metadata; kernels with the metadata parser don't process
metadata if the special files are not included in the image.

From the kernel space perspective, backporting this functionality to older
kernels would require adapting adding the dedicated CollectMetadata state
along with the pathname target tracking. From the user space perspective,
unlike the previous version of the patch set, it is required to modify the
image generators in order to include metadata as separate files.

Changelog

Changes in v6:
- Document that POSIX ACL restoration is currently unsupported
- Validate xattr name and value lengths and compare metadata header and
  entry sizes to remaining buffer when performing bounds checks to avoid
  pointer arithmetic overflow
- Introduce a dedicated CollectMetadata state to consume METADATA!!!
  entries in memory. This replaces the metadata flag and avoids creating
  the metadata entry as a file in the rootfs.
- Verify metadata entry checksums before restoring xattrs
- Initialize and improve tracking of the previous_name_buf so skipped or failed
  entries do not leave an uninitialized or stale metadata target
- Fix gen_init_cpio handling NULL path ptr and define __packed before
  including the shared metadata header

Changes in v5 relative to v4:
- Rebase onto vfs.all
- Add an IMA fix to avoid a deadlock during initramfs metadata restoration
- Use u32 metadata record lengths and reject records smaller than their
  header
- Improve debug output for binary xattr data
- Cleanup metadata buffers at the end of unpack_to_rootfs() 
- For CONFIG_INITRAMFS_FILE_METADATA, replace the metadata string prompt
  with a none/xattr choice
- Fix resource cleanup and format specifiers in gen_init_cpio
- Update gen_initramfs.sh to pass source paths to gen_init_cpio.c for
  nonregular entries (slink, dir, nod). Modify gen_init_cpio to
  properly collect xattrs from the source object. Without this change,
  xattrs will not get included for slink, dir and nod.
- Add documentation of xattr option in usage() for gen_init_cpio

v3:
- include file metadata as separate files named METADATA!!!
- add the possibility to include in the ram disk arbitrary metadata types

v2:
- replace ksys_lsetxattr() with kern_path() and vfs_setxattr()
  (suggested by Jann Horn)
- replace ksys_open()/ksys_read()/ksys_close() with
  filp_open()/kernel_read()/fput()
  (suggested by Jann Horn)
- use path variable instead of name_buf in do_readxattrs()
- set last byte of str to 0 in do_readxattrs()
- call do_readxattrs() in do_name() before replacing an existing
  .xattr-list
- pass pathname to do_setxattrs()

v1:
- move xattr unmarshaling to CPIO parser

Danny Hu (1):
  ima: skip algorithm availability check until initramfs unpacking is
    finished

Mimi Zohar (1):
  initramfs: add file metadata

Roberto Sassu (2):
  initramfs: read metadata from special file METADATA!!!
  gen_init_cpio: add support for file metadata

 include/linux/initramfs.h             |  19 +++
 init/initramfs.c                      | 206 ++++++++++++++++++++++--
 security/integrity/ima/ima_appraise.c |  25 +++
 usr/Kconfig                           |  19 +++
 usr/Makefile                          |   3 +-
 usr/gen_init_cpio.c                   | 221 ++++++++++++++++++++++----
 usr/gen_initramfs.sh                  |  15 +-
 7 files changed, 460 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/initramfs.h


base-commit: 2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
-- 
2.51.0

