Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D53D1CCF;
	Tue, 30 Jun 2026 07:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782803678; cv=none; b=HVfPvK2P1CqQmWqC9pG3kfT95Pb5hq7TSs8AVnwru3hcKug+8FC4OSZ+bQR7CNA+pil/KacQnOOnldsLDAWx/EbiO9AuGRZtVTVPaA7FyOVa8J+aTavh/MgwqvfZ4MgYf2C0oFvbNDaN5u5jzGK7duIuqFdezomArtaiPl9N8/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782803678; c=relaxed/simple;
	bh=VICWaE9WUXW2LWdO5r9lbkxHnC+JwXq4KpepnM7pCA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkJXs8BC9pvEm3+f77B9V7EvylyQh9161F8W/HW6QQuuCBFoYe9gaOG1SHwcq6zBHReOq9kNEk1YmidGEof+6vhuKBzMq7X3ykgZU8XxhsTOH7pxDeqsUtFXQj8EQofqqNtK0bdMZzwjDFBLKmumHMOEr/hgi3rXOlJKB5cws0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lF6Bhj9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lF6Bhj9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE601F00A3A;
	Tue, 30 Jun 2026 07:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782803677;
	bh=+QSVg6eV+J0zaLkGpTTo7MZ6WXU0ihg0UHJ87/LB+6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lF6Bhj9OoogKud4iTtoRksj3SG8/hInr72NpOxv+PftPWGHJV4EyNPyxPsqL7ND/T
	 HPxN3DCwTGHq+fQubufrypHawzwGcB3ChEl6hr8v+CNSILbRcCHoGoNHOkcQuuloko
	 OhuMoeWIy23ruLd/DRjYuxPubIpK4OvaVWx7qzPh2ndE8B9L2q5pUqWSMpWzrHn+By
	 Uj3NVRJjqGt+fY1aoLJRe9EYTho5ZESjxfkVBNGRFaSm8oNFQOQTQzmKJ6OnXYTk05
	 R9KMYRv0T8qLJRR0Q0meWmz0yOZ2eudt4x3nCrzXpfOpqkGl0BD+1RdHQAciG5MVB7
	 pB5lWonGYgsdQ==
Date: Tue, 30 Jun 2026 09:14:30 +0200
From: Christian Brauner <brauner@kernel.org>
To: John Ericson <mail@johnericson.me>
Cc: Li Chen <me@linux.beauty>, Cong Wang <cwang@multikernel.io>, 
	linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: Re: [RFC] Null Namespaces
Message-ID: <20260630-kippen-jobaussicht-restriktionen-2149cc663b22@brauner>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner>
 <eb390c52-eeb3-44b3-88e9-e65c52a26c05@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eb390c52-eeb3-44b3-88e9-e65c52a26c05@app.fastmail.com>

On Mon, Jun 29, 2026 at 10:50:38PM -0400, John Ericson wrote:
> On Mon, Jun 29, 2026, at 7:45 AM, Christian Brauner wrote:
> > But I guess the even simpler model would be to copy what I've been doing
> > for pidfs:
> >
> > [...]
> >
> > we then add fchroot() (overdue anyway) and then teach both fchdir() and
> > fchroot() to honor FD_NULLFS_ROOT. Then a process may shed its fs state
> > and move itself into nullfs. Restrict *chdir() and *chroot() for said
> > process via seccomp and it's locked in forever as well.
> 
> This looks good! It delivers most of what I want, and I do want to be
> very clear that while I am responding to your comments on my patch
> below, I would still be very pleased if we just did this, much more than
> I am pleased with the status quo.
> 
> (And also, yes, good to create the long-overdue fchroot regardless of
> what we do here.)
> 
> > Nothing here requires you to NULL anything and I oppose this on code
> > sanity reasons alone. We shoud absolutely not start to stash any NULL
> > pointers in core kernel objects such as struct path that are used
> > everywhere.
> 
> Before we do the "pidfd style" nullfs route, I want to make one thing
> clear about my patch: I was *not* trying to relax the invariant across
> the board that (live) `struct path` should only contain non-null
> pointers. Rather, I just want `struct fs_struct` to contain ("morally")
> `Option<struct path>`. My use of the null pointer was merely me doing
> the sort of ragged union packing that, for example, Rust does. I think
> as a matter of A_B_I (emphasis on "binary"), this is fine, and not
> going to cause Armageddon --- `struct path` is widely used, but `struct
> fs_struct` is (as far as I can tell) not.
> 
> All that said, as a matter of A_P_I (emphasis on "program"), I do see
> your point that it's too easy for someone to not read my comment, and
> then `struct path` with null pointers starts leaking all over the place,
> making a big mess. I think a simple enough fix is to just use another C
> encoding, such as a union, for `Option<struct path>`.
> 
> For example:
> 
>     union optional_path {
>         struct {
>             void *p0, *p1; /* must be null */
>         } __randomize_layout null_path;
>         struct path path; /* both fields must be non-null */
>     };
> 
> To continue saving space, or --- if relying on the overlap of
> `null_path` and `path.mnt` is too sketchy --- making a bona fide tagged
> union:
> 
>     struct optional_path {
>         enum {
>             OPTIONAL_PATH_ABSENT,
>             OPTIONAL_PATH_PRESENT,
>         } tag;
>         union {
>             struct {} null_path;
>             struct path path;
>         };
>     };

I think Al is about to have a stroke reading this... and I might too.
I agree with the sentiment I disagree with the details of this and
touching the whole kernel for this. You know what the easy solution is:
don't allow a struct path to be empty...
