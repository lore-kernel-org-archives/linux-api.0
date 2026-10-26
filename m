Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052392;
	b=uXgKihRPKZXjuC2AgA/geSXUoC2jxcUkRJ8/oZgTgW9ihN/EM4jOwZA6rCKD5/FuqYLW
	 bJ0HONTIctIolSsutHiAftdYC9zXtgkdWmdMSmDJWV9LW8G82Gxe8QtVGIHJLDmoNZkHH
	 VhZIIDOF1Mp6+gO5CkAS83OYVOWC9NYH4Mr00BAkOBRKgiW+lz9LQuU3MUTnr7orFbFfD
	 LE55cQRWIbjYH4nbYSMetzr85KMCOKfr4DBBQHXVBGoRM1xk4D0XtkdUlgt1R2NEntckn
	 m6zJLvKF9sY46uZX8H7TZr9Y80Oh1jr6rdff6qkvh508P1bCbjEsz1ohbyEbsPU0B3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=J8qqAYIAfPgq1UPwTJslv5kHWAuX4fEMnW0g2gFuydk=;
	b=qTpYwbm1r3lmaACskC3P2pEy9wAw+RgBtGK5ElR/+lwKWgrvNwLBikPf+/70VQVi4TW0
	 1XXayW35OUpPOI3U9w4Z5THZkTyVBPepvSdWc2ip4FaYU/vYgL6y95QKpjFqIwcOEo2OV
	 cZaNPDQFDlsnwH9abcVfLXqCsDdLWYEtzLHkHErg0YLueCv9w9X7xbw1rQstf9rnz/332
	 X2Q9MoqLr4v2Tf+C8af6UMG4DqFVntCbw0Jd5XiUiXYEJvXZusyDH9KyOTCi7V07yNB5c
	 V9A/i8WfeE+wmh0J9b1nLfparOt1yJHhB0QXFbm7UOoghMi+6k0mxck6KHOIVvov9hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=pmobPYnf;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C2D606A31D
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 22:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57C2D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=pmobPYnf
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea0fe07201so23472555ad.1
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 15:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793052392; x=1793657192; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J8qqAYIAfPgq1UPwTJslv5kHWAuX4fEMnW0g2gFuydk=;
        b=pmobPYnfMJPqBM9Z2kYaYIgwBT2yWQssyZu5gvBp2NKVN36E2dDLYsrHEFRe5KgliF
         4hy5KUYQ+476vAgt4RxvQpkVgT+z4C+aVr6SO9j+NN4uSpNMMLDM5W0JOfLydG9X6W26
         6tsR2VHZYXtaoro27T7eQ65iH0o7KXbsGl60BUaOb4ytZCIg80t34G+1Gtoe2pjjoTy5
         lt99/WwCPg1IeTfNJgku25/LiVIBtv/XqyiRxtW4KE5QtbvBrofxt93NuHTLQ6zmplXo
         I1f0/BWxMB696eG2Zj1903ndtVAWoh2o/bIQVU5tCTp6NT2kXs1AbEzt/ADPI2wnNQfz
         aqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052392; x=1793657192;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J8qqAYIAfPgq1UPwTJslv5kHWAuX4fEMnW0g2gFuydk=;
        b=U0vMBK0dNHo4+RSz//G2muYY0BtZWmDfpVz31rLuGRskyVV0eIAx9s6ISurTYOsIZY
         mxP13+D3B6zSrI3flxm0EDXaXJFJtSaWWND0CsggyPKJ/Ng+D2KZ3iPDN23UKhPdndDw
         TpMV0CgtlWPqTA+cjSOYXtRGCIEBWwqBd3ic9udes1sZGgNFNJ1LHlyV1Ff8GVrR8nUD
         Tmw2KyDRtIOFkVKWMFzDQsRo/XhX/wv/T8FOgYFMBb7lPBdwrS6s3rO25q0TYdyQH6L5
         6VVi0uQSy0pMzbg0rhsU1pRTOGSG/EH5OPCDyQGQFHjpIL8eNOMtofhv6DJ2BolFqcyV
         SsoQ==
X-Forwarded-Encrypted: i=1; AKwUvBz/06XveDfYvPGLogQMrC154+Mc+8txmScrD/40gargNuG6RICFWm2/TG5Kws8wJtcgHYmWRbHnsJs=@vger.kernel.org
X-Gm-Message-State: AFq9FYJy7RV58vFwrVoa9MNq01ym96BKmhs7AdLO0ktWfavp8FSB6GE4
	FsS4dr5PBiflzlvyFRIDalLz55V7xEITxCmhwlArhBYac6icO84BEdOCQhrUk7m0R0kIs36mFZK
	kT6oKo74nRj/DbA==
X-Received: from plbjv3.prod.google.com ([2002:a17:903:583:b0:2ea:7f89:8fce])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4c4:b0:2e9:5c55:c46a with SMTP id d9443c01a7336-2ea9c03edbfmr70987685ad.7.1793052391484;
 Mon, 26 Oct 2026 15:06:31 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:05:45 +0000
In-Reply-To: <20261026220546.3114241-1-skhawaja@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026220546.3114241-2-skhawaja@google.com>
Subject: [PATCH 1/2] mm/memfd: add F_SEAL_PUNCH_HOLE
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Users of memfd_pin_folios(), such as udmabuf and iommufd
(IOMMU_IOAS_MAP_FILE), pin the folios backing a memfd range and keep
using them for DMA. A pin keeps a folio alive, but it does not keep the
folio in the file. If userspace later punches a hole with
fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE), the folio is
removed from the page cache while the pin still holds it, and the pin
holder is not told. From then on the device and the file no longer
share memory: data written by the device is not visible through the
file, and data written through the file never reaches the device.

udmabuf already requires F_SEAL_SHRINK so that truncation cannot remove
pages, but there is no seal that prevents punching holes without also
preventing writes. F_SEAL_WRITE and F_SEAL_FUTURE_WRITE do block hole
punching, but they cannot be used for memory that has to stay writable,
and udmabuf rejects memfds that carry them.

Add F_SEAL_PUNCH_HOLE, which makes fallocate(FALLOC_FL_PUNCH_HOLE) fail
with -EPERM on shmem and hugetlbfs memfds. MADV_REMOVE is covered as
well, because it is implemented with vfs_fallocate() and
FALLOC_FL_PUNCH_HOLE.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 fs/hugetlbfs/inode.c       | 3 ++-
 include/uapi/linux/fcntl.h | 1 +
 mm/memfd.c                 | 4 +++-
 mm/shmem.c                 | 3 ++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e8a05d3de327..65034b72b98e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -660,7 +660,8 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	inode_lock(inode);
 
 	/* protected by i_rwsem */
-	if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
+	if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE |
+			   F_SEAL_PUNCH_HOLE)) {
 		inode_unlock(inode);
 		return -EPERM;
 	}
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index e43e3de3e9ee..f9dd929adaf4 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -50,6 +50,7 @@
 #define F_SEAL_WRITE	0x0008	/* prevent writes */
 #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
 #define F_SEAL_EXEC	0x0020  /* prevent chmod modifying exec bits */
+#define F_SEAL_PUNCH_HOLE	0x0040  /* prevent punching holes */
 /* (1U << 31) is reserved for signed error codes */
 
 /*
diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e..3f0ef72fb301 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -227,7 +227,8 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
 		     F_SEAL_SHRINK | \
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE | \
-		     F_SEAL_FUTURE_WRITE)
+		     F_SEAL_FUTURE_WRITE | \
+		     F_SEAL_PUNCH_HOLE)
 
 int memfd_add_seals(struct file *file, unsigned int seals)
 {
@@ -253,6 +254,7 @@ int memfd_add_seals(struct file *file, unsigned int seals)
 	 *   SEAL_GROW: Prevent the file from growing
 	 *   SEAL_WRITE: Prevent write access to the file
 	 *   SEAL_EXEC: Prevent modification of the exec bits in the file mode
+	 *   SEAL_PUNCH_HOLE: Prevent punching holes into the file
 	 *
 	 * As we don't require any trust relationship between two parties, we
 	 * must prevent seals from being removed. Therefore, sealing a file
diff --git a/mm/shmem.c b/mm/shmem.c
index fd0953d55fd6..e79a298d6292 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3853,7 +3853,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
 
 		/* protected by i_rwsem */
-		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
+		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE |
+				   F_SEAL_PUNCH_HOLE)) {
 			error = -EPERM;
 			goto out;
 		}
-- 
2.56.0.307.g5fe7bd680c-goog

