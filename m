Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=66.163.188.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541491;
	b=T0eCCd6SEu9JLuuvEcgw3L+Jn5GnMxH8kfWLtMSpeO1JOxrQ1OdBgPnvBUwXHK0rZCnv
	 e/6V/XhjRTFoiwEpVjfAizpRXqZ6qG8Z6NhxHFihMCfYLceOKLqiO9sdK7yUJiMmXBnJf
	 wfT7ZFHUSKqOl8BbqqGHcMD+8SqldnI1Zq0r7vK3hF/6F9ormt+9bQlMk7ylMSpq2uJGu
	 fzoXHDqekDMStTUSwNMuu85D2wHBiRnpkRaefR3BxBbsw26VUu+73V2bb1sLVEyVv644T
	 9SZmeXCO9HyEb3wQUc0xEhJDqeifP6g17EzyTdCUnN/ZyChVL/Lh7tv1mmr3nFa+Bng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541491;
	h=DMARC-Filter:DKIM-Signature:X-SONIC-DKIM-SIGN:X-YMail-OSG:X-Sonic-MF:
	 X-Sonic-ID:Received:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=obxVbRSlIephVv1mR6mZ90gr2FA9gpYUZLe5xjPWnPY=;
	b=lC2h90goa0JEZ+QjRH/SF22WP05aT65oBqLoFqORUmZp7k2864+bDnWRcazNkqL+m338
	 eL+31MYKg95OgO//xPnnimmYMmdzCv7tahDzpKNK9KaROUFetTXVT8jOsqMrOJpsewLSO
	 BKaaSD2odCGvEF7GGh5F6MyiEo/VF5m+R8HjmoBe3R7VU29wb9p+8jK8FIH0BLmg3QOLt
	 4v6TGdvvjQkero3j2s47113IiKGfEIUBA3sUme5nFRoejsr3gaXxsNObI/qMUJtgzAfNB
	 KtW0cKFoN6ftJcA4GQY5HS62cWbxEO+er9Jdp/Z8m5s8E37fxDj5l7s2tSzMo5hoOJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=schaufler-ca.com;
	spf=pass smtp.mailfrom=schaufler-ca.com;
	dkim=pass header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=JPvFOL5F;
	arc=none smtp.remote-ip=66.163.188.153
Received: from sonic303-27.consmr.mail.ne1.yahoo.com (sonic303-27.consmr.mail.ne1.yahoo.com [66.163.188.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE42606A333
	for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 17:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE42606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=JPvFOL5F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795541489; bh=obxVbRSlIephVv1mR6mZ90gr2FA9gpYUZLe5xjPWnPY=; h=Date:Subject:To:Cc:References:From:In-Reply-To:Content-Type:From:Subject:Reply-To:Content-Type; b=JPvFOL5FebZ6nZIbmCarT2/kph08ccMumcBwenp3NwIBTdRTNjuyCCpreDBtPoHdBD7DL1hGq4T31QLa57uA3AV4bDcfEX1pY0ay5U//6LumcOsqYUcMReP+w91rNntVJtahUzoXtbdo/w4S6W2qSgEVfd4qBKqx1ZbQUCL3jjZQIKOngbd7OFnY78jpUJDpdpPUsqJkvpyOkunVzR4SmlT5i5WE3JwPyaJr1DZRGC6iwQqThq2ENsZO9fnAd+Qa3sDvXA6OmC8iuHsHn4tVsuG6kYJeoXAT4Gv4C2hOFHKzQE8LsNRps6N5414yoeqp2dm/FCFwoLCH0OSNmHFT8Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795541489; bh=34oDlE8IPJfniYlSzx/gdojjvr0WmQoY4APEQCa+6HW=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=fxj8rs3O7JuBvCoTb1sEbrPa1KnWHWqNKJU7YKUmmEISvsUTwlEov55+uawSKLFgX3QISvpDXhttsqT4swmJn9021oy0NCPVKFoTVrRogA9b9xqXBuEEvXYIgLu48hf2MpmtA2Ml11s6ZcwQX4IzhXm02QOOpn/1ZrlLDo8lhjThQjMQzCD9Nmf2mMB6XhlAdQ9mKqu+afu9d5wVp4xgqGBKE03LBjuCrSndos2BcXOiGEgTlF4ktNw2tpbdk2I7NOl+kG6H+SNbYtAclYCLc6xnAV873t6leAm9Wh7eO73HfhorDUCeQCMVVkl5ruHniE1766ywIThRE3YdDTU48A==
X-YMail-OSG: sDd1QUoVM1mxdxnnjM3nEXFWB69uDVvAZdIZgk675hKLQWrtZ9FLo2fAzI7EKuK
 lviFtt2Rt0GE6LwBzTpWoEl6f59LJDLYCij2D3zmpGdfgMppbDR_rvF5jKQcFNRSEWwV4SvPwSNg
 64suxIcXYRVQIrhVx9ecxiJn1yi7e4z413Xz8Jfl8Z1KFVN6K4NYp7x1XT76aDHjqKY9fc.RykXZ
 Xuiso.ArEuM8WfLW3kjHQG7Aj81.YrgrUWbSPerJgk67fKDuD6rFGbRAtrlSO1eWqJRRpsladBlK
 y9ftcE5bcklCC48G.r.nfA.so6Q8yVGeX4JLF2FDYvwJ3XTFDwM2peZt0fz4BaJ18NSMv8_ti9Fu
 1Vpj0IwS4_MgJupK8anzJ0RZN0npWcYw1Qyyz_V5RF5DgItNaekX0b2.wTJJop5kW9Wc0iDR1.lw
 6P4fBSsAV9jF1mohmPoAXndoldLwfWMvBu5a7.jqaqhNZQlwHCG7nEKYr6aTALJ1uATE2ZVvAyWI
 PBqiSorw4PvXYicHI6SBt4ckysvALTVK2.AZWNlzpvXkV4_y.MKSmTJ3Qxfe8hbb27XDHhU0zgvh
 RywkKyIfF09kAZGcPIuohR.lQGIStupVdbl63_1IB0uO5KSn2KSWEjLgP880QaVPn8l2Jb8wY2JE
 ua.OFK6dxn0.2.6Oju2yUAVABrkGtJYOE413h6KEeHlN9ewxb62EVa3Aqby.9jQkdqpoIjJcb9Uo
 N8FwdQ.napAibna7OfJyzKckk6N3Jdn0MZwTg.Zyd0kwqwLdIizM2_RbN09Bja_FFB5KVseDHRCe
 lk9h4b1GWcBdbe8hyUTTA1_L_LeRvzim2pduSQxhhMXZ2F6_tT6_zs3wOUp06CXGv6JVUDjdKh6G
 bj1zeOvsD23XAYOh4ahDgL9HdyeZN4XuiiUidtlt97iL5pD1AN9VaoZPMxqOkimRW5Zko0_JfPnF
 E_S9DV8GXEUE53BFvxclyAUeWf4YOvJXrU0jxuPykqDIfBMMUH1Dmh5qdQR02AmsGDSV1wQVb0kt
 D1B4TF6EwttzQjwuHBl7fHow09VKqhhU_vMB2fRnwqaIL5DbKDVOFRl12cgCdN36a14ZMt7LxtmD
 zufXpvzubdCt44iSvdzYW0Nh1Ic.ub9a5lEsQhtUmnyCWTmdGY7OksGb8iIb19QEpeUI4l5.h9Vz
 9jNFEOUvv2vdH_S4xWn8EFGYunYcrA9WIrgdojJREJt1uyLNTyHVgeV3OgRq5mab1MIYVfPXmg2R
 8pRsUDGB6DgIV3T9rTjH1YLu1myJzT41E70B6vRLDXtYThwL6qvy990ccdb0jkHLzPlxuRs6qn7P
 V7kgesaN9SbHSCNXR0a4mbgd5Yd2JuT9jQP69FGrbhS8l94lis4WtdHQV8nCEMFKyTl_Lbuj7eGp
 qrKkG2m41b_GRrgeOW99UUVVXeMrhcALBYGIcWDbWmFPirgZLa9NYXonkx.qtHUJmlGtLWl0IOT0
 cTZ4unDwH2oKV742_Xkfbk5ozI0obSd2GVYJoD_L5TXH5_5Wj3bgqreZW5BKbnm.t3vD5LHz18vi
 YC7B4pNepSaa52A3yLLcui1AFhVx_Pk5K993A.Wzoi2nlUIaArLWN5mixh_XLufECYrX.byiQxYX
 M.JZKnZb4uNUJ9GuzpzSyI263M_ekqntZ6fQ1Bdakh1X3YqkawEjBO4t7HxmmyY22fiBd3TjNhvx
 4jjyPHY3Y5PxZc4r4.apZrwSVJLd5DN1xt4UxXja5j3wiyc7YRTKAJL9cY2YOYnhntYFL0k1oDz7
 ohOhQcCZcK2i9xKkn5KeVRnCPjueTT_TZwCPFYZPWnMLwwVBFNoHKNQOKGD_OdkHWkureLXEjBO.
 VCHKKdwLSNMdG.abVQXcTcrysWADeGtPkdYgSMWYOkk1x2BSw_qYDM2P1mnU5JzptxqBzsB.UVwV
 AyZgyFjSkOI6DCqyDkgX.5KdVYjYpHcH4T8Y0GoiG7wIz3LTKKbttWFU_z1bzuRrHrm5pV8rrAjh
 w9N9jFgaR_lyErJ3DldF4foLETQwu72cgvWyTZI.hwxDDc4dNN0cOG1DwJDiGWD5FZ01vbg3eLsf
 sbB5rxbrBo4eUgGVjF6WQkD1H94frTZaec0wDpYi_l4gAd8qNXd44wJT_mef7vYsuz9y8EO_vigb
 kpHQRhobiutmf3Tdn.GiUAAORTsaxGDWYGtUvtNKJ4CfNFdPhcB9Sjoa32MItykPaALAi846vP5K
 ddeK9HTqdpK6sZIfLfNtAyLSf13ucZq93IY6_a1uSpP6LVa9srlsYfiXlGvFvN3lymDgaVA0IT83
 1Wfk-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 155f0c9a-b64c-43ca-a896-eb2d8cb3c710
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Tue, 24 Nov 2026 17:31:29 +0000
Received: by hermes--production-gq1-7c58b65db6-8bm7c (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6f1ea87918a90c67eb7a856f289040df;
          Tue, 24 Nov 2026 17:31:27 +0000 (UTC)
Message-ID: <a4a60453-205f-4378-b22d-06eb0d19c044@schaufler-ca.com>
Date: Tue, 24 Nov 2026 09:31:23 -0800
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>,
 "Hallgrimur H. Gunnarsson" <halg@google.com>,
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
 <4db941ba-3001-4019-8910-63e534b29f89@schaufler-ca.com>
 <CALCETrX7_HidtLAjAh=D0m2Fn=1ZkfMBiXUVXbjyu+xDY19u0A@mail.gmail.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CALCETrX7_HidtLAjAh=D0m2Fn=1ZkfMBiXUVXbjyu+xDY19u0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.27100 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 11/23/2026 4:54 PM, Andy Lutomirski wrote:
> On Mon, Nov 23, 2026 at 9:22 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 11/20/2026 9:09 AM, Andy Lutomirski wrote:
>>>> On Nov 19, 2026, at 2:52 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>> ﻿On Thu, Nov 19, 2026 at 2:43 AM Hallgrimur H. Gunnarsson
>>>> <halg@google.com> wrote:
>>>>> When a process creates a new user namespace, it receives a full set of
>>>>> capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
>>>>> in scope, several of these capabilities (such as CAP_NET_ADMIN and
>>>>> CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
>>>>> containers never need. However, there is currently no configurable way
>>>>> to withhold such capabilities from user namespaces while still granting
>>>>> them to workloads that require them.
>>>> One thought (from the rootns thread): the other decent sized attack
>>>> surface here is CAP_MOUNT_ADMIN.  Which doesn't exist as a capability
>>>> bit.
>>>>
>>>> A sort of horrible solution (but maybe not so awful) would be to
>>>> declare that the bits in cap_userns aren't actually capability bits,
>>>> and that you need the bit in cap_userns *and* the bit in cap_effective
>>>> to do sensitive things, and that mounting needs cap_userns to have
>>>> NSCAP_MOUNT_ADMIN *and* cap_effective to have CAP_SYS_ADMIN.
>>>>
>>>> I want to sleep on this.  It might actually solve several problems,
>>>> e.g. controlling creation of ipv4 and ipv6 loopback or tunnel devices
>>>> or whatever.
>>> I slept on it. Here’s a counterproposal.  I’m not saying I think this
>>> is better than this patch set, but I think it’s worth weighting the
>>> options.
>>>
>>> Define a whole new set of privilege bits.  As a
>>> poorly-painted-bikeshed option, I’ll call them eprivs (for exposure
>>> privileges - it’s a crappy name but at least it’s pronounceable).
>> I played with a mechanism I called "chits" (all the good terms for security
>> bits have been consumed for a very long time) that looks a lot like
>> what you're proposing. I did it to address the CAP_SYS_ADMIN problem,
>> where any use of the capability opens up a whole barrel of worms.
>> I cannot, unfortunately, find my patches. :( The basic approach is:
>>
>> A process has an optional set of chits. A process without a chit set is
>> unaffected by the mechanism. A process with a chit set is allowed only
>> those operations for which it has a chit. The existing but empty chit set
>> allows no operations. A process may drop a chit, but not the set, which,
>> again, can be empty.
>>
>> Because I was after CAP_SYS_ADMIN, I envisioned a call
>>         cap_able_chit(capability, chit-list)
>> but there's no reason there couldn't be a
>>         chit_able(chit-list)
>> as well.
> This is quite pronounceable, but I'm not sure I could submit a
> patchset with a chitlist with a straight face :)

Quoting Paul Moore, "naming is hard". There's an online medical staffing product
called e-priv, so you might want to avoid that, too.

> I feel like, in our brave new world, much of the work here is defining
> the interface and how it should work, and our little AI interns have
> gotten quite good at actually writing the code.  So my grand plan is
> to let people contemplate it until next week (i.e. after the
> Thanksgiving holiday) before actually producing any code here.
>
> I was imagining something like:
>
> prctl(PR_EPRIVS_AND, mask1, mask2, mask3, mask4);
>
> (i.e. define the things to be 64 * 4 bits max

I hate to say this, but 256 eprivs/chits/whatevers is not enough.
Data General had a UNIX system aimed at Orange Book B2 that had
(my recollection may not be exact) 360 capabilities. Once the
granularity gremlins get hold of a mechanism it can expand explosively.
A chitlist is a list of u32's. Painful to maintain, and inefficient in
the small set case, but capable of handling large sets of chits.

I'm thinking about a network driver with a separate chit/epriv for
each of it's magical operations. Why? because it's easier to shotgun
the privilege breakup than to think about how to group them.
I strongly object to CAP_REVERSE_TAPE_DIRECTION. I think
EPRIV_REVERSE_TAPE_DIRECTION, which can be one of thousands of chits
with simpler semantics, is a better choice.

>  until we add a new
> prctl, which will hopefully be along time.)  And to maybe make mask4
> be specifically arch-dependent bits, because I think EPRIV_X86_LDT
> would be an excellent addition.  (I say this with some chagrin because
> I fixed some gnarly vulns quite a while ago in modify_ldt, and I
> missed smp_mb(), and someone rooted it.)
>
>> I wrote this as an LSM, but the system-wide aspect of it made that
>> a questionable choice.
> I'm thinking not an LSM.  The goal would be to make it available everywhere.

LSM is my favorite hammer, but the intrusive nature of sprinkling uses
throughout the system makes that problematic.

> (If you missed the other thread, I'm also imagining adding
> CLONE_NO_NNP, only allowed with CLONE_NEWUSER, which would *clear*
> no_new_privs.  LSM would have a chance to veto this, but the default
> behavior would be to allow it.  This would allow running an entire
> system with no_new_privs set for all normal tasks including PID1 while
> still running conventional distros in containers.)
>
>> If you have any interest, I could dig more deeply to try to find the
>> patches. Otherwise, I'm happy to look at what you come up with.
>>
>>> An epriv is not permission to do something *to* an object; it’s
>>> permission to do something that exposes a meaningful attack surface
>>> within the kernel. So there’s no ns_has_epriv because there is no
>>> object.  These are kind of the opposite of object capabilities.
>>> Additionally, an epriv never grants the ability to do something that
>>> one couldn’t do in an epriv-less world.
>>>
>>> For now, all tasks have all eprivs, even not-yet-defined ones, unless
>>> user code or config explicitly changes this.  (Maybe some day secure
>>> boot might remove certain eprivs.)
>>>
>>> There should never be a check like ns_capable || has_epriv. It’s also
>>> &&, or perhaps caps are not checked at all.
>>>
>>> Example eprivs include:

I see the fundamental difference between capabilities and chits/eprivs as
being that capabilities relate to system security *policy* and chits/eprivs
relate to system security *concerns*. The problem with CAP_SYS_ADMIN is that
it encompasses everything that needs privilege but can't be explained in the
system security policy. Reversing the read direction on a disc isn't something
you want just anyone to do, but there's no system policy that says why.

I will pause for a moment and acknowledge that you can do most of what you
want chits/eprivs to do with SELinux policy. Completing that would require
adding lots of LSM hooks, which would most likely result in an effort similar
to adding epriv/chit calls.

>>>
>>> EPRIV_FSOPEN_VIRT: may fsconfig, fsopen, etc a virtual fs like fuse or
>>> tmpfs or overlayfs.
>>>
>>> EPRIV_CLONE_TREE: may clone a mount tree
>>>
>>> EPRIV_MOVE_MOUNT: may move mounts around (but only if you also have
>>> CAP_SYS_ADMIN on the correct namespace, of course)
>>>
>>> EPRIV_FIREWALL_TC: may configure any firewalling configuration or tc
>>> configuration (this includes iptables, nftables, and ebtables)
>>>
>>> EPRIV_NET_RAW: may use raw/packet sockets (like CAP_NET_RAW)
>>>
>>> EPRIV_TUNTAP: may create and attach to tun/tap interfaces
>>>
>>> EPRIV_IP_LOOPBACK: may set up IPv4 and IPv6 loopback using whatever
>>> new facility we add
>>>
>>> EPRIV_NETLINK: may use netlink at all
>>>
>>> EPRIV_NET_ADMIN: may use traditional CAP_NET_ADMIN abilities (all
>>> CAP_NET_ADMIN checks will also check EPRIV_NET_ADMIN)
>>>
>>> EPRIV_OPEN_FILE_HANDLE: May use open_by_handle_at, etc.
>>>
>>> EPRIV_UNSHARE_USERNS: may unshare userns
>>>
>>> EPRIV_UNSHARE_NONUSERNS: may unshare any other namespace
>>>
>>> EPRIV_MOUNT_CGROUPv1, EPRIV_MOUNT_CGROUPv2: may create a new mount of
>>> these subsystems
>>>
>>> EPRIV_PTRACE: there are lots of different variations that might make sense.
>>>
>>> EPRIV_MOUNT_PROC_PIDONLY: may mount proc-pidonly
>>>
>>> EPRIV_MOUNT_PROC_NOTPIDONLY: may mount proc not-pidonly
>>>
>>> EPRIV_MOUNT_SYSFS: may mount sysfs
>>>
>>> Example eprivs that are questionable:
>>>
>>> EPRIV_DMESG: the kernel log is a specific object, and I think it's
>>> better to control access using something kernel-log-specific.
>>>
>>>
>>>
>>> There is no operation that increases eprivs -- even without
>>> no_new_privs set, a task will never gain an epriv, nor will a child
>>> ever have an epriv that its creator did not have at the time the child
>>> was created.
>>>
>>> The evolution rules could be as simple as, on fork/clone, the child
>>> inheriting exactly the parent's eprivs.
>>>
>>> Or we could bind eprivs to a userns instead of a task, but that could
>>> be more limiting and awkward than we want.
>>>
>>>
>>> What do you all think?
>>>
>>>
>>> FWIW, I had an LLM make an inventory (surely not exhaustive) of
>>> recent-ish CVEs and how they relate to this list.  (The below is the
>>> only part of this email that is LLM-generated, although I added
>>> EPRIV_SYSFS because I didn't realize that nonroot userns could mount
>>> it until I asked an LLM, sigh.)  To me, the list and its breakdown
>>> suggests that there is quite a lot of room for meaningful attack
>>> surface reductions while still leaving large parts of userns
>>> available, and that my epriv proposal captures much of this but the
>>> cap_userns proposal may be too coarse-grained.
>>>
>>> (I also asked about eBPF, and my LLM came up with a lot of CVEs, but
>>> there's an existing BPF token mechanism and I therefore did not
>>> propose EPRIV_LOAD_EBPF.)
>>>
>>> --- begin LLM output ---
>>>
>>> **EPRIV_FSOPEN_VIRT:** CVE-2022-0185*, CVE-2023-0386*, CVE-2023-2640*,
>>> CVE-2023-32629*, CVE-2025-38499*
>>>
>>> **EPRIV_CLONE_TREE:** CVE-2025-38499* (only if the check also covers
>>> the relevant internal mount-cloning path; explicit `open_tree()`
>>> restrictions alone are insufficient)
>>>
>>> **EPRIV_MOVE_MOUNT:** CVE-2025-37988
>>>
>>> **EPRIV_FIREWALL_TC:** CVE-2022-25636, CVE-2022-1015, CVE-2022-1016,
>>> CVE-2022-32250, CVE-2022-34918, CVE-2022-48911*, CVE-2022-2588,
>>> CVE-2023-32233, CVE-2023-35001, CVE-2023-4004, CVE-2023-4015,
>>> CVE-2023-4244, CVE-2023-5197, CVE-2023-6817, CVE-2023-3609,
>>> CVE-2023-4623, CVE-2023-4921, CVE-2024-1086, CVE-2024-0607,
>>> CVE-2024-27397, CVE-2024-26925, CVE-2025-38001, CVE-2026-23111
>>>
>>> **EPRIV_NET_RAW:** None identified.
>>>
>>> **EPRIV_TUNTAP:** None identified as requiring TUN/TAP. Some
>>> packet-triggered exploits may optionally use it, but that does not
>>> establish it as a necessary blocker.
>>>
>>> **EPRIV_IP_LOOPBACK:** None identified.
>>>
>>> **EPRIV_NETLINK:** Also those blocked by `EPRIV_FIREWALL_TC`, insofar
>>> as the documented attack paths use netlink. No additional CVEs
>>> identified.
>>>
>>> **EPRIV_NET_ADMIN:** Also those blocked by `EPRIV_FIREWALL_TC`,
>>> insofar as the vulnerable operations require `CAP_NET_ADMIN`. No
>>> additional CVEs identified.
>>>
>>> **EPRIV_OPEN_FILE_HANDLE:** CVE-2025-38306*
>>>
>>> **EPRIV_UNSHARE_USERNS:** Also those blocked by `EPRIV_FSOPEN_VIRT`,
>>> `EPRIV_MOVE_MOUNT`, `EPRIV_FIREWALL_TC`, `EPRIV_OPEN_FILE_HANDLE`,
>>> `EPRIV_MOUNT_CGROUPv1`, and `EPRIV_MOUNT_SYSFS`, plus CVE-2025-38058*.
>>> More generally, blocks the documented unprivileged user-namespace
>>> setup for the entire inventory when no usable user namespace already
>>> exists.
>>>
>>> **EPRIV_UNSHARE_NONUSERNS:** Also the namespace-dependent attack paths
>>> blocked by `EPRIV_FIREWALL_TC`, `EPRIV_MOVE_MOUNT`,
>>> `EPRIV_MOUNT_CGROUPv1`, `EPRIV_MOUNT_SYSFS`, and many of those blocked
>>> by `EPRIV_FSOPEN_VIRT`. Coverage depends on whether the necessary
>>> non-user namespaces already exist.
>>>
>>> **EPRIV_MOUNT_CGROUPv1:** CVE-2022-0492*
>>>
>>> **EPRIV_MOUNT_CGROUPv2:** None identified.
>>>
>>> **EPRIV_PTRACE:** None identified.
>>>
>>> **EPRIV_LOAD_EBPF:** None identified.
>>>
>>> **EPRIV_MOUNT_PROC_PIDONLY:** None identified.
>>>
>>> **EPRIV_MOUNT_PROC_NOTPIDONLY:** None identified.
>>>
>>> **EPRIV_MOUNT_SYSFS:** CVE-2025-22089*
>>>
>>> CVEs not cleanly blocked by an operation-specific bit
>>> Excluding the two EPRIV_UNSHARE_* gates:
>>>
>>> - CVE-2025-38058: No explicit unmount privilege. The vulnerable race
>>> involves umount(2) and path lookup.
>>>
>>> - CVE-2022-0492: The cgroup-v1 mount bit covers the documented
>>> new-mount attack path, but not necessarily configuration of
>>> release_agent on an existing writable hierarchy.
>>>
>>> - CVE-2025-38499: The correct gate depends on which filesystem-context
>>> or internal cloning operation reaches clone_private_mnt(). I would not
>>> count EPRIV_CLONE_TREE as a definitive blocker without checking the
>>> exact call paths.
>
>
