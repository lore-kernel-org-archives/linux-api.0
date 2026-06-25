Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE341176238;
	Thu, 25 Jun 2026 03:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782358893; cv=none; b=MKbys026SoVRM1gQCr+9PSh51U4xdYdAs1T01JjUXq84NLdVpJP0x+H5SfyzCQEj+E3K8QNc5BheE3ucO0Io+mevwWT2vi+LtMuBWmAanPZh8VagG07dDQGK0TuLbs81cYzDaxS3NfrVDAX2zZf3MptfsCTZ39tqk6/Or2vLwEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782358893; c=relaxed/simple;
	bh=1b8491NiBf4oRUYibKv57V5l3o0D9cGEPxDoCVVsCsA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=J8OcRnILpBHLqCaqQzUYC7K8PJ3XHc2w78G6Tge4WL1LVhxABmjori+YM4JewzQ3tyjnrkidfpUNPT1Bw+MIu/uRnspFHj6Ok5eq58Ij1gW6OQLg+hIuKBhErbtbvlCDXlEB757puWT2vHdTJI9PR5+1eWJ/9ItSxcVQz4sxf38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me; spf=pass smtp.mailfrom=johnericson.me; dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b=E3YyoYVS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=O4MOHO2m; arc=none smtp.client-ip=103.168.172.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnericson.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b="E3YyoYVS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O4MOHO2m"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id ED2281380300;
	Wed, 24 Jun 2026 23:41:30 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Wed, 24 Jun 2026 23:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782358890; x=1782366090; bh=5+lJe3bNGVItVn6B+rNzShQxgl8DKdHB
	QcEr+NONrcE=; b=E3YyoYVSVAcpw8g068+og1sIryKoQR8rIwxTuZKuvNTUDYxL
	+yX2qgZmywBKrQ1bqArU+A32ULdGJ4kHlSpF8a/adcHpnBSmCuV3JVFbI354eFvD
	FP3FzoHvbQwhPnoKXrxCV8OVIaica4Xq1oEIIWRHf5a/oyu5h3NzP9VWAtUDuy/5
	LdCVJ8mKWNj6AxXymy2iEBv3PlR5THSG0d15tmXMsdTEWmr78bduPwCt6jTR9baR
	p2oqdQ/Nv/duap4Qm7UZCe0//6CWELyfOWwI6cnuWLc71WntmhuCBxjXG8dCyY5m
	oCHe1UKOLLU+4mZsV9OmfKwHoKUo2YrTGnp/tQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782358890; x=
	1782366090; bh=5+lJe3bNGVItVn6B+rNzShQxgl8DKdHBQcEr+NONrcE=; b=O
	4MOHO2mkN1aSrV1W3ZCS1+Cm3HTHN5bhztCFCTXfUfUTXpm+3HCCf8j/UWsr1zxF
	IWq0acee26Y32bxj668GXZWGoy6QPYeYc21TZL7/Y7+7ChBcC9jI/a29AipD5Ck/
	gCy+rHCpp6Ma8C0/eqIDOxCF4vP+ME4ZXEJBa+nOcIUYUYfW/sqb0FPZWpx7JzyC
	JB3cZa84eiig6EV2Lv3q+tyzg7SzRp0gjyMQryfNnjx0QEVtxzfaJdMAw4/Gggj1
	hSuYY31EBq26v3H1Cs7rZYsLvqCX5uC9OK3RI0Mf/YtQffWWtsR2xD9AUHDu1x9J
	J45fUsiCn8qtANR1n11ww==
X-ME-Sender: <xms:aaM8amDITqozBHwkbroN2j23EkDU75NFiIjTCoLbP1ar7WB-t4SkmA>
    <xme:aaM8arVkoB9iGSXHiH3QNLmUumym_DEePgPMX-OcdAijdAN-O6b0CdGEMxGR-OtkP
    r8KlqUsAPppLCeaZQkROTIcOuQ1bRe4mE_AhzSc0y36CuShoWxccuo>
X-ME-Proxy-Cause: dmFkZTEOSZ1G/dhNAKDsT+2j3RzjT8bsDvJokJhgbWbC8Ku0+jtd3bjWkuI11V1VYxVqXC
    bnZi3Cz8f4Htpgs2AVsZDMf3L5HtP7FBps6/iy1Al0MlzKmaTito2Dh1WVZ7z8JAf0XwzA
    VE9JNAspfHMrvPg3ZuRXFV/VJaCRNG89FrilxuEk0l+WwWER5MfmMQEOeuygWia9AZ50Im
    5WavG8uKqPUl7SwZFKqp9ubQPCJTJq9YtdYZ2PsYCOXxDjjYCWDcCiQB8gSQItzsy1cute
    FB36Bvxv4oXqOlm+nRn0l/9FMwuTMQI+x9AWAq6pH3g5+A+oIP7Fg504BaVpzrZ8rrI+Xn
    IHJ6pjj+X4SAWZJF4gY+bJF1EIokUEDotICk5P3DEyxnDqrSDD+/h497/BPbVDLff0Pz1c
    DK60JyYXh3yb2WY6uPMB6YusnQ2TlHbWgJxA7QsuSm+EZlz8igz+qs6flBBmipzcbWISdr
    bzlpLEyv9RFZGf3riC2bBfetfb0ZTESlNTxCY9HK+q18fl8I3bk3VgFfJ0Tx27iIqM9kjj
    T+1K27Gq0ESgwrPkdmdcIP+3tqwZ6Z6FigVOkfU2BC7buhX4nCXGssqZGoEtpzEVqIkRwf
    eIRQFDHvIBFmsn2dDxrDCZt/O1XXjE0uDIrtfeBrM5BJhyOtbv2LFVfgYc0w
X-ME-Proxy: <xmx:aaM8aswNxZLKq7MPjgzd7ntvjkfBnmnnl0jkPAgmVndDI2N5qqVNJA>
    <xmx:aaM8atd-lD4pQbZHuoJNlRxcpk_cGP0hB85PCW5YupTvvRGzPot_dA>
    <xmx:aaM8ai2kGmcjJVLBWbJ_Q_pFH5998FyzEzQrIG0AiGr5Z2I5tx0l6Q>
    <xmx:aaM8amtcHUscJ24DZ2pLyn0qNk1mWRpuvlhaxdMOM1ZAjqq5zYfCOw>
    <xmx:aqM8apyuhcwJO-e4yDAPnt-66N8-IcJqf-rXlLowI4NDDiGkCD2uUEkR>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A8CF82CC0088; Wed, 24 Jun 2026 23:41:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AG8qDlxFSDr7
Date: Wed, 24 Jun 2026 23:41:07 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Andy Lutomirski" <luto@kernel.org>, "Li Chen" <me@linux.beauty>,
 "Cong Wang" <cwang@multikernel.io>, "Christian Brauner" <brauner@kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-api <linux-api@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Kees Cook" <kees@kernel.org>, "Sergei Zimmerman" <sergei@zimmerman.foo>,
 "Farid Zakaria" <farid.m.zakaria@gmail.com>
Message-Id: <a75a9b82-a15b-4893-8f92-62b62664ea83@app.fastmail.com>
In-Reply-To: <20260625011023.GM2636677@ZenIV>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <CALCETrWhXNetw-BsAaoyT31suMmjYLdMh9MAuLB2Lvk2ac-31g@mail.gmail.com>
 <CALCETrU3bgUxp0k1y-U-uL0-fW2016Gmsyu9O_=830czEUGMcQ@mail.gmail.com>
 <103524f8-1658-41df-88e9-cf49c628a721@app.fastmail.com>
 <20260625011023.GM2636677@ZenIV>
Subject: Re: [RFC] Null Namespaces
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ah, I started replying to your first email, but this is better, this
gets to the heart of the matter. Please don't mind me responding to your
two questions in reverse.

On Wed, Jun 24, 2026, at 9:10 PM, Al Viro wrote:
> What's the fundamental difference between CWD and any open descriptor
> for a directory?  Why does it make sense to ban the former, but allow
> the equivalents done via the latter?

Yes! These two notions are very close --- but that's the *problem*, not
a reason to not care about the existence of the CWD and root FS. I want
to get rid of CWD in my processes not because it is fundamentally
different (it isn't), but because it is superfluous.

If one is capability-minded like me, it's a bad mistake that we ever had
this "working directory" notion to begin with, and yet another example
of the folks at Bell Labs sticking something in the kernel that was
really only needed by the shell, and that could have just been done in
userland.

The current working directory, roughly, is *just* some global state
holding a directory file descriptor. But I don't want that global state.
If I am writing my userland program (that is not a shell), I would not
create the global variable. I do not appreciate the fact that the kernel
foists that state upon me whether I like it or not.

Now obviously we cannot have a giant breaking change removing the notion
of a current working directory altogether. But we can allow individual
processes which don't want it to opt out, and that is what nulling out
these fields (and updating the path resolution code to cope with that)
allows.

There is no loss of expressive power doing this, because one can (and
should!) just use the `*at` and file descriptors. But there is, however,
the imposition of discipline. The programmer (or coding agent) is
encouraged to do everything with file descriptors rather than path
concatenations etc., because they need to use `*at` anyways, and then
voil=C3=A0, without browbeating anyone in security seminars or code revi=
ew, a
bunch of TOCTOU issues disappear simply because doing the right thing is
now the path of least resistance.

> Please, start with explaining what, in your opinion, a mount namespace
> _is_, and where does "mount X is attached at path P relative to mount
> Y" belong.

Let's take a pathological example:

- Process A has `/foo` bind-mounted at `/bar/foo`

- Process B has `/bar` without that bind mount, and `/foo` mounted at
  `/baz/foo`, as is possible because it is in a different mount
  namespace.

If A opens `/bar/foo`, and sends it over (via socket) to B, and then B
does `openat(recv_fd, "..")`, B will get `/bar`, not `/baz`. This is
because `..` is resolved according to the mount referenced in the open
file. (This is, by the way, very good! Directory file descriptors would
be perilous to use if this were not the case!)

The moral of the story is that "mount X is attached at path P relative
to mount Y" is information accessed in the mounts themselves (maybe via
their containing mount namespace, per the `mnt_ns` field, or maybe not,
I am not sure, but it is immaterial). In contrast, the mount namespace
of the *opening* task (`current->nsproxy->mnt_ns`, and current is B)
doesn't matter at all for this purpose.

I am not on a crusade against `struct mnt_namespace` in general; I am
just trying to null out `(struct nsproxy)::mnt_ns` in particular. (This
is just as I am not on a crusade against `struct path`, just `root` and
`pwd` of `struct fs_struct`.)

These days, `current->nsproxy->mnt_ns` is, to me, first and foremost,
there for the legacy mount API. Again, just like our CWD example above,
this is mostly just global state.

The new mount API drastically [^1] reduces the need for it, since it
allows referring to mounts explicitly via file descriptors. That's OK!
The argument is the same as the above --- I am *not* trying to limit
what can be done if one has all the right files open with the right
perms. I am just trying to limit what works out of the box --- to reduce
the default set of privileges, *especially* where the resources involved
are implicit and/or stateful.

[^1]: It doesn't *quite* eliminate the need for `nsproxy->mnt_ns`
    entirely, since (as I understand it, from reading the `move_mount`
    man page) it is still used for some authorization checks, since
    `O_PATH` file descriptors do not grant privileges other than mere
    discoverability. But that's a problem that could be solved later
    with an `O_MOUNT` option analogous to `O_RDONLY` or `O_WRONLY`. In
    the meantime, I am perfectly happy if my processes with null mount
    namespaces get `move_mount` permission errors.
