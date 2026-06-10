Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AD9233921;
	Wed, 10 Jun 2026 07:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781076522; cv=none; b=M3TGiIwef/3Ifr4Bt7VrMucSnDkBnG8ckcnNSj5OSvgP0+Apxu5ah329zKfhBMBM52v1eWyhVPLYrKzqS+iGHMvOxyoY4hjvRVz28Xi26qw1zbeufHBZlzqLoi4C+dZh05BLZfDjzSwzLz7qRzukWsSPS3nFmaqYBAoHybHj9YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781076522; c=relaxed/simple;
	bh=XVzT4dC9J9FFpWrYJ1jidUjuN9wz2V7gqq0wjB+r38s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUOSeJBZUSZxnvYfJVR0HYtlj7W4K9l17CB18hf3XuzPRkCegJjsLWSb8QiKvmawcaUNXrlO65syW+kzLYOMyQ1Js6229GRgaQJaMRNdp1e3tCTuY7+WWavbHY5cM7Wz9C72PysN3deF80x9KQHCQtEfSreJY6zceU23sFr46ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fgvSiRD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fgvSiRD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D40D1F00893;
	Wed, 10 Jun 2026 07:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781076521;
	bh=Ujw8//AhBz2ofNEZXVOO0whE9ziRkQU7WuP9Q2n1nw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fgvSiRD0nlrWeKZ00ARxxj8+SIeSOssxKo/IteKl5SNNXShxIV9RzZYZjW2fJDF4Y
	 BRLJiLnad8I+/cgypVTOTIn/c5oxyEme4EK0poeNVEmG9QKE7i/U92Q7yjVt2JPZoo
	 KKab8o9SdIM2XvpGoVICIQ4XwdgAVtaPGhU54ayQfCnfLlEaW3lPQVBllb9BkmzECO
	 nE7j1CjEqBtnt3cNbOS7Erz0xZkaANJGk+ly24VtiJa0PCDT3qoW/N+IRr4nTvwqZd
	 Z5PKSNrIQl7+mm2qzkxCg4AIGhgZkp5e7n9mKFUe2JXKDXK2WgGk0nXZXZ5u3/BshM
	 PjG2C1OvGIzpg==
Date: Wed, 10 Jun 2026 09:28:32 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Li Chen <me@linux.beauty>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <20260610-saufen-zerfallen-uncool-5608105e0d8e@brauner>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
 <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>

On Mon, Jun 08, 2026 at 05:01:57PM -0700, Andy Lutomirski wrote:
> On Thu, May 28, 2026 at 4:05 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> > > Hi,
> > >
> > > This is an early RFC for an idea that is probably still rough in both the
> > > UAPI and implementation details. Sorry for the rough edges; I am sending
> > > it now to check whether this direction is worth pursuing and to get
> > > feedback on the kernel/userspace boundary.
> >
> > The idea of having a builder api for exec isn't all that crazy. But it
> > should simply be built on top of pidfds and thus pidfs itself instead.
> > It has all the basic infrastructure in place already. Any implementation
> > should also allow userspace to implement posix_spawn() on top of it.
> >
> > fd = pidfd_open(0, PIDFD_EMPTY /* or better name */)
> >
> > pidfd_config(fd, ...) // modeled similar to fsconfig()
> >
> 
> After contemplating this for a bit... why pidfd?  Doesn't a pidfd
> refer to an actual process that is, or at least was, running?  This
> new thing is a process that we are contemplating spawning.  I can
> imagine that basically all pidfd APIs would be a bit confused by the
> nonexistence of the process in question.

I don't think that would be a problem because every api just needs to
handle ESRCH. Ignoring that for a second: the mount api has a builder fd
that is later transformed into a pidfd. Which is easily doable here as
well. My point is that all the infrastructure building blocks already
exist in pidfs.
