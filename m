Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDDA3E8678;
	Tue,  5 May 2026 07:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777967169; cv=none; b=eyyD6h4DMoqAMp8TVUgMh2jCVa/ESzgd+ukmszitnzxm0IZA8HdYDZ300vaAYP1FIfzItZCsIrrSYQ5yozT27Z+OiEiNTIy/iR4qmN0RBN1L712cBSlDVU5mODprNCCAzfbRZhCBQKkGkMYJQsO+ySQecuGMxP6gv5CilcMVNu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777967169; c=relaxed/simple;
	bh=JT5wMT1sCsg0RU/PTayQKO84i81hI2p6dfYOztR/VGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ppxdzTSkktrrTz6O8PzSDZPvdBngeWc4RIakhe7NzT5+dhbIaCuPrT1IPZWB+F4Phf8z6h31TeGdXzLgpvek7WJ5wzI9bwYiYso7QSGfCrMlw3heN7BNNKT1wWxNwT6bQTCL3BVxsAHrdav/nZFDanT2ZlivxTfrv2ELkEsqjnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+GB989b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+GB989b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3116CC2BCB4;
	Tue,  5 May 2026 07:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777967167;
	bh=JT5wMT1sCsg0RU/PTayQKO84i81hI2p6dfYOztR/VGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+GB989b1D6WCa0QN/ERbitOY7ZApGccfMd3uN+3EpYnDIfoQXsV/jhmUsDNjIpzx
	 ymirHWum/1CD3WruoXTSUKcAg6tLryb69b2SMiLN59SpNlSfG2hmfc6JrIl+oqa+vU
	 OC/yLYIE4+JmJoiymWsQZTnkfD9x7q8/EuZojKVf0+XQkttuc2MjS/clz35NXizRWW
	 rEE8sO0pTdHGOoF0qsrCKCaWZOLEGHJorufkc8gWCTLBlBiVUgzc2fQW2h8BXGuMnk
	 DAXrRABEIctXv69kQb/FnL5lNPO8xPZx0NPV/V+yQjX8p8A2E4a53Dm/r3ZLxzE4Wf
	 dCCYR0zGPDdSA==
From: Sasha Levin <sashal@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org,
	tools@kernel.org,
	x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 1/9] kernel/api: introduce kernel API specification framework
Date: Tue,  5 May 2026 03:45:40 -0400
Message-ID: <20260505074545.430334-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <177726106581.2478607.12645653803520391071.b4-review@b4>
References: <20260424165130.2306833-1-sashal@kernel.org> <20260424165130.2306833-2-sashal@kernel.org> <177726106581.2478607.12645653803520391071.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Apr 26, 2026 at 11:37:45PM -0400, Nathan Chancellor wrote:
> On Fri, 24 Apr 2026 12:51:21 -0400, Sasha Levin <sashal@kernel.org> wrote:
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index 6785982013dc..564315153643 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -59,6 +59,9 @@ obj-y += dma/
> >  obj-y += entry/
> >  obj-y += unwind/
> >  obj-$(CONFIG_MODULES) += module/
> > +obj-$(CONFIG_KAPI_SPEC) += api/
> > +# Ensure api/ is always cleaned even when CONFIG_KAPI_SPEC is not set
> > +obj- += api/
>
> If $(CONFIG_KAPI_SPEC) is not set, shouldn't
>
>   obj-$(CONFIG_KAPI_SPEC) += api/
>
> evaluate to
>
>   obj- += api/
>
> anyways? Why the duplication? This is the only place in the kernel where
> this would be needed?

You are right, the explicit "obj- += api/" is redundant. Nicolas pointed
to scripts/Makefile.clean which already evaluates obj- during
'make clean', so the conditional gate alone is sufficient. Dropped in
v4.

> > diff --git a/kernel/api/.gitignore b/kernel/api/.gitignore
> > new file mode 100644
> > index 000000000000..ca2f632621cf
> > --- /dev/null
> > +++ b/kernel/api/.gitignore
> > @@ -0,0 +1,2 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +/generated_api_specs.c
>
> This appears unused?

Correct, leftover from an earlier prototype that generated a single
combined .c file. Nothing in the current series produces
generated_api_specs.c, so the .gitignore is removed entirely in v4.

> > diff --git a/kernel/api/Kconfig b/kernel/api/Kconfig
> > new file mode 100644
> > index 000000000000..d1072728742a
> > --- /dev/null
> > +++ b/kernel/api/Kconfig
> > @@ -0,0 +1,77 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +# Kernel API Specification Framework Configuration
> > +#
> > +
> > +config KAPI_SPEC
> > +	bool "Kernel API Specification Framework"
> > +	default n
>
> I think 'default n' is tautological since 'n' is the default for all
> bool symbols. Consider dropping it on all symbols throughtout this file.

Dropped from KAPI_SPEC, KAPI_RUNTIME_CHECKS, and KAPI_SPEC_DEBUGFS in
v4. KAPI_KUNIT_TEST already uses "default KUNIT_ALL_TESTS" and is left
unchanged.

Thanks for the review!

--
Thanks,
Sasha
