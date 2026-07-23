Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B503A4756D9
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826024; cv=none; b=MzktdJfpl1JZvNNzrcnYjvXah2gjbv1MS0cIi9GsIlF/Av1YQQmhh1MCK8iQ8PDIftqD+J7JeLWgVqeMFKmN+x2GkcFbhzyOhOrI4EvEgOBXHfohBLVUmu/XFFdnjIDuqoTzDGdNxQGABPH6b7UZ/d3Tt6AmQQl84tJCC4Hn5hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826024; c=relaxed/simple;
	bh=iU/FwLMLp21DnC5XkG6DrWvVNQxJ1GvDlQBJ5rSY1sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U+Co1+kJM+RijKRN/1xL/oAY8Y4u+5dj+G3V7Nh/oS4lqbb0xMQjyQEO1IILunQT9t/yP3fiEyQbVT66IpfpmzzcApcanVFIyR5f3iX7K2ddJr7eHpxx/SQ2jjlnR44r3shaWF0CId9KIv2umdQlGpmgOSd5rjmfATgU2A1QqaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwrAorHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwrAorHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596A81F000E9
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784826023;
	bh=nFefWNtVN7QpYcSpa/AAomkqDutNWZGuQiuscM0Wu0E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nwrAorHQZmPTUc+ZYE7Jx6i6p4JVTrTIXtg08yMk0FTm5NuBuetAXvL2uNQzGFc5I
	 4L9hmwcd0a9XpOC1tgo6OlUv0EWz2Zvw+G8JzjdZTxQ2wFpR9QbzFE/E1mmSSgY9sd
	 8szSWtoMWuizg34UwaDZe1JdNcn4FAZnkYfq+L55RX8GH6AQwMZT6Xb5z4U3NKuahQ
	 oA4Hmnc8BZf54j+dVU8D3GksNinqjyMYlGjD2x/CeSxsje205VvZ4qPPi5/HooLYiT
	 3/6b1a9DqjMYL8dGfkm63dPy1VI/65dVoLbPfr4IwmY7CpC/XeGwZzQw+MTClnsN80
	 hqIwpz59pQm/A==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39b3931e259so8236721fa.2
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 10:00:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro/vifTo7efN+57798UicAH+mWWNFhIaUz5CbcmEA4C2zoxo0Cv+5q/FJ9dlkEO62i3S150jXNpbEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGAHokElzvCbhI9PCrQeqtHYGVuRhhVM0zBP+3+iA2O1XjYr/8
	0UmfXI+lnrHYxP7ZmI8bA5VJBobq+9C7M3XPt0nxcSqfwgvjSLe0vvALP28RIQxwW8ldbDT56+I
	BK7De6DCxbHn54qGptEEuPMgi/NAUGdM5kgbRNnfe
X-Received: by 2002:a05:6512:340a:b0:5b0:23c3:4f55 with SMTP id
 2adb3069b0e04-5b2b2f72e6dmr840383e87.53.1784826005059; Thu, 23 Jul 2026
 10:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org> <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
 <20260723-mahlt-abhob-semantik-21254c8d36cb@brauner> <CALCETrVezim-eYOFWon1w7FngTgWb2nkuZb_duf9q=TrNqiqkQ@mail.gmail.com>
 <20260723-wutausbruch-aufraffen-gipfel-73767d4aa71f@brauner>
In-Reply-To: <20260723-wutausbruch-aufraffen-gipfel-73767d4aa71f@brauner>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jul 2026 09:59:52 -0700
X-Gmail-Original-Message-ID: <CALCETrW-ObgCm=Vhm6AiyyS25q+SyXkCvVWB7JEaawmOMCrrpA@mail.gmail.com>
X-Gm-Features: AUfX_mzIpqWq56DGWqbThFbD7a3b3A0zukUyF0HCSGDpiBebVUYhuKOgAcBFT6k
Message-ID: <CALCETrW-ObgCm=Vhm6AiyyS25q+SyXkCvVWB7JEaawmOMCrrpA@mail.gmail.com>
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

On Thu, Jul 23, 2026 at 7:49=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On 2026-07-23 06:50 -0700, Andy Lutomirski wrote:
> > On Thu, Jul 23, 2026 at 6:09=E2=80=AFAM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Thu, Jul 23, 2026 at 05:49:06AM -0700, Andy Lutomirski wrote:
> > > > On Thu, Jul 23, 2026 at 4:37=E2=80=AFAM Christian Brauner <brauner@=
kernel.org> wrote:
> > > > >
> > > > > Once entered, failfs is a throw-away-the-key moment. The task is
> > > > > considered chrooted so it cannot create user namespaces to regain
> > > > > CAP_SYS_CHROOT. chroot()/fchroot() back out require CAP_SYS_CHROO=
T.
> > > >
> > > > I kind of alluded to this earlier, but I don't think we should prom=
ise
> > > > this.  In particular, I still think we should eventually allow a
> > > > non-chrooted process with no_new_privs to chroot to any valid
> > > > directory, and I think we should consider changing the definition o=
f
> > > > current_chrooted() such that failfs-as-root would cause it to retur=
n
> > > > false.  I'm also not sure why it's useful -- if I want to throw awa=
y
> > >
> > > I had considered that but introducing this change alongside this seri=
es
> > > felt too spicy for me.
> >
> > I think I agree.  My only actual objection to your series as is is
> > that your wording seems to make a promise that I think shouldn't be
> > made.
>
> Agreed.
>
> >
> > >
> > > > the key to accessing the normal contents of my mountns without
> > > > changing my mountns, I need to chroot somewhere (like failfs) *and*=
 I
> > > > need to somehow prevent myself from getting an fd or a magic link b=
ack
> > > > to the ordinary mountns contents.  If I somehow get such an fd,
> > > > preventing my from fchrooting to it doesn't seem to accomplish
> > > > anything, since I could traverse the fd with openat, etc just as
> > > > easily, or even fchdir to it and use relative paths.
> > >
> > > I think I generally agree with you. My main concern here is mostly ab=
out
> > > changing very long-standing behavior here and making failfs special h=
ere
> > > feels like it could easily misused.
> >
> > I don't think either of us are really suggesting making failfs
> > special.  I agree about the long-standing behavior.
> >
> > >
> > > >
> > > > My understanding of the exact workings of the mount tree is possibl=
y
> > > > not good enough to specify the semantics I think are correct quite
> > > > exactly, but I think a decent approximation is that a task should b=
e
> > > > considered to be not chrooted if its root is at the top of its moun=
t
> > > > tree or is not in a mount tree at all.
> > >
> > > If we could altering this definition from the patchset I would be in
> > > favor of it. I'm curious what your take is though.
> > >
> >
> > I can't quite parse your question.
>
> Maybe I should shunt everything I write through an LLM so it catches
> grammatical nonsense.
>
> It was basically just trying to say "let's not redesign
> current_chrooted()" in this series - which I already did above.
>
> > I have three sort-of-concrete proposals:
>
> The best proposals...
>
> > (a) current_chrooted returns false if follow_dotdot starting at
> > current root but with nd->root equal to the namespace root would
> > succeed and return the current root.  I think this is fairly solid.
> > The main caveat I can think of is that someone could create a detached
> > mount tree, chroot to its root, then fork and have the child:
> >
> >  - drop privileges
> >  - set no_new_privs
> >  - chroot somewhere else
> >
> > then the parent or another privileged task mounts that tree somewhere,
> > and the child could now access the parent of the mountpoint.  Any
> > actual exploit based on this seems farfetched.
>
> It would also be easy to prevent unprivileged chroot()ing into detached
> mount trees. They're easy to recognize and it's not a super common
> use-case.

In some sense chrooting into a detached mount tree is an entirely
reasonable operation.  Make your favorite mount tree and chroot there
-- it's like mount-namespaces minus the namespace.
