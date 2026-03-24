Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E85538BF91;
	Tue, 24 Mar 2026 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774345763; cv=none; b=ZQBYj8yVZzvkpsLxp8qXYifBknyeU+iR8t0V25S/238qomgKv4miJckndzELE8MfuBTooqdrqDAYMxMKsyxCkJ0ewH8qWX1miC1taMcjbdsWMpUWTx9wl/DTDgJpa+zw28cvHwj/H0UYMHhroIJiYskQKThGnBYkTpBNtiezHYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774345763; c=relaxed/simple;
	bh=mGGWDlEvCtszoQ4/LJ6ikAD4qizFbOUQQcMjcavfSns=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9NaYq6kwIOgDCUxkFLZEU/EZf9d85OK0svbkZFAisXXrGyrhmbC7W9lSSv6cMIT9IKTZEj+EVlccWvNww/MWubDOoEPxnrS73ZQDPf7g/1oD3cEeac20nmbTcBDml7JK+5CO/kF0V+fwdQV1kZC/9vx5rsGJwY/0/X4lWU9S5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6arPN0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6arPN0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9215C19424;
	Tue, 24 Mar 2026 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774345763;
	bh=mGGWDlEvCtszoQ4/LJ6ikAD4qizFbOUQQcMjcavfSns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=s6arPN0U24/Fr+Rq2HroLc7XGolNgyXpLUS7OfX9jS4W0CIXSh+XfQnfnGof9nijp
	 cn4hFV5vFuUZRdi4ptiXHkkam+Gtdk3IkXbcsEW6svpU4vI8+gJxqUgReY98XJ6sDP
	 WaaVe3eRyk76rc/7iai71Tgu2knd0qRMlnxhP3BPJrwaXUBKSGspud03xJtqhDX5WD
	 B490sFh3DzI/sfI3xby8FmR18rFs9dn592eszo49+XtEfoQSa6XKokcNxfntMakKm9
	 D+GZmmnZD9VsEx6j2cFP6Tg1eZB6pJtbuueuo2wTO4MWvM/Kf3oJIXuqsL8NoDNBvq
	 hvPygNyFTU3Tg==
Received: from localhost ([::1])
	by mail.kernel.org with esmtp (Exim 4.99.1)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1w4yO0-00000006aCM-34XV;
	Tue, 24 Mar 2026 10:49:20 +0100
Date: Tue, 24 Mar 2026 10:49:19 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
 workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org, Thomas
 Gleixner <tglx@kernel.org>, "Paul E . McKenney" <paulmck@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Dmitry Vyukov <dvyukov@google.com>, Randy
 Dunlap <rdunlap@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Kees Cook
 <kees@kernel.org>, Jake Edge <jake@lwn.net>, David Laight
 <david.laight.linux@gmail.com>, Askar Safin <safinaskar@zohomail.com>,
 Gabriele Paoloni <gpaoloni@redhat.com>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann
 <arnd@arndb.de>
Subject: Re: [PATCH v2 3/9] kernel/api: add debugfs interface for kernel API
 specifications
Message-ID: <20260324104919.00991a3a@localhost>
In-Reply-To: <acHTupVGxJR3gmFT@laps>
References: <20260322121026.869758-1-sashal@kernel.org>
	<20260322121026.869758-4-sashal@kernel.org>
	<2026032309-jargon-stalling-28c2@gregkh>
	<acHTupVGxJR3gmFT@laps>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Sasha,

On Mon, 23 Mar 2026 19:58:50 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Mon, Mar 23, 2026 at 02:52:58PM +0100, Greg Kroah-Hartman wrote:
> >On Sun, Mar 22, 2026 at 08:10:17AM -0400, Sasha Levin wrote:  
> >> Add a debugfs interface to expose kernel API specifications at runtime.
> >> This allows tools and users to query the complete API specifications
> >> through the debugfs filesystem.
> >>
> >> The interface provides:
> >> - /sys/kernel/debug/kapi/list - lists all available API specifications
> >> - /sys/kernel/debug/kapi/specs/<name> - detailed info for each API
> >>
> >> Each specification file includes:
> >> - Function name, version, and descriptions
> >> - Execution context requirements and flags
> >> - Parameter details with types, flags, and constraints
> >> - Return value specifications and success conditions
> >> - Error codes with descriptions and conditions
> >> - Locking requirements and constraints
> >> - Signal handling specifications
> >> - Examples, notes, and deprecation status
> >>
> >> This enables runtime introspection of kernel APIs for documentation
> >> tools, static analyzers, and debugging purposes.
> >>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>  
> >
> >Debugfs logic looks sane, nice.  
> 
> Thanks!
> 
> >But this only works if the kabi stuff is built into the kernel image,
> >right?  This doesn't work if any of these abi sections are in a module
> >or am I missing that logic here?  
> 
> That is correct, for now.
> 
> I'm only trying to tackle syscalls to begin with, and since no syscalls live in
> modules, we have no need for module support.

Have you seen tools/docs/get_abi.py?

It handles debugfs/sysfs descriptions from Documentation/ABI/.

Its "rest" command converts ABI specs from it into RST. 

The "undefined" command does realtime introspection for sysfs ABI,
checking if they're documented.

Perhaps you should consider integrating it on your new tool.

-- 
Thanks,
Mauro
