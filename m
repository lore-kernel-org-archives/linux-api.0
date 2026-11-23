Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795474335;
	b=p2dOgdOEvqAFBropP4AeBJ0NhAkGbZTepfdUQjoJ46y7mYtle2nUakScrxCe/L0UAgOD
	 LnHcZIRhKRIJer7tuyhFD+ib9kpS3uyeNw/7NSlEA7f7q2ufJIcckEVLobrtDo6hQKlML
	 DTc+o0J5f5Lkz4jyPHN3yve9fNIiCiO9zpiSGU7rOD/v1scxrbvWEBVQFQr9ie6nqTxsn
	 0pVQ3pIFQXlQXyW/m3GT41DacSS1Okrbij1mfTliDKOUHalq3WueDH0AJV+JfSBs05oK/
	 CuE8+WtQRznlzI4QqzS29KAteCdM9bAtv1KjZkSLkzkjc+VV0hBreH321fd9NaXF1SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474335;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=UmTaUK4reXUwzVb93oXwVlnxEqXXaEADfB6OR4M7V58=;
	b=PtZKRDbcPc4I40dXzGStm9Rnqq38AAFNCmg2wZcteG2WwAAFpJePee9hgMvHwpjncaZ/
	 dGim1WIUBnvVKVBwJ4HSDUewzSKRNx+Lg9yGQzFXPn3BXt/X/TpGKJROCpKl2Tgx7QjqD
	 mmXY5epxIIlTt3pXOXcCS8o8mQ2v5Y3gXxkfxoIN8mc8nSmjp80vZ+fjCAjCsJEeFNyC7
	 wtrEUsfOsXFPpIIbn0bhtfKPMdz5YGBqzkpnc7UNScP/6Eyav4AHxuvOJYbGo4xPj2Ubk
	 4ciUfMmKYfNGR2GcycD01FWaITtd5U+Tj9i1AWI7JyiFOT8YX3xYEOFokHOpx59UVcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+3vFAhu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7E103606A31E;
	Mon, 23 Nov 2026 22:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+3vFAhu
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BEF0E1F000E6;
	Mon, 23 Nov 2026 22:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795474335;
	bh=UmTaUK4reXUwzVb93oXwVlnxEqXXaEADfB6OR4M7V58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f+3vFAhuzOymo1wUHu3CjVrRJ8d97kRmIwZcfNT6OA1diC3POPAbn26MrKqHAAO/U
	 3xfHUsCYISsflIvXy0pEIgZu0CepKwoQEUQVJsYermjHB+B0whND6XDCMtNxqnzu7N
	 sY2HNaGEj/JzD/9EaHsanI9E67O1NNEIMNnf6LH1Xufe7WcGYo/o0EHsYi6L2UIQD0
	 vBjtguOuXzWh15X8b1DP6ZcPTjzLdhidOalEs0xyw3pHnpxXHvR3rC0qZQIGf3D0gf
	 3Q4ZZSYKrRrKxiwz1ZEjfOqsDJfnX+9GD38vsVl3n3TLdDgt0e803rhdLbrwHhN8LL
	 ZAdXHhNHrAMbw==
Date: Tue, 24 Nov 2026 00:52:11 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Serge Hallyn <sergeh@kernel.org>, Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	David Howells <dhowells@redhat.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Singh KP <kpsingh@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	containers@lists.linux.dev, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for
 user namespacesg
Message-ID: <awTDm_EpFNwH9uEy@kernel.org>
References: <20261119104208.782900-1-halg@google.com>
 <20261119104208.782900-2-halg@google.com>
 <CALCETrVqc+1bjH1bhqHee9bsUdk2B6314z7PMexbsnNpMhk14g@mail.gmail.com>
 <CALCETrV=zSxb6sgA08DLiK2bQovdMEj9ycG=Cc71mLn2C5Pgeg@mail.gmail.com>
 <4db941ba-3001-4019-8910-63e534b29f89@schaufler-ca.com>
 <awSVO9Zc-233M7_P@kernel.org>
 <6a0539de-1a66-4dfd-a21d-aee48ab18f3f@schaufler-ca.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a0539de-1a66-4dfd-a21d-aee48ab18f3f@schaufler-ca.com>

On Mon, Nov 23, 2026 at 01:58:41PM -0800, Casey Schaufler wrote:
> On 11/23/2026 11:35 AM, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 09:22:29AM -0800, Casey Schaufler wrote:
> >> On 11/20/2026 9:09 AM, Andy Lutomirski wrote:
> >>>> On Nov 19, 2026, at 2:52 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >>>> ﻿On Thu, Nov 19, 2026 at 2:43 AM Hallgrimur H. Gunnarsson
> >>>> <halg@google.com> wrote:
> >>>>> When a process creates a new user namespace, it receives a full set of
> >>>>> capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
> >>>>> in scope, several of these capabilities (such as CAP_NET_ADMIN and
> >>>>> CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
> >>>>> containers never need. However, there is currently no configurable way
> >>>>> to withhold such capabilities from user namespaces while still granting
> >>>>> them to workloads that require them.
> >>>> One thought (from the rootns thread): the other decent sized attack
> >>>> surface here is CAP_MOUNT_ADMIN.  Which doesn't exist as a capability
> >>>> bit.
> >>>>
> >>>> A sort of horrible solution (but maybe not so awful) would be to
> >>>> declare that the bits in cap_userns aren't actually capability bits,
> >>>> and that you need the bit in cap_userns *and* the bit in cap_effective
> >>>> to do sensitive things, and that mounting needs cap_userns to have
> >>>> NSCAP_MOUNT_ADMIN *and* cap_effective to have CAP_SYS_ADMIN.
> >>>>
> >>>> I want to sleep on this.  It might actually solve several problems,
> >>>> e.g. controlling creation of ipv4 and ipv6 loopback or tunnel devices
> >>>> or whatever.
> >>> I slept on it. Here’s a counterproposal.  I’m not saying I think this
> >>> is better than this patch set, but I think it’s worth weighting the
> >>> options.
> >>>
> >>> Define a whole new set of privilege bits.  As a
> >>> poorly-painted-bikeshed option, I’ll call them eprivs (for exposure
> >>> privileges - it’s a crappy name but at least it’s pronounceable).
> >> I played with a mechanism I called "chits" (all the good terms for security
> >> bits have been consumed for a very long time) that looks a lot like
> >> what you're proposing. I did it to address the CAP_SYS_ADMIN problem,
> >> where any use of the capability opens up a whole barrel of worms.
> >> I cannot, unfortunately, find my patches. :( The basic approach is:
> >>
> >> A process has an optional set of chits. A process without a chit set is
> >> unaffected by the mechanism. A process with a chit set is allowed only
> >> those operations for which it has a chit. The existing but empty chit set
> >> allows no operations. A process may drop a chit, but not the set, which,
> >> again, can be empty.
> >>
> >> Because I was after CAP_SYS_ADMIN, I envisioned a call
> >> 	cap_able_chit(capability, chit-list)
> >> but there's no reason there couldn't be a
> >> 	chit_able(chit-list)
> >> as well.
> >>
> >> I wrote this as an LSM, but the system-wide aspect of it made that
> >> a questionable choice.
> >>
> >> If you have any interest, I could dig more deeply to try to find the
> >> patches. Otherwise, I'm happy to look at what you come up with.
> > What if eprivs or chits would take each capability and subvidide
> > them into pieces? CAP_MAC_ADMIN would be formally a set of chits
> > (or eprivs).
> >
> > And process having e.g., CAP_MAC_ADMIN, would actually have the
> > set of chits that are included to CAP_MAC_ADMIN.
> 
> That would require that chits have the same inheritance rules as
> capabilities, and I think that's a really bad idea. I was an active
> member of the P1003.1e/2c committee that defined capabilities, and
> was a major advocate of their inclusion in Linux. I wish that I
> could say they've been successful, but root still rules the roost.
> I attribute that to the complexity that arose from trying to address
> privilege via setuid and privilege bracketing at the same time.
> Chits (or eprivs) as a finer granularity version of capabilities
> would make granular privilege even harder to sell than it is now.

Perhaps (or likely'ish). I'm just unpurging what I meant (even if it
ought to be wrong):

1. You can create F(C) -> S where C is set of caps and S is a set
   of chits.
2. G(S) -> C, which finds using some heuristics a set C for which
   F(C) = S. 

> 
> > Without that type of relation there's just a space full of chit
> > ;-)
> 
> Which is one of the reasons I haven't published anything about them.
> Even with the scheme being (a lot) simpler than capabilities I don't
> see it as something I have the resources to complete. If Andy wants to
> drive the process I'm willing to contribute where I can.

You should e.g., RFC patch. We're exactly in the situation where
the skill of not knowing what you're doing is the skill that 
should be applied with pride ;-)

Br, Jarkko


