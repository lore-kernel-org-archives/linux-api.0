Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D26388E76;
	Thu,  8 Oct 2026 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476221; cv=none; b=VVYtU+kcfaK4Agzzg61zgJdRxiG3p9loox3as3YqP6+a8BUp5uw3qZQV1IhGS8Wd2yX8+s4gbUi3jlH9mHmnAfSUwdITLZlZdNkGgS0x+DOTz/QwH1CiMl5ahCifF4p+pX3c810Zgpiqazybojgyob0WnSumgiCUdxkN8NVr2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476221; c=relaxed/simple;
	bh=ONUAXTXET2uph2ufarl0JR+mBNLNazRrkGyxBpG9j4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHR1USf1ZyBXEyuIVaGnhPU7frEkyUjC8MDk4TcdXMZsxi4rRZog9D5M+Tuxwkcn65Xl6V5G83KR78FtUNjumMn+5pcZiI6wwAr2ynhOtaufW0k28SWVkI5ckoFgA/6V2pQKui5jnD6xu2kwSmHe0OeFR2jSrg3aRSGwzWUy+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=pass smtp.mailfrom=hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=Yc2Uacvw; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="Yc2Uacvw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1791476206; bh=ONUAXTXET2uph2ufarl0JR+mBNLNazRrkGyxBpG9j4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yc2Uacvw/E8IC28sxXYwsgrwszsBc78gC0v31tgczm3TUURjBC6dT9qzn0ggd64gq
	 QjPyeWKyeoRQwZpk4C/p3XxjygiZXH51hK465fbWOKEpvamDUDqilUeF1enE3vwsS1
	 Sb3ubVNpFDt7bIpFLiuX9kowTVZBYkLd8cmikJkEdmVmY8QY8B6sjBeBaLw91GCKAd
	 /xvJW7ygChmDOhJcjpWbQhdJwFHlyx86JWpoebmCL/3z2VPphM3ZcSwh8pPlQzWLNK
	 sLD/G6HPsB6z9aAZSDnHT8qc+Tj2DioSedN97XYBXA76y/VFIhwxD8J09ObjieTlrP
	 MBNbaoIsETP9w==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id B5C69E7D; Thu,  8 Oct 2026 11:16:46 -0500 (CDT)
Date: Thu, 8 Oct 2026 11:16:46 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, Sasha Levin <sashal@kernel.org>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
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
Message-ID: <asfB7tHWs420QkWL@hallyn.com>
References: <20261008084956.2911790-1-sashal@kernel.org>
 <20261008084956.2911790-6-sashal@kernel.org>
 <aseRXi7hMWBBc0tB@hallyn.com>
 <aseWPV6ZRQM3JOMN@gourry-fedora-PF4VCD3F>
 <asemkQ2v0di0Eea3@hallyn.com>
 <20261008171205.7239c463@pumpkin>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008171205.7239c463@pumpkin>

On Thu, Oct 08, 2026 at 05:12:05PM +0100, David Laight wrote:
> On Thu, 8 Oct 2026 09:20:01 -0500
> "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> ...
> > 
> > Even if there's just a three line comment above a fn, history proves
> > that it will not reliably stay in sync as the fn changes.  An automation
> > step/check is needed.
> 
> The only way it can possibly stay in step is to have the compiler process
> the same source text.
> Then, if you add/change a function parameter you'd be pretty much forced
> to add/change the comment.
> Return values would have to be documented at the C return statement and
> really as an extra parameter to the return.
> 
> But, IMHO, the whole thing adds too much bloat to the source files.
> When you 'grep' a source file, you don't really want another match in
> a big comment at the top of every function.
> 
> David

That's why I feel all this info that Sasha has added should go into a
Documentation/uapi/ autogenerated directory.  Auto-updated on every build,
with warnings if the result has changed.

-serge
