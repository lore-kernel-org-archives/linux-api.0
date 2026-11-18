Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012282;
	b=HFK7to3yomVH1zpcyMSaMDbFeoYEMimBvX717KLq3JagKYrcyZOB22YZHYQgEa/UXn9c
	 fGGKb8aL4/wgj5j0ru6G+7hMM6dEAQ+yuR0h6vRmc/hT6VtAYWHyhi4HpJ9rBCq/OsStq
	 vyzy+oTuduiJV3fPUPkyoV+1cIz/2uIchPtxSwD8TdzXOToAekSxdklYhuoTqG5EqllwG
	 PC3/hptF7s0lbrg8b1KGr98rPAcdg6/iZCjTFOvbChRreeu2ZMoIwRyWUYF+4aWVJps8T
	 vpZ4PPLZDTFjMKmsQV9wMOoLyiY0LNgSepSQBscRN57xIwJc6yKgu79Sgx1BFPfvohA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012282;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OXWSHKpo0S6c/jR7/8XBZxBcRvLohSQDocmHEXhtdSE=;
	b=pdC/Y96d9NentfiSaUkI9tQ0Hk4J5d4gVoaI8vrOe+d3R8kW5LIkq9U+kuDqYLEqZHBP
	 inut3knyAOVousnzl0uUE2Y8A7ZaLpzVRSg9dvbkGjFxnETqvvs1+pha4UcC7gzv5XhtY
	 22BXzCR7KwwrBJlTGQmTYkY9D3jo4mVJFFoM7mv4TU/TMMZdCVAgSjniwLSnI6Ftwho3L
	 25wPhdJLIk1Mg/nIt5bFMLDVe/p4/7UrDMFgWi9ia5NMRLwG4aaVetUkKJbAjo0fHuEEx
	 POpxPOfYnSZTmplLFXaGkgYCpGhuvFh6dLGLelfdVLvqVBapAUFe40BSTD4nXHQF7/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ICDVkcIX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4A154606A31C;
	Wed, 18 Nov 2026 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ICDVkcIX
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 201251F000C5;
	Wed, 18 Nov 2026 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012281;
	bh=OXWSHKpo0S6c/jR7/8XBZxBcRvLohSQDocmHEXhtdSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ICDVkcIXTKsGJF4JDPx+noCHqXryDLDuRsiFwCbNSqYHSWqrxcpVtFEnK2/n3K9tl
	 hLUC5Y8djH0g94+VD2H9eKqLQKiCnIOFjqgTzkOt+8jt4BtYH5hp7WLw6E64ZuS3qp
	 OTLMdWu03IA0hkZ4PnZxQ8wHuuQNI7/p6ngkcHjc9w3tdH7d5KC9Fb6ojOUW4nbaR/
	 fftLSJlHIiqjAtX41LjPEqXOwBNl8M/qWkSX/Ydqn2zmLXf3XXzY4EtPGnIJqj0MfT
	 ZEIQVKi1TgDdcexQPnuFQQhoBOnbpyqIduB6GeK4be0sVjetLyY/TwZHP46MgHPsYL
	 Ks+TLg66b9ZQg==
Date: Wed, 18 Nov 2026 16:31:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	op-tee@lists.trustedfirmware.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] KEYS: keycrypt: keys that user space can use but
 never read
Message-ID: <av22tUCclsAPJq1g@kernel.org>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118140421.584086-1-giometti@enneenne.com>

On Wed, Nov 18, 2026 at 03:04:12PM +0100, Rodolfo Giometti wrote:
> This RFC proposes a key type, "keycrypt", whose material user space can
> use for symmetric operations but never read: AES-256-CBC, HMAC-SHA256
> and an authenticated AES-256-GCM stream, through a file descriptor that
> KEYCTL_CRYPT_OPEN returns for one key and one operation. The key is held
> by a backend: the kernel itself (sealed under a trusted key), an OP-TEE
> trusted application, or, as a proposal only, the CAAM. I am asking
> whether this is a direction the keyrings, crypto and TEE maintainers
> would take, before polishing it further.
> 
> Patch 9, the authenticated stream, is a proposal on its own and not
> needed by the rest of the series: it is a construction of keycrypt's
> own, and patches 1-8 do not depend on it, so it can be discussed, or
> left out, apart from them. No user-space consumer uses the stream or
> HMAC-SHA256 yet: craf (below) uses CBC only. If this direction is found
> acceptable, one of the next steps is to bring craf's keycrypt backend
> into craf's main line, with the stream and HMAC-SHA256, as long as
> doing so does not stand in the way of this RFC or of the series I hope
> will follow it.
> 
> The problem
> -----------
> 
> An embedded product that encrypts its own data (a root filesystem
> archive, configuration backups, logs) needs a key that does not sit in
> the root filesystem and that a compromised user space cannot copy. Today
> user space either reads the key (a user or logon key handed to AF_ALG)
> or cannot use it at all (a trusted key serves kernel consumers only).
> AF_ALG, the one interface that let user space drive a key the kernel
> held, has moved away from that use: v7.2 dropped off-CPU cryptography
> from it (7524070f26d8, "crypto: af_alg - Drop support for off-CPU
> cryptography"), whose message says "If using an off-CPU accelerator
> really does turn out to be a win, a new API should be developed that is
> actually a good fit for it", and v7.3 restricted it to allowlisted
> generic algorithms by default (2f204fe718f5, the af_alg_restrict
> sysctl). One exception was let back in, cbc(paes) with a CAAM blob in
> place of the key, because "this crypto operation cannot be implemented
> in a userspace library" (285d8204638c, v7.2), for privileged users only
> (d9506e82ced5, v7.3): the need is acknowledged, for one driver and
> one mode. keycrypt is meant to be the API that 7524070f26d8 asks for,
> for keys that stay in a TEE or in hardware, whatever the backend.
> 
> The interface
> -------------
> 
> 1. A key type, "keycrypt", created with add_key() from "new <alg>
>    <purposes> [tier=|min-tier=] [backend=]", "load <blob>
>    [accepted-min-tier=] [purpose=]" or, when allowed, "import <alg>
>    <purposes> [tier=|min-tier=] [backend=] <hex>". User space states the
>    protection a key needs, as a tier, and the kernel chooses the backend
>    that provides it, unless backend= names one. backend= is a constraint
>    added to the tier, never one in its place: a named backend that does
>    not meet tier= or min-tier= gives ENODEV, not a weaker key. It is for
>    a system with more than one backend, an i.MX8 with both the CAAM and
>    OP-TEE say, where a program must choose which mechanism holds a key
>    (the cost of each call, what the key is bound to) and not only how
>    well; the name chooses among mechanisms that meet the tier asked for,
>    it never lowers a tier asked for (without one, it takes that backend
>    at the tier it declares, so a program that needs a tier states it).
>    Its payload read back is a blob that only that backend can open; the
>    material itself never reaches user space.
> 2. Each key is bound, when it is made, to one algorithm and to the
>    purposes it may serve, checked at every open:
>    a. encrypt and decrypt, for aes256-cbc and aes256-gcm-stream keys:
>       a key that may only encrypt lets a device write data it cannot
>       read back, a key that may only decrypt the reverse;
>    b. mac and verify, for hmac-sha256 keys: "mac" computes a tag over
>       data, "verify" only checks a tag given by the caller, so a
>       component holding a verify-only key can authenticate data (a
>       configuration, an update) but cannot produce a tag that would
>       pass. VERIFY takes the expected tag at FINAL and answers 0 or
>       EBADMSG; the tag it computed never leaves the backend. For
>       example, a server authenticates the commands it sends to a fleet
>       of devices with HMAC-SHA256, and every device holds the same key,
>       imported at the factory as verify-only. With a plain HMAC key,
>       root on one device could extract it and forge commands for the
>       whole fleet; with a verify-only keycrypt key held by a tee or hsm
>       backend, a compromised device can still check commands but can
>       neither read the key nor compute a tag that passes. It comes
>       close to what a signature gives (everyone verifies, only the
>       server signs), with a MAC, as long as no device's TEE or HSM is
>       broken: the key is the fleet's, so the device that breaks forges
>       for all of it, which a signature would not allow.
> 3. KEYCTL_CRYPT_OPEN (keyctl 33) opens an operation context on a key and
>    returns an fd; ioctls on it: KEYCRYPT_IOC_UPDATE, KEYCRYPT_IOC_FINAL,
>    KEYCRYPT_IOC_SEGMENT (the GCM stream, patch 9) and KEYCRYPT_IOC_INFO,
>    which tells a program holding only the fd (passed by SCM_RIGHTS, say)
>    the operation, the minimum tier it was opened with, and the
>    algorithm, purposes, tier, origin and backend of the key it is using.
>    Search permission on the key is the right to open it; the caller may
>    name the lowest tier it accepts (accepted_min_tier), and a key below
>    it is refused.
> 4. Policies: kernel.keys.keycrypt_system_tier and
>    kernel.keys.keycrypt_import (also the boot parameters
>    keycrypt.system_tier= and keycrypt.import=), one-way, so that a
>    system can refuse the use of low-tier keys or clear-key import for
>    good. The system tier is a floor on use only: keys below it can
>    still be made and loaded, but KEYCTL_CRYPT_OPEN refuses them. Its
>    starting value is chosen at build time
>    (CONFIG_KEYCRYPT_SYSTEM_TIER_*), so a signed kernel image carries a
>    floor its command line cannot lower; likewise, a kernel built
>    without CONFIG_KEYCRYPT_IMPORT refuses import whatever its command
>    line or sysctl say.
> 5. EOPNOTSUPP from KEYCTL_CRYPT_OPEN means "not a keycrypt key", or a
>    kernel without keycrypt, so a library may fall back to another
>    interface on it; ENODEV means no backend can run the key.
> 
> Tiers and what a compromised kernel can do
> ------------------------------------------
> 
> Each backend declares a tier, and the open path checks it against the
> system tier and the caller's accepted minimum:
> 
>   tier     key in clear    purpose enforced by   who may use the key
>            in the kernel
>   kernel   yes             the kernel            the kernel
>   engine   no              the kernel            the kernel
>   tee      no              the TA                the kernel
>   hsm      no              the HSM               the kernel
> 
> The last column is the limit of the mechanism: a compromised kernel can
> use a tee or hsm key for the purposes it already has, but cannot extract
> it or change its purpose. Documentation/security/keys/keycrypt.rst,
> "Backend requirements", is the contract a tee or hsm backend must meet.
> 
> 1. kernel: the keys are in clear in kernel memory while loaded. It is
>    there so that the same interface works on a system with no TEE and
>    no suitable hardware, where it still keeps the key out of user space
>    and out of the root filesystem; its one backend, sw, is off by
>    default (CONFIG_KEYCRYPT_SW), and a system that has one of the
>    other tiers should use it, engine at least, and raise the system
>    tier accordingly. Raising it stops the use of kernel-tier keys, not
>    their presence: one created or loaded below it is in clear all the
>    same, as its trusted master is, so a system that must have none
>    builds without CONFIG_KEYCRYPT_SW.
> 2. engine: a crypto engine the kernel drives keeps the key, never in
>    clear in the kernel, but its use is decided by the kernel only. It
>    comes in patch 6, on its own, so that patches 1-5 stand without a
>    tier no backend of theirs declares. The CAAM backend of this series
>    is an engine, since the CAAM does not check what a key is used for;
>    an ELE backend (below) would start as an engine too, and could move
>    to hsm once the firmware is confirmed to enforce a key's purpose. If
>    more such shades appear, a separate property may fit better than
>    more tiers, and I would welcome an opinion.
> 3. tee: the OP-TEE backend; the TA re-checks every operation against
>    the purposes it bound when the key was sealed.
> 4. hsm: as tee, in dedicated hardware apart from the CPU running the
>    kernel (a secure element, a security core of its own such as NXP's
>    EdgeLock Enclave, a crypto engine with its own policy), the place of
>    Android KeyMint's StrongBox; no backend in this series.
> 
> The backends
> ------------
> 
> 1. sw, of the kernel tier (no name is both a tier's and a backend's):
>    keys sealed with AES-256-GCM under a key derived with HMAC-SHA256
>    from a trusted key (any trusted-key source); HKDF-derived stream
>    subkeys; lib/crypto AES. Where the trusted key
>    comes from a TPM, the TPM only unseals that master when a key is
>    loaded; the data itself is ciphered on the CPU, never by the TPM.
> 2. OP-TEE: a trusted application, an early TA, REE kernel login only;
>    it derives its sealing key from OP-TEE's hardware-unique-key
>    service. The TA is written (ta/keycrypt, one patch to optee_os) and
>    is the one that ran on the hardware below, but I have not proposed
>    it to OP-TEE yet: I would first like to know whether this direction
>    can go on. I can publish it for anyone who wants to try it and is
>    willing to support the work.
> 3. CAAM: patches 7 and 8, a proposal and not to be applied as they
>    are.
>    They are based on Richard Weinberger's "crypto: caam" series v1 (see
>    "Base and prerequisites") and never ran on a CAAM. Questions for the
>    CAAM maintainers:
>    a. is an internal cbc(paes) taking the caller's key modifier an
>       acceptable form;
>    b. can a job generate a key in the CAAM and keep it black without it
>       crossing kernel memory;
>    c. can the use of a key be checked by something a compromised kernel
>       does not drive: trusted descriptors, which would let the CAAM
>       itself enforce a key's purpose and make the backend hsm, or a job
>       ring owned by the secure world, which would make it tee;
>    d. could cbc(paes) take CCM black keys, which are authenticated where
>       ECB ones are not, once the driver handles their extra length
>       (Weinberger's series refuses them, so the backend uses ECB).
> 4. ELE (i.MX9), not in this series: this is an RFC, and I am not an
>    expert of the enclave, so I would rather know first what NXP thinks
>    of it, and whether they would be willing to propose an ELE backend
>    themselves, as an engine or, better, as an hsm. As far as I can see,
>    the se_if driver in linux-next gives user space a misc device with a
>    generic send-and-receive ioctl for the enclave's messages, and offers
>    nothing to other kernel code. A per-operation in-kernel API exported
>    by that driver (open a key store reserved to the kernel, generate a
>    key, import a wrapped one, read a key's attributes, delete it,
>    AES-CBC and MAC in one call) would let a keycrypt backend use the
>    enclave. Questions for NXP:
>    a. does the firmware enforce a key's key_usage and permitted_algo on
>       every operation, min_mac_length when verifying, and never release
>       a generated key in clear (yes to all three would make the backend
>       hsm rather than engine);
>    b. could a key be exported wrapped under a device-unique key and
>       imported again, so that a keycrypt blob holds the key itself
>       rather than a reference to the enclave's key store;
>    c. is the key that wraps an imported key unique per device;
>    d. the user-space library has a streaming MAC (hsm_mac() with its
>       INIT, UPDATE_DATA and FINALIZE flags): would the firmware offer
>       it to the kernel for a key in its key store;
>    e. can a key_id be reused after a key is deleted (the library's
>       documentation does not say);
>    f. would a per-operation API of this kind answer the objection Arnd
>       Bergmann raised to the generic passthrough
>       (<2034fb2f-f169-46a5-85e8-fa723ddb0360@app.fastmail.com>).
> 
> Base and prerequisites
> ----------------------
> 
> The series is based on mainline v7.4-rc2-92 (067c5c24cef2). Patches
> 1-6, and patch 9 on top of them, apply on it alone. Patches 7 and 8, the
> CAAM proposal, need Richard
> Weinberger's "crypto: caam" series v1
> (<20260726081504.2182951-1-richard@nod.at>, three patches, listed as
> prerequisites below) applied first, for example with:
> 
>   b4 am -o - 20260726081504.2182951-1-richard@nod.at | git am
> 
> Testing
> -------
> 
> The series comes without its tests. There are KUnit suites for the
> core and the sw, OP-TEE and CAAM backends, and a kselftest for the user
> ABI, with a case for every reachable row of keycrypt.rst's error
> tables; together they are larger than the code they test, so I am
> keeping them for the non-RFC series, once the direction is agreed. The
> results below that name them come from the series with the tests in it.
> Taking them out removed only the tests and the hooks that let them
> reach the code's internals (static functions made visible and exported
> to KUnit modules): with CONFIG_KUNIT off, the posted patches build for
> arm64 to the same instructions as that series.
> 
> On that base, with Weinberger's three patches applied: built for arm64
> with W=1 (security/keys/keycrypt/ and drivers/crypto/caam/, no
> warning), and, with the tests on top, the KUnit suites pass on UML
> but for the one case that needs the system tier above kernel (by
> Kconfig or boot parameter). Patches 1-6 and 9 alone, on the base without
> Weinberger's patches: the same build of security/keys/keycrypt/, no
> warning.
> The runs below were made on that series at v7.3 on QEMU, and, without
> the CAAM code, backported to NXP's 6.18, on QEMU and on hardware:
> 
> 1. QEMU (qemuarm64-secureboot, OP-TEE 4.9.0, an fTPM as the source of
>    the trusted master): the KUnit suites and the kselftest passed on
>    the sw and OP-TEE backends, a case skipped only where its backend
>    was absent (the CAAM) or where it needs a one-way policy setting;
>    the TA's unbind and bind; persistence of a blob across a restart.
>    QEMU proves function, not secrecy: its hardware unique key is a stub.
> 2. Hardware: the series, backported to NXP's linux-imx lf-6.18.2-1.0.0
>    (six upstream prerequisites; the two CAAM patches left out), with the
>    TA built as an early TA into NXP's imx-optee-os 4.8.0, ran on an
>    i.MX93 board with secure boot closed (AHAB), where OP-TEE derives the
>    key that seals the TA's key blobs from the EdgeLock Enclave's
>    hardware unique key. The KUnit suites and the kselftest passed on
>    the OP-TEE backend, a case skipped only where its backend was absent
>    (sw, which 6.18 cannot build for lack of the library AES it needs,
>    and the CAAM, left out) or where it needs a one-way policy setting.
>    A key generated in OP-TEE and kept as its blob
>    was loaded back after a reboot and after a full power-off, and
>    decrypted a file encrypted before them. The same AES-256-CBC key and
>    IV through AF_ALG (cbc-aes-ce), through keycrypt and through openssl
>    gave identical ciphertexts.
> 3. Cost on that board (Cortex-A55), AES-256-CBC, per call on an open
>    context: keycrypt with the OP-TEE backend 59-62us up to 256 bytes,
>    ~106us at 4KiB, 880-930us at 64KiB (67-71MiB/s); AF_ALG cbc-aes-ce
>    6-7, 12-14 and 110-138us (454-570MiB/s). Opening a context costs
>    ~500us, against ~9us for an AF_ALG accept on a keyed socket (~25us
>    for the whole AF_ALG setup). OP-TEE's own benchmark (xtest
>    --aes-perf, from user space through libteec) on the same board gives
>    ~64us per call plus ~1.5ns per byte. keycrypt's fixed cost matches
>    that round trip to the secure world; its remaining ~11ns per byte is
>    spent in this prototype's own data path (buffer allocation and
>    copies between user space, kernel, shared memory and the TA); which
>    part dominates is not yet measured, and it is to be reduced.
> 
> A user-space consumer exists: craf, the archive tool of crypto-afalg,
> has a keycrypt backend on the keycrypt branch of
> https://github.com/giometti/crypto-afalg (tag keycrypt-board-5 is the
> version that ran on the hardware above). Its enc command, an openssl
> enc that takes its key from the keyring, shows what a keycrypt key
> carries. A key made once as
> 
>   k=$(keyctl add keycrypt demo \
>         "new aes256-cbc encrypt,decrypt min-tier=tee" @u)
> 
> is bound there to AES-256-CBC, to encrypting and decrypting, and to a
> backend of tier tee at least, chosen by the kernel; so
> 
>   craf enc -enc-key $k -iv <hex> < plain > cipher
>   craf enc -d -enc-key $k -iv <hex> < cipher > plain
> 
> need nothing else: the open takes no algorithm and no backend, the key
> brings them, and its tier is enforced by the kernel against
> -enc-min-tier or the system's tier. Any other key goes to AF_ALG, and
> the command line must name the cipher. On the board, craf enc with an
> imported keycrypt key and openssl enc with the same key bytes and IV
> each decrypted what the other encrypted.
> 
> While testing the user-space side of this series, craf's test suite hit
> the KEYCTL_PKEY_VERIFY regression of cb481e59ea6c, which lets a short
> RSA signature verify: it is fixed by Florian Bauckholt's patch [1], and
> the reproducer was reported in [2].

I likely have never time to read this. Thus, NAK.

Br, Jarkko
