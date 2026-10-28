Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225911;
	b=l+Gyr68wzEFhANBCyrkvQoZZw4n3eioJ5HZJJv9QVhRwCXovlUgGgOaujh+OAyysAocS
	 XcTSkcYQRPKaSQtPjI0YpFK297KLJZyfcd0jlpoHJcvH7y8kvPQJWIajBOVr/k5pcevna
	 a5p0t9n+eyqTbIjKWFgUMsFEvi5b+tThBqE4MtcFkXZJ135fU6AfLkT3KHjwzjZnbzOS1
	 NeMDnzfBid0jJvuoYOZsHpVAuDouH8o+HgifUunGxg1Uh7Ekil2zFIiuGM26qlYCN/Yx1
	 N0D5qjkI2qPl6MmFjxdzWxrQJuekjmjgU/75LvQbJPuyiXwyIj7a61YC6YgHScVQwmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225911;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=IliLvxEFhtUoKzlsMTRJTupCYDKTYP3W6Uvf0vlrqBM=;
	b=drIWt6A1GlzUK5Riv/AdtMnHKl9VtB7g3r6K2PHpxvIQMvoHghgEjbTQ8rCNQ3oPQBD+
	 djs/HfnpfCpZL5Hu3mTq6ZMpdAEfLBkwzORXjBiLTnTkc/2rnqDwNOflvWyxhd6+DD61R
	 J0GuSTIFCKg2XLNJfJZrHm5VlpSZrf20p9YsrS0WQcupGDNZ8jmkDQt4HhPzJ3vsZ9OLW
	 VVHkXPq+YYoxromACz3s9F4SZPd7IsePEsdZYTq5VGyZ8Z/CnHaZcc8zpVhkeUx3LVANL
	 +9mcFwC+sFsI/9d6t8K6aurhTTdoRiVT8UbNj4tFJYNQgTYPhlih9OpMoYgvx+eQkog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gYALcxqy;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (unknown [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFC460A6F76
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EFC460A6F76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gYALcxqy
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c41b03cd1dcso129296866b.3
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793225895; x=1793830695; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IliLvxEFhtUoKzlsMTRJTupCYDKTYP3W6Uvf0vlrqBM=;
        b=gYALcxqyt70MQ79J9EPFtsq/ZeSTxirIEH01aK2bomk/GvpfcsAjBJqb4Y09rzuNLt
         mO44k7f46rtJ9wunMGpfQFt9lPWqgkNaiFl0SALdNHuEVLvyiq5kt/KV0iSWPCT3tP1c
         zWS2yVnyhtdinRcEUS5DF+dd6ZPtqU4//4OhOvSQSXIQEeSpBlOhVgl5N3HoKZ8HyqgM
         0mOlVcGpmjZAg21fMo5VhSqBp3oUNBCE57ekigI3J8RJl6Rr/QajW+JDtCDvJeRQt3ph
         p+hNl2pv82gkoFDKvZA/guZs8SZ56A95NQsHaEdHFIKKnIsIwK+zXnT381OZUxwV0rNz
         Rg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225895; x=1793830695;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IliLvxEFhtUoKzlsMTRJTupCYDKTYP3W6Uvf0vlrqBM=;
        b=JcniryZBpGKNgm8J6Vjwg6O1pnxu5mt14EqLtBZseZqP/wjplsC6norwMTb3b9Ze7J
         MfqqwTyr37xsafLaLzpX5uxOp21PCmFxCBcXt1++9qok8Zx7Hz8ZSdXReEd9NMimtq8B
         oRvJzezUmumR3drU/w29+OhAkKq23G9cxHOMh8y5hj753wUfFdJmBKv3EfOUNCgrzaJN
         JzEq9RTghjIzzMIuUWX9bnekmtx1f46w/wE0i7rUQPdgzqv6TZjRPRogDblrlZvqdNqJ
         6Ua2gte7aLkv9IcMF0hJRiMTEeBOuf7mnDRt/iIhjRDrGLeEZIN4gkGp5wQTDJ3IMSrj
         2GRw==
X-Forwarded-Encrypted: i=1; AKwUvByNIR3j4tQFnE4xOn1f8aEuwcIWAfRrsmYzvDdtwfd2rsxdFXpR04KqKZZJFQpenljlEWm40fN+ww4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKQycgd+pPPMM5Pbsfi+xmSv7S4arViGmUH4Vl1snUtQrc0b/F8
	z0FrXtAKCNuzNzsVE+fBSwX2I9PiRCvYRL7+CcIM7Piu3Jg0QmKwJuESPsnt9Xc0eIEl5YXwBA=
	=
X-Received: from ejad9.prod.google.com ([2002:a17:906:409:b0:c32:473d:4a4b])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3f88:b0:c40:80eb:c54e
 with SMTP id a640c23a62f3a-c49bddac533mr311667066b.4.1793225894675; Wed, 28
 Oct 2026 15:18:14 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:17:01 +0000
In-Reply-To: <20261028221705.3915340-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028221705.3915340-5-halg@google.com>
Subject: [PATCH 4/8] nsfs: add NS_USER_GET_INFO ioctl to inspect user
 namespace capabilities
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

With the introduction of a capability bounding set for user namespaces,
userspace needs a way to inspect the capability ceiling enforced on a
given user namespace.

Introduce the NS_USER_GET_INFO ioctl on nsfs file descriptors to query
user namespace metadata, mirroring the extensible structure pattern
used by NS_MNT_GET_INFO.

Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 fs/nsfs.c                 | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/nsfs.h | 17 +++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index c3b6ae76594a..50711362d792 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -170,6 +170,17 @@ static int copy_ns_info_to_user(const struct mnt_namespace *mnt_ns,
 	return 0;
 }
 
+static int copy_user_ns_info_to_user(const struct user_namespace *user_ns,
+				     struct user_ns_info __user *uinfo,
+				     size_t usize, struct user_ns_info *kinfo)
+{
+	kinfo->size = min(usize, sizeof(*kinfo));
+	kinfo->spare = 0;
+	kinfo->cap_bset = user_ns->cap_bset.val;
+
+	return copy_struct_to_user(uinfo, usize, kinfo, sizeof(*kinfo), NULL);
+}
+
 static bool nsfs_ioctl_valid(unsigned int cmd)
 {
 	switch (cmd) {
@@ -194,6 +205,8 @@ static bool nsfs_ioctl_valid(unsigned int cmd)
 		return extensible_ioctl_valid(cmd, NS_MNT_GET_NEXT, MNT_NS_INFO_SIZE_VER0);
 	case _IOC_NR(NS_MNT_GET_PREV):
 		return extensible_ioctl_valid(cmd, NS_MNT_GET_PREV, MNT_NS_INFO_SIZE_VER0);
+	case _IOC_NR(NS_USER_GET_INFO):
+		return extensible_ioctl_valid(cmd, NS_USER_GET_INFO, USER_NS_INFO_SIZE_VER0);
 	}
 
 	return false;
@@ -360,6 +373,22 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		ret = fd_publish(fdf);
 		break;
 	}
+	case _IOC_NR(NS_USER_GET_INFO): {
+		struct user_ns_info __user *uinfo = (struct user_ns_info __user *)arg;
+		struct user_ns_info kinfo = {};
+		size_t usize = _IOC_SIZE(ioctl);
+
+		if (ns->ns_type != CLONE_NEWUSER)
+			return -EINVAL;
+
+		if (!uinfo)
+			return -EINVAL;
+
+		if (usize < USER_NS_INFO_SIZE_VER0)
+			return -EINVAL;
+
+		return copy_user_ns_info_to_user(to_user_ns(ns), uinfo, usize, &kinfo);
+	}
 	default:
 		ret = -ENOTTY;
 	}
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 007fed5971b4..d2996d47c857 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -44,6 +44,23 @@ struct mnt_ns_info {
 #define NS_GET_MNTNS_ID		_IOR(NSIO, 5,  __u64)
 #define NS_GET_ID		_IOR(NSIO, 13, __u64)
 
+/**
+ * struct user_ns_info - information about a user namespace
+ * @size: size of this structure
+ * @spare: reserved for future use
+ * @cap_bset: capability bounding set of the user namespace
+ */
+struct user_ns_info {
+	__u32 size;
+	__u32 spare;
+	__u64 cap_bset;
+};
+
+#define USER_NS_INFO_SIZE_VER0 16 /* sizeof first published struct */
+
+/* Get information about user namespace. */
+#define NS_USER_GET_INFO	_IOR(NSIO, 14, struct user_ns_info)
+
 enum init_ns_ino {
 	IPC_NS_INIT_INO		= 0xEFFFFFFFU,
 	UTS_NS_INIT_INO		= 0xEFFFFFFEU,
-- 
2.56.0.313.g2479322e68-goog

