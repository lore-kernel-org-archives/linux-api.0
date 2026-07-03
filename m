Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748441F30A9;
	Fri,  3 Jul 2026 08:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783069182; cv=none; b=sbJ0Rz/gwjFmDBxNlex2wLslau0OP39L30ISNfaIWMNujBlTbCsYUwuqIQ9AcYRtOUnS2Ta0mxDg5HN7Z+Kr7MnbZC6wzakxMiGLgnWl70Ev5w7oLgDWuZ3V8kWMAm6arP4y2wGpkLKEZVO9kk0Wfkmj2KKmI/tM3uetEWhXESY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783069182; c=relaxed/simple;
	bh=4yzkqmFhZhfm3c7SM/OTRFnb8K8G8QjqSnoHzMwibSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vz0aD2/aXxJe1VuP4SfzopYXbn3fDpZovVoDgmFBSy1m3dikfS+2VHNAPyg2C4+y92iBC15h6IIRN3VIYkweuRJAx0MmR0mkdsT7rKKenqjJbKnc3BSq0THbad8LrWJlTmkTLaqBtnSPgVfL8bc5FuXUxgoo6SzYuO3kYdBgqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lew7qOMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lew7qOMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B431F000E9;
	Fri,  3 Jul 2026 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783069181;
	bh=DwvXgjbOo23QIgi9Ih36T5WskUAMqQnB9cf7FG6IlaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lew7qOMbVkBL4AFoR7Oal6NOFbMmbRoynxobvOmbrJ0WmPGPY+8ixTsQNAyn8X2U0
	 0hgwwi9cy/uUvxXkg/PeeZR8Gwup490rtwI4cpF9riI0ViJMU8F0XnlNFbnQPgHvq6
	 bnsHm3BwilkW5auA71JOduE/oKPngBfSDGCcBdL0A3xAatNaHsrYt5esvPdg/D1rZu
	 Bp1WdkKsbktC9VuIxfheWdAkAo5Y/pidCyk4Pmc1wK1tWeptrjCyE32UTNi+xACvKH
	 mFBHc4R/NDbZzynBXyrvOLVeMIGki0yj4aOjLbuUmAHuRVp3PHq+8a9gMiYXy471U4
	 2m5oREXj8Jabw==
Date: Fri, 3 Jul 2026 10:59:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: John Ericson <mail@johnericson.me>
Cc: Andy Lutomirski <luto@kernel.org>, Li Chen <me@linux.beauty>, 
	Cong Wang <cwang@multikernel.io>, linux-arch <linux-arch@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-api <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: Re: [RFC] Null Namespaces
Message-ID: <20260703-liftanlagen-rednerpult-briefe-5eb403e3cdaa@brauner>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner>
 <CALCETrVuh0-biOw=TgYN9ERTFAoiki57XeZ3S2T3dO2+hL54gA@mail.gmail.com>
 <20260702-entladen-farbkombinationen-klarheit-fe24cb608f23@brauner>
 <5abd7c81-3c6b-45d1-aaab-195493c1cdc9@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5abd7c81-3c6b-45d1-aaab-195493c1cdc9@app.fastmail.com>

On Thu, Jul 02, 2026 at 11:43:31AM -0400, John Ericson wrote:
> On Thu, Jul 2, 2026, at 4:34 AM, Christian Brauner wrote:
> > I think we could make that work with both FD_NULLFS_ROOT and
> > FD_FAILFS_ROOT...
> 
> Fantastic!!
> 
> What comes next? Do you want to submit the patches for this, Christian,
> or do you want one of us to? (Just trying to be helpful.)

I'll send a patch soon-ish.
