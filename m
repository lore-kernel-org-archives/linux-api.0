Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFEB476CEB;
	Thu, 23 Jul 2026 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817319; cv=none; b=E68kHCwOGl7XR3wKJ7TpBzwgxr/6yJLF4FEIaxtDrZari98W89gspvLfQG20D866Jsc5sdbmtCuw1g4MMN/knAD7g9QTSLkGvsEzTyLiuXFruDEauoSqJUofKRh7g/wBcOjEaR4UGHld+Om5XsiCcNWJQ2ASKpYE8mtZuYzDSDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817319; c=relaxed/simple;
	bh=JvGWMVYzRAhB1Wa38GhMIis3TIab8tHHHqhdYJH4B74=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=dyBZd8BKE7YMHI+3g0z0WLx4sQ8IOtGVmdYzC77fLHMy20fwqRyvht1BNUIgAy/QVLolxBCJVKtHUYjgcQMtDg6imWf8HIzC/ZGLGqerXrS5ItFUi9ERQ8UYEPm3V+2Y+ono70uBip1WgKuMY2s6b+tmlSigV11YJxz/KA/6d8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyZ1e0kQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyZ1e0kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508B41F000E9;
	Thu, 23 Jul 2026 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784817312;
	bh=hsEeVMWWHxzJ0SePZkphRR2O3h+VdPz015ReoYLhFSY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=MyZ1e0kQrUsWpwm0CvR1DI/jiPvBbrIxExYlWd++p+2jQ/rU6NaUIngL0BFaiHJPR
	 0eknYC+af8RQImPDhqA2caQS2H1SaG2Vj/Rk9f3WqbdtWngRzmHGSJzjtFEngnqFVx
	 PFg43CbP/X2LKafpbfnhr1Z+d04bxxjxOKi5TWtRepKnCp6+IBEEJMzaJ2e/Pr+Van
	 9iTmV/c2Ud47bHgMH7pGgbkJ/SqL0KhoxkF93IcWk+iPKZT5V8JI9mDP8vPaS0NebH
	 xtv+hR4flFN/oldrJ51qswkhajLwP9CebtBmfkNAETvESrYID+XIE/ML+LqvbqNjsc
	 y8qMDGbcUSiWw==
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, 
 linux-api@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
In-Reply-To: <CALCETrVezim-eYOFWon1w7FngTgWb2nkuZb_duf9q=TrNqiqkQ@mail.gmail.com>
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org>
 <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
 <20260723-mahlt-abhob-semantik-21254c8d36cb@brauner>
 <CALCETrVezim-eYOFWon1w7FngTgWb2nkuZb_duf9q=TrNqiqkQ@mail.gmail.com>
Date: Thu, 23 Jul 2026 16:35:06 +0200
Message-Id: <20260723-wutausbruch-aufraffen-gipfel-73767d4aa71f@brauner>
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=5158; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JvGWMVYzRAhB1Wa38GhMIis3TIab8tHHHqhdYJH4B74=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlqc3htjcOqvucVTan4WT3e9WIcPHkssTJ3buX6/qHr
 7s4cUJ7RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETutzIyzDIwf967707+ys0n
 37gVuHJsn/rvTnz3Nvttmpt/8x1bUsvwvzb97E82/lMvVTawZ7q/0y7/o34+R9dKpIRh8wkNV4c
 wNgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-23 06:50 -0700, Andy Lutomirski wrote:
> On Thu, Jul 23, 2026 at 6:09 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Jul 23, 2026 at 05:49:06AM -0700, Andy Lutomirski wrote:
> > > On Thu, Jul 23, 2026 at 4:37 AM Christian Brauner <brauner@kernel.org> wrote:
> > > >
> > > > Once entered, failfs is a throw-away-the-key moment. The task is
> > > > considered chrooted so it cannot create user namespaces to regain
> > > > CAP_SYS_CHROOT. chroot()/fchroot() back out require CAP_SYS_CHROOT.
> > >
> > > I kind of alluded to this earlier, but I don't think we should promise
> > > this.  In particular, I still think we should eventually allow a
> > > non-chrooted process with no_new_privs to chroot to any valid
> > > directory, and I think we should consider changing the definition of
> > > current_chrooted() such that failfs-as-root would cause it to return
> > > false.  I'm also not sure why it's useful -- if I want to throw away
> >
> > I had considered that but introducing this change alongside this series
> > felt too spicy for me.
> 
> I think I agree.  My only actual objection to your series as is is
> that your wording seems to make a promise that I think shouldn't be
> made.

Agreed.

> 
> >
> > > the key to accessing the normal contents of my mountns without
> > > changing my mountns, I need to chroot somewhere (like failfs) *and* I
> > > need to somehow prevent myself from getting an fd or a magic link back
> > > to the ordinary mountns contents.  If I somehow get such an fd,
> > > preventing my from fchrooting to it doesn't seem to accomplish
> > > anything, since I could traverse the fd with openat, etc just as
> > > easily, or even fchdir to it and use relative paths.
> >
> > I think I generally agree with you. My main concern here is mostly about
> > changing very long-standing behavior here and making failfs special here
> > feels like it could easily misused.
> 
> I don't think either of us are really suggesting making failfs
> special.  I agree about the long-standing behavior.
> 
> >
> > >
> > > My understanding of the exact workings of the mount tree is possibly
> > > not good enough to specify the semantics I think are correct quite
> > > exactly, but I think a decent approximation is that a task should be
> > > considered to be not chrooted if its root is at the top of its mount
> > > tree or is not in a mount tree at all.
> >
> > If we could altering this definition from the patchset I would be in
> > favor of it. I'm curious what your take is though.
> >
> 
> I can't quite parse your question.

Maybe I should shunt everything I write through an LLM so it catches
grammatical nonsense.

It was basically just trying to say "let's not redesign
current_chrooted()" in this series - which I already did above.

> I have three sort-of-concrete proposals:

The best proposals...

> (a) current_chrooted returns false if follow_dotdot starting at
> current root but with nd->root equal to the namespace root would
> succeed and return the current root.  I think this is fairly solid.
> The main caveat I can think of is that someone could create a detached
> mount tree, chroot to its root, then fork and have the child:
> 
>  - drop privileges
>  - set no_new_privs
>  - chroot somewhere else
> 
> then the parent or another privileged task mounts that tree somewhere,
> and the child could now access the parent of the mountpoint.  Any
> actual exploit based on this seems farfetched.

It would also be easy to prevent unprivileged chroot()ing into detached
mount trees. They're easy to recognize and it's not a super common
use-case.

> 
> (b) separate the concepts of fs-root-for-absolute-paths and
> fs-root-for-blocking-dotdot.  IMO this actually makes sense but would
> would be a much more intrusive change.  We would have
> fs->root_of_abspaths and fs->dotdot_blocking_root, and fchroot would
> only change root_of_abspaths unless a flag is set asking to change
> both.  (And document that setting that flag is not advised and that
> one should create a detached mount tree instead for 90% of use cases.)
>  And no_new_privs tasks would be allowed to freely change
> root_of_abspaths.
> 
> I like (b) conceptually in the sense that I wish no one had ever
> invented chroot-for-security in the first place.  I'm not sure I like
> it as an actual practical idea because it has a much larger scope.
> Also (a) is almost equivalent as long as no one ever sets the root to
> something that isn't the root of a mount tree, and it really would
> confuse some people if "/.." was not equivalent to "./".

Yeah, I'm not so excited about this part...

> 
> (c) Add a bit to fs_struct called something like chroot_locked.
> chroot() sets the bit if it chroots anywhere other than "/" or its
> equivalent.  fchroot does not set it unless a flag asking for it is
> set.  Switching mount namespace clears the bit.  If you have
> no_new_privs and don't have chroot_locked then you can chroot.

That sounds reasonable - the fchroot() extension is also a nice touch.

