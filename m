Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935B3A48F4
	for <linux-api@vger.kernel.org>; Wed,  1 Jul 2026 09:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782899395; cv=none; b=Fs+74oRzEgP5vkTnCopLtTHywQrgWQiQp6pgylULnKL38aT2ApwXR0KmcTA4T11QxZ0fm0vXCsS3LuLo8ZfWAHKxLEjax3D+xVxZ4DUS6kqDOgof7lC2eviwTKX0KOvlD0hKkmhcFiLdYLqdXM8PV7CcqgH1g7e0LrGS5/0W+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782899395; c=relaxed/simple;
	bh=AiogJaqLh4zevLJ3YPP2ujRb3Z7ElglpMC8/iJghYpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oTTGGigWQ3p+XdRZWXpJovQLJMxOFzetLEgpIsQ2lCB+75R5x24W6mJfZCMODQf4xO4EvlNyK0PuNsdfqWxTOLcNt0csOOd3MLIwarVKP4QOSmYaiXSmaH9DbGCxbit29fGeGdQ4wIcQOo+bJONrO/6zpeHPB/TcYJMLGMeUowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=atNY65Bi; arc=none smtp.client-ip=195.121.94.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="atNY65Bi"
X-KPN-MessageId: 31530d12-7532-11f1-9e8e-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 31530d12-7532-11f1-9e8e-005056999439;
	Wed, 01 Jul 2026 11:49:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=s+5GyPbhJbyw9OfQ5HHnpZIp2rkGbCNIb5ImOOO4pNI=;
	b=atNY65BiA/OtX+DJD0Vgd2PnUNvUGJf9POi4F5kx4qmteka3SiP/OYhxqDbMlwT6jV9KvrnSyDch7
	 9ejnDrpAHWZcIcLX+AImKVucAxVDe0PYO/YYuJPkyuX9aZ5g/E3/j2oPnKRsIQng1/6SPfwPV0k7u0
	 2ZnWZj4JU11R24Ce8NHXKuZeosnfy/IFPNrNIVbcojWLcpbE7f6+ZCwHljAOs7gg5f1Q1y3OLN+YK3
	 9pZYfk0lRYITidoyP5hFx6t0P4nachaDtIWtHSd/POu/Hx+AIIB6tW+dNkwgpHEdc34GtkHUaBjxay
	 mWngSN6uyKoICzMUQpafX2lp8/oW+oQ==
X-KPN-MID: 33|PB//EH737mjLoI494/5lxwN9mhSAEBPFQ66TW8dWGkevGDPysYyVvstvqSjByG9
 S5Q+rBoZOUq1zZFCQCDRruBgAasoK3UGM/A0wHrdmu2Y=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|lQAlBfbhrfnT/vdJGg0q/LH8cfhkhQUPcULwEftpYByVqKwC1dbgv/ZkntsTW/S
 gqVpGVTS39cyXq4cj88Q0Hw==
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 3132f06d-7532-11f1-87f1-00505699b758;
	Wed, 01 Jul 2026 11:49:46 +0200 (CEST)
Date: Wed, 1 Jul 2026 11:49:42 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: John Ericson <mail@johnericson.me>, "H. Peter Anvin" <hpa@zytor.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Li Chen <me@linux.beauty>, Cong Wang <cwang@multikernel.io>, 
	linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: Re: [RFC] Null Namespaces
Message-ID: <akTgQH1YIg2blzRe@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, John Ericson <mail@johnericson.me>, 
	"H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>, Li Chen <me@linux.beauty>, 
	Cong Wang <cwang@multikernel.io>, linux-arch <linux-arch@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-api <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>, 
	Sergei Zimmerman <sergei@zimmerman.foo>, Farid Zakaria <farid.m.zakaria@gmail.com>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260624231219.GL2636677@ZenIV>
 <29cd3188-2d7c-4470-a39a-6648638f795e@zytor.com>
 <614b290f-e274-4eb2-b687-008b004de526@app.fastmail.com>
 <20260629-zoomen-tragweite-redakteur-dc6c41c9c151@brauner>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629-zoomen-tragweite-redakteur-dc6c41c9c151@brauner>

On Mon, Jun 29, 2026 at 12:39:56PM +0200, Christian Brauner wrote:
> > The kernel rightfully has consolidated path resolution in a few key
> > places as much as possible -- the internal `struct path` does not suffer
> > from these issues. I barely modify those places to support null root and
> > CWD, and because of that consolidation, we shouldn't expect new places
> > to crop up in the future. (Duplicative path resolution logic is a bad
> > idea whether or not we have a nascent, little-used NULL-cwd/root code
> > path.) Therefore, I think existing code review, even among people
> > totally ignorant of this feature, will protect us --- the vast majority
> > of code will just be working with `struct path`, and be totally
> > unaffected by this change.
> 
> I actually did laugh out loud reading this. I'm sorry, I can't really
> take this argument seriously. May I introduce you to drivers/ for a
> start and the history of path lookup exploits of the last - say 10
> years.
> 
> You have to excuse me but it's a mixture of amusement and slight anger.
> Amusement because this is really naive and thus also a bit endearing.
> Anger because it single-handedly dismisses how big of an attack surface
> and problem space path lookup is. The equivalent of every math
> professor's "trivial. excercise left to the reader".

I could easily show you why path lookup is trivial, but I have no space
left in the margins of this email.
