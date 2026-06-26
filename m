Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0213148850;
	Fri, 26 Jun 2026 00:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782432949; cv=none; b=kq0mfvBRqpdoSbFHBxNnENbbhOsCWiWrVHk4AsIbd0VE1xu057mXvIn2qyUel0LD7mplBzcBr1RutE3KVf4i5qQOdQ6Ruv6YGxIB/a1qU/Q/SMUfKHNc4EsOTBsjQslrmzafsE7zJpnwDjhbDQIkupvf9h6jGNBNvNhj+wljzuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782432949; c=relaxed/simple;
	bh=TXFUd1//ASVCm45IdM7vCzKmpt2KivxrRxl8T59HmGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzTZL6YMbwDwJySwLYr31zW72T2BgztYjedVbgDDtTJ59gWiK8POwP6wYO847cwFoqWiYmGb1tuL5b1bLSckpIFCkJQA95sar3VbH7JlMKopQU73QAXdv3mhG80QwWBuu2qRa4Q+QkMBkuCLArHuiFbvUyEOmebcAZwOEN6+fBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=E6c+dNVg; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="E6c+dNVg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=RXGcvQsylfrmfPpvXKTtDL2DjwJxYfuocbo/6g3/+YM=; b=E6c+dNVgGQn1AxI7tf4I3RZVpV
	WQzWhxxIRnyg/nFdU2MWLaU9k2Nx16h9SuUQXDzsCI0mW8rOONB61jAS95qQzU0+YzVc1gk/ywTQR
	NW15XHxFmnGwTg06CmqVu1u/fH+kU8bG6dMprh0I+x7IzZGR3jxzakN/+mv275qNhdhyt3/YHfOWO
	YQ52SD/e4Z0gIDwi93qD21rWErt0BfLjsl1VuiVkQK9N3LDOEon6GFmBuRN4LTEvpx3AQbIT0i9Ao
	GaOnq5G/ZPnZVL4HoACTibttIzA5BSRtYn5e26KELgJnwm4der3mC/6ruuYuui5U757ifAoThgXf6
	2ZQd8gfA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.4 #2 (Red Hat Linux))
	id 1wcuEM-000000082GQ-1gGn;
	Fri, 26 Jun 2026 00:15:39 +0000
Date: Fri, 26 Jun 2026 01:15:38 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: John Ericson <mail@johnericson.me>
Cc: Andy Lutomirski <luto@kernel.org>, Li Chen <me@linux.beauty>,
	Cong Wang <cwang@multikernel.io>,
	Christian Brauner <brauner@kernel.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-api <linux-api@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>,
	Sergei Zimmerman <sergei@zimmerman.foo>,
	Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: Re: [RFC] Null Namespaces
Message-ID: <20260626001538.GO2636677@ZenIV>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <CALCETrWhXNetw-BsAaoyT31suMmjYLdMh9MAuLB2Lvk2ac-31g@mail.gmail.com>
 <CALCETrU3bgUxp0k1y-U-uL0-fW2016Gmsyu9O_=830czEUGMcQ@mail.gmail.com>
 <103524f8-1658-41df-88e9-cf49c628a721@app.fastmail.com>
 <20260625011023.GM2636677@ZenIV>
 <a75a9b82-a15b-4893-8f92-62b62664ea83@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a75a9b82-a15b-4893-8f92-62b62664ea83@app.fastmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Jun 24, 2026 at 11:41:07PM -0400, John Ericson wrote:

> The current working directory, roughly, is *just* some global state
> holding a directory file descriptor.

So's the descriptor table; what's the difference?

> But I don't want that global state.

Don't use it, then... out of curiosity, does that extend to stdout et.al.?

> If I am writing my userland program (that is not a shell), I would not
> create the global variable. I do not appreciate the fact that the kernel
> foists that state upon me whether I like it or not.

<wry> Kernel will have to live without your appreciation, I suppose. </wry>

> Now obviously we cannot have a giant breaking change removing the notion
> of a current working directory altogether. But we can allow individual
> processes which don't want it to opt out, and that is what nulling out
> these fields (and updating the path resolution code to cope with that)
> allows.
> 
> There is no loss of expressive power doing this, because one can (and
> should!) just use the `*at` and file descriptors. But there is, however,
> the imposition of discipline.

So supply a library of your own and try to convince people to use it
instead of libc.  You'll have to anyway, seeing that a large and
hard-to-predict part of libc will be non-functional.  Which syscalls
are used by your library is entirely up to you.

Would that kind of thing added kernel-side assist the development of such
library?  Maybe, but I wouldn't bet too much on that - if you start from
scratch, you can trivially verify that you don't even attempt given
set of syscalls and if you use libc as a starting point, you get to
debug all the failure exits you've added...

> The programmer (or coding agent) is
> encouraged to do everything with file descriptors rather than path
> concatenations etc., because they need to use `*at` anyways, and then
> voilà, without browbeating anyone in security seminars or code review, a
> bunch of TOCTOU issues disappear simply because doing the right thing is
> now the path of least resistance.

I'm sorry, but the path of least resistance is picking a snippet from google
that will implement open(), etc., on top of your setup and using it.
_Especially_ if coding agents are going to be involved, precisely because
they'll do a convincing simulation of human duhveloper's behaviour, i.e.
"cut'n'paste it from the net".
