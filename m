Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA841D223
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814674; cv=none; b=QTUrcvMw39bllHe6ypN9UDPp4G2aAMva7N/vbQAIaLHplsniP0MnUBVae9LdVwY0DNcAzxz9Pqj7+tGjRi2KRCBIpniEpLjdE5MOn6Z9/KxDBur0Hqk0GY91rz6Px35+94Wpz4z4UStDzwJVhmH3OEXY7M9mQG1TBxbop5P+7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814674; c=relaxed/simple;
	bh=qTCtUO20aHBaoQd/HG/5QDxAb9VXAQXH9n/VX8aHHlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ht08jYEj+M5J74x+2qGsWU7LG4AcrOI346Zo2jUmZYI+eqFi5bVElfAy10X9qspWs9mHWObuDrl54bPkHO+h02m6QJf+qk31mXhfseNBLvC/EGXSetDUybL5Nf9cB/3i40G2vGskDZKCuiHaAWKdaV7H6toXZRSj6s36KXpfx5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0Fkuymf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0Fkuymf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211D51F00A3A
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 13:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784814672;
	bh=n1DEl7HdaV9+H803Y0sSiDSe+MyaXZhWnsHtsDRoo7o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B0FkuymfCd36zakbK/WvPAomQ4e3RgEXSCMZGFyhMegnqP8diCLkWSVw9DkS66i8T
	 rLKsegmqrXcgbvA5ihDwH+rX4f8uABXaJS5R/IYef9EGqf+KXxXEc5gIjLkC8i+5TS
	 CCTwOBhsZDG/F24bzt0tuicjeIZsddb2p9sbKmHP8nQvrvDjCDxRsWf/9qHRsDIlCx
	 qPw/4ixBCgE/kekjymjxqln1hfLnMw0fnXM/fcYYNV910HTrtepTGYqV5LRp1xOh3I
	 7/Z7AuwFTdmreFJihH34vnOC7oFzXu8ZHUxMyOGcRBTxPqWbzTPcKMksw5KDrJeOtT
	 6BjclXGEkXSGg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b00d083818so412011e87.1
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 06:51:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqS7hv7fhVUbEIWFuH5iMg/UheLofB84IWS4fj0kbJndCnPLg6V4JjG8VntF/2odkccgozQh+pV4YY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEjU4N06Z5tCNaOpnqebppdx4u0qum4WPpQobNOBpbmbZLFO53
	r/szFF6NpO32DeGidGRYC42n+U/bi9dVJ9kd4KaGxB4VP+e+JCdrbpnT9lkwbgTMJxmxO8I6Jul
	85x4y8od32SAIWnL5OVQvrb1z60ISuVVuzpHnigUP
X-Received: by 2002:a05:6512:250d:b0:5b2:af9c:a5cf with SMTP id
 2adb3069b0e04-5b2b33a6299mr612275e87.27.1784814646486; Thu, 23 Jul 2026
 06:50:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org> <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
 <20260723-mahlt-abhob-semantik-21254c8d36cb@brauner>
In-Reply-To: <20260723-mahlt-abhob-semantik-21254c8d36cb@brauner>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jul 2026 06:50:35 -0700
X-Gmail-Original-Message-ID: <CALCETrVezim-eYOFWon1w7FngTgWb2nkuZb_duf9q=TrNqiqkQ@mail.gmail.com>
X-Gm-Features: AUfX_mxrk4wRgWPLjixGoyqZWEAlTjavFRX3T9mw_3W96-ZNwXFV2jgzWe5MeHs
Message-ID: <CALCETrVezim-eYOFWon1w7FngTgWb2nkuZb_duf9q=TrNqiqkQ@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 6:09=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Jul 23, 2026 at 05:49:06AM -0700, Andy Lutomirski wrote:
> > On Thu, Jul 23, 2026 at 4:37=E2=80=AFAM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > Once entered, failfs is a throw-away-the-key moment. The task is
> > > considered chrooted so it cannot create user namespaces to regain
> > > CAP_SYS_CHROOT. chroot()/fchroot() back out require CAP_SYS_CHROOT.
> >
> > I kind of alluded to this earlier, but I don't think we should promise
> > this.  In particular, I still think we should eventually allow a
> > non-chrooted process with no_new_privs to chroot to any valid
> > directory, and I think we should consider changing the definition of
> > current_chrooted() such that failfs-as-root would cause it to return
> > false.  I'm also not sure why it's useful -- if I want to throw away
>
> I had considered that but introducing this change alongside this series
> felt too spicy for me.

I think I agree.  My only actual objection to your series as is is
that your wording seems to make a promise that I think shouldn't be
made.

>
> > the key to accessing the normal contents of my mountns without
> > changing my mountns, I need to chroot somewhere (like failfs) *and* I
> > need to somehow prevent myself from getting an fd or a magic link back
> > to the ordinary mountns contents.  If I somehow get such an fd,
> > preventing my from fchrooting to it doesn't seem to accomplish
> > anything, since I could traverse the fd with openat, etc just as
> > easily, or even fchdir to it and use relative paths.
>
> I think I generally agree with you. My main concern here is mostly about
> changing very long-standing behavior here and making failfs special here
> feels like it could easily misused.

I don't think either of us are really suggesting making failfs
special.  I agree about the long-standing behavior.

>
> >
> > My understanding of the exact workings of the mount tree is possibly
> > not good enough to specify the semantics I think are correct quite
> > exactly, but I think a decent approximation is that a task should be
> > considered to be not chrooted if its root is at the top of its mount
> > tree or is not in a mount tree at all.
>
> If we could altering this definition from the patchset I would be in
> favor of it. I'm curious what your take is though.
>

I can't quite parse your question.

I have three sort-of-concrete proposals:

(a) current_chrooted returns false if follow_dotdot starting at
current root but with nd->root equal to the namespace root would
succeed and return the current root.  I think this is fairly solid.
The main caveat I can think of is that someone could create a detached
mount tree, chroot to its root, then fork and have the child:

 - drop privileges
 - set no_new_privs
 - chroot somewhere else

then the parent or another privileged task mounts that tree somewhere,
and the child could now access the parent of the mountpoint.  Any
actual exploit based on this seems farfetched.

(b) separate the concepts of fs-root-for-absolute-paths and
fs-root-for-blocking-dotdot.  IMO this actually makes sense but would
would be a much more intrusive change.  We would have
fs->root_of_abspaths and fs->dotdot_blocking_root, and fchroot would
only change root_of_abspaths unless a flag is set asking to change
both.  (And document that setting that flag is not advised and that
one should create a detached mount tree instead for 90% of use cases.)
 And no_new_privs tasks would be allowed to freely change
root_of_abspaths.

I like (b) conceptually in the sense that I wish no one had ever
invented chroot-for-security in the first place.  I'm not sure I like
it as an actual practical idea because it has a much larger scope.
Also (a) is almost equivalent as long as no one ever sets the root to
something that isn't the root of a mount tree, and it really would
confuse some people if "/.." was not equivalent to "./".

(c) Add a bit to fs_struct called something like chroot_locked.
chroot() sets the bit if it chroots anywhere other than "/" or its
equivalent.  fchroot does not set it unless a flag asking for it is
set.  Switching mount namespace clears the bit.  If you have
no_new_privs and don't have chroot_locked then you can chroot.


--Andy
