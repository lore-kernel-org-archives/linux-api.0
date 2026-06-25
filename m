Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C68526F2BE
	for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 15:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782402685; cv=none; b=tD0Bi5YXt0LiiVG/Nf1bSvQ+KbfZn6BZRnj3cPt9T4kwwGeifaDlUfPZCe9RtnEk4S5GVHnqFjuQ/7H01G+yNaRpRbtZ2MZUAQmG+ZI73Rv915apVHGbB5LMV3SDekbZpEjryFWeQhHPcCRtlTyYAR8IdWeUPEaHfeiIorVTPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782402685; c=relaxed/simple;
	bh=jRy8DPU+3KK9hjCqyr0r4UFSYg9SRA83IBr0VGhimhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ju2k/UT+T4egk8r5c6fuKxx04DLh+6VRC8NVOS70yvAKaMACyd2EEotMm1vrt2JnyejjEhe6uGRTQi2tsbN+9dg1TnQCGfAk3lGhjRr6P/U1YmOTCKkVbF1GIV71y74u5IzKEIWZ1OdXEzFlTPFI5qctVLXWze5p+lN0nDDS3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwCQbXIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwCQbXIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A11F00ACA
	for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 15:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782402684;
	bh=Kw/IQi4exB4+R3l9GqrvOCZO/Y90Qcj33bUN4lpzTUI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FwCQbXIaW+By0J8qS932seOm65bhUUfo5T8tNhnrtYSk3kSw0Ioavb7V3ePyGBwnb
	 pKywczy1RoK9i1S+Q535GAB12tRTO1G/praJ3IlgAlGb5Z66R8SZJ6+vRnCADa11ta
	 nGbi8bscHaEtG+L13EBzzJ0v+RW5p+zqiWEDV5KnT15Fa0VTQPwK6MNH2ZTT66drTB
	 L52fkTnVSXqVzc7jg4JjqlGL0KI5hi+CkZzrY0FpsTad7+VUKxbRGYIIXaMXSLa5Po
	 eWi93IhKYy3giweUh5NzK6H2aQkMfjP9mpjUyzUsb3Hi6LogppAUg60rKxX6MnL05P
	 yzTvqF8ulnMcA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aa68d65d24so2968311e87.1
        for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 08:51:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpymbKvkr9a9IoKcDwzhX6JdpTU9FTsqam4b34ILomOQpgsfrky2cLPtFmpGfwK5Y63LcIlBmh/jWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaWbfGZbgOfldqKuXHj32buo9RZl92IbrhwNkE41xaS/mYp9mv
	q9woKn7gi38Im8TZMhUkkV4tt0VXEN41ZTSSbsqe02sQBbgrt92fh8l/I4dFnBIMOkGQ0hh8S3m
	x6FLg8Ks+SNirVPoByjYmPCLEDBybrch1MQ2vN18X
X-Received: by 2002:a05:6512:8041:b0:5ad:5a14:4c1b with SMTP id
 2adb3069b0e04-5aea1f645b0mr1066558e87.36.1782402682653; Thu, 25 Jun 2026
 08:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <CALCETrWhXNetw-BsAaoyT31suMmjYLdMh9MAuLB2Lvk2ac-31g@mail.gmail.com>
 <CALCETrU3bgUxp0k1y-U-uL0-fW2016Gmsyu9O_=830czEUGMcQ@mail.gmail.com>
 <103524f8-1658-41df-88e9-cf49c628a721@app.fastmail.com> <20260625011023.GM2636677@ZenIV>
 <a75a9b82-a15b-4893-8f92-62b62664ea83@app.fastmail.com>
In-Reply-To: <a75a9b82-a15b-4893-8f92-62b62664ea83@app.fastmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 25 Jun 2026 08:51:11 -0700
X-Gmail-Original-Message-ID: <CALCETrVdtYeJ7rXmvymLpOvn6X4LsfHYoVmbL6XgTqnjcP5n7g@mail.gmail.com>
X-Gm-Features: AVVi8CeHU1loVo7LvRH0ljWOqNwsMMJXA7mgH3mrRcgo4SlKSTlcciqoC_CrBHo
Message-ID: <CALCETrVdtYeJ7rXmvymLpOvn6X4LsfHYoVmbL6XgTqnjcP5n7g@mail.gmail.com>
Subject: Re: [RFC] Null Namespaces
To: John Ericson <mail@johnericson.me>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Li Chen <me@linux.beauty>, 
	Cong Wang <cwang@multikernel.io>, Christian Brauner <brauner@kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 8:41=E2=80=AFPM John Ericson <mail@johnericson.me> =
wrote:
>
> Ah, I started replying to your first email, but this is better, this
> gets to the heart of the matter. Please don't mind me responding to your
> two questions in reverse.
>
> On Wed, Jun 24, 2026, at 9:10 PM, Al Viro wrote:
> > What's the fundamental difference between CWD and any open descriptor
> > for a directory?  Why does it make sense to ban the former, but allow
> > the equivalents done via the latter?
>
> Yes! These two notions are very close --- but that's the *problem*, not
> a reason to not care about the existence of the CWD and root FS. I want
> to get rid of CWD in my processes not because it is fundamentally
> different (it isn't), but because it is superfluous.
>
> If one is capability-minded like me, it's a bad mistake that we ever had
> this "working directory" notion to begin with, and yet another example
> of the folks at Bell Labs sticking something in the kernel that was
> really only needed by the shell, and that could have just been done in
> userland.
>
> The current working directory, roughly, is *just* some global state
> holding a directory file descriptor. But I don't want that global state.
> If I am writing my userland program (that is not a shell), I would not
> create the global variable. I do not appreciate the fact that the kernel
> foists that state upon me whether I like it or not.
>
> Now obviously we cannot have a giant breaking change removing the notion
> of a current working directory altogether. But we can allow individual
> processes which don't want it to opt out, and that is what nulling out
> these fields (and updating the path resolution code to cope with that)
> allows.
>
> There is no loss of expressive power doing this, because one can (and
> should!) just use the `*at` and file descriptors. But there is, however,
> the imposition of discipline. The programmer (or coding agent) is
> encouraged to do everything with file descriptors rather than path
> concatenations etc., because they need to use `*at` anyways, and then
> voil=C3=A0, without browbeating anyone in security seminars or code revie=
w, a
> bunch of TOCTOU issues disappear simply because doing the right thing is
> now the path of least resistance.
>
> > Please, start with explaining what, in your opinion, a mount namespace
> > _is_, and where does "mount X is attached at path P relative to mount
> > Y" belong.
>
> Let's take a pathological example:
>
> - Process A has `/foo` bind-mounted at `/bar/foo`
>
> - Process B has `/bar` without that bind mount, and `/foo` mounted at
>   `/baz/foo`, as is possible because it is in a different mount
>   namespace.
>
> If A opens `/bar/foo`, and sends it over (via socket) to B, and then B
> does `openat(recv_fd, "..")`, B will get `/bar`, not `/baz`. This is
> because `..` is resolved according to the mount referenced in the open
> file. (This is, by the way, very good! Directory file descriptors would
> be perilous to use if this were not the case!)
>
> The moral of the story is that "mount X is attached at path P relative
> to mount Y" is information accessed in the mounts themselves (maybe via
> their containing mount namespace, per the `mnt_ns` field, or maybe not,
> I am not sure, but it is immaterial). In contrast, the mount namespace
> of the *opening* task (`current->nsproxy->mnt_ns`, and current is B)
> doesn't matter at all for this purpose.

It's sort of a combination -- read the data structures :)  Other than
the propagation part, they're really not that bad.

In any event, I think this discussion is sort of immaterial to the
proposed API change.  No one is about to remove the concept of a mount
namespace.  But maybe it makes sense to have a way to have a task that
doesn't actually belong to a mount namespace.  A mount namespace is
certainly going to exist.

There will definitely be subtleties.  For example, what happens if a
task with "no mount namespace" tries to do OPEN_TREE_CLONE?  In some
logical sense it ought to work but it ought to be impossible to
actually mount the resulting tree anywhere, but this risks running
afoul of all kinds of checks.  Maybe you get a whole new mount
namespace (that does not become your current mnt_ns) if you
OPEN_TREE_CLONE?

This stuff is complex and it probably makes more sense to keep changes simp=
le.
