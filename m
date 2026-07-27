Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952A3E6DD0;
	Mon, 27 Jul 2026 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785142798; cv=none; b=c32qsdG3/0KDPhmUaJuNvRoPY/CwgRy2eAIQjpgBim25aje3sLL4BtrI+J8BBR3vbFWJIBy5pyiHwac1Mjklygi+51OYKwaN3d4nVh0Z8bEHHxgigxCtIyXjXMtWLvGS5GRiBtHX/or+l/EjuIpleuwvavSaEidbzbicqnz7L3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785142798; c=relaxed/simple;
	bh=XmnX3xaTMospqFBFtkSGCx4suLEYFdzEmv8vhopXmbk=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=QfVU1TSqQGMkTbQG86fOprkbrZhibrAGS7W2W85wU0ODOIzUVOeVhxE+wGXBTAWgMUKDu28CAIynJkSVIIRxR7TgxM/LShWPJbtowP5CUCYNkotVf5Buolhux7IAG9S1mqeVCtvvuzYoyGfpyCDmRTe8TBE0qqWs/8n6uuZE1Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKC2ruj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKC2ruj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980AC1F000E9;
	Mon, 27 Jul 2026 08:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785142796;
	bh=/wwZ0jYC5didrHnlyUhU5niX1eJOA3eG9/+DW+HYdYA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=mKC2ruj82qnFoCRXzEVa1AVYIry5m3KzSavK+fQ8krsKPBWJtoPqNQBq8TcFhEfPZ
	 b06nPvNGZGO8hVG/byQkaVVSCfXjamLdB84wCZq5xYYtZVOEeY6rq4NlsMhzcRk8P8
	 OAvFK0Gr7IvMGgoWepqDJwI/vtF1tS9FpbxDWRi7fmziVpfvlKLim08L2vCfR1RqSn
	 HrqdzUaL2GaOi9Wb/UEO9mpq+/Sp/RF1x10SbDkc6Mk8kEwpkqjuBgBF8zFaEWa7GC
	 KDTYBxCJAihHM54KGFcLCCg+tIzQj1LHA3kezIfVcnBDxlmw33decJ/ZyeOACZjhho
	 d1nCO72l5XClA==
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Ericson <mail@johnericson.me>, Andy Lutomirski <luto@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jann Horn <jannh@google.com>, 
 linux-api <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc <linux-doc@vger.kernel.org>
In-Reply-To: <CALCETrVSKnT=wo8j+3bUBjcizEEWcg_a7WtfK_erLDGRqp3f-g@mail.gmail.com>
References: <09b4735f-c04e-40f3-a7f5-254b7918fbfd@app.fastmail.com>
 <ABB3CF80-5F05-4279-8E0F-73A21E6B9DDA@amacapital.net>
 <CALCETrVSKnT=wo8j+3bUBjcizEEWcg_a7WtfK_erLDGRqp3f-g@mail.gmail.com>
Date: Mon, 27 Jul 2026 10:59:51 +0200
Message-Id: <20260727-nasen-gezweifelt-weitverbreitet-d6c0d9f5d28b@brauner>
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=1662; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XmnX3xaTMospqFBFtkSGCx4suLEYFdzEmv8vhopXmbk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSly3Gmm8z4n9s8YaHgMnnWYL55Zn93/MjxmmYhEOek2
 bts5RuBjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInsmsbwP8z00bcTO9hLWN5/
 KKtf2/Vr56UlG9dyvDnc885tx+ZNHYyMDHs9J5crrvVKvCTfaXncYU/7iiPOB1e3qnH1mJeltv6
 R4gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-27 00:57 -0700, Andy Lutomirski wrote:
> > On Jul 27, 2026, at 9:43 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > ﻿
> >>
> >> goes along way to getting Capsicum's "capability mode".
> >
> > One thing I dislike about this is that it’s (approximately) a task mode. Why should an fd representing a capability represent one capability (a subtree) to one task but a different capability (dotdot) in a different task?  Do we need to prevent unsharing a userns if this bit is set?   Do we want to have to worry about any task that could potentially SCM_RIGHTS and fd to a task without that bit set? I prefer beneathness being an OFD property.
> 
> Sigh, I keep thinking and typing OFD, and that won’t magically make it
> be correct.  All these privilege restrictions applied to a file or
> path reference need to follow every user-controllable reference around
> correctly.  So if I fchdir or fchroot to a restricted OFD, my cwd or
> root needs to preserve those restrictions, and reopening "/" or "." or
> any other path (via root or cwd or openat etc) needs to respect the
> restrictions as well.  Putting it in struct path may or may not be a
> good idea.

I think making struct path carry more meaning than it does right now
will cause us endless amounts of subtle issues. I fear that change very
very much. That will have such a fundamental ripple effect across _all_
corners of the codebase that I'm very unwilling to be led down that
road. And I think Al had traditionally similar reservations as me. One
of the really thorny issues with the O_PATH upgrade masks was precisely
the struct path modification.

