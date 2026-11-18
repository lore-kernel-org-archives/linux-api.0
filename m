Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795011188;
	b=ueGkXuav7ksKkHD0ZHLJ4m+PyxZhA8eTrDzkTTU0gYQest4qSLhLJmTeHXEfuw/lfn8w
	 9efTftBnpDdxHWpFa27mzEPTBBefMdbJbP0blDZ9mp0m6oZ8+0a9UxkumzgQhr2uNw8wZ
	 pgoTtkojWlJL17pd08DpBf3qpCAQ8v0fkiqCqZhjsAeoNuNYFObNoGzxOj6d8GH/XkkE5
	 9E9KlDxKoghNhOHKyaDVBI77KrxkVWKwJAIJSOowf/qj+aM/8UQr96E0dcYhjh4BGUFX3
	 vXBxMgavEE5fu+chzPj8T2mMOfgQJzq375L4N273np3XsmjzNz539309PHUgsI/6KKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011188;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=9Yf92H1iS2bJ6FffedMh4jMOCjIGNI7x/gGzNegQIxs=;
	b=CEvzsyJXKYdJh72g2MlgwBCJNsh56q1gOf2sS/J5ZoPPybMAVvVUzmqRp1CX0JGdYyT8
	 yr/y7N+oMMEjt2U7wxMG0BqYkwAP7UlPOSKvIIBOvmeRpRQLvs0gTjcvk5bZ9VF6kMIze
	 gaTRxYKoF4dwpJRSbzw9VqINIUrizCMH2sePpEwZcFs3hnyboTLOuHjdR6KV+vYIdwZF/
	 Wc+3x/oWHiPvjVpiRiAbL1oGkkq0DUr9oq4FOKECTQ+QxpY8ia7W35Th7kmN+W146JA/l
	 1ABDCpLplWUq8OUtg8kah6kEZS2zPSe5RFsY8cKgcq+kXpcSlK1AbQKP1vuxT/Fq1sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=nsB8KCdv;
	arc=none smtp.remote-ip=62.149.156.116
Received: from smtpcmd11116.aruba.it (smtpcmd11116.aruba.it [62.149.156.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD260A260F
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEBD260A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=nsB8KCdv
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgPDx53cE6VShTgPDxMxRV; Wed, 18 Nov 2026 15:13:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795011180; bh=65zDAD9P34/8jmWl7x/eHL/cB56MElSEVrbnFcipqqw=;
	h=From:To:Subject:Date:MIME-Version;
	b=nsB8KCdvy2r8K9gdEEAfmzaLosTxpIuh0egfjtCvwo6jDK3voZ6SNhX0IahV/qPhi
	 xZ0tH5tg0adF19ZdpPWpsL3v+ZJu4t5CmUixWSzGp7iBMtvT2G0NpnGnEnhiFC/q/F
	 Hm94oXzOVJ9iTP8AwdWdUGXxoQ0KEBu+jDH5Y3XbKa0AF1fo4gzazzaGi0Vf/y+68V
	 uzlXbhkwJTkYAksfiSTCC1/cu4ajRce7ZzMxhHmGiMEnLEw40Kh6PsF9U0q60s2f8k
	 pY4JjUv56HSIEyUai5buG6UZnPBJba1i3Wl7HZdcgXVHqJXgsWdmlUqNzFgm2bIbWw
	 WEyGqdOxD+Q6A==
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
Subject: [RFC PATCH 9/9] KEYS: keycrypt: Add the aes256-gcm-stream algorithm
Date: Wed, 18 Nov 2026 15:12:57 +0100
Message-ID: <20261118141257.627441-1-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfHatx1b6jf06LbJ8lit0J/IJCpnIYJJxyFnwlMdkaOjRpGwb8ymXgQBMdhRCO4kl386cGlzoYmticYy6fo5R4EujhWbcEWUIt09geR98WWzQ6r+dZGSI
 LNOw1cQK7btxLzX5DX4gOU4i9OMpf0FDldq/QL1rJ0EwjWWiTk4gSqRqj+Zabv12EtaEARyXZ/ei/QaRSXjHh5AYUvwSWMBoKlA2/jzkgClv1Q4XxhfkEBbn
 s+rO79xnjsux5JQgACoakYAWB6UzKGxbXw37vXJ7WcEXjWIbOf2Kad9qDf8GmFCLoVuZ9Er+uBWxwrD1KSlgPtgYgVunHgkU/9NJ3YK25t/7u8xqge5C01yt
 r0A0gEHwOK9aj77vusNF0UeftQflzOO0zQSTqD6IYj7PkRNh7iEgskT3uVu83h4eXfDKVcvEQLAHnkFXvc1VxQ/imt01AwBbKEzxxa9AfGjaWBv8rRDxBHcX
 EwVgl/8z3SF7P3u9LqxTP4IhezZGS1KKLCY+NT+Nxg6UWOSD7ECd1tVIPEEIRTdh/tdj9BggX4KIuXdqwPK3IsOCzqmkUr3abyquaUWf6SvRfXXuGldfFzeY
 pUsij//XTZxxJhl/yZY81vg0QzI8SsV0GXYLy+8fLZIPi9rhWvBlw+eF1GwB6nTwhuPVtriynvpT7/tQdD/naffIawX6apwfjzWE3KtbW3Po73e9lARdLoYE
 +Rh7/7PvZQCMgPwidpoTDfYWee0cpcaeZJLlsZdfVKqkcTQKS4LCYlO6DFE84e9JoeNDy/xPYvP0Jz4Mj3+n2Tbj2FCXoOzgDjhqEFL0WCBU56Lgdru00VVD
 1/KBc6XxaCvCOxUTZFYqxgA6xw4STksDVvCHfDqLV9JJLFfvIIrY+zXW/dI7kZI+51L2e9VIt8fW+kJQL3I9ahXoOYWBAT1dJUvRIh1z8agernfpdspxHSKj
 xMIY0voHiQg7s7pNGDN7a1HhunxaHyu8MUZ4GHG2ZTrGapa+xIE/tbzj+RRMeTPmsVb/GnvJ9aY7pD7jesgJVJGJjRArhHvnEH1GWJrvWRUXWqmMnd9B5Aln
 8K0iKgroSVJRPX373D6TJs9ReZrnjCThIcfhPJk5vV7WZk4lhQRiG/WivBXNMg2EtMwiP/c8iTX+78tcJCEPsEgott52pFiAOFoHB9zQH16/dkyPti2tsDXT
 Ect0rC3gJErK9xNVmov7iK/iKCuC3ZwcDM8N16x9zf+aXH2gGKBqRpS8HBN4kcjKM7MYLrkKS7XiW5Zh3CsSvuRdHJ+IUemwwiIty9rF2bmaYFyqVlNIqe28
 DheYOiLBojVYfi6TQnVsTzPf6qXcwcmL+JWAqm1gmQdPO2gp/Co=

This patch is a proposal on its own: nothing before it needs it, so it
can be discussed, or left out, apart from the rest.

aes256-cbc does not authenticate what it decrypts, and a file or a
transfer longer than one call cannot be sealed with a single AES-GCM
invocation without buffering all of it, nor decrypted without
releasing plaintext before its tag is checked.

Add aes256-gcm-stream: the STREAM construction (Hoang, Reyhanitabar,
Rogaway, Vizar) over AES-256-GCM. A message is split into segments
of up to 64 KiB, each sealed with its own tag under a subkey derived
with HKDF-SHA256 from the key and a 16-byte salt drawn at
KEYCTL_CRYPT_OPEN; the nonce carries the segment's position and a
last-segment flag, and the counter lives in the kernel, so segments
can be neither reordered nor dropped from the end unnoticed. The
segments go through a new ioctl, KEYCRYPT_IOC_SEGMENT, and
KEYCRYPT_IOC_FINAL reports a stream whose last segment never came.
A tee or hsm backend draws the salt and keeps the counter in its
secure side; the sw and optee backends implement it.

With it comes its section of the documentation, with a file format
built on it.

No user-space consumer uses it yet.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 Documentation/security/keys/keycrypt.rst | 244 ++++++++++++++++++++---
 include/keys/keycrypt.h                  |  15 +-
 include/uapi/linux/keycrypt.h            |  43 +++-
 security/keys/keycrypt/core.c            |   3 +
 security/keys/keycrypt/ctx.c             | 139 ++++++++++++-
 security/keys/keycrypt/keycrypt.h        |   5 +
 security/keys/keycrypt/optee.c           |  70 ++++++-
 security/keys/keycrypt/optee.h           |   4 +-
 security/keys/keycrypt/sw.c              |  68 ++++++-
 9 files changed, 541 insertions(+), 50 deletions(-)

diff --git a/Documentation/security/keys/keycrypt.rst b/Documentation/security/keys/keycrypt.rst
index e2ee5f75d9f4..02b5e82f355c 100644
--- a/Documentation/security/keys/keycrypt.rst
+++ b/Documentation/security/keys/keycrypt.rst
@@ -84,8 +84,8 @@ the key's purpose and the key's tier against the caller's
 ``KEYCTL_CRYPT_OPEN`` (`Using a key`_); and, at
 ``keycrypt_register_backend()``, that a backend declares a valid tier,
 offers ``generate`` and ``load``, the four context callbacks all or
-none and, for a ``tee`` or ``hsm`` backend with context operations,
-``verify`` for hmac-sha256. None of
+none, ``aead`` for aes256-gcm-stream and, for a ``tee`` or ``hsm``
+backend with context operations, ``verify`` for hmac-sha256. None of
 that defends against a *compromised kernel*: the core is kernel code
 too, and a kernel that lies to itself can skip or fake any check it
 runs itself.
@@ -102,7 +102,11 @@ itself does what the core has no way to check:
 - fixes the operation for a context at ``ctx_open`` and holds to it,
   refusing ``final`` on a context it fixed for VERIFY and ``verify``
   on any other;
-- fixes the length of a MAC or VERIFY tag.
+- fixes the length of a MAC or VERIFY tag;
+- keeps the aes256-gcm-stream segment counter and whether the last
+  segment was seen in the secure world rather than trusting them from
+  the caller, and draws there the salt to encrypt;
+- zeroes its output when a tag fails to verify.
 
 A backend declares its own tier at ``keycrypt_register_backend()``; the
 core stores and compares it wherever a tier is checked, but never
@@ -119,8 +123,8 @@ Metadata
 ========
 
 ========= ======================================================
-algorithm ``aes256-cbc`` or ``hmac-sha256``
-purpose   ``encrypt``, ``decrypt`` (aes256-cbc);
+algorithm ``aes256-cbc``, ``aes256-gcm-stream`` or ``hmac-sha256``
+purpose   ``encrypt``, ``decrypt`` (aes256-cbc, aes256-gcm-stream);
           ``mac``, ``verify``, or both (hmac-sha256)
 tier      the backend's, when the key was sealed
 backend   its name
@@ -134,6 +138,12 @@ purpose, tier and origin instead as the numeric ``KEYCRYPT_ALG_*``,
 ``KEYCRYPT_PURPOSE_*``, ``KEYCRYPT_TIER_*`` and ``KEYCRYPT_ORIGIN_*``
 values of ``<linux/keycrypt.h>``.
 
+``aes256-gcm-stream`` names keycrypt's own STREAM construction over
+AES-256-GCM, run under a per-stream subkey derived with HKDF
+(`Authenticated streams (aes256-gcm-stream)`_); it is not interoperable
+with a plain AES-GCM implementation, and a different construction, even
+one also built on AES-256-GCM, gets a different name.
+
 A key cannot be changed: ``keyctl update`` fails (``EACCES`` with the
 default permissions, which give no write permission; ``EOPNOTSUPP``
 otherwise). Adding a key with the same description to the same keyring
@@ -246,8 +256,8 @@ operation that moves a sealed key to another backend; the same material
 imported again elsewhere is a new key.
 
 ``import`` needs CAP_SYS_ADMIN and CONFIG_KEYCRYPT_IMPORT (off by
-default); the key is 32 bytes for aes256-cbc, 1 to 64 bytes for
-hmac-sha256. The core's own copies of it are erased once the
+default); the key is 32 bytes for aes256-cbc and aes256-gcm-stream, 1 to
+64 bytes for hmac-sha256. The core's own copies of it are erased once the
 backend has sealed it. Do not put a key in clear on a command line;
 give the payload on standard input::
 
@@ -390,12 +400,15 @@ The TA meets `Backend requirements`_: at every ``KEYCTL_CRYPT_OPEN`` it
 authenticates the blob's header again and checks the operation against
 the purpose it reads there; a context is a TA session fixed to one
 operation, refusing ``final`` on a VERIFY context and ``verify`` on any
-other; tags are 32 bytes. An aes256-cbc IV is used as given: to
+other; tags are 32 bytes for HMAC and 16 for the stream; the stream's
+salt to encrypt is drawn in the TA, its subkey derived there, and its
+segment counter and last segment kept there; a segment that fails to
+verify comes back zeroed. An aes256-cbc IV is used as given: to
 encrypt, the core's random one or, with ``KEYCRYPT_OPEN_CALLER_IV``, the
 caller's; to decrypt, the caller's.
 
-Every context holds a TA session and 65,584 bytes of TEE shared memory,
-rounded up to whole pages and physically contiguous (68 KiB with 4 KiB
+Every context holds a TA session and 69,680 bytes of TEE shared memory,
+rounded up to whole pages and physically contiguous (72 KiB with 4 KiB
 pages), until the context ends (``KEYCRYPT_IOC_FINAL``, or a failure),
 its key is revoked, or its fd is closed, whichever comes first. The TA
 refuses a session once 32 are open (``KC_TA_SESSIONS_MAX``), the
@@ -506,9 +519,15 @@ A key is used through an operation context, a file descriptor opened by
                                         */
             __u32   flags;          /* KEYCRYPT_OPEN_CALLER_IV, or 0 */
             __u32   __reserved;     /* must be zero */
-            __u8    iv[16];         /* aes256-cbc: the IV; MAC,
-                                      * VERIFY: 0
-                                      */
+            union {
+                    __u8    iv[16];    /* aes256-cbc: the IV; MAC,
+                                        * VERIFY: 0
+                                        */
+                    __u8    salt[16];  /* aes256-gcm-stream: the
+                                        * 16-byte stream salt; an
+                                        * alias of iv
+                                        */
+            };
     };
 
 ``params`` is extended by size (``copy_struct_from_user()``): a caller
@@ -560,20 +579,38 @@ maintain (see `CBC and MAC`_). The flag is valid only together with
 aes256-cbc encryption; any other combination is ``EINVAL``. For
 aes256-cbc decryption ``iv`` is always the caller's.
 
+For aes256-gcm-stream, ``salt`` must be zero on input for encryption: the
+kernel draws a random 16-byte salt, or leaves whatever a backend that
+must draw its own has written there, and writes it back the same way as
+the aes256-cbc IV; whichever drew it, a salt that comes out all zero is
+refused with ``EIO`` and no fd is created (see `Authenticated streams
+(aes256-gcm-stream)`_). A ``tee`` or ``hsm`` backend must not leave the
+salt it draws itself all zero; the sw backend never touches ``salt`` at
+all, so there the same check instead guards against the core's own
+random draw coming out all zero, true with probability 2^-128.
+Decryption takes the salt the encryption side returned.
+
 Data goes through ``ioctl()`` on the fd:
 
 ``KEYCRYPT_IOC_UPDATE`` (``struct keycrypt_update``: ``in``, ``out``, ``len``, ``flags``)
     aes256-cbc and MAC/VERIFY only: process ``len`` bytes, at most
     ``KEYCRYPT_UPDATE_MAX`` (65536): for aes256-cbc a multiple of 16,
     written to ``out``, the IV advancing in the context (padding is the
-    caller's); for MAC and VERIFY ``out`` is 0.
+    caller's); for MAC and VERIFY ``out`` is 0. ``EINVAL`` on an
+    aes256-gcm-stream context.
 ``KEYCRYPT_IOC_FINAL`` (``struct keycrypt_final``: ``out``, ``len``, ``flags``)
     end the context: for MAC write the 32-byte tag to ``out`` (``len``:
     room in, bytes written out); for VERIFY ``out`` is the caller's
     32-byte expected tag (``len`` must be exactly 32), written back as
-    0 on a match and left as given on a mismatch; for aes256-cbc
-    ``out`` is 0, nothing is written to it, and ``len`` is written back
-    as 0.
+    0 on a match and left as given on a mismatch; for aes256-cbc and
+    aes256-gcm-stream ``out`` is 0, nothing is written to it, and
+    ``len`` is written back as 0; for aes256-gcm-stream, ``EBADMSG`` if
+    the stream's last segment was never processed (see `Authenticated
+    streams (aes256-gcm-stream)`_), 0 otherwise.
+``KEYCRYPT_IOC_SEGMENT`` (``struct keycrypt_segment``: ``in``, ``out``, ``aad``, ``tag``, ``len``, ``aad_len``, ``flags``)
+    aes256-gcm-stream only: process one authenticated segment of the
+    stream; ``EINVAL`` on any other context (see `Authenticated
+    streams (aes256-gcm-stream)`_).
 ``KEYCRYPT_IOC_INFO`` (``struct keycrypt_info``: ``op``, ``alg``, ``purpose``, ``tier``, ``origin``, ``accepted_min_tier``, ``backend``)
     describe the context, whatever its algorithm or operation: the
     operation it was opened for, the ``accepted_min_tier`` it was opened
@@ -587,8 +624,7 @@ Data goes through ``ioctl()`` on the fd:
     ``SCM_RIGHTS`` can tell what it holds (see `An fd is a shared
     stream`_). On an ended context ``EBADFD``; on a context whose key
     was revoked, invalidated or expired, or whose backend was removed,
-    the ``EKEYREVOKED``, ``EKEYEXPIRED`` or ``ENODEV`` that UPDATE with
-    no data gives.
+    ``EKEYREVOKED``, ``EKEYEXPIRED`` or ``ENODEV``.
 
 VERIFY compares the expected tag against the one computed for it: by
 the core, in constant time (``crypto_memneq()``), for a backend with no
@@ -729,7 +765,8 @@ An fd is a shared stream
 ========================
 
 The fd from ``KEYCTL_CRYPT_OPEN`` carries the context's state (the IV,
-the running hash) outside the key itself: after ``SCM_RIGHTS`` or
+the running hash, a stream's salt and segment counter) outside the key
+itself: after ``SCM_RIGHTS`` or
 ``fork()``, every holder of a copy of the fd shares that state with
 every other, and an ``ioctl()`` from any of them advances it for all.
 Close the sending side's copy once sent, and receive with
@@ -772,6 +809,129 @@ differently (an aes256-cbc encryption context is a raw AES oracle on
 the key, above), and every new pairing of algorithms would need its own
 analysis that nothing here does.
 
+Authenticated streams (aes256-gcm-stream)
+=========================================
+
+An aes256-gcm-stream context runs the STREAM construction: a message is split
+into segments, each authenticated on its own, with a running counter and
+a per-segment flag standing in for the position that a single big
+AES-GCM invocation would get from encrypting the whole message at once.
+Every segment of a context runs under a per-stream subkey
+
+::
+
+    K_s = HKDF-SHA256(key, salt, "keycrypt aes256-gcm stream v1")
+
+derived from the key and the 16-byte salt returned at
+``KEYCTL_CRYPT_OPEN`` (`Using a key`_); the construction is keycrypt's
+own, the same in every backend, though each backend builds the nonce
+itself. ``KEYCRYPT_IOC_SEGMENT`` (``struct keycrypt_segment``) processes
+one segment: ``in``/``out`` are the plaintext and ciphertext (``len``
+bytes, at most ``KEYCRYPT_SEGMENT_MAX``), ``aad``/``aad_len`` is this
+segment's associated data (at most ``KEYCRYPT_AAD_MAX``), and ``tag`` is
+the ``KEYCRYPT_AEAD_TAG_LEN``-byte (16) tag: written by encryption, read
+by decryption. Segment *i*, counting from 0, is encrypted or decrypted
+under ``K_s`` and the nonce::
+
+    0^7 || be32(i) || last
+
+``last`` is one byte, 1 for the segment flagged
+``KEYCRYPT_SEGMENT_LAST``, 0 otherwise. The counter lives in the
+kernel, advances by exactly one per accepted segment and is never
+exposed or settable by user space, so segments cannot be reordered or
+replayed against a decrypting context: decrypting segment *i* out of
+order fails its tag, since the nonce the kernel computes no longer
+matches the one encryption used at that position.
+
+Decryption never releases a segment's plaintext until its tag verifies:
+on ``EBADMSG`` the output buffer the kernel used is zeroed before the
+copy that never happens, and the context ends (every later call gives
+``EBADFD``). No segment is accepted after the one flagged LAST
+(``EBADFD``), but unlike the cases above this does not end the context:
+``KEYCRYPT_IOC_FINAL`` still works and ends it, itself detecting
+truncation: ``EBADMSG`` if no segment flagged LAST was ever processed, 0
+otherwise. The counter is 32 bits and runs from 0: segment number
+2^32-1, which would need to leave the counter at 2^32, gets
+``EOVERFLOW`` instead of silently wrapping it back to 0.
+``KEYCRYPT_IOC_UPDATE`` is ``EINVAL`` on an
+aes256-gcm-stream context, as is ``KEYCRYPT_IOC_SEGMENT`` on any other
+one.
+
+A fresh encryption context draws a fresh random 16-byte salt (`Using a
+key`_), unless its backend is of tier ``tee`` or ``hsm`` and meets
+`Backend requirements`_: such a backend draws the salt itself,
+overwriting whatever the core drew, and tracks the segment counter and
+whether the last segment was seen in the TEE or the hardware rather
+than the caller's, refusing a segment out of order or past the last
+one, so that a compromised kernel cannot make it reuse a nonce. The
+core itself, uncompromised, never calls a backend with such
+a segment: the counter lives in the kernel and is never set by user
+space, so this guards only against a compromised kernel, not a
+condition an ordinary caller can reach, and its refusal would reach
+user space as ``EIO`` like any other backend failure mid-context (see
+`Using a key`_), never as the backend's own internal error. A backend
+that drew the same salt for every stream instead of a fresh random one
+would reuse every nonce of every stream it opens; the core refuses a
+salt that comes out all zero, with ``EIO`` (`Using a key`_), which at
+least catches that case. Two streams under one key otherwise collide
+only if their salts do: about q^2/2^129 for q streams under that key,
+counting every device holding a copy of the key's blob; such a
+collision would reuse every nonce of the two streams. The salt needs no
+authentication of its own: a wrong salt derives the wrong subkey, which
+fails segment 0's tag.
+
+A decrypt-only aes256-gcm-stream key cannot be made to forge, unlike an
+aes256-cbc decryption key (`CBC and MAC`_), which is what an
+update-bundle verifier relies on: the property holds against a
+compromised device's own user space. It does not extend to a
+kernel-tier key shared across a fleet: that key is in clear in kernel
+memory on every device, so a compromised kernel on any one device can
+forge for the whole fleet. A fleet that must survive a compromised
+device wants a ``tee`` or ``hsm`` key, or signatures, instead: a
+``tee``/``hsm`` backend meeting `Backend requirements`_ surviving a
+compromised kernel is exactly why it checks the operation, in the TEE
+or the hardware, against the key's own purpose bound there, rather
+than trusting the kernel's copy of it (`Using a key`_).
+
+The stream is not key-committing: a segment's tag does not prove which
+key, among several a format might try, produced it. A format that may
+try several keys must pick the right one another way (e.g. a key
+identifier in the header) and never rely on a tag for that choice.
+
+The backend, not the core, builds the nonce: for a ``tee`` or ``hsm``
+backend, both the salt and the segment ordering are the backend's own
+(above); a backend of a lower tier, ``engine`` or ``kernel`` (the sw
+backend), draws neither itself and relies on the core's randomness and
+counter instead. The fd shares the salt and the counter
+between its holders (`An fd is a shared stream`_), safely, since calls
+on one fd are serialised.
+
+A file format built on it
+--------------------------
+
+An application such as an archive tool or an update bundle installer
+can build a file format directly on ``KEYCRYPT_IOC_SEGMENT``,
+informatively: the format is written and read in order, segment by
+segment; the counter cannot be set by encryption, by design, nor by
+decryption, for now (a decrypt-side seek could come later through
+``__reserved`` and a flag). A fixed header (a magic value per format,
+a format version or anti-rollback field the application checks, the
+segment size, the 16-byte salt, plus whatever metadata the format
+needs) is given as the associated data of segment 0, authenticating it
+without encrypting it, and cannot be patched afterwards; the rest of
+the file is segments of ``ciphertext || tag``, in order, the last one
+flagged. No header field but those needed to find segment 0 should be
+acted on before segment 0 verifies, and one key should never serve two
+formats, so that a blob valid for one cannot be replayed as another's.
+
+Decryption streams while reading: each segment's plaintext is usable as
+soon as its tag verifies, with no need to buffer the whole file first.
+Whatever the application does with a segment's plaintext before the
+stream's last segment verifies must be undoable: a file truncated by a
+failed write or a cut transfer is caught only at
+``KEYCRYPT_IOC_FINAL`` (0 once the last segment has verified), and
+closing the fd without calling it detects nothing.
+
 Why not AF_ALG or KEYCTL_PKEY_*
 ================================
 
@@ -784,9 +944,10 @@ in the kernel too: a skcipher socket's IV buffer lives in the socket
 and is advanced in place as the cipher mode chains across calls, the
 same state keycrypt keeps in its context. The difference is that
 ``AF_ALG`` never *chooses* an IV itself: it is always the caller's,
-zero by default and otherwise set with ``ALG_SET_IV``; keycrypt
-instead draws a random IV itself at ``KEYCTL_CRYPT_OPEN`` unless the
-caller asks for its own
+zero by default and otherwise set with ``ALG_SET_IV``, and an AEAD
+socket takes the caller's nonce on every request rather than drawing
+one; keycrypt instead draws a random IV or salt itself at
+``KEYCTL_CRYPT_OPEN`` unless the caller asks for its own
 (``KEYCRYPT_OPEN_CALLER_IV``, aes256-cbc encryption only). ``AF_ALG``
 also copies the key's payload into the socket and applies whatever
 algorithm the socket was set up for, with nothing tying the key to
@@ -816,18 +977,32 @@ EINVAL       ``__reserved`` or flags not zero, an unknown operation, an
              ``accepted_min_tier`` that is neither 0 nor a tier, an IV
              given for MAC or VERIFY, a non-zero IV given
              for CBC encryption without ``KEYCRYPT_OPEN_CALLER_IV``,
-             or that flag with anything but CBC encryption; a CBC length
-             not a multiple of 16, an ``out`` given for MAC or for
-             aes256-cbc FINAL, or missing for CBC UPDATE; VERIFY FINAL
-             with ``len`` other than 32; a ``usize`` below
+             that flag with anything but CBC encryption, or a non-zero
+             salt for aes256-gcm-stream encryption; a CBC length not a
+             multiple of 16, an ``out`` given for MAC or for
+             aes256-cbc or aes256-gcm-stream FINAL, or missing for CBC
+             UPDATE; VERIFY FINAL with ``len`` other than 32;
+             ``KEYCRYPT_IOC_UPDATE`` on an aes256-gcm-stream context,
+             or ``KEYCRYPT_IOC_SEGMENT`` on any other one; a segment's
+             flags other than ``KEYCRYPT_SEGMENT_LAST``, its
+             ``__reserved`` non-zero, its ``aad_len`` above
+             ``KEYCRYPT_AAD_MAX``, a ``tag`` of 0, a ``len`` given
+             without ``in`` or ``out``, or an ``aad_len`` given
+             without ``aad``; a ``usize`` below
              ``KEYCRYPT_OPEN_PARAMS_SIZE_VER0``
 E2BIG        ``usize`` above ``PAGE_SIZE``, or a non-zero byte in its
              excess over this kernel's ``struct keycrypt_open_params``;
-             a ``len`` above ``KEYCRYPT_UPDATE_MAX``
+             a ``len`` above ``KEYCRYPT_UPDATE_MAX`` (UPDATE) or
+             ``KEYCRYPT_SEGMENT_MAX`` (SEGMENT)
+EOVERFLOW    the aes256-gcm-stream segment counter would wrap: segment
+             number 2^32-1 on this context
 ENOSPC       MAC FINAL with ``out`` 0, or less than 32 bytes of room for
              the tag (the context stays usable)
 EBADMSG      VERIFY FINAL whose tag does not match (the context ends);
-             a backend's own
+             an aes256-gcm-stream segment whose tag does not match
+             (nothing is released, the context ends); aes256-gcm-stream
+             FINAL without a segment flagged ``KEYCRYPT_SEGMENT_LAST``
+             (truncation; the context ends); a backend's own
              ``EBADMSG`` from ``KEYCTL_CRYPT_OPEN`` (no fd is created)
              or from ``KEYCRYPT_IOC_UPDATE`` (the context ends)
 EKEYREVOKED  the key was revoked, its type removed, or (an already
@@ -852,14 +1027,19 @@ EIO          a backend failure, including one refusing at
              ``KEYCTL_CRYPT_OPEN`` itself: a backend's ``ENOMEM``,
              ``EINTR`` and ``EBADMSG`` pass unchanged (a restart it
              asks for restarts the call), any other error becomes
-             ``EIO`` (no fd is created either way)
-EBADFD       a call on a context that already ended: after
+             ``EIO`` (no fd is created either way); or
+             (``KEYCTL_CRYPT_OPEN``, aes256-gcm-stream encryption
+             only) a salt that comes out all zero, whatever the
+             backend's tier
+EBADFD       a segment past the one flagged ``KEYCRYPT_SEGMENT_LAST``,
+             which the context survives (``KEYCRYPT_IOC_FINAL`` still
+             works); or a call on a context that already ended: after
              FINAL, or after a failure once the backend had been
              called for this call (``EBADMSG``, ``EIO``, an
              ``EFAULT`` on the output copy, or ``EINTR`` from an
              interrupted backend). Every other error leaves the
              context usable too: ``EINVAL``, ``E2BIG``, ``ENOSPC``,
-             an ``EFAULT`` on the input copy or on
+             ``EOVERFLOW``, an ``EFAULT`` on the input copy or on
              ``KEYCRYPT_IOC_INFO``'s output copy, ``ENOMEM`` before
              the backend ran, ``EKEYREVOKED``, ``EKEYEXPIRED`` and
              ``ENODEV`` (repeated instead, above), and ``EINTR`` while
diff --git a/include/keys/keycrypt.h b/include/keys/keycrypt.h
index 8aae3d47e697..eae6010c678c 100644
--- a/include/keys/keycrypt.h
+++ b/include/keys/keycrypt.h
@@ -16,7 +16,8 @@ struct module;
 struct keycrypt_handle;
 
 #define KEYCRYPT_ALGS_ALL		(BIT(KEYCRYPT_ALG_AES256_CBC) | \
-					 BIT(KEYCRYPT_ALG_HMAC_SHA256))
+					 BIT(KEYCRYPT_ALG_HMAC_SHA256) | \
+					 BIT(KEYCRYPT_ALG_AES256_GCM_STREAM))
 
 #define KEYCRYPT_BACKEND_DATA_MAX	4096
 
@@ -75,6 +76,9 @@ struct keycrypt_key {
 	void			*priv;
 };
 
+/* The STREAM subkey's HKDF info string, fixed by the protocol */
+#define KEYCRYPT_STREAM_INFO	"keycrypt aes256-gcm stream v1"
+
 /**
  * struct keycrypt_backend - a place where keycrypt keys live
  * @name: [a-z0-9_-], at most KEYCRYPT_BACKEND_NAME_MAX; it names a sealing
@@ -91,7 +95,8 @@ struct keycrypt_key {
  *	set @k->priv if needed, leaving it unset on failure
  * @destroy: release @k->priv; called at most once per key, and last
  * @ctx_open: start @op on @k and set *@ctx, releasing what it acquired on
- *	failure; @iv (16 bytes) is the aes256-cbc IV, used as given
+ *	failure; @iv (16 bytes) is the aes256-cbc IV, used as given, or the
+ *	aes256-gcm-stream salt, which a backend drawing its own may overwrite
  * @update: process @len bytes from @in to @out, in place allowed; @out is
  *	NULL for MAC and VERIFY
  * @final: end the context; MAC and VERIFY write the 32-byte tag to @out
@@ -100,6 +105,9 @@ struct keycrypt_key {
  *	the key lives, 0 or -EBADMSG, never the tag. Required of a _TEE or
  *	_HSM backend with context callbacks offering hmac-sha256
  * @ctx_free: release @ctx, once, however the context ends
+ * @aead: seal or open segment @seq of an aes256-gcm-stream (@last for the
+ *	final one) as keycrypt.rst describes, writing or checking @tag;
+ *	-EBADMSG leaves @out zeroed. Required for aes256-gcm-stream
  * @handle: core private
  *
  * @opts given to a callback are the "key=value" options the core did not
@@ -140,6 +148,9 @@ struct keycrypt_backend {
 	int (*verify)(struct keycrypt_backend *b, void *ctx,
 		      const u8 *expected);
 	void (*ctx_free)(struct keycrypt_backend *b, void *ctx);
+	int (*aead)(struct keycrypt_backend *b, void *ctx, u32 seq, bool last,
+		    const u8 *aad, size_t aad_len, const u8 *in, u8 *out,
+		    size_t len, u8 *tag);
 
 	struct keycrypt_handle *handle;
 };
diff --git a/include/uapi/linux/keycrypt.h b/include/uapi/linux/keycrypt.h
index 71209a08c924..3d5716b2147e 100644
--- a/include/uapi/linux/keycrypt.h
+++ b/include/uapi/linux/keycrypt.h
@@ -39,6 +39,7 @@
 /* struct keycrypt_info: the key's algorithm */
 #define KEYCRYPT_ALG_AES256_CBC		1
 #define KEYCRYPT_ALG_HMAC_SHA256	2
+#define KEYCRYPT_ALG_AES256_GCM_STREAM	3
 
 /* struct keycrypt_info: the key's purpose mask */
 #define KEYCRYPT_PURPOSE_ENCRYPT	0x0001
@@ -66,6 +67,9 @@
  * @iv: aes256-cbc: the IV, given for decryption and with
  *	KEYCRYPT_OPEN_CALLER_IV, otherwise written back by the kernel; MAC
  *	and VERIFY: zero
+ * @salt: aes256-gcm-stream: the stream's KEYCRYPT_STREAM_SALT_LEN-byte
+ *	salt, given for decryption, written back for encryption; an alias
+ *	of @iv (one 16-byte field, named for the algorithm it is used with)
  *
  * Extended by size (copy_struct_from_user()); at least
  * KEYCRYPT_OPEN_PARAMS_SIZE_VER0 bytes.
@@ -75,7 +79,10 @@ struct keycrypt_open_params {
 	__u32	accepted_min_tier;
 	__u32	flags;
 	__u32	__reserved;
-	__u8	iv[16];
+	union {
+		__u8	iv[16];		/* aes256-cbc */
+		__u8	salt[16];	/* aes256-gcm-stream */
+	};
 };
 
 #define KEYCRYPT_OPEN_PARAMS_SIZE_VER0	32
@@ -98,7 +105,7 @@ struct keycrypt_update {
  * struct keycrypt_final - KEYCRYPT_IOC_FINAL argument
  * @out: user pointer; MAC: the tag, written, @len room in, bytes out;
  *	VERIFY: the expected 32-byte tag, read, @len must be 32, 0 back;
- *	aes256-cbc: 0, and @len comes back 0
+ *	aes256-cbc and aes256-gcm-stream: 0, and @len comes back 0
  * @len: see @out
  * @flags: must be zero
  */
@@ -111,6 +118,36 @@ struct keycrypt_final {
 #define KEYCRYPT_UPDATE_MAX	65536
 #define KEYCRYPT_MAC_LEN	32
 
+/**
+ * struct keycrypt_segment - KEYCRYPT_IOC_SEGMENT argument (aes256-gcm-stream)
+ * @in: user pointer to @len input bytes
+ * @out: user pointer to @len output bytes
+ * @aad: user pointer to @aad_len bytes of associated data, or 0
+ * @tag: user pointer to the KEYCRYPT_AEAD_TAG_LEN-byte tag: written when
+ *	encrypting, read when decrypting
+ * @len: bytes, at most KEYCRYPT_SEGMENT_MAX
+ * @aad_len: bytes, at most KEYCRYPT_AAD_MAX
+ * @flags: KEYCRYPT_SEGMENT_LAST for the stream's last segment
+ * @__reserved: must be zero
+ */
+struct keycrypt_segment {
+	__u64	in;
+	__u64	out;
+	__u64	aad;
+	__u64	tag;
+	__u32	len;
+	__u32	aad_len;
+	__u32	flags;
+	__u32	__reserved;
+};
+
+#define KEYCRYPT_SEGMENT_LAST	0x0001
+
+#define KEYCRYPT_SEGMENT_MAX	65536
+#define KEYCRYPT_AAD_MAX	4096
+#define KEYCRYPT_AEAD_TAG_LEN	16
+#define KEYCRYPT_STREAM_SALT_LEN	16
+
 /**
  * struct keycrypt_info - KEYCRYPT_IOC_INFO argument, written by the kernel
  * @op: KEYCRYPT_OP_* the context was opened for
@@ -139,7 +176,7 @@ struct keycrypt_info {
 #define KEYCRYPT_IOC_MAGIC	0xBB
 #define KEYCRYPT_IOC_UPDATE	_IOW(KEYCRYPT_IOC_MAGIC, 1, struct keycrypt_update)
 #define KEYCRYPT_IOC_FINAL	_IOWR(KEYCRYPT_IOC_MAGIC, 2, struct keycrypt_final)
-/* 3: KEYCRYPT_IOC_SEGMENT, with the aes256-gcm-stream algorithm */
+#define KEYCRYPT_IOC_SEGMENT	_IOW(KEYCRYPT_IOC_MAGIC, 3, struct keycrypt_segment)
 #define KEYCRYPT_IOC_INFO	_IOR(KEYCRYPT_IOC_MAGIC, 4, struct keycrypt_info)
 
 #endif /* _UAPI_LINUX_KEYCRYPT_H */
diff --git a/security/keys/keycrypt/core.c b/security/keys/keycrypt/core.c
index 4a2609c6830f..916fa329293d 100644
--- a/security/keys/keycrypt/core.c
+++ b/security/keys/keycrypt/core.c
@@ -36,6 +36,7 @@ struct keycrypt_name {
 static const struct keycrypt_name keycrypt_algs[] = {
 	{ KEYCRYPT_ALG_AES256_CBC,	"aes256-cbc" },
 	{ KEYCRYPT_ALG_HMAC_SHA256,	"hmac-sha256" },
+	{ KEYCRYPT_ALG_AES256_GCM_STREAM,	"aes256-gcm-stream" },
 };
 
 static const struct keycrypt_name keycrypt_tiers[] = {
@@ -87,6 +88,7 @@ static bool keycrypt_purpose_valid(u8 alg, u16 purpose)
 {
 	switch (alg) {
 	case KEYCRYPT_ALG_AES256_CBC:
+	case KEYCRYPT_ALG_AES256_GCM_STREAM:
 		return purpose && !(purpose & ~(KEYCRYPT_PURPOSE_ENCRYPT |
 						KEYCRYPT_PURPOSE_DECRYPT));
 	case KEYCRYPT_ALG_HMAC_SHA256:
@@ -410,6 +412,7 @@ int keycrypt_register_backend(struct keycrypt_backend *b)
 	    !b->algs || (b->algs & ~KEYCRYPT_ALGS_ALL) ||
 	    !b->generate || !b->load ||
 	    ((!!b->ctx_open + !!b->update + !!b->final + !!b->ctx_free) % 4) ||
+	    ((b->algs & BIT(KEYCRYPT_ALG_AES256_GCM_STREAM)) && !b->aead) ||
 	    (b->tier >= KEYCRYPT_TIER_TEE &&
 	     b->ctx_open &&
 	     (b->algs & BIT(KEYCRYPT_ALG_HMAC_SHA256)) && !b->verify))
diff --git a/security/keys/keycrypt/ctx.c b/security/keys/keycrypt/ctx.c
index ce62ba08479b..7addd0e75628 100644
--- a/security/keys/keycrypt/ctx.c
+++ b/security/keys/keycrypt/ctx.c
@@ -26,8 +26,12 @@
 #include "../internal.h"
 #include "keycrypt.h"
 
+static_assert(KEYCRYPT_STREAM_SALT_LEN ==
+	      sizeof_field(struct keycrypt_open_params, salt));
 static_assert(offsetofend(struct keycrypt_open_params, iv) ==
 	      KEYCRYPT_OPEN_PARAMS_SIZE_VER0);
+static_assert(sizeof_field(struct keycrypt_open_params, iv) ==
+	      sizeof_field(struct keycrypt_open_params, salt));
 static_assert(KEYCRYPT_BACKEND_NAME_MAX <
 	      sizeof_field(struct keycrypt_info, backend));
 
@@ -193,6 +197,8 @@ static long keycrypt_ioc_update(struct keycrypt_ctx *c,
 	bool ran = false;
 	long ret;
 
+	if (c->meta.alg == KEYCRYPT_ALG_AES256_GCM_STREAM)
+		return -EINVAL;
 	if (copy_from_user(&u, uarg, sizeof(u)))
 		return -EFAULT;
 	if (u.flags || (hmac && u.out) || (!hmac && u.len && !u.out) ||
@@ -310,6 +316,8 @@ static long keycrypt_ioc_final(struct keycrypt_ctx *c,
 			ret = -EFAULT;
 		goto wipe;
 	}
+	if (!ret && c->meta.alg == KEYCRYPT_ALG_AES256_GCM_STREAM)
+		ret = c->last_seen ? 0 : -EBADMSG;
 	if (!ret && len != (mac || verify ? KEYCRYPT_MAC_LEN : 0))
 		ret = -EIO;
 	if (!ret && verify && crypto_memneq(tag, expected, KEYCRYPT_MAC_LEN))
@@ -327,6 +335,111 @@ static long keycrypt_ioc_final(struct keycrypt_ctx *c,
 	return ret;
 }
 
+/*
+ * Segment @seq of the stream; the backend derives the nonce. Encryption
+ * writes the ciphertext and its tag; decryption decrypts into a kernel
+ * buffer and copies it out only once the tag verifies. Nothing after the
+ * segment flagged LAST is accepted; aes256-gcm-stream only.
+ */
+static long keycrypt_ioc_segment(struct keycrypt_ctx *c,
+				 struct keycrypt_segment __user *uarg)
+{
+	bool enc = c->op == KEYCRYPT_OP_ENCRYPT;
+	u8 tag[KEYCRYPT_AEAD_TAG_LEN];
+	u8 *in = NULL, *out = NULL, *aad = NULL;
+	struct keycrypt_backend *b;
+	struct keycrypt_segment s;
+	bool last, ran = false;
+	long ret;
+
+	if (c->meta.alg != KEYCRYPT_ALG_AES256_GCM_STREAM)
+		return -EINVAL;
+	if (copy_from_user(&s, uarg, sizeof(s)))
+		return -EFAULT;
+	if (s.__reserved || (s.flags & ~KEYCRYPT_SEGMENT_LAST) ||
+	    s.aad_len > KEYCRYPT_AAD_MAX)
+		return -EINVAL;
+	if (s.len > KEYCRYPT_SEGMENT_MAX)
+		return -E2BIG;
+	if (!s.tag || (s.len && (!s.in || !s.out)) ||
+	    (s.aad_len && !s.aad))
+		return -EINVAL;
+	last = s.flags & KEYCRYPT_SEGMENT_LAST;
+
+	ret = mutex_lock_killable(&c->lock);
+	if (ret)
+		return ret;
+	if (c->done || c->last_seen) {
+		ret = -EBADFD;
+		goto unlock;
+	}
+	ret = keycrypt_ctx_check(c);
+	if (ret)
+		goto unlock;
+	if (c->seq == U32_MAX) {
+		ret = -EOVERFLOW;
+		goto unlock;
+	}
+
+	if (s.len) {
+		in = kvmalloc(s.len, GFP_KERNEL_ACCOUNT);
+		out = kvmalloc(s.len, GFP_KERNEL_ACCOUNT);
+		if (!in || !out) {
+			ret = -ENOMEM;
+			goto free;
+		}
+		if (copy_from_user(in, u64_to_user_ptr(s.in), s.len)) {
+			ret = -EFAULT;
+			goto free;
+		}
+	}
+	if (s.aad_len) {
+		aad = kvmalloc(s.aad_len, GFP_KERNEL_ACCOUNT);
+		if (!aad) {
+			ret = -ENOMEM;
+			goto free;
+		}
+		if (copy_from_user(aad, u64_to_user_ptr(s.aad), s.aad_len)) {
+			ret = -EFAULT;
+			goto free;
+		}
+	}
+	if (!enc && copy_from_user(tag, u64_to_user_ptr(s.tag),
+				   sizeof(tag))) {
+		ret = -EFAULT;
+		goto free;
+	}
+
+	down_read(&c->h->sem);
+	ret = keycrypt_ctx_backend(c, &b);
+	ran = !ret;
+	if (!ret)
+		ret = keycrypt_ctx_ret(b->aead(b, c->bctx, c->seq, last, aad,
+					       s.aad_len, in, out, s.len,
+					       tag));
+	up_read(&c->h->sem);
+
+	if (!ret && s.len && copy_to_user(u64_to_user_ptr(s.out), out, s.len))
+		ret = -EFAULT;
+	if (!ret && enc && copy_to_user(u64_to_user_ptr(s.tag), tag,
+					sizeof(tag)))
+		ret = -EFAULT;
+	if (!ret) {
+		c->seq++;
+		c->last_seen = last;
+	} else if (ran) {
+		ret = keycrypt_ctx_end(c, ret);
+	}
+free:
+	kvfree_sensitive(in, s.len);
+	kvfree_sensitive(out, s.len);
+	kvfree_sensitive(aad, s.aad_len);
+	memzero_explicit(tag, sizeof(tag));
+unlock:
+	mutex_unlock(&c->lock);
+	return ret;
+}
+
 static long keycrypt_ioc_info(struct keycrypt_ctx *c,
 			      struct keycrypt_info __user *uarg)
 {
@@ -349,6 +462,8 @@ static long keycrypt_ioctl(struct file *file, unsigned int cmd,
 		return keycrypt_ioc_update(c, (void __user *)arg);
 	case KEYCRYPT_IOC_FINAL:
 		return keycrypt_ioc_final(c, (void __user *)arg);
+	case KEYCRYPT_IOC_SEGMENT:
+		return keycrypt_ioc_segment(c, (void __user *)arg);
 	case KEYCRYPT_IOC_INFO:
 		return keycrypt_ioc_info(c, (void __user *)arg);
 	}
@@ -375,6 +490,7 @@ static const struct file_operations keycrypt_fops = {
  */
 static int keycrypt_open_backend(struct keycrypt_handle *h,
 				 const struct keycrypt_payload *p,
+				 u8 alg,
 				 struct keycrypt_backend **b)
 {
 	*b = h->b;
@@ -384,6 +500,8 @@ static int keycrypt_open_backend(struct keycrypt_handle *h,
 		return -EKEYREVOKED;
 	if (!(*b)->ctx_open)
 		return -ENODEV;
+	if (WARN_ON_ONCE(alg == KEYCRYPT_ALG_AES256_GCM_STREAM && !(*b)->aead))
+		return -EIO;	/* registration refuses such a backend */
 	return 0;
 }
 
@@ -463,6 +581,12 @@ long keyctl_crypt_open(key_serial_t id, void __user *uparams,
 		if (gen_iv && memchr_inv(params.iv, 0, sizeof(params.iv)))
 			ret = -EINVAL;
 	}
+	if (!ret && p->key.meta.alg == KEYCRYPT_ALG_AES256_GCM_STREAM &&
+	    params.op == KEYCRYPT_OP_ENCRYPT) {
+		gen_iv = true;
+		if (memchr_inv(params.salt, 0, sizeof(params.salt)))
+			ret = -EINVAL;
+	}
 	h = ret ? NULL : p->handle;
 	if (h)
 		refcount_inc(&h->ref);
@@ -490,7 +614,7 @@ long keyctl_crypt_open(key_serial_t id, void __user *uparams,
 	c->accepted_min_tier = params.accepted_min_tier;
 
 	down_read(&h->sem);
-	ret = keycrypt_open_backend(h, p, &b);
+	ret = keycrypt_open_backend(h, p, c->meta.alg, &b);
 	if (!ret)
 		ret = keycrypt_ctx_ret(b->ctx_open(b, &p->key, params.op,
 						   params.iv, &c->bctx));
@@ -506,6 +630,19 @@ long keyctl_crypt_open(key_serial_t id, void __user *uparams,
 		goto put_handle;
 	}
 
+	/*
+	 * An all-zero salt would make every stream reuse the same nonces: refuse
+	 * it, whether a backend drawing its own salt wrote it or the core's
+	 * random bytes came out so
+	 */
+	if (c->meta.alg == KEYCRYPT_ALG_AES256_GCM_STREAM &&
+	    c->op == KEYCRYPT_OP_ENCRYPT &&
+	    !memchr_inv(params.salt, 0, sizeof(params.salt))) {
+		memzero_explicit(params.salt, sizeof(params.salt));
+		keycrypt_ctx_free(c);
+		return -EIO;
+	}
+
 	/* The write-back happens before the fd exists: no fd on EFAULT */
 	if (gen_iv &&
 	    copy_to_user(((struct keycrypt_open_params __user *)uparams)->iv,
diff --git a/security/keys/keycrypt/keycrypt.h b/security/keys/keycrypt/keycrypt.h
index 40487eb3e139..1d16217d93f7 100644
--- a/security/keys/keycrypt/keycrypt.h
+++ b/security/keys/keycrypt/keycrypt.h
@@ -110,6 +110,8 @@ struct keycrypt_req {
  * @accepted_min_tier: the caller's KEYCRYPT_TIER_* at open, or 0
  * @done: ended by FINAL or by a failure once the backend ran; every later
  *	call gives -EBADFD
+ * @seq: aes256-gcm-stream: the next segment's counter
+ * @last_seen: aes256-gcm-stream: a segment flagged LAST was processed
  */
 struct keycrypt_ctx {
 	struct mutex		lock;	/* serialises the calls on the fd */
@@ -121,6 +123,8 @@ struct keycrypt_ctx {
 	struct keycrypt_meta	meta;
 	u8			accepted_min_tier;
 	bool			done;
+	u32			seq;
+	bool			last_seen;
 };
 
 /* The key length each algorithm takes; false for an unknown alg */
@@ -128,6 +132,7 @@ static inline bool keycrypt_key_len_valid(u8 alg, size_t len)
 {
 	switch (alg) {
 	case KEYCRYPT_ALG_AES256_CBC:
+	case KEYCRYPT_ALG_AES256_GCM_STREAM:
 		return len == 32;
 	case KEYCRYPT_ALG_HMAC_SHA256:
 		return len >= 1 && len <= 64;
diff --git a/security/keys/keycrypt/optee.c b/security/keys/keycrypt/optee.c
index 5a3ab6f825f1..b616d77acef1 100644
--- a/security/keys/keycrypt/optee.c
+++ b/security/keys/keycrypt/optee.c
@@ -20,20 +20,22 @@
 /*
  * Offsets in a shared buffer, which carries one call's parameters at a
  * time: header, blob and imported key for a control call; header, blob
- * and IV for CTX_OPEN; data and tag for a context's later calls.
+ * and IV for CTX_OPEN; data, AAD and tag for a context's later calls.
  */
 #define KC_SHM_HDR	0
 #define KC_SHM_BLOB	(KC_SHM_HDR + KEYCRYPT_HEADER_MAX)
 #define KC_SHM_KEY	(KC_SHM_BLOB + KC_TA_DATA_MAX)
 #define KC_CTL_SIZE	(KC_SHM_KEY + KC_KEY_MAX)
 #define KC_SHM_DATA	0
-#define KC_SHM_TAG	(KC_SHM_DATA + KEYCRYPT_UPDATE_MAX)
+#define KC_SHM_AAD	(KC_SHM_DATA + KEYCRYPT_SEGMENT_MAX)
+#define KC_SHM_TAG	(KC_SHM_AAD + KEYCRYPT_AAD_MAX)
 #define KC_SHM_IV	(KC_SHM_TAG + KEYCRYPT_MAC_LEN)
-#define KC_IV_LEN	sizeof_field(struct keycrypt_open_params, iv)
-#define KC_CTX_SIZE	(KC_SHM_IV + KC_IV_LEN)
+#define KC_CTX_SIZE	(KC_SHM_IV + KEYCRYPT_STREAM_SALT_LEN)
 
-static_assert(KC_SHM_BLOB + KC_TA_DATA_MAX <= KC_SHM_TAG);
-static_assert(KEYCRYPT_UPDATE_MAX <= KC_TA_BUF_MAX);
+static_assert(KEYCRYPT_UPDATE_MAX <= KEYCRYPT_SEGMENT_MAX);
+static_assert(KC_SHM_BLOB + KC_TA_DATA_MAX <= KC_SHM_AAD);
+static_assert(KEYCRYPT_SEGMENT_MAX <= KC_TA_BUF_MAX);
+static_assert(KEYCRYPT_AAD_MAX <= KC_TA_AAD_MAX);
 
 /**
  * struct kc_optee - the backend's link to the TA
@@ -239,7 +241,7 @@ static int kc_optee_ctx_open(struct keycrypt_backend *b,
 
 	memcpy(c->va + KC_SHM_HDR, k->hdr, k->hdr_len);
 	memcpy(c->va + KC_SHM_BLOB, k->data, k->data_len);
-	memcpy(c->va + KC_SHM_IV, iv, KC_IV_LEN);
+	memcpy(c->va + KC_SHM_IV, iv, KEYCRYPT_STREAM_SALT_LEN);
 	kc_memref(&p[0], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, c->shm,
 		  KC_SHM_HDR, k->hdr_len);
 	kc_memref(&p[1], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, c->shm,
@@ -247,12 +249,16 @@ static int kc_optee_ctx_open(struct keycrypt_backend *b,
 	p[2].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
 	p[2].u.value.a = op;
 	kc_memref(&p[3], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT, c->shm,
-		  KC_SHM_IV, KC_IV_LEN);
+		  KC_SHM_IV, KEYCRYPT_STREAM_SALT_LEN);
 	ret = kc_invoke(c->session, KC_TA_CMD_CTX_OPEN, p);
-	if (!ret && p[3].u.memref.size != KC_IV_LEN)
+	if (!ret && p[3].u.memref.size != KEYCRYPT_STREAM_SALT_LEN)
 		ret = -EIO;
 	if (ret)
 		goto wipe;
+	/* The TA drew the salt of a stream to encrypt: the caller gets it */
+	if (k->meta.alg == KEYCRYPT_ALG_AES256_GCM_STREAM &&
+	    op == KEYCRYPT_OP_ENCRYPT)
+		memcpy(iv, c->va + KC_SHM_IV, KEYCRYPT_STREAM_SALT_LEN);
 	memzero_explicit(c->va, KC_CTX_SIZE);
 	c->alg = k->meta.alg;
 	c->op = op;
@@ -332,6 +338,51 @@ static int kc_optee_verify(struct keycrypt_backend *b, void *ctx,
 	return ret;
 }
 
+static int kc_optee_aead(struct keycrypt_backend *b, void *ctx, u32 seq,
+			 bool last, const u8 *aad, size_t aad_len,
+			 const u8 *in, u8 *out, size_t len, u8 *tag)
+{
+	struct kc_optee_ctx *c = ctx;
+	bool enc = c->op == KEYCRYPT_OP_ENCRYPT;
+	struct tee_param p[4] = {};
+	int ret;
+
+	if (len > KEYCRYPT_SEGMENT_MAX || aad_len > KEYCRYPT_AAD_MAX)
+		return -EIO;
+	if (len) {
+		memcpy(c->va + KC_SHM_DATA, in, len);
+		kc_memref(&p[0], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT, c->shm,
+			  KC_SHM_DATA, len);
+	}
+	if (aad_len) {
+		memcpy(c->va + KC_SHM_AAD, aad, aad_len);
+		kc_memref(&p[1], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT, c->shm,
+			  KC_SHM_AAD, aad_len);
+	}
+	if (!enc)
+		memcpy(c->va + KC_SHM_TAG, tag, KEYCRYPT_AEAD_TAG_LEN);
+	kc_memref(&p[2], TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT, c->shm,
+		  KC_SHM_TAG, KEYCRYPT_AEAD_TAG_LEN);
+	p[3].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
+	p[3].u.value.a = seq;
+	p[3].u.value.b = last;
+	ret = kc_invoke(c->session, KC_TA_CMD_SEGMENT, p);
+	if (!ret && ((len && p[0].u.memref.size != len) ||
+		     (enc && p[2].u.memref.size != KEYCRYPT_AEAD_TAG_LEN)))
+		ret = -EIO;
+	/* An empty segment comes with no buffers (@in and @out NULL) */
+	if (!ret && len)
+		memcpy(out, c->va + KC_SHM_DATA, len);
+	if (!ret && enc)
+		memcpy(tag, c->va + KC_SHM_TAG, KEYCRYPT_AEAD_TAG_LEN);
+	if (ret && len)
+		memset(out, 0, len);
+	memzero_explicit(c->va + KC_SHM_DATA, len);
+	memzero_explicit(c->va + KC_SHM_AAD, aad_len);
+	memzero_explicit(c->va + KC_SHM_TAG, KEYCRYPT_AEAD_TAG_LEN);
+	return ret;
+}
+
 static void kc_optee_ctx_free(struct keycrypt_backend *b, void *ctx)
 {
 	struct kc_optee_ctx *c = ctx;
@@ -353,6 +404,7 @@ static struct keycrypt_backend keycrypt_optee = {
 	.final		= kc_optee_final,
 	.verify		= kc_optee_verify,
 	.ctx_free	= kc_optee_ctx_free,
+	.aead		= kc_optee_aead,
 };
 
 static int kc_optee_match(struct tee_ioctl_version_data *ver,
diff --git a/security/keys/keycrypt/optee.h b/security/keys/keycrypt/optee.h
index 391eba15b699..546c1665fc5f 100644
--- a/security/keys/keycrypt/optee.h
+++ b/security/keys/keycrypt/optee.h
@@ -23,9 +23,11 @@
 #define KC_TA_CMD_UPDATE	4
 #define KC_TA_CMD_FINAL		5
 #define KC_TA_CMD_VERIFY	6
+#define KC_TA_CMD_SEGMENT	7
 
 #define KC_TA_DATA_MAX		93	/* the TA's data: 1 + 12 + 64 + 16 */
-#define KC_TA_BUF_MAX		65536	/* data of one UPDATE */
+#define KC_TA_BUF_MAX		65536	/* data of one UPDATE or SEGMENT */
+#define KC_TA_AAD_MAX		4096	/* associated data of one SEGMENT */
 /* The TA's limit, the control session included; not enforced here */
 #define KC_TA_SESSIONS_MAX	32
 
diff --git a/security/keys/keycrypt/sw.c b/security/keys/keycrypt/sw.c
index f1ff4de4afc6..28cc7188d587 100644
--- a/security/keys/keycrypt/sw.c
+++ b/security/keys/keycrypt/sw.c
@@ -4,7 +4,9 @@
  * trusted key, used by the kernel itself
  *
  * The blob's layout and its GCM key are in keycrypt.rst, "The sw
- * backend".
+ * backend". That GCM use seals the key at rest only: an aes256-gcm-stream
+ * key's own stream segments run under a separate per-stream subkey,
+ * derived by sw_ctx_open() from the salt the core passes in.
  *
  * Copyright (C) 2026 Rodolfo Giometti <giometti@enneenne.com>
  */
@@ -20,6 +22,7 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/unaligned.h>
 #include "keycrypt.h"
 #include "sw.h"
 
@@ -151,6 +154,28 @@ static int keycrypt_sw_unseal(const u8 *master, size_t mlen,
 	return 0;
 }
 
+/*
+ * HKDF-SHA256 (RFC 5869) with one block of output: extract with @salt,
+ * expand with @info, 32 bytes to @out.
+ */
+static void sw_hkdf_sha256(const u8 *ikm, size_t ikm_len,
+			   const u8 *salt, size_t salt_len,
+			   const u8 *info, size_t info_len,
+			   u8 *out)
+{
+	static const u8 one = 1;
+	struct hmac_sha256_ctx ctx;
+	u8 prk[SHA256_DIGEST_SIZE];
+
+	hmac_sha256_usingrawkey(salt, salt_len, ikm, ikm_len, prk);
+	hmac_sha256_init_usingrawkey(&ctx, prk, sizeof(prk));
+	hmac_sha256_update(&ctx, info, info_len);
+	hmac_sha256_update(&ctx, &one, 1);
+	hmac_sha256_final(&ctx, out);
+	memzero_explicit(prk, sizeof(prk));
+	memzero_explicit(&ctx, sizeof(ctx));
+}
+
 /*
  * Copy the key material of the trusted key @desc that the caller can
  * search for into @buf (MAX_KEY_SIZE bytes). No callout information, so no
@@ -286,6 +311,7 @@ static void sw_destroy(struct keycrypt_backend *b, struct keycrypt_key *k)
 
 struct sw_ctx {
 	u32 op;
+	bool enc;	/* aes256-gcm-stream only: encryption, not decryption */
 	union {
 		struct {
 			union {
@@ -295,6 +321,7 @@ struct sw_ctx {
 			u8 iv[AES_BLOCK_SIZE];
 		} cbc;
 		struct hmac_sha256_ctx mac;
+		struct aes_gcm_key gcm;
 	};
 };
 
@@ -311,7 +338,21 @@ static int sw_ctx_open(struct keycrypt_backend *b, struct keycrypt_key *k,
 	if (!c)
 		return -ENOMEM;
 	c->op = op;
-	if (op == KEYCRYPT_OP_MAC || op == KEYCRYPT_OP_VERIFY) {
+	if (k->meta.alg == KEYCRYPT_ALG_AES256_GCM_STREAM) {
+		u8 sk[SHA256_DIGEST_SIZE];
+
+		c->enc = op == KEYCRYPT_OP_ENCRYPT;
+		sw_hkdf_sha256(kk->key, kk->len, iv, KEYCRYPT_STREAM_SALT_LEN,
+			       KEYCRYPT_STREAM_INFO,
+			       sizeof(KEYCRYPT_STREAM_INFO) - 1, sk);
+		ret = aes_gcm_preparekey(&c->gcm, sk, sizeof(sk),
+					 KEYCRYPT_AEAD_TAG_LEN);
+		memzero_explicit(sk, sizeof(sk));
+		if (ret) {
+			kfree_sensitive(c);
+			return -EIO;
+		}
+	} else if (op == KEYCRYPT_OP_MAC || op == KEYCRYPT_OP_VERIFY) {
 		hmac_sha256_init_usingrawkey(&c->mac, kk->key, kk->len);
 	} else {
 		ret = op == KEYCRYPT_OP_ENCRYPT ?
@@ -327,6 +368,28 @@ static int sw_ctx_open(struct keycrypt_backend *b, struct keycrypt_key *k,
 	return 0;
 }
 
+static int sw_aead(struct keycrypt_backend *b, void *ctx, u32 seq, bool last,
+		   const u8 *aad, size_t aad_len, const u8 *in, u8 *out,
+		   size_t len, u8 *tag)
+{
+	struct sw_ctx *c = ctx;
+	u8 nonce[12] = {};
+
+	put_unaligned_be32(seq, nonce + 7);
+	nonce[11] = last;
+
+	if (c->enc) {
+		aes_gcm_encrypt(out, in, len, tag, aad, aad_len, nonce,
+				&c->gcm);
+		return 0;
+	}
+	if (aes_gcm_decrypt(out, in, len, tag, aad, aad_len, nonce, &c->gcm)) {
+		memzero_explicit(out, len);
+		return -EBADMSG;
+	}
+	return 0;
+}
+
 static int sw_update(struct keycrypt_backend *b, void *ctx, const u8 *in,
 		     u8 *out, size_t len)
 {
@@ -382,6 +445,7 @@ static struct keycrypt_backend keycrypt_sw = {
 	.update		= sw_update,
 	.final		= sw_final,
 	.ctx_free	= sw_ctx_free,
+	.aead		= sw_aead,
 };
 
 static int __init keycrypt_sw_init(void)
-- 
2.43.0

