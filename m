Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2673E40F5;
	Thu,  8 Oct 2026 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499625; cv=none; b=KJjdF1LwVFjGAObmEVweW6HntCBPO7CvAdCvobtjSw3M/lUl5cVaYpPWWgrpUa93T2VconfZ/Z9H/0MuEdXp6G22nzy8uS7C72xiEgqgleJ5qzI7znFVjUdfndaCTC4g2SfcolVXxb1zKJkrqHGKsZqdKepPQ28fGu/HjdmIN5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499625; c=relaxed/simple;
	bh=1xff5OP4JTlo3Wsm/jooTd+9avb5DjpWuRtnCb8Vg7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBm9dOzJYMYCfOJNZp4nxSSTAcJ1GoVYIZNwLGVuPOQQeqcHVtWcRU4uo+PKA5SWC0P06R95Cma4t0d+K2mzUWQF3oA6Eb7v1WW40rq94Pn2E3BB9xak+XVNMzwDjjZTadb6YKUDxbytezy53MAgtMBKZKsJ1uBdtL/8oKxrG5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiWatklT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiWatklT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0578B1F000FF;
	Thu,  8 Oct 2026 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791499624;
	bh=pCfJKPsNaF/SxbFsWfcA1FHSBJHgg6l/3ARJ3G8D/iE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YiWatklTha/8mDOvNOV4ymEYyqODHFwSzx3UXwKSES/mokMZYcEdudNXmJwRXrIgp
	 6A9mrj9RUzb/nIujVnVifEXe0So7H23ze7t4egFVedFW8PnEw+9+QHzUCKsQkTz7un
	 49AP0BiFCrDG1YPEOlqzrM61dqiynA7v4xubPo6CDj7kIxQ3QmSAtrShOAJa5JqOXC
	 lDrLy3BXBIOC9Bju+9E42B6lrAMwQcJhhvVTZOPLaoiAVt3ANPKzlcBS5KOnVldcYD
	 /AhFqUoAuKhZ0iqXDFAFLAq8Ow653o5CiXNcZmXm9u1K81AsiQaLBfx8tgPH9XeZJh
	 9ius3rVPTxQ5A==
Date: Thu, 8 Oct 2026 18:47:01 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	Gregory Price <gourry@gourry.net>, linux-api@vger.kernel.org,
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
	Jake Edge <jake@lwn.net>, Gabriele Paoloni <gpaoloni@redhat.com>,
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
Message-ID: <asgdZfjXmX3gnkfQ@laps>
References: <20261008084956.2911790-1-sashal@kernel.org>
 <20261008084956.2911790-6-sashal@kernel.org>
 <aseRXi7hMWBBc0tB@hallyn.com>
 <aseWPV6ZRQM3JOMN@gourry-fedora-PF4VCD3F>
 <asemkQ2v0di0Eea3@hallyn.com>
 <20261008171205.7239c463@pumpkin>
 <asfB7tHWs420QkWL@hallyn.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asfB7tHWs420QkWL@hallyn.com>

On Thu, Oct 08, 2026 at 11:16:46AM -0500, Serge E. Hallyn wrote:
>On Thu, Oct 08, 2026 at 05:12:05PM +0100, David Laight wrote:
>> On Thu, 8 Oct 2026 09:20:01 -0500
>> "Serge E. Hallyn" <serge@hallyn.com> wrote:
>>
>> ...
>> >
>> > Even if there's just a three line comment above a fn, history proves
>> > that it will not reliably stay in sync as the fn changes.  An automation
>> > step/check is needed.
>>
>> The only way it can possibly stay in step is to have the compiler process
>> the same source text.
>> Then, if you add/change a function parameter you'd be pretty much forced
>> to add/change the comment.
>> Return values would have to be documented at the C return statement and
>> really as an extra parameter to the return.
>>
>> But, IMHO, the whole thing adds too much bloat to the source files.
>> When you 'grep' a source file, you don't really want another match in
>> a big comment at the top of every function.

I guess I don't mind either way: I heard both sides of this argument, and the
spec workflow is okay with either, so if the relevant maintainer asks for
changes here I'm more than happy to reformat this.

Which is, I think, the advantage here: it works just fine for the various
"kingdoms" we have in kernel-land.

-- 
Thanks,
Sasha
