Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119260;
	b=gGdr8ENWI0q8Z6e4Fq7fdHurMPtR5uz2N4r52+JklqU//ZSchlSQiKTBGbPLUdwgMDNG
	 0bYs5yWvouIRQorbu9e8EOgcvqcxq7PXhLdg+Uv6cv+gMotu3iweSetTjJDtpls8Ts2zi
	 CTwOIxsWumJrcp72h5goWuoQFMXfraOZgkHd3XjiqSYF4Pg/60+7nbLDGWr0q6DzrCMRn
	 qnOYVe7bDdErcU43r7CCX7brE63IGnjVCiUSZWfkkXrHty/DaTQ264PVY23WfOktFL+gQ
	 sKKCT7OTo41M/UmwB6NJP4JzMIxF6DkBHdNyxICT/s0vsUrGCeCnsfIB8TAzlPcxQdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119260;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ztZOYDDj4YBSqYLNwQGp2fMnE23YsKtU2LeiU8/UQwE=;
	b=06irUZf2HB4Ectvcdb7wvcVagxxHKrs5DvB8x7t7J+g0umphTzd8llX3kj2BSe3nYVkh
	 iXSjIl0g0X140S3DehYnfuv/kr91xb2JGp1bu59V9iPBZ/YQ1cE+jSnajnLEpGxuuGJL8
	 qNwlAJjBIKLP2sICv/kNBNFw+G5ZzCL6qpi8WyiCviU4WqdmvXLHj8z6eLC6vX8HazSfX
	 GD70vJwZUcr/CQM7smvFTFXr47LoUSBY2e/cywfSs/4r6wwMvbAy/fBjwbHt3SdjtXffK
	 YApbK24sE+iOS/nQQ2U3WGDFA1eBgnidm5w9mtv1tJ9Uv4uJMcsNmknIcwhq9T80ouA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNSYDVjJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 479D0606A320;
	Thu, 19 Nov 2026 20:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNSYDVjJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9941C1F000C0;
	Thu, 19 Nov 2026 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795119260;
	bh=ztZOYDDj4YBSqYLNwQGp2fMnE23YsKtU2LeiU8/UQwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mNSYDVjJ/BEzpaUbevR2cNTUAwuX81DGs1T+9sVKjtaxqcTSGfvEPldgdpP7Jchji
	 jqpAwSVXHOuhZ5aY45s9O9/0dgEPRPZniI/JiMbsnRUlbivecIuPENcjQqdjVBDKMp
	 ekjPDsS5ooFm3VuggwXme6iPKovVVyVVkrEajuUi3jLY+wMwI1h/m47qU+VP6NkvTy
	 OJdcoCeBw7o0G6JmK1KtFdtqiC+TMVFiC8s6nHvMHqMFbv5kUCCyPJ3qOPEzuA1gPs
	 3pgHdelX/ywey3HjBAONozyA2zIkL89dLrU7ld9cbhT8mPqGmYi5dUa7nyPLlXjqpk
	 YjQ8Z6Y9pHgwA==
Date: Thu, 19 Nov 2026 22:14:16 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Serge Hallyn <sergeh@kernel.org>, Andy Lutomirski <luto@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	David Howells <dhowells@redhat.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	containers@lists.linux.dev, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for
 user namespaces
Message-ID: <av9YmPJexMJoCGWO@kernel.org>
References: <20261119104208.782900-1-halg@google.com>
 <20261119104208.782900-2-halg@google.com>
 <av8QNiFcnGWocORy@kernel.org>
 <av9L2ez51erKkQNo@google.com>
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
In-Reply-To: <av9L2ez51erKkQNo@google.com>

On Thu, Nov 19, 2026 at 07:19:53PM +0000, Hallgrimur H. Gunnarsson wrote:
> On Thu, Nov 19, 2026 at 05:05:26PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Nov 19, 2026 at 10:42:05AM +0000, Hallgrimur H. Gunnarsson wrote:
> > >  static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
> > 
> > I read the diff through but this led me to dead end. Cannot find this
> > function from anywhere. I look the changes again once this is sorted
> > out becaus this is interesting.
> > 
> > I wanted to look at the call site to understand how cap_bset gets set,
> > which is not now possible but I do get the gist and agree with it.
> 
> Thanks for taking a look. The series is based on v7.4-rc1 and
> set_cred_user_ns() lives in kernel/user_namespace.c, where it is called
> from create_user_ns() and userns_install(). ns->cap_bset itself is
> initialized in create_user_ns() right before calling set_cred_user_ns().
> 
> > I'd figure getting this relates to my rootns patches (perhas). One key
> > mechanism for me resolving the unprivileged in my use case is
> > MOVE_MOUNT_T_MNTNS [1], which is orthogonal but just pointing out
> > the problem space.
> 
> From a quick look, they appear complementary. Being able to do more
> setup operations from the outside generally aligns with bounding
> capabilities inside the user namespace.
> 
> > I read through https://lwn.net/Articles/978846/ to understand the topic
> > overall. Just mentionining as a possible addition to the cover letter
> > (not a priority/necessity).
> 
> That LWN article is actually linked in the cover letter as [2].
> 
> > Hope these help and can be kept in the loop :-)
> 
> Will do, I'll keep you CC'd on future revisions.

Thank you.

Br, Jarkko
