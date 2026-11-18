Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037332;
	b=jm8LLXKPudSV+fwFaInROqDnxKWN6Jtn6Au4O5Cbc6MIXXG+wXvwxRQCyfHBccWompOD
	 EKtn+mrsgjTgK1ijoG9IX2rmIswjPFLBhYmZxhhhWQBc/LLpNQW+KXt7Uo3DidOsRyYBW
	 7GSVDMH6aQs9Wwic1245JLoFRfRkeTTfFH+HNWXj5xcA+mxeZgq+h2H2HDDx/66FMTjLv
	 aOzr9QLrtztrJCx0L2mTj4Bcg/5Zu3kigsxVENbRlRtGOXQEv4z9x9HeaRk59Nhpq1cKL
	 mAlVSt1E/HlO2rNLEDi/Aa9g6vsvNdE8cSz8Rvjx+KqYKMJpftuGtNghAsWh/rudoZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037332;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rcOKrKC5VH2EJYd32jje86IEEuy7ivHNpMjvoLy4Pag=;
	b=oDtQqB/2y2qCA+tLrykTcUceddiDDMFQmtpEoUKQsQTQ345sZm6WXGpccHoGj/IDGHpL
	 SL3fNmj6OPBBJxkxZa6KC3UbP6h6qCaVIoWvO49lQTHNev2vQ7C3WG259t6dhCV6WXLvO
	 Gy6FJFr/lprQKFLhnim9qzXCFWXRbApKV7/t/m3xFoTrUpGuDtmiA8TtirMieQTreMKR2
	 gNvyNExZbxms07A4xnJfYDoH3GiKh78IbohmOE+ruaYBn8urmGhKu1y3K6FLlE1lQnrBK
	 UDIhgNuvQHD3X2EHl+dEJmTfWUobyE3hWsuhCpMotomekeCUS51+r5q8iX2w24xWNAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=dKq2+911;
	arc=none smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DD8606A33F
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 21:28:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27DD8606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=dKq2+911
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7d2d1b4a83aso546152137.3
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 13:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795037330; x=1795642130; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rcOKrKC5VH2EJYd32jje86IEEuy7ivHNpMjvoLy4Pag=;
        b=dKq2+911V6f3mCCoT91q/B9EbEcgcYC0SU7+8anT0+yvtrnieQqhFUpIn0r5IIRTs+
         taFjPr07zKynB4iZMS//Evj2vbQH+Gk8TKX79XLD7/2Gy2i4L+bSwwZ+abqAQyxWLXsa
         rkPbQxZdq7LvVQK+iLNWnkQa5K8UZeEdioFzPaEZ8d1ehXcx40qoovh60BbUhGHO7Gog
         Zk/TNqn1xrtbFs/066P/9WgrQtxlV0WqdS7gtIhvsogGvcJyYchXWciHjPYTP4ncgl4y
         yTogek1Hjokaqs0C9ffnH6OWITg9H6AKkJDuBM5A81RWG/YPfP+MDPbn5fz7OgKPJtZp
         3Kkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037330; x=1795642130;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rcOKrKC5VH2EJYd32jje86IEEuy7ivHNpMjvoLy4Pag=;
        b=2lnYTMonK9EaR3XmB60k8H2QD9i1MP4UWx1FrV38UX9SG5ermfTRwTGM/NyI/kDNe4
         V5aEBtwMJeREYdDL1ipDYfO8I4I2Cq03ybTmxSRFYP/FaUVpLGvHfcxaq3u5IgSpicgT
         AVXayhRgx+YE70f3IHxbcA49iVGWBnKExuzrGkCDMVkMUQmFCiuv8rgd5hxrQkKUZnbw
         MmxBB2iC0KMzZHSBqcmsYxbPKuBJ3qRnxtcqtnP7nIClU71DkZmfQNS/16hjjLFmvkcA
         SliWflbVihHmB2LrFhIFt57pV5//PM38vSXLrv+Bo1nvxlfBhYfOff/5Mn0fjlLXzy9I
         ZqPQ==
X-Forwarded-Encrypted: i=1; AL+hErEyEPuO1I1QN/UTu++1es4MeGUtav85ytNLfn8He244VzCzRBpOg2ZS5iAllNCScA0NGj6OWtyefsk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9UWEl/QmlRKb85ZaUk5f+9nG4iHC5CYI74Y26M4pwoKchsUEAR
	PGd8yRbOobax1NXqg3uyuifUJmMa8bG0wIFkDpdMJ0P3cBXR7I542mLZBXs2lhSW4YY=
X-Gm-Gg: AYBFou35VlLid2e69yak/Ts+doAovKmkOSC1vbnqS2B6QnGiJ59d7wBf9H8Rnb/LUCt
	WO7njJDFlDMcxxyoX8zB1nehRr0m1eZ3yuIk+NysFby0A7n3kIG6D3ekgk7D2jwjBWzP8KrVnMu
	eGa4AMp4uyToi3xnA1Q9aYaQZQr/y7A6rWcY/MybVgggPpq6NLSp0U+qAMzh0DqnlPmse/HQIPq
	JmKhn0KTX+XOh1/tdoaKdwVKldsBv+mi5bjyeJyZUjCC6gXKLVm7Bb4YyIEVlFIyQ22X8b5Nvkx
	wJh6rRrxcGQmNBZmq0ac4xGeABeURICV3oas2x7zeiOcvY3WCyChT9SBfw897V/y/SeW/s9+v7l
	/fRpBlCTNiwA6nWPivNKUdtZS+mgd4OIAA2ojPWioavxbVTpFdSJF7zB3RJn8gTrQN+guEsw++b
	St+HPGuJBMTMMd8vSKFJ9GASVXnEsuJ6M8DUYZKPBZYo3b7qwaog5DvJvO0gSDaKQWnSU7bkYAl
	rfusQX/jV8+sHaPYA2r2v5iosHT43oQRkENOR1zJ0bQPV8nDIRSGe1CTCk166izDNnnsaTSaE+0
	stVA73L9fTpbDZcDlyzemDmrybqgB7C4/jL+F2HW+M1HbZQStBilodvW0yQ0htYE9+Q5/kA9R0W
	xoTPOw/qPsiU4r2dTyCBx/NEU6d9jXa5Xgq4J8JE9pc3PPKYH/1Zg
X-Received: by 2002:a05:6102:2d03:b0:7a7:196a:84ea with SMTP id ada2fe7eead31-7d6ba480612mr1670329137.34.1795037329535;
        Wed, 18 Nov 2026 13:28:49 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6b9185bc3sm2724635137.5.2026.11.18.13.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:28:49 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-api@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v6 1/7] liveupdate: Move file_set_ser handling to luo_session_serialize()
Date: Wed, 18 Nov 2026 16:28:36 -0500
Message-ID: <20261118212845.2855249-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In preparation for allowing userspace to freeze a session explicitly
before kexec reboot, luo_file_freeze() and luo_file_unfreeze() need to
be called on session->file_set before any struct luo_session_ser entry
is reserved in luo_session_serialize().

Currently, struct luo_session_ser is populated and cleared across two
layers: luo_session_serialize() writes and clears ser->name, while
luo_file_freeze() and luo_file_unfreeze() write and clear
ser->file_set_ser.

Drop the struct luo_file_set_ser pointer parameter from
luo_file_freeze() and luo_file_unfreeze() (and struct luo_session_ser
from luo_session_freeze_one() and luo_session_unfreeze_one()), and
populate and clear all fields of struct luo_session_ser in
luo_session_serialize().

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     | 24 ++++++++----------------
 kernel/liveupdate/luo_internal.h |  6 ++----
 kernel/liveupdate/luo_session.c  | 19 ++++++++++---------
 3 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..988eb313a135 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -440,8 +440,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_freeze - Freezes all preserved files and serializes their metadata.
- * @file_set:     The file_set whose files are to be frozen.
- * @file_set_ser: Where to put the serialized file_set.
+ * @file_set: The file_set whose files are to be frozen.
  *
  * This function is called from the reboot() syscall path, just before the
  * kernel transitions to the new image via kexec. Its purpose is to perform the
@@ -457,8 +456,8 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  *
  * 2. Serializes Metadata: After a successful freeze, it copies the final file
  *    metadata—the handler's compatible string, the user token, and the final
- *    private data handle—into the pre-allocated contiguous memory buffer
- *    (file_set->files) that will be handed over to the next kernel via KHO.
+ *    private data handle—into the pre-allocated serialization blocks
+ *    (file_set->block_set) that will be handed over to the next kernel via KHO.
  *
  * Error Handling (Rollback):
  * This function is atomic. If any handler's .freeze() operation fails, the
@@ -471,8 +470,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  * Context: Called only from the liveupdate_reboot() path.
  * Return: 0 on success, or a negative errno on failure.
  */
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser)
+int luo_file_freeze(struct luo_file_set *file_set)
 {
 	struct luo_file *luo_file;
 	struct kho_block_set_it it;
@@ -506,9 +504,6 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		file_ser->token = luo_file->token;
 	}
 
-	file_set_ser->count = file_set->count;
-	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
-
 	return 0;
 
 err_unfreeze:
@@ -519,28 +514,25 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
- * @file_set:     The file_set whose files are to be unfrozen.
- * @file_set_ser: Serialized file_set.
+ * @file_set: The file_set whose files are to be unfrozen.
  *
  * This function rolls back the state of all files in a file_set after the
  * freeze phase has begun but must be aborted. It is the counterpart to
  * luo_file_freeze().
  *
  * It invokes the __luo_file_unfreeze() helper with a NULL argument, which
- * signals the helper to iterate through all files in the file_set and call
- * their respective .unfreeze() handler callbacks.
+ * signals the helper to iterate through all files in the file_set, call their
+ * respective .unfreeze() handler callbacks, and clear the serialized blocks.
  *
  * Context: This is called when the live update is aborted during
  *          the reboot() syscall, after luo_file_freeze() has been called.
  */
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser)
+void luo_file_unfreeze(struct luo_file_set *file_set)
 {
 	if (!file_set->count)
 		return;
 
 	__luo_file_unfreeze(file_set, NULL);
-	memset(file_set_ser, 0, sizeof(*file_set_ser));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..01a172cd9d7a 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -103,10 +103,8 @@ int luo_session_deserialize(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser);
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser);
+int luo_file_freeze(struct luo_file_set *file_set);
+void luo_file_unfreeze(struct luo_file_set *file_set);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74bc66929f4b..6dea35911181 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -219,18 +219,16 @@ static int luo_session_finish_one(struct luo_session *session)
 	return luo_file_finish(&session->file_set);
 }
 
-static void luo_session_unfreeze_one(struct luo_session *session,
-				     struct luo_session_ser *ser)
+static void luo_session_unfreeze_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+	luo_file_unfreeze(&session->file_set);
 }
 
-static int luo_session_freeze_one(struct luo_session *session,
-				  struct luo_session_ser *ser)
+static int luo_session_freeze_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
-	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+	return luo_file_freeze(&session->file_set);
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -657,13 +655,16 @@ int luo_session_serialize(void)
 			goto err_undo;
 		}
 
-		err = luo_session_freeze_one(session, ser);
+		err = luo_session_freeze_one(session);
 		if (err) {
 			kho_block_set_it_prev(&it);
 			goto err_undo;
 		}
 
 		strscpy(ser->name, session->name, sizeof(ser->name));
+		ser->file_set_ser.count = session->file_set.count;
+		ser->file_set_ser.files =
+			kho_block_set_head_pa(&session->file_set.block_set);
 	}
 
 	if (sh->count > 0)
@@ -676,8 +677,8 @@ int luo_session_serialize(void)
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
 		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
 
-		luo_session_unfreeze_one(session, ser);
-		memset(ser->name, 0, sizeof(ser->name));
+		luo_session_unfreeze_one(session);
+		memset(ser, 0, sizeof(*ser));
 	}
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);

base-commit: 079c138d2b6870bb658b6e638077264aefc03833
-- 
2.56.1.708.g77570a6a1d-goog

