Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB154C8FE4;
	Thu, 23 Jul 2026 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811682; cv=none; b=NFlTql7Xl7ESq6eFm9Ke0vEc3Bh0UdL2/kSpPSRgeJr6hdw49qZ6OBDohUurUKwQDJZjczTaDnd7o6xjT1EwXYLlPU8EsgfpymE/ZAHR+pWx41if/3ls8ipxMXNG2/m/3Ha2DOaY1aExDowmyK+rWu8rWROZuuAUAcFs8l534A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811682; c=relaxed/simple;
	bh=TzYl/feHKRvyXhoYZqF8YQdzm6DS52XUGoegXeqUVkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVGKNPy/wtvznrfPBxsOdTA66WatcJNaMx0HE0HvhQ7jjz+ymoMk208/yDry7EpB10WjyliweLJfxiTdJxVboThWe2HmJN848HO7CxzLQxSRQqSPkru0Z5HITm0XhomUmmYIJidbm7RhtN4EFEL/znwWhIhUfmjORi3m8aePdD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2761E1F000E9;
	Thu, 23 Jul 2026 13:01:16 +0000 (UTC)
Date: Thu, 23 Jul 2026 15:01:09 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Kees Cook <kees@kernel.org>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
Message-ID: <20260723-mahlt-abhob-semantik-21254c8d36cb@brauner>
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org>
 <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>

On Thu, Jul 23, 2026 at 05:49:06AM -0700, Andy Lutomirski wrote:
> On Thu, Jul 23, 2026 at 4:37 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > Once entered, failfs is a throw-away-the-key moment. The task is
> > considered chrooted so it cannot create user namespaces to regain
> > CAP_SYS_CHROOT. chroot()/fchroot() back out require CAP_SYS_CHROOT.
> 
> I kind of alluded to this earlier, but I don't think we should promise
> this.  In particular, I still think we should eventually allow a
> non-chrooted process with no_new_privs to chroot to any valid
> directory, and I think we should consider changing the definition of
> current_chrooted() such that failfs-as-root would cause it to return
> false.  I'm also not sure why it's useful -- if I want to throw away

I had considered that but introducing this change alongside this series
felt too spicy for me.

> the key to accessing the normal contents of my mountns without
> changing my mountns, I need to chroot somewhere (like failfs) *and* I
> need to somehow prevent myself from getting an fd or a magic link back
> to the ordinary mountns contents.  If I somehow get such an fd,
> preventing my from fchrooting to it doesn't seem to accomplish
> anything, since I could traverse the fd with openat, etc just as
> easily, or even fchdir to it and use relative paths.

I think I generally agree with you. My main concern here is mostly about
changing very long-standing behavior here and making failfs special here
feels like it could easily misused.

> 
> My understanding of the exact workings of the mount tree is possibly
> not good enough to specify the semantics I think are correct quite
> exactly, but I think a decent approximation is that a task should be
> considered to be not chrooted if its root is at the top of its mount
> tree or is not in a mount tree at all.

If we could altering this definition from the patchset I would be in
favor of it. I'm curious what your take is though.
