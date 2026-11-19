Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084975;
	b=KEPD5VDFs2QFi6mPof+Fp015fjbTpQxjFXJ4wQLQc01kLGgL21KUVzORYFAL9AztyZUs
	 yg8cEC6H3PL33OkBVCCMF4Lok5Nf83bJsSxzvw7zeTf5BexRbAUDpmauXz8Ne9yKDgfm3
	 JBfs9lABk1Isf8EkZ+h4ggWTIwJte+THqh2/ecn3YwMDVzEZiXTI2MVhOzJBnWfXBWI8r
	 ebKWqdvfdRPZ7Zcf+ERKOG7/4lsKhjAq59lFIlbn0VXzIJqGZHTfG2zUyoCdbkgSK1JAR
	 5K4rAYrQvmsuU7HAtu4k9Ou9z89z35JYYCQf0/jEba9k5W8cBzGvYbi0G0CHjPp9QVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084975;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=u8ExomxaVoqynWwbL+tI4DQgA+MBylEC1NcrigkAqXU=;
	b=qW07381ytPcCH+yArziqfs6rIjJKeit7p8fNfNrNuIIUti6bu41P2M1aodO3FtNvM2QF
	 RH+d4jucdaeyhzAf/36bmfAbQkgK5ByN5cKsIHeqIrUrhVROkH6et+EAqqLK8riDt2Kwr
	 mbkhdzSymSo6PrMbettYUnW4nUSpWlPBO5Pp6EJPfl5/WJipy31QrAuDF6pWLkNi30jIK
	 k6Bjfx6pp+/81P7h9djyzyn2CmLWtostLQdWtjSJY3dmn4LNbwruSgLv74zSyyAjC9zDJ
	 64tGaLgszN0cIAyMWPC9JxRsQxAQXPZW3a0w6b8s0XSepmPuyu12mt9HfpEPOwJTYEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dRpOyqCS;
	arc=none smtp.remote-ip=209.85.208.72
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395E160A261F
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 10:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 395E160A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dRpOyqCS
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b8b0fff76dso1269274a12.2
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 02:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795084973; x=1795689773; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u8ExomxaVoqynWwbL+tI4DQgA+MBylEC1NcrigkAqXU=;
        b=dRpOyqCSUSWTPKJ5FMfmD1uxS4cVZ9x50pGRiq5+1mqfSqLDQLsI9SKhFwGKxlv6Cm
         iZMlFCNmkFWgnArllT5nf5e/Dzw7i3l17A4wvG2Y994GFEu1tL/bVrRAcqjoNAt8ienm
         HHNl4aY82koHmEHoAPTmABAdIHF+E+Sn94fEzXi5R1QE7cJ5En/hRp/Ak9umPloOyZnL
         79/LdJXMV+dDshnQLosb0wToQ/Mft+9ep+kz6cA25h2SDCt2vQwY2FJkcpx9UQwUmDoq
         KVnSxD9BbZivtMMIdLXc/mxZgwFoKaqJsf9y+zQLGby+xG+nPqqw/aihv33bcRVSae1S
         r43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084973; x=1795689773;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u8ExomxaVoqynWwbL+tI4DQgA+MBylEC1NcrigkAqXU=;
        b=OIJ1ljkwOJ5p8fvDUDpb8b5geIj9FezOng/P927J3aMWixaDBPxcOcIIBVooWql8Sg
         tAhl/8muXfcB0MV+v7XvWHffcaA3Majg8FULP1kRLRmOEbNcnT0ATScxswg1xi/H/S6G
         tzLaD+Hd8E2MlYSYMAA7460syGs6q8+S9R53oMx5EgRfu7NlmxoK/BKfcwWCy5W2/IAX
         Pr4BRnup6JmZOuNG5m7LnwFpNqxxEpy9gKuMQK7wXZpD8CQdn9EmlpLt9BYcWmzsMwAI
         S+kBgFQNm36uNmRjf5sOCpAKWDDP3WExB5M1LNQ/r/8/jnC0etrT5CYEABnguvPFbnWU
         4Yog==
X-Forwarded-Encrypted: i=1; AL+hErGhLGMc8twfGtcMfUDx7PwNkugCyytOZBJ9jwNM+Nw8IHBjnY/ZDhlJKTg5765Y605wn73ncM1zWcM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+6+9W28zHwCpR28Zk5AA0uutPSG5Rb5Eypt7qgIdl9aP8QxQiR
	NdLAujIXxemfBZ2ShdsFN0fmsX3DQ0PwQwNOXP18IfjANcn7/cd6DF1LjSXcCMOr+eSH/9FJpw=
	=
X-Received: from edqs14.prod.google.com ([2002:aa7:d78e:0:b0:6b5:76e4:de9f])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:321b:b0:6ba:1347:5bf
 with SMTP id 4fb4d7f45d1cf-6ba13470764mr1098394a12.35.1795084972449; Thu, 19
 Nov 2026 02:42:52 -0800 (PST)
Date: Thu, 19 Nov 2026 10:42:07 +0000
In-Reply-To: <20261119104208.782900-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261119104208.782900-1-halg@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119104208.782900-4-halg@google.com>
Subject: [PATCH v2 3/4] proc: expose userns capability mask as CapUns in /proc/<pid>/status
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Serge Hallyn <sergeh@kernel.org>, 
	Andy Lutomirski <luto@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, keyrings@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

Render cred->cap_userns as CapUns in /proc/<pid>/status alongside other
capability masks, allowing userspace tools to inspect a task's userns
capability mask directly.

Document the new field in Documentation/filesystems/proc.rst.

Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 Documentation/filesystems/proc.rst | 2 ++
 fs/proc/array.c                    | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index fa7a468e8edf..9cf45810e41c 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -200,6 +200,7 @@ read the file /proc/PID/status::
   CapEff: 0000000000000000
   CapBnd: ffffffffffffffff
   CapAmb: 0000000000000000
+  CapUns: ffffffffffffffff
   NoNewPrivs:     0
   Seccomp:        0
   Speculation_Store_Bypass:       thread vulnerable
@@ -286,6 +287,7 @@ It's slow but very precise.
  CapEff                      bitmap of effective capabilities
  CapBnd                      bitmap of capabilities bounding set
  CapAmb                      bitmap of ambient capabilities
+ CapUns                      bitmap of userns capabilities
  NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
  Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Speculation_Store_Bypass    speculative store bypass mitigation status
diff --git a/fs/proc/array.c b/fs/proc/array.c
index f6f75d206762..2b86673aae00 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -311,7 +311,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
 	const struct cred *cred;
 	kernel_cap_t cap_inheritable, cap_permitted, cap_effective,
-			cap_bset, cap_ambient;
+			cap_bset, cap_ambient, cap_userns;
 
 	rcu_read_lock();
 	cred = __task_cred(p);
@@ -320,6 +320,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	cap_effective	= cred->cap_effective;
 	cap_bset	= cred->cap_bset;
 	cap_ambient	= cred->cap_ambient;
+	cap_userns	= cred->cap_userns;
 	rcu_read_unlock();
 
 	render_cap_t(m, "CapInh:\t", &cap_inheritable);
@@ -327,6 +328,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	render_cap_t(m, "CapEff:\t", &cap_effective);
 	render_cap_t(m, "CapBnd:\t", &cap_bset);
 	render_cap_t(m, "CapAmb:\t", &cap_ambient);
+	render_cap_t(m, "CapUns:\t", &cap_userns);
 }
 
 static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
-- 
2.56.1.708.g77570a6a1d-goog

