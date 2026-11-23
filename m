Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795474470;
	b=XZwjmNhQF49xJWz5dtI37xPi6xpOThE0Ltde+5Mi0uBqZo7nnEK7kKGaWoTC5K7LtvNi
	 lmntZzbhTsKfuvyKikn75K9fHPYLIEYBgcXhPimKQwoLz1i3R2VW1ZQVIJWd3H7b9/TTf
	 0H9vQto474f2vclYnOaOmOB6xYtx5oJPYjqY1PcIvWsxf0kPXsg7TLbYKG271kXoxxO2y
	 5DAFEdEZCk8jRsuwKER8mdXKS3gnHMQoRMW7V5OW1PnF8z7pFZi6VM/glqvU8VKGE0CRY
	 m2Jn5YTzfhZSSdJZqU8JwNN8CRJH/bKboDTKWiljpbpbt7oLH4Y/K9YhQt2ke4ZZo5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474470;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=uxm7cLwrZsIM4FY8CLhKRgjetTXm1POR2deWfop5jak=;
	b=zDhp9BB9rYretkxnvoo+FRA1eneWRfKrhaizzFkPcFkD3g5mq6s2fm4YFv3A7tocg1xN
	 WUnalVO0ufZ1vxYWijpMuTqdRP7qbGbF3QZMbq+Sj/nXlFKL1Na8IGMsA4czsxWLVJega
	 2bgZ9yjZ5xqoiKFYekPAQAMCItNKY+g9/6VIAEmhVZos7WlYjrKmBMopH2q12b2xjnS/K
	 z/d9kw5+1YlCGYys3QpfTWZ5iC6QI5sjnta7L5P25KRKajRgBJsx9Nd1gciEHmddkTk/W
	 Lts8bgjIq2y9HfKL2PXdEeuSkJp0XRnAo3uqpV0jOlvXMEiIRcraWvRIWBqfXKr4mSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1LdxNlp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 931C0606A321;
	Mon, 23 Nov 2026 22:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1LdxNlp
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A2A331F000E0;
	Mon, 23 Nov 2026 22:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795474470;
	bh=uxm7cLwrZsIM4FY8CLhKRgjetTXm1POR2deWfop5jak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i1LdxNlp/1zyBaviNuUf/h4QPiP4GfqVT5G2k+cWvyL7/22tImxQR6Z2/bQIXxh64
	 Io6U8QMXfs81Zdk5ZwyX8et/r6I7bs59qT+Gw3gbWbT9S/+wWJiCGrFzyH1smhIlr5
	 Ywcm3Hqr0VUr+Qar8O+jVtHMrdE7lSanS5T/pI46OzAXZUSIh3Y7l8AVp0zKyepT4M
	 yScBuk23/btShriRh1vunn17kUM7At5ojanxd7lCacX6IZwKunMV5M5hrQmpLAQ7FO
	 Bl3yFVwWC62Yk/r/gR7Mptgth8KTuhNaq8dhZDOPUtQeZY5mKPqsBqxKTwagNy433V
	 g6ej6r3HtxkzA==
Date: Tue, 24 Nov 2026 00:54:26 +0200
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
Message-ID: <awTEIj-S7ODioVv0@kernel.org>
References: <20261119104208.782900-1-halg@google.com>
 <20261119104208.782900-2-halg@google.com>
 <CALCETrVqc+1bjH1bhqHee9bsUdk2B6314z7PMexbsnNpMhk14g@mail.gmail.com>
 <CALCETrV=zSxb6sgA08DLiK2bQovdMEj9ycG=Cc71mLn2C5Pgeg@mail.gmail.com>
 <4db941ba-3001-4019-8910-63e534b29f89@schaufler-ca.com>
 <awSVO9Zc-233M7_P@kernel.org>
 <6a0539de-1a66-4dfd-a21d-aee48ab18f3f@schaufler-ca.com>
 <awTDm_EpFNwH9uEy@kernel.org>
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
In-Reply-To: <awTDm_EpFNwH9uEy@kernel.org>

On Tue, Nov 24, 2026 at 12:52:15AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 01:58:41PM -0800, Casey Schaufler wrote:
> > On 11/23/2026 11:35 AM, Jarkko Sakkinen wrote:
> > > On Mon, Nov 23, 2026 at 09:22:29AM -0800, Casey Schaufler wrote:
> > >> On 11/20/2026 9:09 AM, Andy Lutomirski wrote:
> > >>>> On Nov 19, 2026, at 2:52 PM, Andy Lutomirski <luto@kernel.org> wrote:
> > >>>> ﻿On Thu, Nov 19, 2026 at 2:43 AM Hallgrimur H. Gunnarsson
> > >>>> <halg@google.com> wrote:
> > >>>>> When a process creates a new user namespace, it receives a full set of
> > >>>>> capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
> > >>>>> in scope, several of these capabilities (such as CAP_NET_ADMIN and
> > >>>>> CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
> > >>>>> containers never need. However, there is currently no configurable way
> > >>>>> to withhold such capabilities from user namespaces while still granting
> > >>>>> them to workloads that require them.
> > >>>> One thought (from the rootns thread): the other decent sized attack
> > >>>> surface here is CAP_MOUNT_ADMIN.  Which doesn't exist as a capability
> > >>>> bit.
> > >>>>
> > >>>> A sort of horrible solution (but maybe not so awful) would be to
> > >>>> declare that the bits in cap_userns aren't actually capability bits,
> > >>>> and that you need the bit in cap_userns *and* the bit in cap_effective
> > >>>> to do sensitive things, and that mounting needs cap_userns to have
> > >>>> NSCAP_MOUNT_ADMIN *and* cap_effective to have CAP_SYS_ADMIN.
> > >>>>
> > >>>> I want to sleep on this.  It might actually solve several problems,
> > >>>> e.g. controlling creation of ipv4 and ipv6 loopback or tunnel devices
> > >>>> or whatever.
> > >>> I slept on it. Here’s a counterproposal.  I’m not saying I think this
> > >>> is better than this patch set, but I think it’s worth weighting the
> > >>> options.
> > >>>
> > >>> Define a whole new set of privilege bits.  As a
> > >>> poorly-painted-bikeshed option, I’ll call them eprivs (for exposure
> > >>> privileges - it’s a crappy name but at least it’s pronounceable).
> > >> I played with a mechanism I called "chits" (all the good terms for security
> > >> bits have been consumed for a very long time) that looks a lot like
> > >> what you're proposing. I did it to address the CAP_SYS_ADMIN problem,
> > >> where any use of the capability opens up a whole barrel of worms.
> > >> I cannot, unfortunately, find my patches. :( The basic approach is:
> > >>
> > >> A process has an optional set of chits. A process without a chit set is
> > >> unaffected by the mechanism. A process with a chit set is allowed only
> > >> those operations for which it has a chit. The existing but empty chit set
> > >> allows no operations. A process may drop a chit, but not the set, which,
> > >> again, can be empty.
> > >>
> > >> Because I was after CAP_SYS_ADMIN, I envisioned a call
> > >> 	cap_able_chit(capability, chit-list)
> > >> but there's no reason there couldn't be a
> > >> 	chit_able(chit-list)
> > >> as well.
> > >>
> > >> I wrote this as an LSM, but the system-wide aspect of it made that
> > >> a questionable choice.
> > >>
> > >> If you have any interest, I could dig more deeply to try to find the
> > >> patches. Otherwise, I'm happy to look at what you come up with.
> > > What if eprivs or chits would take each capability and subvidide
> > > them into pieces? CAP_MAC_ADMIN would be formally a set of chits
> > > (or eprivs).
> > >
> > > And process having e.g., CAP_MAC_ADMIN, would actually have the
> > > set of chits that are included to CAP_MAC_ADMIN.
> > 
> > That would require that chits have the same inheritance rules as
> > capabilities, and I think that's a really bad idea. I was an active
> > member of the P1003.1e/2c committee that defined capabilities, and
> > was a major advocate of their inclusion in Linux. I wish that I
> > could say they've been successful, but root still rules the roost.
> > I attribute that to the complexity that arose from trying to address
> > privilege via setuid and privilege bracketing at the same time.
> > Chits (or eprivs) as a finer granularity version of capabilities
> > would make granular privilege even harder to sell than it is now.
> 
> Perhaps (or likely'ish). I'm just unpurging what I meant (even if it
> ought to be wrong):
> 
> 1. You can create F(C) -> S where C is set of caps and S is a set
>    of chits.

s/You can create//

(left by accident)

Br, Jarkko
