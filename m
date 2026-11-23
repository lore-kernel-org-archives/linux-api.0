Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=66.163.188.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454556;
	b=3g9joJmMBF22ndhazC84wdc5J/OBfhc705b8ZdN7XH3K8IE675KPE2+eA50B19D5aDfE
	 p/MZ93StGAr1aABBmM4z/YReDF/plFa3PQisFx9uzCAET51m7CkzwZXgM5Y2ENjACVO0j
	 Ljj7ewWH0vfbv+FE91MIWW7o43H6ze4nqQ7840LR5CmdvtvE2vGxCd1GRFhd5+HT69v9B
	 60It06SRJF9jfr0PB/wPEkGhDIbAAH66YmtMJKiyWdaSd8v2rm71UIX1zjzdaDxGOFsvC
	 wJPN4WI+1DL+b7dO6hFXO8WvcB62MFnmmtAKBw3AQ7R4SG2/9xyQCfnBqaB6JeD2luA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454556;
	h=DMARC-Filter:DKIM-Signature:X-SONIC-DKIM-SIGN:X-YMail-OSG:X-Sonic-MF:
	 X-Sonic-ID:Received:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=uRKZ+RMxC4bMe0mgfpp7MDpzdbKDn8Xzj2j2ppWb+8Y=;
	b=35d0i4XWpYv18XfAQCnoRSKGVljPv7wIZkzfZsEoLwM8jlBzjP9wzjNoiqF3lyJNUIWi
	 COnDXmKlYt8H3bP0ylTx43Y6/1Hj2daGpvGwn2dlfD29ZRIG+M3jWYkeecW3cUNjO0kKH
	 ebVZd4dumh/sSev+lVqWUpnjgMIDRlElPMeoKgf6Thr1olWRM/+Lx6eFRfvoIblEp7ISG
	 q06PT5esXJScjO/WI2ThkW/NtcIMKId4iXEGKWUxDQGQ2XRCwhYV93YxnQPbIBRpBMVZl
	 bY0uL/UUWyrPWQ1+xvOT6wGzTYxUsF5gU/LWgACLFudP6C8aVxVMI9UVpJVjNjkrmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=schaufler-ca.com;
	spf=pass smtp.mailfrom=schaufler-ca.com;
	dkim=pass header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=VXG9ycOT;
	arc=none smtp.remote-ip=66.163.188.153
Received: from sonic303-27.consmr.mail.ne1.yahoo.com (sonic303-27.consmr.mail.ne1.yahoo.com [66.163.188.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C927E606A681
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 17:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C927E606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=VXG9ycOT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795454553; bh=uRKZ+RMxC4bMe0mgfpp7MDpzdbKDn8Xzj2j2ppWb+8Y=; h=Date:Subject:To:Cc:References:From:In-Reply-To:Content-Type:From:Subject:Reply-To:Content-Type; b=VXG9ycOTErIOBGQMzvbttrolFMLjiwQLqgCcoaWQ/LT6R65Bya+1zecCmrQLiJnFBGSV4WJJKDjhqqzOuI29MuvtfHXsYaZAPk1PEJCgBCgOQK8khz4ER+v1pjWVJAt7BzF+hf05GoqVLuHfGDSKhUSkJv+VUoplH6fbn5GPCkTDJz5fyOAvmZbbNQuyrqEGoThUnSQst3z4ReMbUW+eN+SYlFWXUBuyVvQ9yvQjlhw7vGrAFnWStQPM1Q9bZm1+vjBuvLH/Dt7KsypsSxVDNIuG6L16Us3gZ0AZpUBVp1yeJiAhb5jBPVefnbBSYdoSAQjoJcSdduI7Lr+YKRQgdw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795454553; bh=x1A605av1sLOQbOOtOi6xPddovH0dUBhiTBMvhxZKTq=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=EBOeXdlMhxFDf4Oor7T6dR+ybcijAltLAjfzLMeUtij2wgtJKnFCoa8fxXQLccykIybIK0tneG63iSrJTC86kYddJsEBI+MyuMnpE5PKAueU1ImRxEGulbGHmZBbuMN9e5r30KgFwmVt2X/Hfpwi/9pISB6zNG1iXvvLnoAJZZw99Y1BuHLteYI5TP4oDqKqm5VsSWt5zfccB131lE+qDasntWTM+syS5mfozNtqJkNvJAV2M52yewft5nlmt6SNuv7lGg6bZ30bq7QkfrH5TWXsQKioOU2fym/x0X6zL27CJ+l4uibIq0LdLx3w4G6do8lLQtUpZhnj9LF1ysbEFQ==
X-YMail-OSG: pISsn8wVM1kgswdtsc5HJ8sWGKnYZ0xjyEO.clxMobdNV99yGaQz1ZS2sa3asvd
 6v0LoWxEXm7NsCPDFEbu8SCxAqx4YhMKKSKJJ59bc4fvJi.lv2feXKCP02Gr0K8Ny7uWFyOexy9o
 e.y2hz_CuZjW86LbyM5NdmAm8dS652v8git0yOdOlWsn2IyOPjJGFI8G_M1qefvL7Uo9olCHlw9C
 OSgO.9.m03XqChQy7hO0z7t8pNp4C9ShyjZNTs6S_Tl2k3CYMScN4aWSgJBBHp1so661Z3o7rVXo
 5CtM83wlIo9CiMmogVRcaog7jY0vYIgkYC1jKO7PnWg0aKZd13ffmwGpawalqgRS8hVB3Hz7mGAw
 0kdNeP4a_PaNfEpWw_cH0dyf4aXgGfwg.amuPBaDhXJlJjwn8U2Fmr1By4A_V7ID58ZFKLgFERkl
 LQuXAm1NsRm.hY0drwlzyPUVvp9d5MR2ZzgrOZ_vOT6Pfhxf4ek7Sga7YCmmrqf4dgok9eGW2LYo
 RC_hBhsmPJ0BJBwIf.t_gH_x1FHDLcZbRkWr7KMgYpS4uqgk61xwJCZ3CjYcBI1ZkajjnIhsT9iv
 pG2Rse9km9owH3GX8NdMFGZl4.ORVWgP5lyvVKM7pgIHJo0Gkg6pKzFbcRwHZp6E3iIENvweVEL7
 DZqJXnRZ7Isjt_5z3tFYHS2Qs7.WhqVHwf1CVpcwXD07_AvMvMlVAcMgeyS8_LYxNXiWd4vJ8vB8
 BGbbkpwbEugvn5oOtaECcRTP40AJptU_x_xn5c8vWKnNncc7oQiUGbNS4Ve_41a_OGYl8cXsaMun
 RNfVoDXd1FgYI4SsaxDc90_Tyq0.ZIlECFRoxabr1UYn8VgS_Ic4.hqfPv1jg2cdNWiWg08jutX1
 0zrbUn4VRDZOxAJCXmT8d70mzVAWnVnm5.Qq5Gk4y5rCZxFqSnM5PrjerR1aU2qeIzst1mX_dJhQ
 8_bhRfoyDeDFyUX4HvsLbBtG8UsOS8vSMda4HdQyurPgSLW2T4GNX_ItDExzTZSp4V091P9AscA2
 E6G0m_QR.Ub.pa83oWNYaxRv7kp31vdn1iXI096GAe4VY3IrbfHro7H_gkhKVp3OhC.ilu4tHQ9t
 ZMVrc6B1YAidEQZWVsUwZcmxHxjkq.euP61yN1lZqpSs51ybjPnRVcDMX..dUVy.FW7voOc4ykG1
 JRuda28JvedkaBTfvGsk37o708VDKL_0EEKF6Gqbuim7xs.oHqEErpTyMLlTXE6NNIDT4JKP5wfD
 fHDkwapyG25dgY_u0MDdIivh4XWIGak8QUZInIOrd4BTRL2HwJfRFOQXp.rQeJ4K1mt4ehqoObBF
 a5_QIEv6IL_sLOhS5U_ezKQmKnlhLfiDh5HaHa1mPAkfXUa2HxwHuPxS.qrr2ChqTYo_Yblgs9kO
 Bwcoc2yZjRnhB_1ID2Vi8M9cXh_qnR.68zvgYxunEv.qIix.afah_QZatzdrZhaYuYYLY8b8iyts
 WUFZJraivHHuLKXUYm.82RbqXFBbLj41sOcGsU7Cnhc.VDzNIj0lEldnBIhPsfE6etBh79h5CeoO
 HStvBfAwG2Q1jIHtC_PzBLV0eoyVz_Saf.xFML9YZe_8VnrNoivBbAbUw30m0LyTtqCT52eTMxns
 L3eNuC_Wf4VHUSSnpTDvH0iaFvKPatJpxLqeRwUoSho0UYOrtpwoZhtGlta9AYP6WSDizfXrJz20
 YZkLq6.ahuoF8tOstEYvlrfGRdblywHkxoKCYtr9fLyr2zPsnL.6nwOxd8PKKF3yIivXque8IXa.
 bbOQoIhBsduxtVAPgRSPASpiMslfQ.Z_LJtw2Hruf4XPhV6xLpIhPm8oLs_joE8R5iRYVddZ10VZ
 IyOq5WjrrgUfLqUEO5PdbPXYafT3ilpoPHuqV8Dc.MKtPOtt8eUKdsi.u7lrt6wc5xb7P4pYJ0ZG
 51.MkKDfJ8nwa5qE5foVosx6vnB5nkU.Z1gyCOIkFC.SFEo8YgIG_65yicqW3mz0BnWYVQlDaYE0
 cLG.I8qvGMum0EpjiXAAhYy_WT__ZXHqRo9PhK_RdcSHxVYaCsC_foBPZ1EiijTr_79yD9sh4kAU
 ziAJBg1rQwS5uyGTr_juz4R9dycl602obRXAql14cY7wylGKiHQQXNlYOvMhTZttZ5cPQ8NN2Yj1
 egZTbNmJoFZ_m6I8u8ml1MlrqaWnf4LEPBebAnd.ilMYKxpkL5bZR.Q9YX0Ii0.YqLx_7SIUmaiB
 1Oy5bmByT2Qrl0j959qSQ0mOfr_fcW0MoQXB4XEaIiPtvk07BJIJlv_utfX2uyBt3t8_fSe7lfC4
 -
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 1166c4d1-03f0-4fc4-bf3b-c504ad85dd9b
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Mon, 23 Nov 2026 17:22:33 +0000
Received: by hermes--production-gq1-7c58b65db6-gqclq (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 001180dc5b70f5b27368d9bc68412e31;
          Mon, 23 Nov 2026 17:22:32 +0000 (UTC)
Message-ID: <4db941ba-3001-4019-8910-63e534b29f89@schaufler-ca.com>
Date: Mon, 23 Nov 2026 09:22:29 -0800
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for user
 namespaces
To: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>,
 Christian Brauner <brauner@kernel.org>, Serge Hallyn <sergeh@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Kees Cook <kees@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
 <mic@digikod.net>, Jonathan Calmels <jcalmels@3xx0.net>,
 Jann Horn <jannh@google.com>, =?UTF-8?Q?G=C3=BCnther_Noack?=
 <gnoack@google.com>, Singh KP <kpsingh@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-api@vger.kernel.org, containers@lists.linux.dev,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20261119104208.782900-1-halg@google.com>
 <20261119104208.782900-2-halg@google.com>
 <CALCETrVqc+1bjH1bhqHee9bsUdk2B6314z7PMexbsnNpMhk14g@mail.gmail.com>
 <CALCETrV=zSxb6sgA08DLiK2bQovdMEj9ycG=Cc71mLn2C5Pgeg@mail.gmail.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CALCETrV=zSxb6sgA08DLiK2bQovdMEj9ycG=Cc71mLn2C5Pgeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.27100 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 11/20/2026 9:09 AM, Andy Lutomirski wrote:
>> On Nov 19, 2026, at 2:52 PM, Andy Lutomirski <luto@kernel.org> wrote:
>> ﻿On Thu, Nov 19, 2026 at 2:43 AM Hallgrimur H. Gunnarsson
>> <halg@google.com> wrote:
>>> When a process creates a new user namespace, it receives a full set of
>>> capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
>>> in scope, several of these capabilities (such as CAP_NET_ADMIN and
>>> CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
>>> containers never need. However, there is currently no configurable way
>>> to withhold such capabilities from user namespaces while still granting
>>> them to workloads that require them.
>>
>> One thought (from the rootns thread): the other decent sized attack
>> surface here is CAP_MOUNT_ADMIN.  Which doesn't exist as a capability
>> bit.
>>
>> A sort of horrible solution (but maybe not so awful) would be to
>> declare that the bits in cap_userns aren't actually capability bits,
>> and that you need the bit in cap_userns *and* the bit in cap_effective
>> to do sensitive things, and that mounting needs cap_userns to have
>> NSCAP_MOUNT_ADMIN *and* cap_effective to have CAP_SYS_ADMIN.
>>
>> I want to sleep on this.  It might actually solve several problems,
>> e.g. controlling creation of ipv4 and ipv6 loopback or tunnel devices
>> or whatever.
> I slept on it. Here’s a counterproposal.  I’m not saying I think this
> is better than this patch set, but I think it’s worth weighting the
> options.
>
> Define a whole new set of privilege bits.  As a
> poorly-painted-bikeshed option, I’ll call them eprivs (for exposure
> privileges - it’s a crappy name but at least it’s pronounceable).

I played with a mechanism I called "chits" (all the good terms for security
bits have been consumed for a very long time) that looks a lot like
what you're proposing. I did it to address the CAP_SYS_ADMIN problem,
where any use of the capability opens up a whole barrel of worms.
I cannot, unfortunately, find my patches. :( The basic approach is:

A process has an optional set of chits. A process without a chit set is
unaffected by the mechanism. A process with a chit set is allowed only
those operations for which it has a chit. The existing but empty chit set
allows no operations. A process may drop a chit, but not the set, which,
again, can be empty.

Because I was after CAP_SYS_ADMIN, I envisioned a call
	cap_able_chit(capability, chit-list)
but there's no reason there couldn't be a
	chit_able(chit-list)
as well.

I wrote this as an LSM, but the system-wide aspect of it made that
a questionable choice.

If you have any interest, I could dig more deeply to try to find the
patches. Otherwise, I'm happy to look at what you come up with.

>
> An epriv is not permission to do something *to* an object; it’s
> permission to do something that exposes a meaningful attack surface
> within the kernel. So there’s no ns_has_epriv because there is no
> object.  These are kind of the opposite of object capabilities.
> Additionally, an epriv never grants the ability to do something that
> one couldn’t do in an epriv-less world.
>
> For now, all tasks have all eprivs, even not-yet-defined ones, unless
> user code or config explicitly changes this.  (Maybe some day secure
> boot might remove certain eprivs.)
>
> There should never be a check like ns_capable || has_epriv. It’s also
> &&, or perhaps caps are not checked at all.
>
> Example eprivs include:
>
> EPRIV_FSOPEN_VIRT: may fsconfig, fsopen, etc a virtual fs like fuse or
> tmpfs or overlayfs.
>
> EPRIV_CLONE_TREE: may clone a mount tree
>
> EPRIV_MOVE_MOUNT: may move mounts around (but only if you also have
> CAP_SYS_ADMIN on the correct namespace, of course)
>
> EPRIV_FIREWALL_TC: may configure any firewalling configuration or tc
> configuration (this includes iptables, nftables, and ebtables)
>
> EPRIV_NET_RAW: may use raw/packet sockets (like CAP_NET_RAW)
>
> EPRIV_TUNTAP: may create and attach to tun/tap interfaces
>
> EPRIV_IP_LOOPBACK: may set up IPv4 and IPv6 loopback using whatever
> new facility we add
>
> EPRIV_NETLINK: may use netlink at all
>
> EPRIV_NET_ADMIN: may use traditional CAP_NET_ADMIN abilities (all
> CAP_NET_ADMIN checks will also check EPRIV_NET_ADMIN)
>
> EPRIV_OPEN_FILE_HANDLE: May use open_by_handle_at, etc.
>
> EPRIV_UNSHARE_USERNS: may unshare userns
>
> EPRIV_UNSHARE_NONUSERNS: may unshare any other namespace
>
> EPRIV_MOUNT_CGROUPv1, EPRIV_MOUNT_CGROUPv2: may create a new mount of
> these subsystems
>
> EPRIV_PTRACE: there are lots of different variations that might make sense.
>
> EPRIV_MOUNT_PROC_PIDONLY: may mount proc-pidonly
>
> EPRIV_MOUNT_PROC_NOTPIDONLY: may mount proc not-pidonly
>
> EPRIV_MOUNT_SYSFS: may mount sysfs
>
> Example eprivs that are questionable:
>
> EPRIV_DMESG: the kernel log is a specific object, and I think it's
> better to control access using something kernel-log-specific.
>
>
>
> There is no operation that increases eprivs -- even without
> no_new_privs set, a task will never gain an epriv, nor will a child
> ever have an epriv that its creator did not have at the time the child
> was created.
>
> The evolution rules could be as simple as, on fork/clone, the child
> inheriting exactly the parent's eprivs.
>
> Or we could bind eprivs to a userns instead of a task, but that could
> be more limiting and awkward than we want.
>
>
> What do you all think?
>
>
> FWIW, I had an LLM make an inventory (surely not exhaustive) of
> recent-ish CVEs and how they relate to this list.  (The below is the
> only part of this email that is LLM-generated, although I added
> EPRIV_SYSFS because I didn't realize that nonroot userns could mount
> it until I asked an LLM, sigh.)  To me, the list and its breakdown
> suggests that there is quite a lot of room for meaningful attack
> surface reductions while still leaving large parts of userns
> available, and that my epriv proposal captures much of this but the
> cap_userns proposal may be too coarse-grained.
>
> (I also asked about eBPF, and my LLM came up with a lot of CVEs, but
> there's an existing BPF token mechanism and I therefore did not
> propose EPRIV_LOAD_EBPF.)
>
> --- begin LLM output ---
>
> **EPRIV_FSOPEN_VIRT:** CVE-2022-0185*, CVE-2023-0386*, CVE-2023-2640*,
> CVE-2023-32629*, CVE-2025-38499*
>
> **EPRIV_CLONE_TREE:** CVE-2025-38499* (only if the check also covers
> the relevant internal mount-cloning path; explicit `open_tree()`
> restrictions alone are insufficient)
>
> **EPRIV_MOVE_MOUNT:** CVE-2025-37988
>
> **EPRIV_FIREWALL_TC:** CVE-2022-25636, CVE-2022-1015, CVE-2022-1016,
> CVE-2022-32250, CVE-2022-34918, CVE-2022-48911*, CVE-2022-2588,
> CVE-2023-32233, CVE-2023-35001, CVE-2023-4004, CVE-2023-4015,
> CVE-2023-4244, CVE-2023-5197, CVE-2023-6817, CVE-2023-3609,
> CVE-2023-4623, CVE-2023-4921, CVE-2024-1086, CVE-2024-0607,
> CVE-2024-27397, CVE-2024-26925, CVE-2025-38001, CVE-2026-23111
>
> **EPRIV_NET_RAW:** None identified.
>
> **EPRIV_TUNTAP:** None identified as requiring TUN/TAP. Some
> packet-triggered exploits may optionally use it, but that does not
> establish it as a necessary blocker.
>
> **EPRIV_IP_LOOPBACK:** None identified.
>
> **EPRIV_NETLINK:** Also those blocked by `EPRIV_FIREWALL_TC`, insofar
> as the documented attack paths use netlink. No additional CVEs
> identified.
>
> **EPRIV_NET_ADMIN:** Also those blocked by `EPRIV_FIREWALL_TC`,
> insofar as the vulnerable operations require `CAP_NET_ADMIN`. No
> additional CVEs identified.
>
> **EPRIV_OPEN_FILE_HANDLE:** CVE-2025-38306*
>
> **EPRIV_UNSHARE_USERNS:** Also those blocked by `EPRIV_FSOPEN_VIRT`,
> `EPRIV_MOVE_MOUNT`, `EPRIV_FIREWALL_TC`, `EPRIV_OPEN_FILE_HANDLE`,
> `EPRIV_MOUNT_CGROUPv1`, and `EPRIV_MOUNT_SYSFS`, plus CVE-2025-38058*.
> More generally, blocks the documented unprivileged user-namespace
> setup for the entire inventory when no usable user namespace already
> exists.
>
> **EPRIV_UNSHARE_NONUSERNS:** Also the namespace-dependent attack paths
> blocked by `EPRIV_FIREWALL_TC`, `EPRIV_MOVE_MOUNT`,
> `EPRIV_MOUNT_CGROUPv1`, `EPRIV_MOUNT_SYSFS`, and many of those blocked
> by `EPRIV_FSOPEN_VIRT`. Coverage depends on whether the necessary
> non-user namespaces already exist.
>
> **EPRIV_MOUNT_CGROUPv1:** CVE-2022-0492*
>
> **EPRIV_MOUNT_CGROUPv2:** None identified.
>
> **EPRIV_PTRACE:** None identified.
>
> **EPRIV_LOAD_EBPF:** None identified.
>
> **EPRIV_MOUNT_PROC_PIDONLY:** None identified.
>
> **EPRIV_MOUNT_PROC_NOTPIDONLY:** None identified.
>
> **EPRIV_MOUNT_SYSFS:** CVE-2025-22089*
>
> CVEs not cleanly blocked by an operation-specific bit
> Excluding the two EPRIV_UNSHARE_* gates:
>
> - CVE-2025-38058: No explicit unmount privilege. The vulnerable race
> involves umount(2) and path lookup.
>
> - CVE-2022-0492: The cgroup-v1 mount bit covers the documented
> new-mount attack path, but not necessarily configuration of
> release_agent on an existing writable hierarchy.
>
> - CVE-2025-38499: The correct gate depends on which filesystem-context
> or internal cloning operation reaches clone_private_mnt(). I would not
> count EPRIV_CLONE_TREE as a definitive blocker without checking the
> exact call paths.
