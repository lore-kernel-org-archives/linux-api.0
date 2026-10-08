Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2EE4CB8B5;
	Thu,  8 Oct 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791470773; cv=none; b=uyEmpKwx0ieXcuxKhTScUGOAjMmk3BBhTYXDU4eodzsy76THvJZoA7OC6b0dBSt4DQFN99p/J0OxZ1Sv6pyH4wrscS+0KvFXWhqGRP3N11deHlTiuj+upQjYjQPIteSHuQlZ683atJzRgHCxAr/RXISkailV/2sWGQcZo98Ek68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791470773; c=relaxed/simple;
	bh=MVEV9yjSB9tNALeuWefzERFXLmdUYsA24XQRLOpTNfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQavuHEHtdwrlBxAg10ylbJs79ksTK6MVGb1/idgFyekprDqJfTgaQKPAkf0AeFNiQGdb8y+1zQjKmwUeUCqZx3GB2i8eWCBmmy4WjRp8mg7rToDb8+axKsTl/YSgvjmpt8guAZ9OllG1rBnUJL6VKqB3I1i818stAGOWwZXB1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=unknown smtp.mailfrom=hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=cVrae5Ai; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="cVrae5Ai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1791470761; bh=MVEV9yjSB9tNALeuWefzERFXLmdUYsA24XQRLOpTNfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cVrae5AiujcKzze1N9hA2EqJp+i8rFPLEO+6zDYHPz1z9UWfGnhqyuf/LOCNFikMb
	 MjTJPPW+D8Cd7b8Hg8hkUKTRODY3NjMHtqX6d8hu0QbLA4qWgy5vqGmEfszh06Izm6
	 Y3udqlh56KqpqTbEISFGd9CA/YGVlbb5DMjl4TIxJH0EbG56utOSC7I9xE8P3qbN5u
	 ewXDBaYLtJW4OwLJ/4lQsqyf2g+AYHIk3eKLrbFYl1n7il3NKtKyrCrA+hgXliNSLR
	 r077T7GwKiW88gefbmbCU08wB3wRbxenKZlN185lpyMR2BN2xNjjor8DPExHlv2gHv
	 LQunQAiSZbQDg==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 24683196B; Thu,  8 Oct 2026 09:46:01 -0500 (CDT)
Date: Thu, 8 Oct 2026 09:46:01 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
	tools@kernel.org, x86@kernel.org, Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v5 05/11] kernel/api: add API specification for sys_open
Message-ID: <asesqWv1gv0lPZhD@hallyn.com>
References: <20261008084956.2911790-1-sashal@kernel.org>
 <20261008084956.2911790-6-sashal@kernel.org>
 <aseRXi7hMWBBc0tB@hallyn.com>
 <aseWPV6ZRQM3JOMN@gourry-fedora-PF4VCD3F>
 <asemkQ2v0di0Eea3@hallyn.com>
 <aseqx-uc_QySDiiw@laps>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseqx-uc_QySDiiw@laps>

On Thu, Oct 08, 2026 at 10:37:59AM -0400, Sasha Levin wrote:
> On Thu, Oct 08, 2026 at 09:20:01AM -0500, Serge E. Hallyn wrote:
> > On Thu, Oct 08, 2026 at 09:13:38AM -0400, Gregory Price wrote:
> > > On Thu, Oct 08, 2026 at 07:49:34AM -0500, Serge E. Hallyn wrote:
> > > > On Thu, Oct 08, 2026 at 04:49:45AM -0400, Sasha Levin wrote:
> > > > > Add KAPI-annotated kerneldoc for the sys_open system call in fs/open.c.
> > > > >
> > > > > The specification documents parameter constraints (pathname, flags
> > > > > bitmask, permission mode), 24 error conditions, locking requirements,
> > > > > side effects, required capabilities, and usage examples.
> > > > >
> > > > > Assisted-by: LLM
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > >
> > > > I know Kees and Jonathan and others asked for exactly this.  But one
> > > > downside to this is it makes just paging through fs/open.c a lot more
> > > > painful.  Maybe it's worth it.  Maybe "noone will ever do that again" bc
> > > > that's why we have ai and tools.  But a) that's how I've historically
> > > > done a lot of code research, b) IMO something like a manpages section 2
> > > > under Documentation/ would be a great place for this, and c) we can also
> > > > use tools to always sync these, or even show/edit in a single view when
> > > > you want  ('kdocedit fs/open.c').
> > > >
> > > 
> > > In many, many other projects i've worked on, these docs are placed in
> > > the header as opposed to the .c file, but I understand there is some
> > > pain that comes with ifdef.
> > > 
> > > Keeping it in the header ties the definition to exactly the location
> > > external users import to find the function - so it makes sense.
> > > 
> > > But separating the contracts from the code guarantees they'll go stale,
> 
> My plan is to be able to have the more detailed part of these specs somewhere
> else, specially as they will grow some more, but I didn't want to add this
> complexity right now.
> 
> > OTOH these descriptions are so long that IMO they are guaranteed to go
> > stale anyway :)  While I'm editing a return value at the bottom of the
> > fn, most or all of the description is already going to be off my
> > terminal.
> > 
> > > so I don't think shoving it in Documentation/ does anyone any good.
> > 
> > If every build auto-generates an update and then looks for and flags
> > meaningful changes (API breakages), then a) that is more reliable and b)
> > it doesn't matter where the docs are.
> > 
> > Even if there's just a three line comment above a fn, history proves
> > that it will not reliably stay in sync as the fn changes.  An automation
> > step/check is needed.
> 
> Please see CONFIG_KAPI_RUNTIME_CHECKS added by this series.

My point was just that whether the docs are inline or not, they will go
stale without that automation.  So if that's the case, then the docs do
not need to be inline.
