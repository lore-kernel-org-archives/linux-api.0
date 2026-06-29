Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235AD35836A;
	Mon, 29 Jun 2026 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782729605; cv=none; b=At2fqrBAQoqXIonYgeF676TdJHzZ71i7G67JMJkS7zFuswRiXTan/5IuD2nSrKna/n0aNo8tA+Jku+E2dFzyK/MMdAvtd7BKPPKR3OdNp/2h50bDLZrFptGnALA3sc5dFUS3N7vEsJSrLdtX/xqB1m30XpnXd5gzLTFFlZgvdtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782729605; c=relaxed/simple;
	bh=le/98cvh8bnpkFsgfhvQ9vhpjKzTUK7LEraAOs5UZDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgeld0H5mjDKwFq9xXuSxZ/zsLKRAfuPSrfMOV3jFhbWVM1kAf0QMpEGj9BeiGHtgIFWM8paoWL1MGRsVDRuXAJrJPbRDlq4jgpqiqlnnJT0Qc+QGFJUZOSBjr6I1aI+gdnzyiibEz/MQMNRKPNYGaLRaj0DCmBs9Vwbrprycvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHFH+JLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHFH+JLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CD41F000E9;
	Mon, 29 Jun 2026 10:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782729603;
	bh=le/98cvh8bnpkFsgfhvQ9vhpjKzTUK7LEraAOs5UZDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fHFH+JLiMXwWQn5pJh3p/9MVLmU9+uQiXEl4vUkRAbPO7NeMmTogzbRnuBXOnlNtR
	 Zt6fherKrZevxa3oF/byBPaEpWRbCTHMejhwhLNdsnsmbaSim0T1XSRtWXJenkd2AZ
	 DvXBBuc5bcuvl8iUUmd3O6F1/4Lsaf/J4FbGRWKxPvm0JrLcBDwh8gypF7ijKsq3rl
	 xf1/zf30UNO79mJY8Uc28M81itqowtkKOwoWFO10LP1BqzL5G82XfRAF0x6HTRvZ9L
	 PYk6lNettS7OW5AZ2emu61iDha5rpQukcRCi13yVSV3ob38VxqMnrT6ZZc5XANpWov
	 mSpDZIbYZPdaA==
Date: Mon, 29 Jun 2026 12:39:56 +0200
From: Christian Brauner <brauner@kernel.org>
To: John Ericson <mail@johnericson.me>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Li Chen <me@linux.beauty>, Cong Wang <cwang@multikernel.io>, 
	linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: Re: [RFC] Null Namespaces
Message-ID: <20260629-zoomen-tragweite-redakteur-dc6c41c9c151@brauner>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260624231219.GL2636677@ZenIV>
 <29cd3188-2d7c-4470-a39a-6648638f795e@zytor.com>
 <614b290f-e274-4eb2-b687-008b004de526@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <614b290f-e274-4eb2-b687-008b004de526@app.fastmail.com>

> The kernel rightfully has consolidated path resolution in a few key
> places as much as possible -- the internal `struct path` does not suffer
> from these issues. I barely modify those places to support null root and
> CWD, and because of that consolidation, we shouldn't expect new places
> to crop up in the future. (Duplicative path resolution logic is a bad
> idea whether or not we have a nascent, little-used NULL-cwd/root code
> path.) Therefore, I think existing code review, even among people
> totally ignorant of this feature, will protect us --- the vast majority
> of code will just be working with `struct path`, and be totally
> unaffected by this change.

I actually did laugh out loud reading this. I'm sorry, I can't really
take this argument seriously. May I introduce you to drivers/ for a
start and the history of path lookup exploits of the last - say 10
years.

You have to excuse me but it's a mixture of amusement and slight anger.
Amusement because this is really naive and thus also a bit endearing.
Anger because it single-handedly dismisses how big of an attack surface
and problem space path lookup is. The equivalent of every math
professor's "trivial. excercise left to the reader".
