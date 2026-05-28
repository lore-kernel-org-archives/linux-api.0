Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1583DFC82;
	Thu, 28 May 2026 11:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779966186; cv=none; b=VL4VFvpdhQXyjmVBJdqENf46IIDKJ2olFokarZM5ajj5jDThGdlzC60tq1xpduRqG9aBGAggKYrEPYnRnsnAjfvNw7tXFNg0kghdnpkQgIyTn+RIgz/yVDfW2CO4rrSOuwx5BeP9TCTPxCARxt+p9GlFh1W0JzwlznOkq50rgYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779966186; c=relaxed/simple;
	bh=IyobJ07gZquirzdRMhL9lwAbGUYF3JLJgWcI717MFGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXAzmhIxWl3yM9eFtJtVQ9pdntcIu8OvYGMBhj1LaBvrxpfCKmBJAVbtrdhi3uvPWbXA74VOr9TmruxOWDZrId/beue7PufN4eskvhP5PQRPTQqFTTWHtB65wrjDeF5QLAYAY04OsPxQ1WW3WMmKtabAZV5yik+eazkGugYVVUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIcGObyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIcGObyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579601F000E9;
	Thu, 28 May 2026 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966181;
	bh=XKOsaV5agj5ZF2LCn9OwHL3I/NXH5DsoLdW7z8XfuWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EIcGObyHg7KH6/938ojTjdYoGEZyqrONHwbJhnbwGWZaJMDw6xN0Z/glfoVyHnwOE
	 ZCCSlqEfgIXhctCmLa0/xITHftUSreWpMfdv1Q42RozcuCUKx4PbiO0uFYolQojqSb
	 seL4tph1nhw2S9eVIXMuXYQDoopecAQ6gteYQ/L2zGLwH2UfjoAACdubIzxQZLVLgU
	 ExaQBMwEPj1a27vzps0J8nGRuMkIiXpIJKB0S1YdVu/Av1l1OAVJ5W2W9zb/AyHCpl
	 NV8KZTOtlCbu0EX4R+lUH3PwRuyCzOJpQA4rKvVo4YDn9wsH6VA1fUbuD/Iz8qy5N6
	 OdNyxAOE/Gu4Q==
Date: Thu, 28 May 2026 13:02:53 +0200
From: Christian Brauner <brauner@kernel.org>
To: Li Chen <me@linux.beauty>
Cc: Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
References: <20260528095235.2491226-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>

On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> Hi,
> 
> This is an early RFC for an idea that is probably still rough in both the
> UAPI and implementation details. Sorry for the rough edges; I am sending
> it now to check whether this direction is worth pursuing and to get
> feedback on the kernel/userspace boundary.

The idea of having a builder api for exec isn't all that crazy. But it
should simply be built on top of pidfds and thus pidfs itself instead.
It has all the basic infrastructure in place already. Any implementation
should also allow userspace to implement posix_spawn() on top of it.

fd = pidfd_open(0, PIDFD_EMPTY /* or better name */)

pidfd_config(fd, ...) // modeled similar to fsconfig()
