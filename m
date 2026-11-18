Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010990;
	b=rH5mRxZrfSV9cqnDW90uzLfQhMbIs2CHjwnRMSnD9s2MYwMGpz42CR12cL//iXjhVVZB
	 j+mVlF3ZYJt6swhzkXgMZLnrI2PZc/MQcU2ZhlZ63V0pDg+VCWR3VUfXhcDYEMgkIqJxp
	 UY75XGvGssGglfyoAKYGS7CgWg2uznRcrUACZAw0RGRhQ4y2SwmPuuBbUle04OTN1bEZk
	 ZquMR4HktpCmey4Hc8eREWUvWnynT4vTC+XPJ7nIASQtMSpkbRo1RC3Xuy472JOzSctcT
	 fdhOGadUq4P63QM0tw+pjG5XKh4Idj/0181BaXfubucCMYuYdILWFrdlsnssbGsnetw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010990;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=T1qvRLtkirmgKXEavAQCYElsIkpIGZmynR3Whc+7Ebc=;
	b=FVB628wGH/YY9Xes3NZ3A0XcrU1K/McilDkk8+Vs7HkQvkWWIOYBWnQ4ZEjfZ6/GkEZw
	 YzjSclJKh/82vNebfV8gfF3nxDSraLwU/oCKApl99qDYBIteXK8sAcgFN6aN2Z3qm9gIf
	 SREdduQTYQD2XGTV6UsxUR1oR6Qi4rP3HIZxb/NzjWtS/ok2iwO8i1ZEx/yCVLFJBiZ8L
	 HsmbcRmkF71OQss9ONoCA7PsFsDOIY/O7iHfhtjmGTnWtxFi0QyoIg8XULEO/cxYWKgSH
	 3T8ugEBwlbDaPI/xIMqd+lgJnt+2Wwj5FlWLT0M5833MOPDZ2UxxZ58hYP0U+olG1SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=MFTygGwd;
	arc=none smtp.remote-ip=62.149.156.91
Received: from smtpcmd0991.aruba.it (smtpcmd0991.aruba.it [62.149.156.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C3F60A2629
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11C3F60A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=MFTygGwd
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgM6xLP476q8sTgM6xc97L; Wed, 18 Nov 2026 15:09:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795010987; bh=XZv05H9A0y4JWx4C2kfVEJYBBhLV1Q9ClegJUUM5OIE=;
	h=From:To:Subject:Date:MIME-Version;
	b=MFTygGwdCJZ8dpJvyJST8MwHh46EfjwD8kJhmEijTWLZPxxhase+OwFsh7lq4cxfB
	 LvCzgmBzy5Sj0C+N8g+2EU6Pcu6B9geb94MQEOAaldHnVjX4NbEFpnu9yCVc7RVqVI
	 +/AlMwU46kB64xB6rlOg11YsetCkK56NQCCud9ukyLEjGxv8FI2EFtwtCzI88HVCUM
	 B6NkgyZorcsWSf/nTrtd3tpjpBJsBiLJVblcOmVSQ+xtE2OkhSr6Xp9ZjC4W2kKWsf
	 BdIKUCSta0s0GrqoJrElz2rqMIPfoGeQMGuaO7S4Jm0PYmBD6xJ5cqhofu31zEpuIG
	 sgCvnIdr8afqw==
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	keyrings@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	op-tee@lists.trustedfirmware.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [RFC PATCH 6/9] KEYS: keycrypt: Add the engine tier
Date: Wed, 18 Nov 2026 15:09:42 +0100
Message-ID: <20261118140942.611715-1-giometti@enneenne.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118140421.584086-1-giometti@enneenne.com>
References: <20261118140421.584086-1-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfFtUaTfzPhMStwlKWj88S+iQKFn5wIBaG0bPK9UENjParNezD2h+kZm7q4GYiByZEdzsQH74S0KbPsFg8L7xfVpZZUnjhY3pvc+kJ0BI7LAXIm58qdb9
 bmkkzJji62ZNTiCaxMVfpuHS4eJ/IXnFce4WrfNK4ImC4JclA+7r7fNiS6xXF3F9kUC91n5svOz1wzWSghT5q6XEf53LyZNPrrc/noqYJn3OAMFe3Pcb7d+Z
 lRjzZ3rJpEVlyaE6ZI2Wxa4zh+XsUDK06eYDCydSJelXQvFXJ/WcWw5zkZJmJbm+vSiBAWnHsm2ItB4NZD5IeudmMrhZuKOXH7fJAO1LJTX3f0+sCHzRh9Xa
 n6jRK7VYKmcuD36NmPcE5a5qQ/DRV4vSOdUvPRrj/YvrPiea5MQ272QjO9qYLF/tix30iyVpguDSK2HRDa5zWr9oHu/AmEqOnLHKbVlXBpjLAdAazGEbIdth
 HLdXtums/t6kZMih5f2171UZiUULMzQNNsA94fCJdyDrVNFgPi8QHEXi6Y6xttQhUmXYmmZ4AuvnmL3kqMJn7s1upMk6hz9BbrqmMr4MMqaJVK30Jdysnt3f
 aRE8ya2QcCJtLQZr2RKmA4za1+IDt3smFwyvwU0c0r7cklwl8k5m34d/3+v0wnQc3OYnJcu1eSKZC7iiFg5RCwiMaeE4GI9gOFJDyvCaAFdyRFcCpRjXKm/u
 GnIMoCQUZ5cJbIXmH42HgeB9Mom/HM5zjf0AlDmQtFWyjsKOawX6s1W3KoFBLp0q0/5py+RkiRvnGJj0OMMIa9p3PYucVRq6lNq9gjio7BegbgMgdi8r8j/d
 xoJQ/GXQOWY68hvg/ZjD3OLU7hzNveMPkTCK96+gF/kzvrwVR+Ov6eIIfrB54gLPMnycFVr8wlY9Ouj04WoukiONU0ZPwhpz+SloxyLiXmGFuthIFr8FhsfS
 0eWaDGWHGPkp/suwdEXROQaeuYznS1LzoE24Vp3dBHi6YHa/fK4JF7yMGmMjjJSkbdNO9q5+x8865SHF0fA8CjK0jlLmZcGf6DM0Kiite82qeySAORG2OHJj
 tsqmLYj7eCkPBqaXElyOd10BiBW5+l71PrgU6PmJ01lz1dfGGYbyi0hh2O084BQyoFb51+EX8oC0fOneRnlTf5YqiiOyj8W3ITzlZC4yuRDvls9YeeraZcew
 16RkCXAhbo/9u1wjwqAT+RTjXNHh+RgruILUwr6hGEZ6T7PcMQzrNneKZec16tMsxqCQ1dH6MW6E9jAeCvsC9SIXyrfSWdpa1/TFF9zOmXIA7d6cP1Vrkwvq
 /dvjANn24zLCUQGaJId5m7U3wjKNz3IJB5tye/7AjlK9e0p9aQ0=

Some crypto engines hold a key so that the kernel never reads it once
sealed, yet run whatever operation the kernel asks of it: the CAAM's
black keys are of this kind. A key there is better kept than in
kernel memory, but its use is no more checked than the kernel
tier's.

Add the engine tier, 15, between kernel and tee, for such backends:
tier=engine and min-tier=engine choose them, accepted-min-tier=engine
and KEYCTL_CRYPT_OPEN's accepted_min_tier take them, and
CONFIG_KEYCRYPT_SYSTEM_TIER_ENGINE makes it the system tier at boot.
The core warns in the kernel log when a backend registers at it, since
the protection its name may suggest stops short of the use of the key.

No backend in the kernel declares this tier yet; the keycrypt CAAM
backend proposed with it does.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 Documentation/security/keys/keycrypt.rst      | 42 ++++++++++++-------
 include/uapi/linux/keycrypt.h                 |  2 +
 security/keys/keycrypt/Kconfig                | 11 ++++-
 security/keys/keycrypt/core.c                 |  4 ++
 security/keys/keycrypt/keycrypt.h             |  2 +
 6 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 62d44a5225e4..0cacb7d1ca1d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2947,7 +2947,7 @@ Kernel parameters
 	keycrypt.system_tier=	[KEYS] Lowest protection tier a keycrypt key
 			may be used at; keys of a lower tier can still
 			be created and loaded.
-			Format: { kernel | tee | hsm }
+			Format: { kernel | engine | tee | hsm }
 			Default: the CONFIG_KEYCRYPT_SYSTEM_TIER_*
 			choice, kernel unless set. Can only be raised,
 			here or later through the
diff --git a/Documentation/security/keys/keycrypt.rst b/Documentation/security/keys/keycrypt.rst
index 17af3b041000..ac393a0bc97d 100644
--- a/Documentation/security/keys/keycrypt.rst
+++ b/Documentation/security/keys/keycrypt.rst
@@ -26,6 +26,10 @@ The tiers, lowest first:
 ========== =========================================================
 ``kernel`` the key is in clear in kernel memory while loaded; the
            kernel enforces its use
+``engine`` a crypto engine the kernel drives keeps the key, never in
+           clear in the kernel once sealed; the kernel decides its use
+           (a secure element that does not check a key's use is an
+           engine too)
 ``tee``    a trusted execution environment keeps the key and checks
            every use against the purpose it bound (an OP-TEE TA)
 ``hsm``    as ``tee``, in dedicated hardware apart from the CPU running
@@ -34,7 +38,9 @@ The tiers, lowest first:
            policy)
 ========== =========================================================
 
-Each tier holds the guarantees of those before it.
+Each tier holds the guarantees of those before it. Keys of the ``engine``
+tier, such as the CAAM's protected keys, are used by the kernel, which
+cannot read them once sealed.
 
 The backends of this document: ``sw``, of tier ``kernel``, where the
 kernel's own software uses the key (`The sw backend`_); and ``optee``,
@@ -55,7 +61,9 @@ sw backend the secret is the trusted master each key names with
 master (`The sw backend`_).
 
 A backend of tier ``tee`` or ``hsm`` also declares that it meets
-`Backend requirements`_.
+`Backend requirements`_; one that keeps a sealed key out of the kernel's
+reading but leaves its use to the kernel is ``engine``. The core says
+so in the kernel log when an ``engine`` backend registers.
 
 A backend registers with ``keycrypt_register_backend()``
 (``include/keys/keycrypt.h``) under a name that is stored in every blob it
@@ -96,10 +104,13 @@ itself does what the core has no way to check:
 A backend declares its own tier at ``keycrypt_register_backend()``; the
 core stores and compares it wherever a tier is checked, but never
 confirms that the backend is actually a TEE or hardware rather than
-ordinary kernel code claiming to be one. The ``kernel`` tier meets
-none of the above: its key material is in clear in kernel memory (`The
-sw backend`_), so there every property above is only as strong as the
-kernel itself.
+ordinary kernel code claiming to be one. The ``engine`` and ``kernel``
+tiers meet none of the above: an ``engine`` backend leaves the key's
+use to the kernel, and the kernel tier's key material is in clear in
+kernel memory (`The sw backend`_), so there every property above is
+only as strong as the kernel itself. What an ``engine`` backend keeps
+against a compromised kernel is only that a sealed key is not in clear
+in kernel memory, as far as its hardware's own properties hold.
 
 Metadata
 ========
@@ -187,7 +198,7 @@ Any other ``<option>=<value>`` is passed to the backend; the core refuses
 an option the backend does not declare and an option given twice. The
 one option a backend of this document takes from user space is
 ``master=``, the sw backend's: it needs a master to seal its keys, while from
-``tee`` up a backend's own mechanisms protect the key. A command for
+``engine`` up a backend's own mechanisms protect the key. A command for
 the kernel tier therefore reads ``tier=kernel master=<name>``; the kernel
 tier chosen without ``master=``, or ``master=`` given to a backend of
 another tier, is refused with ``EINVAL``.
@@ -451,10 +462,11 @@ so that a kernel compromised enough to lie about the operation or the
 key's metadata still cannot open, say, an encryption context on a
 decrypt-only key; the sw backend has no such check of its own, since
 a compromised kernel already has that backend's key material in clear
-(`The sw backend`_), and relies on the core's check alone. Across
-every tier it is the kernel, not any backend, that decides who may open
-a context on a key, since Search permission is the core's own check; a
-compromised kernel can
+(`The sw backend`_), and relies on the core's check alone; neither
+does an ``engine`` backend, whose key's use the kernel decides
+(`Tiers and backends`_). Across every tier it is the kernel, not any
+backend, that decides who may open a context on a key, since Search
+permission is the core's own check; a compromised kernel can
 therefore still open a context on a key of any tier and use it for a
 purpose the key already has, but, for a backend of tier ``tee`` or
 ``hsm`` meeting `Backend requirements`_, it can neither read that key
@@ -603,8 +615,8 @@ the capability); neither touches a context already open at the time
 they change.
 
 ``kernel.keys.keycrypt_system_tier`` is the system tier, the lowest tier
-a key may be used at: one of ``10`` (``kernel``), ``20`` (``tee``)
-or ``30`` (``hsm``), the same values as
+a key may be used at: one of ``10`` (``kernel``), ``15`` (``engine``),
+``20`` (``tee``) or ``30`` (``hsm``), the same values as
 ``KEYCRYPT_TIER_*`` (`Tiers and backends`_). It can only be raised,
 never lowered (``EPERM`` on a lower value, ``EINVAL`` on anything
 else). It applies to use only: ``KEYCTL_CRYPT_OPEN`` refuses a key
@@ -630,8 +642,8 @@ already loaded is affected, imported or not. With
 rather than this one.
 
 Each has a boot parameter setting its starting value before either sysctl
-is ever written: ``keycrypt.system_tier=`` (``kernel``, ``tee`` or
-``hsm``) and ``keycrypt.import=`` (a boolean). An invalid
+is ever written: ``keycrypt.system_tier=`` (``kernel``, ``engine``,
+``tee`` or ``hsm``) and ``keycrypt.import=`` (a boolean). An invalid
 value, or one that would lower what is already set, is ignored, with a
 kernel warning, rather than failing the boot. An administrator who
 wants either policy fixed from the very start, before any user-space
diff --git a/include/uapi/linux/keycrypt.h b/include/uapi/linux/keycrypt.h
index c03348579f62..71209a08c924 100644
--- a/include/uapi/linux/keycrypt.h
+++ b/include/uapi/linux/keycrypt.h
@@ -13,6 +13,8 @@
 
 /* Protection tiers, lowest first; the gaps leave room for more */
 #define KEYCRYPT_TIER_KERNEL	10	/* the kernel itself */
+/* a crypto engine the kernel drives; the kernel decides its use */
+#define KEYCRYPT_TIER_ENGINE	15
 #define KEYCRYPT_TIER_TEE	20	/* a trusted execution environment */
 /* as TEE, in dedicated hardware apart from the CPU running the kernel */
 #define KEYCRYPT_TIER_HSM	30
diff --git a/security/keys/keycrypt/Kconfig b/security/keys/keycrypt/Kconfig
index e61922933bd7..a6d8a0fa6d29 100644
--- a/security/keys/keycrypt/Kconfig
+++ b/security/keys/keycrypt/Kconfig
@@ -56,11 +56,20 @@ config KEYCRYPT_SYSTEM_TIER_KERNEL
 	  A system with no backend of the kernel tier built has no key of
 	  that tier to use.
 
+config KEYCRYPT_SYSTEM_TIER_ENGINE
+	bool "Engine"
+	help
+	  Only keys whose backend declares them never in clear in the
+	  kernel once sealed can be used: a key of the kernel tier is
+	  refused at every KEYCTL_CRYPT_OPEN; the engine, tee and hsm tiers
+	  can be used. For a system that must never use a key held in clear
+	  by the kernel.
+
 config KEYCRYPT_SYSTEM_TIER_TEE
 	bool "TEE"
 	help
 	  Keys whose use a trusted execution environment or the hardware
-	  checks: keys of the kernel tier are refused at every
+	  checks: keys of the kernel and engine tiers are refused at every
 	  KEYCTL_CRYPT_OPEN; the tee and hsm tiers can be used. For a
 	  system where OP-TEE or an hsm backend holds the keys.
 
diff --git a/security/keys/keycrypt/core.c b/security/keys/keycrypt/core.c
index debd0845621e..4a2609c6830f 100644
--- a/security/keys/keycrypt/core.c
+++ b/security/keys/keycrypt/core.c
@@ -40,6 +40,7 @@ static const struct keycrypt_name keycrypt_algs[] = {
 
 static const struct keycrypt_name keycrypt_tiers[] = {
 	{ KEYCRYPT_TIER_KERNEL,		"kernel" },
+	{ KEYCRYPT_TIER_ENGINE,		"engine" },
 	{ KEYCRYPT_TIER_TEE,		"tee" },
 	{ KEYCRYPT_TIER_HSM,		"hsm" },
 };
@@ -441,6 +442,9 @@ int keycrypt_register_backend(struct keycrypt_backend *b)
 		b->handle = h;
 	}
 	mutex_unlock(&keycrypt_lock);
+	if (!ret && b->tier == KEYCRYPT_TIER_ENGINE)
+		pr_warn("backend %s registered at tier engine: the use of its keys is checked by the kernel only\n",
+			b->name);
 	if (ret)
 		kfree(h);
 	return ret;
diff --git a/security/keys/keycrypt/keycrypt.h b/security/keys/keycrypt/keycrypt.h
index 5a41a68c48fa..40487eb3e139 100644
--- a/security/keys/keycrypt/keycrypt.h
+++ b/security/keys/keycrypt/keycrypt.h
@@ -143,6 +143,8 @@ bool keycrypt_tier_valid(u32 tier);
 #define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_HSM
 #elif IS_ENABLED(CONFIG_KEYCRYPT_SYSTEM_TIER_TEE)
 #define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_TEE
+#elif IS_ENABLED(CONFIG_KEYCRYPT_SYSTEM_TIER_ENGINE)
+#define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_ENGINE
 #else
 #define KEYCRYPT_BOOT_SYSTEM_TIER	KEYCRYPT_TIER_KERNEL
 #endif
-- 
2.43.0

