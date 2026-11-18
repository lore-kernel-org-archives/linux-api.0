Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=185.203.200.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795013855;
	b=A6z9QxS9+X1FwJFMDnBRCMBuVOaZsKActeuKsrfOu1INFi1AT0DX3nfpggwWihP/Tfhr
	 mRamnkgDwECLg+Sa8Lplkobc9ZKPeojz9UBqd66I1Wtg+APdRAKdlqZphse4Pj7VYI6RO
	 CtwvsacxIpICk9ld6VARoyfNJN42ZlHUMmS8mHfs/ioByRl3xLCT/PXmAPWPCd6j0vIAi
	 YZgE4QsHXu8vMtlNJNCNRFfPtNx+awhfjP7znqSLpDKk5iUGDMC+Ey3VHm115nvzE9fYT
	 ufaHPBGTfJPApmJouDsU/wfSVSyAQTlt12pPyShlcoSVvd39VOtVzl4tDyJuPLB6lbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013855;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UouHQ6MpTNXM8uJfZQ0fB7S7wKdW0uqNg5BNvSU1JoQ=;
	b=vkCOBXyG77P74reJzJN6N4EMb3Dtr50/wA/9Hy3Zvz0D0DeqihMbq24vtL7s0m6KuRPg
	 HNWb54t7hFvGi2G4JZhVE3F/bhhQx0GmtsZcNEG/E1PmZNToeMQXs7aDIuEnrgzi+chAD
	 rfkL2WIbOFxX5uhpZ31MC3ypBb4rycF2rfZdzWow686PnH1AJMwXV/9jE79TkGcqBgsUV
	 yMQLqdVEYvx7RUDIZEW9APGsgmr9wXO+Hax1bR6TMGlArUqYEQ6eYMak0mD7ua/Fe4bb3
	 FCrSbajtE1Sx1pydbzEAHtPWeeYBQkHjFH8sTDDaTPijPX1SieD0J488H4HB/ZeYnNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=pengutronix.de;
	spf=pass smtp.mailfrom=pengutronix.de;
	dkim=pass header.d=pengutronix.de header.i=@pengutronix.de header.a=rsa-sha256 header.s=20260414 header.b=EqcFm6Cd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=185.203.200.13
Received: from mx1.white.stw.pengutronix.de (mx1.white.stw.pengutronix.de [185.203.200.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF9606A31C;
	Wed, 18 Nov 2026 14:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3BF9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pengutronix.de header.i=@pengutronix.de header.a=rsa-sha256 header.s=20260414 header.b=EqcFm6Cd
Received: from ptx.office.stw.pengutronix.de (ptx.office.stw.4.pengutronix.de [10.9.0.3])
	(Authenticated sender: relay-from-ptx.office.stw.pengutronix.de)
	by mx1.white.stw.pengutronix.de (Postfix) with ESMTPSA id 4FAAC20102E;
	Wed, 18 Nov 2026 15:57:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pengutronix.de;
	s=20260414; t=1795013847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UouHQ6MpTNXM8uJfZQ0fB7S7wKdW0uqNg5BNvSU1JoQ=;
	b=EqcFm6Cd3BeswGDiUUFP1eT0bWpx3qRYeDpILSWDZyitUiayImOfN+iOGoVUJrj/zTE8fc
	FQaj9a/SQ7Z2owIMP+CLMVvkyDT6pQRqFhSV31YNnoCQZ5scqoZXdZ97qLKnQGEWCJwSjC
	HNIm/YUb+1QHUMMpLQ/BlvCKeA7gzJb5IRKC7PEZYKZ5zMJ2zSFyryKq34Ltv+RDE7hBwa
	3f6xbNB3AG5iahNBIeevNNZA64vxbFiY+DI4mG0m1CsJCLo/ZRqWOlIwx+gP7ooJR+9xH7
	1Rfb3glnZEdpx65ryBO8lMOSQdpRdf/DkGIyl7F/g24Gq8Olyb1N7ENMS1ZtpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=pengutronix.de;
	s=20260414; t=1795013847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UouHQ6MpTNXM8uJfZQ0fB7S7wKdW0uqNg5BNvSU1JoQ=;
	b=Z9zowXMi3wTKE3VmwA6li7eqOv28E0M0RpHqMb/bhMBvC14Ag419gfYG93a73ig437QbBC
	NUMaVcE6R8drYKpGT9oeYqgpUW3w+ygiHWoO0ERnrN/aD/hr876sKKrTVreYpfwbNCG96O
	OH+HZUkHkBi6OcB2L0C4N2fujK3Y+IGjhJeEHL3CQZTBJBhiDwDaELa/nESKGr+RPTyTKG
	HEv1kLdHqJn5zYgRu4gNOxoq3QpWu0iVVPUKlvs7o1Lzcqxvgm0WOF15Q/ZLs6WRztXJCf
	ZVucZOVlN8jglocApJXmofFHYWeZdCpuA9/EB3JkonL3uRUJopwwhK2AJdcO+Q==
ARC-Seal: i=1; s=20260414; d=pengutronix.de; t=1795013847; a=rsa-sha256;
	cv=none;
	b=Kvpb6SJ5RoWBBGPx2VtY/7Uh0dvpTpWRIgK0T1Xb5UrDCkGGRcxMjSAQ6uD6qPRJAXIdbV
	J9Lx7nBBlKtBrzze2LKGwutucfVP8rkWiXdAEFvRg3pMh/f358h+CPuQuGcoFA93VK6UB2
	lg7Xrkz4LzsGCpDkmb5TON3FDVhDk25Qaa4Rvh9AuNEsvFJKEb63FZH+1WZerrqe7Ca3eq
	/pr35Ka5GuRlO9LXjKm2iHQiP5IU01R1borZsnjHRLBoJeF8OSL62NIzPhFK9MXFIu6VC9
	PZX0+Q52WTAZ797IKDx/iH12LSTvTZX+XkKtKQfCjVRAFRQsiMy+7SudHxBGcw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=relay-from-ptx.office.stw.pengutronix.de smtp.mailfrom=mfe@pengutronix.de
Received: by ptx.office.stw.pengutronix.de (Postfix, from userid 1064)
	id 2E6A91BF4FD; Wed, 18 Nov 2026 15:57:27 +0100 (CET)
Date: Wed, 18 Nov 2026 15:57:27 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	op-tee@lists.trustedfirmware.org, Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, Sahil Malhotra <sahil.malhotra@nxp.com>, 
	Ahmad Fatoum <a.fatoum@pengutronix.de>, Richard Weinberger <richard@nod.at>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [RFC PATCH 0/9] KEYS: keycrypt: keys that user space can use but
 never read
Message-ID: <mvyqqjhvfka3kkumztixzozrthutkq6mfakkonxqbpm5gvzb62@eitzzleeyioe>
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

Hi Rodolfo,

thanks for the RFC and bringing this up. Please see my comments below.

On 26-11-18 15:04, Rodolfo Giometti wrote:
> This RFC proposes a key type, "keycrypt", whose material user space can

Albeit I'm not against a new key-type we already have plenty types.

Furthermore the keyctl API is very open, lacks a common API. E.g. for the
'trusted-key' keytype userspace needs to know the actual used backend
because each backend handles it differently.

Therefore I wouldn't add further keytypes till we have a common API
which the userspace can rely on.

> use for symmetric operations but never read: AES-256-CBC, HMAC-SHA256
> and an authenticated AES-256-GCM stream, through a file descriptor that
> KEYCTL_CRYPT_OPEN returns for one key and one operation. The key is held
> by a backend: the kernel itself (sealed under a trusted key), an OP-TEE
> trusted application, or, as a proposal only, the CAAM. I am asking
> whether this is a direction the keyrings, crypto and TEE maintainers
> would take, before polishing it further.

So it's not a new keytype but a new mechanism to handle trusted-keys
from userspace?

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
								^
					What exactly do you mean by copy?

If you're using the standard LUKS2 scheme, the (volume)key never sits
inside encrypted device. The key is part of the LUKS2 header. Maybe I
didn't got your use-case, can you please elaborate a bit more?

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

Above you mentioned trusted-keys, but trusted-keys don't let the key
stay inside the TEE. Albeit the key is only reachable kernel (EL1) it is
always reachable from normal world. So a kernel CVE could leak the key
as well. This is different compared to protected keys like
p(rotected)aes. Here the keys always stay within firmware/secure-world.

I didn't get your problem from your above description, sorry and
therefore I'm asking.
Do you want to use trusted-keys for partition (rootfs, data, ...)
encryption? In such case I've developed another idea which I'm about to
post as RFC.

> The interface
> -------------
> 
> 1. A key type, "keycrypt", created with add_key() from "new <alg>
>    <purposes> [tier=|min-tier=] [backend=]", "load <blob>
>    [accepted-min-tier=] [purpose=]" or, when allowed, "import <alg>
>    <purposes> [tier=|min-tier=] [backend=] <hex>". User space states the

This is exactly what I meant at the begining. I'm not a maintainer, but
this string parsing "API" is very error-prone. Furthermore, how can a
userspace enum available backends? Instead of try and error I would like
to see a query/enum phase and later on userspace can decide which
backend and tier to use.

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

These are basically the trusted-key purpose.

>   engine   no              the kernel            the kernel
>   tee      no              the TA                the kernel
>   hsm      no              the HSM               the kernel

These are protected keys which we have already (see S390, CAAM, DCP,
Zynqmp, ...).

I don't see what you want to solve with your approach. Do you want to
have a common interface for generating/loading protected keys?

That beeing said, loading protected keys can already be done by just
specifying the correct key-cipher. Generating the key is platform
specific and would need a common API.

Thanks for sharing your ideas :)

Regards,
  Marco

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
> 
> [1] https://lore.kernel.org/keyrings/20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de/
> [2] https://lore.kernel.org/all/0e20f799-e389-40d2-aaee-2f174748faae@enneenne.com/
> 
> Why not AF_ALG or KEYCTL_PKEY_*
> -------------------------------
> 
> They are the two existing interfaces through which user space uses a
> key it does not read, so they are the first alternatives a reviewer
> will name; keycrypt.rst has a section on them.
> 
> 1. AF_ALG takes a trusted key by serial (ALG_SET_KEY_BY_KEY_SERIAL),
>    but copies its payload into the socket, ties it to no algorithm and
>    no purpose, and runs it on whatever implementation the socket is
>    bound to, since v7.2 only on the CPU but for cbc(paes); extending it
>    would mean adding purposes, tiers and off-CPU backends to what it
>    has just removed.
> 2. KEYCTL_PKEY_* already lets user space use a key without reading it,
>    but for asymmetric keys, one operation per call; a symmetric mode
>    needs state across calls (the CBC chain, the stream's segments),
>    which an fd holds naturally.
> 
> Whether one of them should be extended instead is the first question I
> would like answered.
> 
> Known limits
> ------------
> 
> Some are limits of the design, kept on purpose:
> 
> 1. Only the sw backend is self-contained in the tree; every guarantee
>    against a compromised kernel is a requirement on the other backends,
>    which "Backend requirements" in keycrypt.rst sets out.
> 2. Kernel-tier keys are in clear in kernel memory while loaded: that
>    tier is there for systems with nothing better, and a system that has
>    more can refuse it (above).
> 3. The tier is declared by the backend, not proven: the kernel cannot
>    check what a TEE or a piece of hardware does, so it records and
>    enforces what the backend declares.
> 4. A blob is a bearer credential, and a process that possesses a key
>    can read its blob: what binds the key is the backend's secret,
>    unique to the device, and the purposes sealed with it, not the blob.
> 5. CBC is unauthenticated and is a raw AES oracle for its holder: it is
>    there for the formats that need it, and the GCM stream is the
>    authenticated choice. The stream is not key-committing, which a
>    format trying several keys must handle (keycrypt.rst says how), and
>    is bounded at 2^32-1 segments, 256TiB at 64KiB each.
> 
> The others I plan to address if this direction is taken:
> 
> 6. Checks happen at open only, so an open context survives a raised
>    policy or removed Search (revocation closes it): raising a policy
>    would close the contexts it no longer allows, as revocation does.
>    Whether Search should be the use permission is among the points
>    below.
> 7. import moves a clear key through kernel memory: an encrypted import,
>    wrapped for the backend, would avoid it. Policies are global: they
>    could follow namespaces, if that is wanted, and stay one-way.
> 8. The GCM stream has no seek: decryption could start at a given
>    segment (keycrypt.rst leaves room for it in the open parameters);
>    encryption never will, so that no counter is used twice.
> 9. OP-TEE backend: its control session is not reopened after a TA
>    panic, the TA's session limit is a build constant, and every context
>    has shared buffers of its own: the session would be reopened, the
>    limit made configurable, and the buffers taken from a pool, as part
>    of the work on the per-byte cost above.
> 10. No keyutils or man-page support yet: to be added.
> 
> Other points I would like opinions on:
> 
> 1. two KDFs and a stream construction living in security/keys rather
>    than reusable primitives;
> 2. Search as the use permission;
> 3. an rwsem held across sleeping backend calls;
> 4. whether a KEYCTL_CAPS1_* bit telling a process once that keycrypt
>    is there would help (not in this series).
> 
> Not in this RFC: signatures, ECDH, encrypted import, io_uring, other
> modes; ELE code; external secure elements as backends.
> 
> How this series was made
> ------------------------
> 
> This work comes from a project to strengthen the secure-boot chain of
> embedded Linux systems.
> 
> I used an AI coding assistant, Anthropic's Claude (claude-opus-5-5 in
> Claude Code), in the sense of
> Documentation/process/coding-assistants.rst. However, the way the
> problem is solved is mine: a new key type, so that user space can go on
> using keys it never reads while AF_ALG drops off-CPU cryptography and
> restricts what it allows, built on backends that hold the key and on
> tiers that say what a backend protects against, the engine one
> included. I directed the design and took its decisions, choosing among
> the options the assistant set out or bringing my own. The assistant
> surveyed the prior art, set out the design options with a
> recommendation at each step, and wrote the code, the KUnit tests, the
> selftests (not posted, see Testing) and the documentation under my
> direction, in plans I approved, partly through lower-tier Claude models
> it dispatched for individual tasks; each plan was followed by an AI
> review that I read.
> Claude also built and ran the QEMU bench and analysed the hardware run,
> which another Claude session carried out with me at the board.
> 
> I have reviewed every patch and I am responsible for all of it.
> 
> Rodolfo Giometti
> 
> Rodolfo Giometti (9):
>   KEYS: keycrypt: Add a key type for keys user space never reads
>   KEYS: keycrypt: Add the sw backend
>   KEYS: keycrypt: Add the OP-TEE backend
>   docs: keycrypt: document keycrypt keys
>   MAINTAINERS: add KEYS-KEYCRYPT
>   KEYS: keycrypt: Add the engine tier
>   crypto: caam - add an internal cbc(paes) taking the blob's key
>     modifier
>   KEYS: keycrypt: Add the CAAM backend
>   KEYS: keycrypt: Add the aes256-gcm-stream algorithm
> 
>  .../admin-guide/kernel-parameters.txt         |   20 +
>  Documentation/security/keys/index.rst         |    1 +
>  Documentation/security/keys/keycrypt.rst      | 1105 +++++++++++++++++
>  .../userspace-api/ioctl/ioctl-number.rst      |    2 +
>  MAINTAINERS                                   |   18 +
>  drivers/crypto/caam/caamalg.c                 |   89 +-
>  drivers/crypto/caam/caamalg_desc.c            |    3 +-
>  drivers/crypto/caam/caamalg_desc.h            |    1 +
>  include/keys/keycrypt.h                       |  161 +++
>  include/soc/fsl/caam-blob.h                   |    8 +
>  include/uapi/linux/keycrypt.h                 |  182 +++
>  include/uapi/linux/keyctl.h                   |    1 +
>  security/keys/Kconfig                         |    2 +
>  security/keys/Makefile                        |    1 +
>  security/keys/compat.c                        |    3 +
>  security/keys/internal.h                      |   12 +
>  security/keys/keycrypt/Kconfig                |  153 +++
>  security/keys/keycrypt/Makefile               |    9 +
>  security/keys/keycrypt/caam.c                 |  346 ++++++
>  security/keys/keycrypt/caam.h                 |   30 +
>  security/keys/keycrypt/core.c                 | 1077 ++++++++++++++++
>  security/keys/keycrypt/ctx.c                  |  667 ++++++++++
>  security/keys/keycrypt/keycrypt.h             |  180 +++
>  security/keys/keycrypt/optee.c                |  489 ++++++++
>  security/keys/keycrypt/optee.h                |   39 +
>  security/keys/keycrypt/sw.c                   |  468 +++++++
>  security/keys/keycrypt/sw.h                   |   30 +
>  security/keys/keyctl.c                        |    5 +
>  28 files changed, 5090 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/security/keys/keycrypt.rst
>  create mode 100644 include/keys/keycrypt.h
>  create mode 100644 include/uapi/linux/keycrypt.h
>  create mode 100644 security/keys/keycrypt/Kconfig
>  create mode 100644 security/keys/keycrypt/Makefile
>  create mode 100644 security/keys/keycrypt/caam.c
>  create mode 100644 security/keys/keycrypt/caam.h
>  create mode 100644 security/keys/keycrypt/core.c
>  create mode 100644 security/keys/keycrypt/ctx.c
>  create mode 100644 security/keys/keycrypt/keycrypt.h
>  create mode 100644 security/keys/keycrypt/optee.c
>  create mode 100644 security/keys/keycrypt/optee.h
>  create mode 100644 security/keys/keycrypt/sw.c
>  create mode 100644 security/keys/keycrypt/sw.h
> 
> 
> base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
> prerequisite-patch-id: 6f1c5a861378c58d6adea4e1745794466a9d73d6
> prerequisite-patch-id: e1565dff5540351c42ee04e0308649a6d97e9e09
> prerequisite-patch-id: 37ed62269bd4b1fcaeeab38f5feb5b0f63608459
> -- 
> 2.43.0
> 
