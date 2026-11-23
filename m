Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=66.163.189.90
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795471129;
	b=Fqo7Yx5SILpBSPab3dy9Oq1+t7UR/0KdmjVe6mu2OpJjd6xQRMAFzwVRpmaNKVZvxCW1
	 piMb09tzFBlJUrWh6FfLyME5i8RVSbhCHTffcWmcqclJY3YhPniVQMN+dbqrDB4wQ+G/T
	 ohkakJwM7gfggxb7FWGyeuMcTr7XvpKOnfcMxwmxxaxG10xEs7+BLAvi+nBLCdmCDOCQI
	 YULmv+s+RUfLTwFPiQWmkBNQVAEkmODLfLwH1zC7xfcO82cYYwmr4jlHllZ4jp8P7nwcr
	 6qSBCW/E31xbAMrhuUOsjzOw3tD2iwMcMihQ7ImcDz0dWP11qn1IYKu/7YDU1EgizYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795471129;
	h=DMARC-Filter:DKIM-Signature:X-SONIC-DKIM-SIGN:X-YMail-OSG:X-Sonic-MF:
	 X-Sonic-ID:Received:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=5mfQoHHU7yW7lgBOVTdWKSOxY0Ql9ccpfJGLZOeJlhE=;
	b=yhL+3QEIrjcy7KEzpTmU7D8ht8zQGP7fitfVvTKCOteiz3v4Rj2NUdjmbFYL+mms2DWh
	 mrrRCoEwzD5KYEbe7fj19bJWGvBmayPggn+U11oD4gQWsIbSHbOALVFa3ZNTWpafhwFGT
	 rcJGb2qIe0cZJPuSDZs0tj7OfkS0Xmx0JpRCc9HYPQj7quUO3SfWYhNA9bFlp3ppNwqal
	 uJikw4ZEVJINl1HhaIdmm/Vad99in6IwOXe49gaI1ntR4dkEPYC5xKvNBTLaCWzFKFe//
	 hQNhR2jHccI/RRNSLlSWMJycpWJgV1cCHe1iW7Iwgt4irAy6Ac1cEYH5vbnQs7ps/tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=schaufler-ca.com;
	spf=pass smtp.mailfrom=schaufler-ca.com;
	dkim=pass header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=Ng2q5Yqq;
	arc=none smtp.remote-ip=66.163.189.90
Received: from sonic306-28.consmr.mail.ne1.yahoo.com (sonic306-28.consmr.mail.ne1.yahoo.com [66.163.189.90])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72568606A31E
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 21:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72568606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=Ng2q5Yqq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795471127; bh=5mfQoHHU7yW7lgBOVTdWKSOxY0Ql9ccpfJGLZOeJlhE=; h=Date:Subject:To:Cc:References:From:In-Reply-To:Content-Type:From:Subject:Reply-To:Content-Type; b=Ng2q5YqqKGhQ6E0aQKYxjuWtB4iRVLcStAcTY65eXhmF30rtBZnRS7HW4aIg36nPIKJ9aQNDI7XbQF4wHlLraHeGkLbu29qGjt6KcZTnQad1KIUkEviq2jvCsgTEvXt2wrts2QayZVqml+MKqvh27qQMXh4cq6Q/YQZyh5otWbVRYEwrZJmpr1+vxmrLRe4aHIUDTNj+3RPg/5LTpqkNDGFuUlZ/wfb0rFN4+FCwpXR5jAp5ElRg2xAFMlCsEzkK8nnro511H1evWghfGDGhU6rhN7sJ/6VSRLcphu3G/QAEqeMujZPzTNjdHKaK92GXAlfPxYWUD0Rr7G7hA6prrA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1795471127; bh=1+ng/PAptC0XGDpgvm3vrJAPMNqjQ1tOnkBT6GCtDB7=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=gtneVtj4JVXOoHaFag40cKJF55Zy3wG7nyJLWqEgoK5bUA3J1g140RaYss8v7GZvblWEB978/bU1ph9le0TZbq6XHe/cU2061U848ZZuoTXtpFBc1EkZbgxQOZzx4X03rrnM9Uw2TvUcDOXBf2do4HERtiavPzniZLyRwRIfY2x9pK55mTLRp3V1YiiiStQrAUyxxgMbSSFTB07sFwhAb6OR8uncaatpXXqQiXCxjhq0ilzhYhHCWZHLkEyBL4NJ62+4+K6OuRFrVBA0V/FRZ4+ofPJquaw5Raay1V6z+ma/kosS+qCq7MP68kjwoDi3NgxM2BwVCl85E+uNh2H8mg==
X-YMail-OSG: n6Q_G00VM1mndtEdQbMfoyB9msomQJYaJNIMXX1J8oDZaAutjg7JG4VVlkU70fz
 XcWPkPK_Osl3IJj4ifZlcaWX1gjEqffg.Sttmda0GmRYhUC4TbwDuWnCs8nVNxeh1JRbvpK4nS2e
 ylFJ0Q8B5b1Z9YhTBBILRs9YJWsLkhiGybG9fqY882CgqcondACd35ZvADk5Wc_x2e_X.KeiyCSG
 6dG43yRlq4pdNKLtbSnKRBY3t_VXHPA_Z3lKRJqpOuSMcVwm1gKLPeZAHBbIPhZTWzar0_A7DFdL
 8Yz3EytY3KWm1vD1klkCgwKDU0XIomRly4Dh9Zh.etjBDGKlehC0.hHJmSDAH5EANPGzhSK4bTz7
 2xj8ucr2iW0Ei6t3nAbw6bxiYPEJ4b9UfxhybCw0xRAszI11kYds4tcZ2bpeU4kOPsxS8sH9T4Uq
 VIGPBFCaEWLA0bA4AVZ7ixGetsECpAPUUL6jRaCED1tI1_Q1hfHSFoAdJ7VgmVESBG.kpU8rC1VJ
 zOOWqs5WNivJZ7O9OBzratP2uo925k.BSXLQTLS1RFmABMgemOkF4UlEkb_6xBqP041FJ1HITgQ5
 YKVm9AQGl6d6O2dVCkF6433EhHgV2nPMRWlgsPeEw.1YkutoTgdVeKex7GjXWms35.dz7HWHEBZp
 hWPoXoRwKGCttn7MKc_Av715lxrswP9UKArFLnwz0fCRamK3TT0y.leHeojH60GskbhfBaKLczmv
 c_x7QCl8WI2VqyI4Eal2jfxQo70Q.nEUVdjPdUolAFr7LJTng09TmIFVRSeAKJqlEpnjZvDZY2sD
 sPdZmZkAwhzz0ftOw1HGxjM7MOF56eI8D3TG6hKG9bogfYgSgiGxI9A2k0y0e8f6Za5rvDo3croh
 eTFh81XjzX9P8jM2vWRr0xWRweO.WjKXEeoHPDt1.j1dMDXx0Pc0gjrl61SDHV2TQ5PCFV7Mh0bp
 kVJbIqIDijGsn5JontjC5u8VEL.1O7J44UFqt3jtxo45njCyTQYB8LV2ytLC.n42QPalrlWHEgZC
 FiUq9NohawAfWbNHHM5mwA225zLYqEGXXmdU55KeTkDbgoO0NPpByVZ6tJtwswjBcfHGSaH_uGpb
 HOrGY5KBs6ws.HkMSExG.vtts.0buJ7XmxTQY99tIMTLx4YtCy5LjXYxSXvIQ8hDhOvuFKFPQRAd
 S1iMX._T_zbfuLzJF6xgKY8537ObtvsbQefcHVXUcMbf6autZ0TBzGC7GUOz4_4tCmNZpeGMwr4Q
 hVGwuEOIo3VUDysDOoqFMNVNFAEEd.MNinO0o_wcWZeAgmgZPP5CeheLuLlbSGIf4abrIslWldyg
 7l3Wsvdp2OWbiXpIY5r.SmHnJ.EmbwhIqYHxwzGgW620beW3WV7kYIKm.h92xb8tk1_QLdCIOvIc
 cpaI5kV_XeC2OA1uT8FE0X1s2mKtynPur6We0z9vGY.UfP35EYIK9.OQXfitlpq_D_7CbVyc4XEs
 pfwPB1t2oY5NO6tomkIaxI3pKNlWsqCiDXnXs5otyZjfRRPDpWDFWyz40AlpLzu8IOyocZGrgy1U
 hl4kcE4I2mWlh7NYvskBtAeF_jQ8EZ2AlRT7SzvyZ7vbz8ti1mhNv6mx0OJJU6sGJuMWB1Z0QxkZ
 VgBuy_V.tvlAv60qSPHUn4sTuroTVt3P9gpamovLXbqlJhDTIMyoXJU_8Mfa1AvDkYVFDeo.KIHX
 L_3_sNzN9ybe51VuQkiHGA78vTy7H1Z3y3XHjMlcWaUsuf.sUrNxvcXGHhCGLiNFKkDmjCJuKG3a
 urMZrCI3Skxkdv2IcWBFEf.ReSsQumtGhefs3znurkPC00hd5_tycwXRTBRqCVX7bwJK4r754qFl
 AskTNC4WoT5DLcanPr8L0ir5l8ya_6JxcnnjA50h3bCD42HFI_w5XWGkX6BTZU.YhSZ3jS7xCiC0
 _693oLmM7hKnm24W.34HgFdG1tte8rN.OL3WXLaoIWbvvGzEUB2RFk6XdAHEjw1q6DwCAbCJQ885
 JEaNmS0LT2hNs.2bznE46o8RvqgvAcYuhSiFcNk3gMF84yvgJV1aggcYwMSAZNqndX1G4ufT_cbC
 fQbceHHPmUncK9omw.p5FYz8H_bWK9Lbov9AU2CZXGI14Zsar5m4AHLUySfrXhNX4OV4YnlUw4zK
 Y743hNvVXEO2auTaHrTwXUgBq9katjee04U0D5z5Ez21vc_LDSstvheoucaqOMuttXSWUvjC_P6W
 dvRANTPjTR_Ru4t3qUO9mUXwNZJ72Hr9MG9wZXRwKqeJade.H3mRpX8g.zM3FSZC7krqM3DfSd.r
 7ew--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: a08fa82a-0c30-4e08-8166-acf25c44b381
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Mon, 23 Nov 2026 21:58:47 +0000
Received: by hermes--production-gq1-7c58b65db6-rd56z (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID f0e77ddbdbd531f59d72e05fb2f71575;
          Mon, 23 Nov 2026 21:58:44 +0000 (UTC)
Message-ID: <6a0539de-1a66-4dfd-a21d-aee48ab18f3f@schaufler-ca.com>
Date: Mon, 23 Nov 2026 13:58:41 -0800
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
 namespacesg
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
 "Hallgrimur H. Gunnarsson" <halg@google.com>,
 Christian Brauner <brauner@kernel.org>, Serge Hallyn <sergeh@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 David Howells <dhowells@redhat.com>, Kees Cook <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
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
 <awSVO9Zc-233M7_P@kernel.org>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <awSVO9Zc-233M7_P@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.27100 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 11/23/2026 11:35 AM, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 09:22:29AM -0800, Casey Schaufler wrote:
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
>> 	cap_able_chit(capability, chit-list)
>> but there's no reason there couldn't be a
>> 	chit_able(chit-list)
>> as well.
>>
>> I wrote this as an LSM, but the system-wide aspect of it made that
>> a questionable choice.
>>
>> If you have any interest, I could dig more deeply to try to find the
>> patches. Otherwise, I'm happy to look at what you come up with.
> What if eprivs or chits would take each capability and subvidide
> them into pieces? CAP_MAC_ADMIN would be formally a set of chits
> (or eprivs).
>
> And process having e.g., CAP_MAC_ADMIN, would actually have the
> set of chits that are included to CAP_MAC_ADMIN.

That would require that chits have the same inheritance rules as
capabilities, and I think that's a really bad idea. I was an active
member of the P1003.1e/2c committee that defined capabilities, and
was a major advocate of their inclusion in Linux. I wish that I
could say they've been successful, but root still rules the roost.
I attribute that to the complexity that arose from trying to address
privilege via setuid and privilege bracketing at the same time.
Chits (or eprivs) as a finer granularity version of capabilities
would make granular privilege even harder to sell than it is now.

> Without that type of relation there's just a space full of chit
> ;-)

Which is one of the reasons I haven't published anything about them.
Even with the scheme being (a lot) simpler than capabilities I don't
see it as something I have the resources to complete. If Andy wants to
drive the process I'm willing to contribute where I can.

>
> Br, Jarkko
