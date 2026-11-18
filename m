Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.91
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010861;
	b=p97X6L5zdEMPs60S97xS/yxxkJAs/Vgdmh1EqfT2nXPixoyG8zB26AM+MOLjC7PxkjI2
	 Rpqh7m3yLobqw5t06JpbkXfhn9itSmF/3t4Se05wo2m6W20SnLN3r8DdwYaFoFwo1SWBI
	 sa3yV82yoiNjJfmc3T0bmhwaBk4gCxyn5CJQQoF4dCaQZcvEjtr8tXX1J1Ox5juQ1eaps
	 ef691366lumys51C/xJqmHY7KZ+mh2jaU7MeiOKrzC1Sh5N+TYKJPDJwUCdh/NSemFPgf
	 IHX3L5wejValAzUiZNYyrjw8OMUibnKsBVdVwW62+Q5Vj2pZcsgI5BnsLJhJ5RaNmOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010861;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=tnG27anv/clasJ41YJT6fNDRfPYKa85htRw7qYwHbVQ=;
	b=1RMrsNAdMqo/nyqoLJ9cgbfBYxbRXvy9jX5RsBpCflDrNfWwd8nkASA2xvCaae1o27wr
	 tO/bWqpDJl/6syMvIiaxvL5AdPgCL13/P/w6a75IaKU/sAgln0Q/5FyX+UL8zSxqYm/Qr
	 63ewb6XQIRH6Nzp5Peg3VXWcZv146Uq9bLbFocOA9G5KYVyXDH6EpkHNq4yUu/klh0PF5
	 YbGAjeiOO7BEywbzEfRVg1S7C2otxBXCgvYcRX+05JlZwZ5FiVb+jSfHs2Xyk4Ry2CtQg
	 3c8E70C1z1WY943lWwB9cPMUUFqtkR2/h0hAnNnXg3GoRz4/ymJAl8vRB2dJLpFVG1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b="Y/RfSfCb";
	arc=none smtp.remote-ip=62.149.156.91
Received: from smtpcmd0991.aruba.it (smtpcmd0991.aruba.it [62.149.156.91])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2B8606A32A
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED2B8606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=Y/RfSfCb
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgK1xLN2v6q8sTgK1xc7sL; Wed, 18 Nov 2026 15:07:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795010858; bh=TKjIwAmGMFv+JF/ig2rkwBzdBx15DkKnvWVe1PUV+Tc=;
	h=From:To:Subject:Date:MIME-Version;
	b=Y/RfSfCbSwBLOvlghAk9YDLryEAGLMYlWEc3np39XqzLTN1y4q1DKyIVZ7NK6Of8X
	 zn+tJrqMa/V1R5UClqCMmpB5r0PqW7AUXY2Qs7Xoj0ypkYqjdaZBpTMe8QSjs0V9pf
	 oBUgbQUZPCDHyemR1BWFOw9BqWskUDJeN7Zw6iNFzgeIs1p3uadm6rUKpsstn8fYVd
	 nJa0xn+9SkTy9Wk0Zs6dcw/1fU7LDfrBtppIwk+u2fuan0L/OUITyvEXzU3LY9EuaD
	 LLre2jrKhjuZTUUnmsDKHevzFxmFBFTeTyq0yzJxGAFTOec/GG5GxlxJ0FTy10cV3n
	 BPecznVVmN0MQ==
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
Subject: [RFC PATCH 4/9] docs: keycrypt: document keycrypt keys
Date: Wed, 18 Nov 2026 15:07:34 +0100
Message-ID: <20261118140734.601772-1-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfCr+9l+FJskrH+951sUXEa28jLHOtUMW4t9z7zxKyh/LXO4sqoa7bQBd5Rk6CQeu3aHUyoWlOXg5QGIjMDgGUfSOhZ/i1sKCEVaP00hf8DkpNgKw0W71
 E29FfSc9BLxGDnW7Bfh2//I+/JKkjFvBFqNnwnKv70TJnaip7zwf7CMcXIswYqS+tvCrVteSQhYyEEbjV45Ajwr+eoENFNVH/zP6VyJKEOZotiL3NwJg1zlr
 GR9oIC1PDh+/fQTII3gW5yy4dj9nmK/Yp4jKjPhw6FI3a7hea/F1Ubml4rwU0h3NZyhpiJAARnzqvIQLSq/QoWQRG4Pb2yAs5uAw81R0c+kUbSbObBQDsVSa
 aSf1OB2MZxZ2hQbxfYljUo8StHntXNaDLvwbIFZDZzcH/4LgnOQYgA54ewhKiA5X6PpD+WKm7Ea6Ak4dUfO7KUYbD5lvTlXHxhdrLQLTkraLdv2cs9Pnt/KU
 kj5WjqOvU0XOx0I54JWLqLJG2MNJzWVAm3cfke6i3+7QgIqMTPLre7Zp5KWv+8b2vkcemrFxX/DWVJj2360HgVPEY0pWrv4MHOvU9g1uSYq1FbLtH739lMMn
 uVUtJrTwH1tWXSRDOx4lVZIt4ebtRjY8YToj7Fjbqn4CbM3+ybZBy332BGKnk2F/enGXHQBbjeqgrlqUITNXMA9J7Y3LnCNp4A18Zs9jkCNiOXG5f05OPWU1
 Wk4Rs3DFWNHHV6QuFu1YDvM7XWZaY95cVEosI9RUVh3CuGTh0M3TKxWUPWzXllDkpCEj5zTJIZb67IIU73QjtWbuARMf66hwm2JbZ0gF0P7Nc+Ibjn1BqKDQ
 oHWCzDujfg+AUpKlznkHhv7dJzxlZgIunyF5a9Mj/CLSZC8/CbKOLX4rmOoS0vyCMfSNjrpC4M+sCud1ap4p0zhMmjVYBgOZz93YFICmT4apaPP27+jL9ioj
 O64SjTsY5BaxoqRCS5NtmwA9HSW/roUqXWulxrIir3qmQ8Iqaby6k1E7qDKPoeYb4wLWzWWx7ulXLP3M4Ac98h1cUHsS1O4KZL2/XpjN4f+HmZtvuJAaCWQp
 wkZH5nehGoJigIfsvDtEbsCNZv6owjyanScdqHxCPWBnh6UaNofM0tOZnePie2C7uWD03Eshw/S0K8t4V1gVcT0fkaCahKUzGQzd+IucLg8kQeFlqH2IqhMw
 eX4xE9xSRE4OYFifDDJdXaR9z2qFNMg4Td+OQ5Co0zSfC0UM6zhPoV30fpTQZK62HgoCM/TUUpNz6yhxpqKgP0sJqskE2MKcPXz4tQM2leulX5D/kCH9Uh++
 2EPPfncg0Y3SbIgzcvo/Q2NcihdNOIHFEDpsNwpYZIivhkXMt3Y=

Document the keycrypt key type: its model and tiers, what the core
enforces and what only a tee or hsm backend can guarantee against a
compromised kernel, the add_key() syntax and the blob, the kernel tier,
the OP-TEE backend, the operation context and its ioctls, CBC, MAC and
VERIFY, revocation and permissions, the system policies, why AF_ALG
and KEYCTL_PKEY_* do not cover this, and the errors.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 Documentation/security/keys/index.rst    |   1 +
 Documentation/security/keys/keycrypt.rst | 838 +++++++++++++++++++++++
 2 files changed, 839 insertions(+)
 create mode 100644 Documentation/security/keys/keycrypt.rst

diff --git a/Documentation/security/keys/index.rst b/Documentation/security/keys/index.rst
index 647d58f2588e..ff44babc7a8f 100644
--- a/Documentation/security/keys/index.rst
+++ b/Documentation/security/keys/index.rst
@@ -7,5 +7,6 @@ Kernel Keys
 
    core
    ecryptfs
+   keycrypt
    request-key
    trusted-encrypted
diff --git a/Documentation/security/keys/keycrypt.rst b/Documentation/security/keys/keycrypt.rst
new file mode 100644
index 000000000000..17af3b041000
--- /dev/null
+++ b/Documentation/security/keys/keycrypt.rst
@@ -0,0 +1,838 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+=============
+Keycrypt Keys
+=============
+
+A "keycrypt" key is a symmetric key that user space uses for cryptography
+but never reads. Its algorithm, purpose and protection tier are fixed when
+the key is created; the key itself lives in a *backend*, and user space
+keeps only a blob that the backend sealed and that authenticates that
+metadata.
+
+Tiers and backends
+==================
+
+Two kinds of name appear in this document. A *tier* names a guarantee
+about a key; a *backend* names a mechanism that holds keys; it declares
+one tier when it registers, and gives at least that tier's guarantee.
+No name is both. User space asks for a tier (`Usage`_), and may
+name the backend too; otherwise the kernel chooses the backend that
+provides it. A key stays bound to the backend that sealed it, which
+``/proc/keys`` and ``KEYCRYPT_IOC_INFO`` report.
+
+The tiers, lowest first:
+
+========== =========================================================
+``kernel`` the key is in clear in kernel memory while loaded; the
+           kernel enforces its use
+``tee``    a trusted execution environment keeps the key and checks
+           every use against the purpose it bound (an OP-TEE TA)
+``hsm``    as ``tee``, in dedicated hardware apart from the CPU running
+           the kernel (a secure element, a security core of its own
+           such as NXP's EdgeLock Enclave, a crypto engine with its own
+           policy)
+========== =========================================================
+
+Each tier holds the guarantees of those before it.
+
+The backends of this document: ``sw``, of tier ``kernel``, where the
+kernel's own software uses the key (`The sw backend`_); and ``optee``,
+of tier ``tee`` (`The OP-TEE backend`_).
+
+Every backend, whatever its tier, must seal with a secret that is secret
+and unique to the device: the trusted key the sw backend derives from
+or OP-TEE's hardware unique key. Were that secret known, the blob, which
+user space reads, would be the key itself; were it shared by several
+devices, a blob copied from one would load on another, and its key would
+be used there. Every tier presumes it, and keycrypt cannot check it, nor
+that the hardware is configured so that the secret is secret (an OP-TEE
+whose hardware unique key is provisioned, not OP-TEE's test value):
+whoever builds in or loads a backend for a device declares
+that the device meets it, as a backend declares its tier. For the
+sw backend the secret is the trusted master each key names with
+``master=``, so there the requirement falls on whoever creates that
+master (`The sw backend`_).
+
+A backend of tier ``tee`` or ``hsm`` also declares that it meets
+`Backend requirements`_.
+
+A backend registers with ``keycrypt_register_backend()``
+(``include/keys/keycrypt.h``) under a name that is stored in every blob it
+seals. Its data must authenticate the blob's header, which carries the
+metadata: a blob whose metadata was changed does not load. Each key pins
+the backend's module; a backend that goes away
+(``keycrypt_unregister_backend()``) leaves its keys in place, unusable.
+
+Backend requirements
+====================
+
+The core enforces, from the key's own metadata, the operation against
+the key's purpose and the key's tier against the caller's
+``accepted_min_tier`` and the system tier at every
+``KEYCTL_CRYPT_OPEN`` (`Using a key`_); and, at
+``keycrypt_register_backend()``, that a backend declares a valid tier,
+offers ``generate`` and ``load``, the four context callbacks all or
+none and, for a ``tee`` or ``hsm`` backend with context operations,
+``verify`` for hmac-sha256. None of
+that defends against a *compromised kernel*: the core is kernel code
+too, and a kernel that lies to itself can skip or fake any check it
+runs itself.
+
+A sentence in this document that claims a property of a key's *use*
+against a compromised kernel holds only for a backend of tier ``tee``
+or ``hsm``: declaring one of those tiers is declaring that its secure
+side -- the TEE or the hardware, not its kernel-side callbacks alone --
+itself does what the core has no way to check:
+
+- binds the key's purpose into its own secure-world state when the key
+  is loaded, or re-authenticates the blob's header there at every
+  ``ctx_open``, instead of trusting the core's copy of the metadata;
+- fixes the operation for a context at ``ctx_open`` and holds to it,
+  refusing ``final`` on a context it fixed for VERIFY and ``verify``
+  on any other;
+- fixes the length of a MAC or VERIFY tag.
+
+A backend declares its own tier at ``keycrypt_register_backend()``; the
+core stores and compares it wherever a tier is checked, but never
+confirms that the backend is actually a TEE or hardware rather than
+ordinary kernel code claiming to be one. The ``kernel`` tier meets
+none of the above: its key material is in clear in kernel memory (`The
+sw backend`_), so there every property above is only as strong as the
+kernel itself.
+
+Metadata
+========
+
+========= ======================================================
+algorithm ``aes256-cbc`` or ``hmac-sha256``
+purpose   ``encrypt``, ``decrypt`` (aes256-cbc);
+          ``mac``, ``verify``, or both (hmac-sha256)
+tier      the backend's, when the key was sealed
+backend   its name
+origin    ``generated`` (created by the backend: inside it for
+          ``tee`` and ``hsm``) or ``imported``
+========= ======================================================
+
+These are the human-readable forms, as ``keyctl`` and ``/proc/keys``
+show them; ``KEYCRYPT_IOC_INFO`` (`Using a key`_) reports algorithm,
+purpose, tier and origin instead as the numeric ``KEYCRYPT_ALG_*``,
+``KEYCRYPT_PURPOSE_*``, ``KEYCRYPT_TIER_*`` and ``KEYCRYPT_ORIGIN_*``
+values of ``<linux/keycrypt.h>``.
+
+A key cannot be changed: ``keyctl update`` fails (``EACCES`` with the
+default permissions, which give no write permission; ``EOPNOTSUPP``
+otherwise). Adding a key with the same description to the same keyring
+replaces the link with a new key, as for every key type. Nor is a key
+ever constructed on demand: ``request_key()`` for a keycrypt key that
+does not exist fails with ``ENOKEY`` without calling a request-key
+helper, which would create it with its own credentials.
+
+Blob format
+===========
+
+The blob, which ``keyctl read`` gives and ``load`` takes in hex, is a
+header the core writes and the backend authenticates, the length of the
+backend's data, and that data, opaque to the core:
+
+============ ======== ================================================
+field        bytes    content
+============ ======== ================================================
+magic        3        ``KCR``
+version      1        1
+flags        1        0
+algorithm    1        ``KEYCRYPT_ALG_*``
+purpose      2        ``KEYCRYPT_PURPOSE_*`` mask, little endian
+tier         1        ``KEYCRYPT_TIER_*``
+origin       1        ``KEYCRYPT_ORIGIN_*``
+name length  1        1 to 16
+name         variable the backend's name, ``[a-z0-9_-]``
+data length  4        1 to 4096, little endian
+data         variable the backend's own
+============ ======== ================================================
+
+``load`` refuses another version, or flags other than 0, with
+``EOPNOTSUPP``, and any other malformed field with ``EBADMSG``; hex
+that does not decode, or a blob longer than the largest possible, gives
+``EINVAL``.
+
+Usage
+=====
+
+::
+
+    keyctl add keycrypt name "new <alg> <purpose>[,<purpose>...] [<option>...]" ring
+    keyctl add keycrypt name "import <alg> <purpose>[,<purpose>...] [<option>...] <hex key>" ring
+    keyctl add keycrypt name "load <hex blob> [<option>...]" ring
+
+Options of ``new`` and ``import``, ``tier=`` and ``min-tier=`` at most
+one of the two:
+
+``tier=<tier>``
+    use a backend of exactly this tier
+``min-tier=<tier>``
+    use the highest tier backend of at least this tier
+``backend=<name>``
+    use the backend registered under this name, which must also meet
+    ``tier=`` or ``min-tier=`` when given
+
+Options of ``load``:
+
+``accepted-min-tier=<tier>``
+    fail with ``EPERM`` if the key's tier is lower
+``purpose=<purpose>[,<purpose>...]``
+    fail with ``EKEYREJECTED`` unless the key has exactly this purpose
+
+Any other ``<option>=<value>`` is passed to the backend; the core refuses
+an option the backend does not declare and an option given twice. The
+one option a backend of this document takes from user space is
+``master=``, the sw backend's: it needs a master to seal its keys, while from
+``tee`` up a backend's own mechanisms protect the key. A command for
+the kernel tier therefore reads ``tier=kernel master=<name>``; the kernel
+tier chosen without ``master=``, or ``master=`` given to a backend of
+another tier, is refused with ``EINVAL``.
+
+With neither a tier option nor ``backend=``, the highest tier backend
+registered at that moment that supports the algorithm (and, for
+``import``, importing) is used, the kernel tier included when no backend
+of a higher tier is; with a tier option, a backend that answers it, or
+``ENODEV`` when none registered does. ``backend=`` leaves one candidate,
+the backend of that name, used if it meets the tier option and has the
+algorithm (and, for ``import``, importing), ``ENODEV`` otherwise.
+Between backends of the same tier, with no ``backend=``, the one with
+the smaller name is used. ``tier=`` pins one tier;
+``min-tier=`` is the form for "this tier or better". Since the choice
+depends on which backends are registered at that moment, ``tier=`` or
+``min-tier=`` is what guarantees a tier: there is no fallback once a
+backend is chosen, but the choice itself can only be as good as what is
+registered. A system that must not use a tier at all
+raises the system tier above it (`System policies`_): keys below it can
+still be created and loaded, but not used.
+
+``tier=`` and ``min-tier=`` state the protection a key needs;
+``backend=`` names the mechanism that provides it, for a system with
+more than one backend where a program must choose which one holds a key
+and not only how well: two backends of one tier, or a difference the
+tier does not express, such as the cost of each call or what a sealed
+key is bound to. It adds to the tier options and never replaces them:
+``backend=optee min-tier=hsm`` fails with ``ENODEV`` rather than make a
+``tee`` key, and so does a name no backend registered, or a backend
+without the algorithm (or, for ``import``, importing). Alone, it takes
+that backend at the tier it declares, so a program that needs a tier
+states it too. A backend's name is not a tier's: ``optee`` holds keys of
+the tier ``tee``, and ``backend=tee`` names no backend; ``/proc/keys``
+and ``KEYCRYPT_IOC_INFO`` give the backend of a key.
+
+A key stays bound to the backend that sealed it, whatever is registered
+later: ``load`` finds that backend by the name in the blob's header,
+and fails with ``ENODEV`` while it is not registered, never trying
+another backend of the same tier, which could not open the blob
+anyway. ``load`` therefore takes no ``backend=``. keycrypt has no
+operation that moves a sealed key to another backend; the same material
+imported again elsewhere is a new key.
+
+``import`` needs CAP_SYS_ADMIN and CONFIG_KEYCRYPT_IMPORT (off by
+default); the key is 32 bytes for aes256-cbc, 1 to 64 bytes for
+hmac-sha256. The core's own copies of it are erased once the
+backend has sealed it. Do not put a key in clear on a command line;
+give the payload on standard input::
+
+    keyctl padd keycrypt name ring < payload
+
+``keyctl read`` returns the blob in hex, which ``load`` takes back; the
+metadata appear in ``/proc/keys``::
+
+    name: aes256-cbc decrypt tee optee imported
+
+The blob is a bearer credential: whoever can read it, from the key or
+from a file, can load a copy of the key into a keyring of their own, and
+any local user can create a blob of their own with the same metadata.
+Protect blob files as secrets, and load them with
+``accepted-min-tier=`` and ``purpose=`` so that a substituted blob of a
+lower tier or of another purpose is refused; a program can give
+``accepted_min_tier`` at open too (`Using a key`_), which refuses a key
+of a lower tier however it was loaded. Without either, ``load`` takes a
+blob of any tier its backend accepts, the kernel tier included, and at
+the default system tier such a key can be used.
+
+``accepted-min-tier=`` and ``purpose=`` do not stop a substitution by a
+blob of the same tier and purpose that its maker kept a copy of: with a
+``mac`` key, the maker's tags then verify. The ``load`` command line, with its
+options, must therefore come from integrity-protected configuration (a
+signed initramfs, a verified root filesystem), like the blobs it names.
+
+The sw backend
+==============
+
+With CONFIG_KEYCRYPT_SW the ``sw`` backend is available,
+built in or as a loadable module: it is a module, ``keycrypt_sw``,
+whenever trusted keys themselves are (CONFIG_KEYCRYPT_SW=m when
+CONFIG_TRUSTED_KEYS=m); load it, e.g. ``modprobe keycrypt_sw``,
+once the trust source is available. Its keys are sealed with AES-256-GCM
+under a key derived from a ``trusted`` key (see trusted-encrypted.rst),
+named at creation::
+
+    keyctl add trusted kmk "new 32 ..." ring
+    keyctl add keycrypt name "new aes256-cbc decrypt tier=kernel master=kmk" ring
+    keyctl add keycrypt name "load <hex blob>" ring
+
+The backend data is the version, the master description's length and the
+description, a 32-byte random salt, a 12-byte nonce, the ciphertext and a
+16-byte tag. The GCM key is derived afresh for every blob as
+HMAC-SHA256 keyed with "keycrypt kernel-tier v1" || salt over the
+master's material, which is never itself the key of a primitive: other
+interfaces, AF_ALG among them, key a primitive with a trusted key given
+by serial, and would then compute the blob's key. The associated
+data is the blob's header followed by every byte that precedes the nonce
+(version, length, description, salt), so a blob whose master description
+or salt was changed does not load.
+
+``load`` looks the master up again in the caller's keyrings by
+description, without calling user space, exactly as ``request_key()``
+does: the description is a name, not an identity, so a trusted key of the
+same description earlier in the caller's search path is used instead of
+the one that sealed the blob. Search permission on the master is all
+that is needed, both to seal a new key under it and, given its blob, to
+load one back: whoever can search a master can seal and load keys under
+it. ``load`` waits, uninterruptibly, while the named master is still
+being created by another process.
+
+Whoever knows the master's material can open every blob sealed under it
+and forge blobs of any metadata. Use as masters only trusted keys
+generated by the kernel or the trust source ("new"), never ones made
+from material someone supplied, such as a CAAM ``pk`` key.
+
+A TPM-backed master is kept as a blob only the TPM can unseal, and
+whoever gets it unsealed can open every key sealed under it. Create it
+with a password (``keyauth=``) or a PCR policy, so that the blob file
+and access to the TPM are not enough.
+
+A loaded key of this tier is in clear in kernel memory until the key is
+revoked or destroyed: the kernel log says so when the backend registers
+and again when the first key of this tier is loaded. Revoking a
+keycrypt key of this tier erases its clear key and the state of every
+context already open on it, at once (`Revocation`_); invalidation and
+expiry do neither: the clear key, and the state of any context already
+open, stay in memory until the key is actually destroyed or that
+context's fd is closed. Looking the master up fails with ``ENOKEY`` when it
+is not found, including when the trusted key type is not registered at
+all, or when the master is revoked or expired, and with ``EACCES`` only
+when the master itself may not be searched. The backend is chosen by
+``tier=kernel`` or ``backend=sw``, or with neither a tier option
+nor ``backend=`` when no backend of a higher tier is registered; a
+system that must not use it raises the system tier above
+it (`System policies`_), or leaves CONFIG_KEYCRYPT_SW off.
+Raising the system tier stops the use of its keys, not their presence: a
+key of this tier loaded below it is in clear in kernel memory all the
+same, as its trusted master is while loaded. It accepts one option,
+``master=``, at creation, and none at ``load``.
+
+Its AES runs through ``lib/crypto``, which uses the CPU's AES
+instructions when it has them and a much slower software implementation
+otherwise: on hardware without them, prefer another backend where one is
+available.
+
+The OP-TEE backend
+==================
+
+With CONFIG_KEYCRYPT_OPTEE the ``optee`` backend, of tier ``tee``, is
+available, built in or as the module ``keycrypt_optee``. Its keys are
+sealed and used by the keycrypt Trusted Application of OP-TEE
+(``ta/keycrypt`` in ``optee_os``), built into OP-TEE as an early TA
+(``CFG_IN_TREE_EARLY_TAS``): OP-TEE then lists it on the TEE bus, the
+driver binds to it (its module loaded for it, if modular), and the
+backend registers::
+
+    keyctl add keycrypt name "new aes256-cbc encrypt,decrypt tier=tee" ring
+
+Built as an ordinary TA loaded from the file system instead, it is not
+listed there and the backend never registers. Until the backend has
+registered, a ``load`` of one of its blobs fails with ``ENODEV``, and so
+do ``backend=optee``, and ``tier=tee`` where no other backend of that
+tier is registered.
+
+The TA accepts only kernel clients (``TEE_LOGIN_REE_KERNEL``): a process
+that opens the TEE device cannot use it to get around keycrypt's
+permissions and policies. OP-TEE's ``xtest`` cannot exercise it for the
+same reason.
+
+The backend data is a version byte, a 12-byte nonce, the key encrypted
+with AES-256-GCM and a 16-byte tag, under a key the TA derives from
+OP-TEE's hardware unique key and its own UUID; the associated data is
+the blob's header followed by the version byte. A blob loads only on a
+device with the same hardware unique key (on a provisioned device, only
+the one that sealed it), and only into this TA. Its keys are only as
+secret as the hardware unique key: on QEMU, and on a board whose key is
+not provisioned, OP-TEE uses a fixed test value and anyone can unseal
+the blobs made there, so such a setup shows that the backend works, not
+that its keys are protected. The UUID is exclusive only on a firmware
+that embeds the TA: a TA with the same UUID, signed with OP-TEE's
+default (public) key and loaded from the file system by another firmware
+on the same device, would open every blob. A product therefore signs
+its TAs with a key of its own, uses OP-TEE's rollback protection, and
+ships no keycrypt ``.ta`` file.
+
+The TA meets `Backend requirements`_: at every ``KEYCTL_CRYPT_OPEN`` it
+authenticates the blob's header again and checks the operation against
+the purpose it reads there; a context is a TA session fixed to one
+operation, refusing ``final`` on a VERIFY context and ``verify`` on any
+other; tags are 32 bytes. An aes256-cbc IV is used as given: to
+encrypt, the core's random one or, with ``KEYCRYPT_OPEN_CALLER_IV``, the
+caller's; to decrypt, the caller's.
+
+Every context holds a TA session and 65,584 bytes of TEE shared memory,
+rounded up to whole pages and physically contiguous (68 KiB with 4 KiB
+pages), until the context ends (``KEYCRYPT_IOC_FINAL``, or a failure),
+its key is revoked, or its fd is closed, whichever comes first. The TA
+refuses a session once 32 are open (``KC_TA_SESSIONS_MAX``), the
+backend's own control session and any other kernel client's session to
+this TA among them: once 31 contexts are open, system wide,
+``KEYCTL_CRYPT_OPEN`` fails with ``ENOMEM``, and any user with Search
+permission on a key of this backend can hold them all. With a static
+shared-memory pool instead of OP-TEE's dynamic shared memory, fewer
+contexts fit, and they take the pool other TEE clients use. On QEMU,
+whose OP-TEE has a 128 KiB core heap, all 31 fit; with a smaller heap,
+or other TAs busy, the TA can run out of memory first and panic. A
+panic ends every context open at that moment (``EIO``); new contexts
+on keys already loaded work, but ``new``, ``import`` and ``load`` give
+``EIO`` until the driver is unbound and bound again::
+
+    cd /sys/bus/tee/drivers/keycrypt-optee
+    echo optee-ta-65a0d9f0-f057-414c-9d5a-9aac7c8ba461 > unbind
+    echo optee-ta-65a0d9f0-f057-414c-9d5a-9aac7c8ba461 > bind
+
+Unbinding unregisters the backend: every key of this backend already in
+a keyring, and every context open on one, gives ``ENODEV`` from then on,
+also after the driver is bound again; once it is, ``load`` each key
+again from its blob.
+
+Using a key
+===========
+
+A key is used through an operation context, a file descriptor opened by
+``keyctl(KEYCTL_CRYPT_OPEN, key, &params, sizeof(params), 0)``
+(``<linux/keycrypt.h>``)::
+
+    struct keycrypt_open_params {
+            __u32   op;             /* KEYCRYPT_OP_ENCRYPT, _DECRYPT, _MAC,
+                                      * _VERIFY
+                                      */
+            __u32   accepted_min_tier; /* refuse a key of a lower
+                                        * tier; 0: no requirement
+                                        */
+            __u32   flags;          /* KEYCRYPT_OPEN_CALLER_IV, or 0 */
+            __u32   __reserved;     /* must be zero */
+            __u8    iv[16];         /* aes256-cbc: the IV; MAC,
+                                      * VERIFY: 0
+                                      */
+    };
+
+``params`` is extended by size (``copy_struct_from_user()``): a caller
+built against a later header may give a larger ``usize`` than this
+kernel knows, which is accepted as long as the excess is zero; a
+``usize`` above ``PAGE_SIZE`` is refused with ``E2BIG``, one below
+``KEYCRYPT_OPEN_PARAMS_SIZE_VER0`` (32 bytes) with ``EINVAL``. That
+floor is the fixed value the uapi header names, not
+``sizeof(struct keycrypt_open_params)`` as this kernel builds it: a
+later kernel may grow the struct without raising the floor an older
+caller, built against this version, must still meet.
+
+The key needs Search permission; its type, the operation against its
+purpose and its tier against the higher of ``accepted_min_tier`` and the
+system tier (`System policies`_) are checked once, at open.
+``accepted_min_tier`` 0 states no requirement of the caller's own,
+leaving the system tier alone; any other value must be a tier.
+Against user space this check is the whole story, at every tier: it
+runs in the core, from the key's own metadata, whatever backend holds
+the key. A backend of tier ``tee`` or ``hsm`` meeting `Backend
+requirements`_ checks the operation again, in the TEE or the hardware,
+against the purpose it bound there rather than the core's copy of it,
+so that a kernel compromised enough to lie about the operation or the
+key's metadata still cannot open, say, an encryption context on a
+decrypt-only key; the sw backend has no such check of its own, since
+a compromised kernel already has that backend's key material in clear
+(`The sw backend`_), and relies on the core's check alone. Across
+every tier it is the kernel, not any backend, that decides who may open
+a context on a key, since Search permission is the core's own check; a
+compromised kernel can
+therefore still open a context on a key of any tier and use it for a
+purpose the key already has, but, for a backend of tier ``tee`` or
+``hsm`` meeting `Backend requirements`_, it can neither read that key
+(an imported one: unless the kernel was already compromised when it
+was imported) nor make it accept an operation outside the purpose its
+secure side bound when the key was sealed. The fd is
+``O_RDWR | O_CLOEXEC`` and holds a reference to the key: passing it to
+another process (``SCM_RIGHTS``) hands over the use of the key (see
+`An fd is a shared stream`_).
+
+For aes256-cbc encryption, ``iv`` must be zero on input unless
+``KEYCRYPT_OPEN_CALLER_IV`` is set: the kernel then draws a random IV
+(``get_random_bytes_wait()``) and writes it back into the caller's
+``params.iv`` before the fd is created, so a failed write-back
+(``EFAULT``) leaves no fd behind. With ``KEYCRYPT_OPEN_CALLER_IV`` the
+caller's IV is used instead, and IV uniqueness becomes the caller's to
+maintain (see `CBC and MAC`_). The flag is valid only together with
+aes256-cbc encryption; any other combination is ``EINVAL``. For
+aes256-cbc decryption ``iv`` is always the caller's.
+
+Data goes through ``ioctl()`` on the fd:
+
+``KEYCRYPT_IOC_UPDATE`` (``struct keycrypt_update``: ``in``, ``out``, ``len``, ``flags``)
+    aes256-cbc and MAC/VERIFY only: process ``len`` bytes, at most
+    ``KEYCRYPT_UPDATE_MAX`` (65536): for aes256-cbc a multiple of 16,
+    written to ``out``, the IV advancing in the context (padding is the
+    caller's); for MAC and VERIFY ``out`` is 0.
+``KEYCRYPT_IOC_FINAL`` (``struct keycrypt_final``: ``out``, ``len``, ``flags``)
+    end the context: for MAC write the 32-byte tag to ``out`` (``len``:
+    room in, bytes written out); for VERIFY ``out`` is the caller's
+    32-byte expected tag (``len`` must be exactly 32), written back as
+    0 on a match and left as given on a mismatch; for aes256-cbc
+    ``out`` is 0, nothing is written to it, and ``len`` is written back
+    as 0.
+``KEYCRYPT_IOC_INFO`` (``struct keycrypt_info``: ``op``, ``alg``, ``purpose``, ``tier``, ``origin``, ``accepted_min_tier``, ``backend``)
+    describe the context, whatever its algorithm or operation: the
+    operation it was opened for, the ``accepted_min_tier`` it was opened
+    with (0 for none), and its key's algorithm
+    (``KEYCRYPT_ALG_*``), purpose (``KEYCRYPT_PURPOSE_*``), the tier
+    the key was sealed at (``KEYCRYPT_TIER_*``), origin
+    (``KEYCRYPT_ORIGIN_*``) and backend name, NUL terminated; the
+    reserved words and the name's tail are zero. A program that knows
+    only this interface can record how it encrypted (asking before
+    FINAL, which ends the context), and a process given the fd through
+    ``SCM_RIGHTS`` can tell what it holds (see `An fd is a shared
+    stream`_). On an ended context ``EBADFD``; on a context whose key
+    was revoked, invalidated or expired, or whose backend was removed,
+    the ``EKEYREVOKED``, ``EKEYEXPIRED`` or ``ENODEV`` that UPDATE with
+    no data gives.
+
+VERIFY compares the expected tag against the one computed for it: by
+the core, in constant time (``crypto_memneq()``), for a backend with no
+``verify`` of its own, or by the backend's own ``verify``, where the
+key lives, for one that offers it (required of a ``tee`` or ``hsm``
+backend with context operations that offers hmac-sha256); either way
+the result is 0 on a match, ``EBADMSG`` otherwise, and the computed tag
+itself never leaves
+wherever it was computed. Against a compromised *user space*, the two
+are the same: a device given a ``verify`` key (without ``mac``) can
+check a tag but never forge one, at every tier, since the computed tag
+never reaches the fd either way; see `CBC and
+MAC`_ for why that matters. Against a compromised *kernel* they are
+not: a kernel-tier ``verify`` key is in clear in kernel memory like any
+other kernel-tier key (`The sw backend`_), so a compromised kernel can
+read it and forge, while a ``tee`` or ``hsm`` backend's own ``verify``,
+meeting `Backend requirements`_, keeps the key, and the comparison,
+where a compromised kernel cannot reach either.
+
+Every call checks the key again: a revoked, invalidated or expired key
+gives ``EKEYREVOKED`` or ``EKEYEXPIRED`` (see `Revocation`_). Calls on
+one fd are serialised, and a call blocked on another one's input or
+output copy is killable (only a fatal signal ends the wait). The
+kernel buffers of a call are erased before it returns.
+
+Revocation
+==========
+
+``keyctl revoke`` on a keycrypt key detaches every context already open
+on it (including one held only by another process through a passed fd)
+and releases the backend's state of the key, at once: every later
+call on such a context gives ``EKEYREVOKED``, not the key's own state at
+the time the context was opened. The backend's own ``destroy`` runs
+immediately too, even though the key itself survives, unusable, until it
+is actually garbage collected; for the sw backend this erases the key's
+clear copy in memory immediately as well, together with every detached
+context's own state (see `The sw backend`_). Revoking a key is
+therefore the way to stop every open use of it; removing Search
+permission (below) is not. "At once" has one exception: a kernel-tier
+``load`` or ``new`` in progress on the same backend holds it while it
+looks its master up with ``request_key()``, which can wait for a key
+still under construction; a revocation waits behind it, and so does
+every call that comes after the revocation, the key garbage collector
+included when it frees a key of that backend, which holds up the
+collection of keys of every type until the master's construction ends.
+
+Who can use a key
+=================
+
+Search permission is what lets a process open a context on a key;
+having it is "use" in the sense LSMs check (``key:search``), whatever
+the operation. Whoever can read a key can also copy it: ``keyctl read``
+returns the blob, which ``load`` turns into a key of one's own with the
+same backend state, out of reach of any revocation of the original.
+
+A keycrypt key added without explicit permissions gets the keyrings'
+defaults, as a user or trusted key does: Search, Read and the rest for
+its possessor, only View for its owner. A key added to the user keyring
+(``@u``) is therefore usable only by a process that possesses it, one
+whose session keyring links the user keyring; a login whose session
+keyring does not, as some console logins do not, gets ``EACCES`` from
+``KEYCTL_CRYPT_OPEN`` and from ``keyctl read`` on its own key, until the
+link is made (``keyctl link @u @s``) or the key is added to a keyring
+the session reaches.
+
+Read permission alone does not decide who can read: ``keyctl read``
+also succeeds, whatever the Read bit, for a key the caller possesses,
+that is, one it reaches by Search from its own keyrings. A process that
+possesses a key it can use can therefore always read its blob; clearing
+the possessor's Read bit does not change that. Use without read is
+possible only for a process that does not possess the key: Search
+granted through the user, group or other bits on a key that is not in
+any keyring the process can reach, or, simpler, an operation context fd
+handed to it (`An fd is a shared stream`_), which gives use of the key
+and its description (``KEYCRYPT_IOC_INFO``) without View permission,
+never its blob.
+
+Within one login session, possessor Search is shared by every program
+running as the session keyring's possessor, not only the one that opened
+a context: a setuid helper or a broker handing out access to several
+clients should pass each client an fd of its own (``SCM_RIGHTS``) rather
+than let them ``KEYCTL_CRYPT_OPEN`` a serial number that any possessor
+can open. Removing Search from a keyring stops a *future*
+``KEYCTL_CRYPT_OPEN``; it does not touch a context already open, nor the
+fds already handed out: only `Revocation`_ does.
+
+System policies
+===============
+
+Two sysctls, both under ``kernel.keys.``, bound every key on the system
+rather than one: both are one-way until reboot, readable by anyone, and
+writable only by root (mode ``0644``): a non-root writer gets ``EACCES``
+from opening the file at all, before keycrypt is ever asked, and
+keycrypt's own handler checks CAP_SYS_ADMIN again, before the written
+value is even parsed (``EPERM`` for whoever got the file open but lacks
+the capability); neither touches a context already open at the time
+they change.
+
+``kernel.keys.keycrypt_system_tier`` is the system tier, the lowest tier
+a key may be used at: one of ``10`` (``kernel``), ``20`` (``tee``)
+or ``30`` (``hsm``), the same values as
+``KEYCRYPT_TIER_*`` (`Tiers and backends`_). It can only be raised,
+never lowered (``EPERM`` on a lower value, ``EINVAL`` on anything
+else). It applies to use only: ``KEYCTL_CRYPT_OPEN`` refuses a key
+below it with ``EPERM``, whatever ``accepted_min_tier`` the caller
+gave, while ``new``, ``import`` and ``load`` of such a key succeed, so
+that blobs can be made and kept for a system where it is lower. It is
+checked once, at open: raising it does not touch a context already
+open, nor unload a key; `Revocation`_ is how to actually remove a key
+still in use. It starts at the tier chosen at build time,
+``CONFIG_KEYCRYPT_SYSTEM_TIER_*`` (``kernel`` unless set): neither the
+boot parameter below nor the sysctl can go under it, so a signed kernel
+image fixes a floor its command line cannot lower.
+
+``kernel.keys.keycrypt_import`` goes from ``1`` to ``0`` only (``EPERM``
+on turning it back on). Once it is ``0``, ``add_key``'s ``import``
+command fails with ``EPERM``, on top of the existing
+``CONFIG_KEYCRYPT_IMPORT`` and ``CAP_SYS_ADMIN`` checks that command
+already has. It stops only that command: neither ``load`` of a blob the
+backend already sealed (whatever its origin) nor the use of a key
+already loaded is affected, imported or not. With
+``CONFIG_KEYCRYPT_IMPORT=n`` the sysctl still reads back its default,
+``1``, and ``import`` is refused regardless, for the config reason
+rather than this one.
+
+Each has a boot parameter setting its starting value before either sysctl
+is ever written: ``keycrypt.system_tier=`` (``kernel``, ``tee`` or
+``hsm``) and ``keycrypt.import=`` (a boolean). An invalid
+value, or one that would lower what is already set, is ignored, with a
+kernel warning, rather than failing the boot. An administrator who
+wants either policy fixed from the very start, before any user-space
+program can run, uses the boot parameter rather than a sysctl written
+from ``sysctl.conf`` or similar, which runs only after early user space.
+Without CONFIG_SYSCTL neither sysctl exists at all; only the boot
+parameters remain.
+
+An fd is a shared stream
+========================
+
+The fd from ``KEYCTL_CRYPT_OPEN`` carries the context's state (the IV,
+the running hash) outside the key itself: after ``SCM_RIGHTS`` or
+``fork()``, every holder of a copy of the fd shares that state with
+every other, and an ``ioctl()`` from any of them advances it for all.
+Close the sending side's copy once sent, and receive with
+``MSG_CMSG_CLOEXEC`` so an unrelated child does not inherit it; the same
+holds for a fd that outlives an ``exec()`` without ``O_CLOEXEC`` (keycrypt
+sets it, but a caller that duplicates the fd without ``FD_CLOEXEC``
+keeps the duplicate across ``exec()``, and so hands the context to the
+program it runs).
+
+CBC and MAC
+===========
+
+aes256-cbc decryption is not an integrity boundary: given a decryption
+key, chosen ciphertext and a chosen IV can be made to decrypt to a
+chosen plaintext (a CBC padding/relay style attack, "CBC-R"); encrypted
+data must be authenticated (MAC or VERIFY) before it is trusted, and the
+MAC or VERIFY must be checked *before* the plaintext is used
+(encrypt-then-MAC), never after. Encryption without
+``KEYCRYPT_OPEN_CALLER_IV`` gets a kernel-chosen random IV, so a repeat
+is improbable, not impossible; with the flag, the caller's IV must be
+unpredictable to whoever supplies the plaintext, not merely unique (a
+counter is unique and still breaks CBC under chosen plaintext). A
+reused IV with the same key shows whether two messages share a
+plaintext prefix, not the XOR of them: equal first plaintext blocks
+XORed with the same IV give the same input to the block cipher, and so
+the same first ciphertext block. The IV is returned at
+``KEYCTL_CRYPT_OPEN``, and each later block's IV is the previous
+ciphertext block, so an encryption context is also a raw AES oracle for
+whoever holds its fd: inherent to CBC, not a keycrypt defect.
+
+A ``mac`` key can both compute and check a tag, so a program that only
+needs to check one can also forge one if compromised; give a verifier a
+``verify`` key instead of a ``mac`` key wherever possible (`Using a
+key`_), and keep ``mac`` for whatever actually produces tags. Importing
+the same key material twice, once with ``mac`` and once with
+``verify``, under the *same* algorithm is exactly how to give a
+producer and a verifier that pairing. Never import the same key
+material under two different *algorithms*, though: each uses the bytes
+differently (an aes256-cbc encryption context is a raw AES oracle on
+the key, above), and every new pairing of algorithms would need its own
+analysis that nothing here does.
+
+Why not AF_ALG or KEYCTL_PKEY_*
+================================
+
+``AF_ALG`` can take a key from a keyring by serial number
+(``ALG_SET_KEY_BY_KEY_SERIAL``), from a ``user``, ``logon``,
+``encrypted`` or ``trusted`` key. Of those a ``trusted`` key is the
+right comparison: like a keycrypt key, it is sealed at rest and never
+read back in clear by user space. ``AF_ALG`` keeps and chains the IV
+in the kernel too: a skcipher socket's IV buffer lives in the socket
+and is advanced in place as the cipher mode chains across calls, the
+same state keycrypt keeps in its context. The difference is that
+``AF_ALG`` never *chooses* an IV itself: it is always the caller's,
+zero by default and otherwise set with ``ALG_SET_IV``; keycrypt
+instead draws a random IV itself at ``KEYCTL_CRYPT_OPEN`` unless the
+caller asks for its own
+(``KEYCRYPT_OPEN_CALLER_IV``, aes256-cbc encryption only). ``AF_ALG``
+also copies the key's payload into the socket and applies whatever
+algorithm the socket was set up for, with nothing tying the key to
+that algorithm or to a purpose; keycrypt instead binds a key to one
+algorithm and purpose when it is created, and lets a backend of tier
+``tee`` or ``hsm`` run in a TEE or in hardware, where a key the backend
+created is never in kernel memory at all (an imported one passes
+through it once, to be sealed).
+``ALG_SET_KEY_BY_KEY_SERIAL`` refuses a keycrypt key
+(``ENOPROTOOPT``), as it does any key type it does not take.
+``KEYCTL_PKEY_*`` covers asymmetric keys only, a different problem.
+
+Errors of KEYCTL_CRYPT_OPEN and of the ioctls
+=============================================
+
+============ ==============================================================
+ENOKEY       the key does not exist, or (KEYCTL_CRYPT_OPEN only) is
+             invalidated; an already open context instead gives
+             ``EKEYREVOKED`` for an invalidated key (see `Revocation`_)
+EACCES       no Search permission on the key
+EOPNOTSUPP   not a keycrypt key, or a kernel without KEYCTL_CRYPT_OPEN
+EKEYREJECTED the operation is not in the key's purpose; VERIFY needs
+             ``mac`` or ``verify``, MAC needs ``mac``
+EPERM        the key's tier is below ``accepted_min_tier``, or below the
+             system tier, ``kernel.keys.keycrypt_system_tier``
+EINVAL       ``__reserved`` or flags not zero, an unknown operation, an
+             ``accepted_min_tier`` that is neither 0 nor a tier, an IV
+             given for MAC or VERIFY, a non-zero IV given
+             for CBC encryption without ``KEYCRYPT_OPEN_CALLER_IV``,
+             or that flag with anything but CBC encryption; a CBC length
+             not a multiple of 16, an ``out`` given for MAC or for
+             aes256-cbc FINAL, or missing for CBC UPDATE; VERIFY FINAL
+             with ``len`` other than 32; a ``usize`` below
+             ``KEYCRYPT_OPEN_PARAMS_SIZE_VER0``
+E2BIG        ``usize`` above ``PAGE_SIZE``, or a non-zero byte in its
+             excess over this kernel's ``struct keycrypt_open_params``;
+             a ``len`` above ``KEYCRYPT_UPDATE_MAX``
+ENOSPC       MAC FINAL with ``out`` 0, or less than 32 bytes of room for
+             the tag (the context stays usable)
+EBADMSG      VERIFY FINAL whose tag does not match (the context ends);
+             a backend's own
+             ``EBADMSG`` from ``KEYCTL_CRYPT_OPEN`` (no fd is created)
+             or from ``KEYCRYPT_IOC_UPDATE`` (the context ends)
+EKEYREVOKED  the key was revoked, its type removed, or (an already
+             open context only) invalidated, or (``KEYCTL_CRYPT_OPEN``
+             only) the key's backend state already released by a
+             revoke that raced the open; a context detached this way
+             repeats the same answer on every later call, without
+             ending (see `Revocation`_)
+EKEYEXPIRED  the key expired
+ENODEV       the key's backend was removed (for ``optee``, its driver
+             unbound: `The OP-TEE backend`_), or (``KEYCTL_CRYPT_OPEN``
+             only) the key's backend offers no context operations;
+             either is permanent for the key, since a backend
+             registered again does not take back the keys of the one
+             removed (``load`` each key again); a context already open
+             on a backend later removed repeats the same answer on
+             every later call, without ending
+ENOMEM       out of memory, including (``KEYCTL_CRYPT_OPEN``) a backend
+             with no room for another context, as ``optee`` once 31 are
+             open (`The OP-TEE backend`_)
+EIO          a backend failure, including one refusing at
+             ``KEYCTL_CRYPT_OPEN`` itself: a backend's ``ENOMEM``,
+             ``EINTR`` and ``EBADMSG`` pass unchanged (a restart it
+             asks for restarts the call), any other error becomes
+             ``EIO`` (no fd is created either way)
+EBADFD       a call on a context that already ended: after
+             FINAL, or after a failure once the backend had been
+             called for this call (``EBADMSG``, ``EIO``, an
+             ``EFAULT`` on the output copy, or ``EINTR`` from an
+             interrupted backend). Every other error leaves the
+             context usable too: ``EINVAL``, ``E2BIG``, ``ENOSPC``,
+             an ``EFAULT`` on the input copy or on
+             ``KEYCRYPT_IOC_INFO``'s output copy, ``ENOMEM`` before
+             the backend ran, ``EKEYREVOKED``, ``EKEYEXPIRED`` and
+             ``ENODEV`` (repeated instead, above), and ``EINTR`` while
+             waiting to acquire the context's lock
+============ ==============================================================
+
+KEYCTL_CRYPT_OPEN checks its parameters, then looks the key up, then
+looks at its type: a key that is not a keycrypt key gives
+``EOPNOTSUPP`` only once the parameters are accepted and the lookup
+has succeeded, and the lookup's own errors come first, such as
+``ENOKEY`` (a negative key included), ``EKEYREVOKED``, ``EKEYEXPIRED``
+and ``EACCES``. A kernel without KEYCTL_CRYPT_OPEN answers
+``EOPNOTSUPP`` too, so user space that falls back to another interface
+for a key of another type does so on ``EOPNOTSUPP`` alone.
+
+Errors of add_key
+=================
+
+============ ==========================================================
+EINVAL       malformed options or input (an embedded NUL included), a
+             blob that is not hex or too long, algorithm and purpose not
+             matching, ``tier=`` with ``min-tier=``, a tier option of
+             the other commands (``accepted-min-tier=`` at ``new`` or
+             ``import``, ``tier=``, ``min-tier=`` or ``backend=`` at
+             ``load``), ``backend=`` twice or not a backend name
+             (``[a-z0-9_-]``, at most 16 characters), an option the
+             backend does not know, the kernel tier chosen without
+             ``master=``, a key of the wrong length
+ENODEV       no backend for the request (none registered for the
+             algorithm, none of the tier ``tier=`` or ``min-tier=`` asks
+             for, or ``backend=`` naming no registered backend, or one
+             that does not meet ``tier=``/``min-tier=``, the algorithm
+             or, for ``import``, importing), or the blob's backend is not
+             registered
+ENOKEY       the master key of a kernel-tier key was not found,
+             including when the trusted key type is not registered
+             or the master is revoked or expired
+EPERM        a blob below ``accepted-min-tier=``; import disabled
+             (``kernel.keys.keycrypt_import``) or without
+             CAP_SYS_ADMIN
+EOPNOTSUPP   a blob of an unknown format version, or with a non-zero
+             header flags byte
+EKEYREJECTED a blob claiming a tier above its backend's, or not of the
+             purpose ``load`` asked for
+EBADMSG      a blob that is malformed, altered, or not the backend's
+EIO          a backend failure
+============ ==========================================================
+
+An altered blob may be refused before its backend sees it, with
+``EOPNOTSUPP``, ``ENODEV``, ``EKEYREJECTED`` or ``EPERM``, rather than
+``EBADMSG``; past those checks ``optee`` answers ``EBADMSG`` for any
+altered byte. For the kernel tier, an altered master description gives
+``ENOKEY`` only when the altered name exists nowhere in the caller's
+search path; found there, it gives ``EACCES`` if the caller may not
+search that key, or, found and searchable but not the master that
+sealed the blob, ``EBADMSG`` once unsealing it fails to authenticate
+the header.
+
+A backend may also report ``ENOMEM``, ``EINVAL``, ``EBADMSG``, ``ENOKEY``,
+``EKEYREJECTED``, ``EACCES`` or ``EINTR`` (a restart it asks for restarts
+the call); any other backend error is reported as ``EIO``.
-- 
2.43.0

