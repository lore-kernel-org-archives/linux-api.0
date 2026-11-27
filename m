Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795819392;
	b=L2vtf1s17o02lX4znkqGN1iRuPhSFJhGXh3qEomJACOxsUL75QckiTUBsqKPMPstm445
	 5cwUiStJnhISAQJenjosrO2W9k+PJmcEBnd9t+HDc6Izfg653S4k7U4kF77WoeUtp/VV9
	 1Z3IZcIdumSxe4yrKy5C8y9hBRTdvtbHp0I0/qte5iGUO8UBLa4sYQEKNZvNGNslwYUR0
	 FmYDSb2OQZhZBvcP/YEGeaD88ePoqwXq6AWVwXE9319Vo9oPTiP6+YVhy3RYN/NREODR/
	 v4Wk7PDo9+/MVnP0jIp44IAskK1LSsKOhyKzQCQlKutQzl5ScTsYfKUA0P7GdAzA8Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795819392;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vr8Cyu6OnN1kywiPQZaviQUiC/sNy6ZdV1ZpB2i7LQ8=;
	b=AnsnH4Se3S4hBJgN0lhjO4g0hcPettOxxpIqBeG6hE83qYOuyW35ETi4KMNCsxd75WCo
	 OR6mUBNN3+tnSeIW4J6xM+RNApKPJnXdns+FSX3L4fibW2likfz9kLdnv73m6TVCw8HGi
	 DekAZsjstHwwJGSbUynrpvnfFoHba92JM91MnZgKIYW0jDYNBX/RCgOOXKHjWIMv3X8QA
	 eHPX/yYxeiotjfMXWTRDVXR3CWyy+eXqHBmY0hGa/WbM1ofkcLjnpTVEXp7FJFLbHp07u
	 LsHw8SQJoiV6oB7kaI894ga56t/9uAHuk9m4d/v8Z1lwkETGEgJ+GITwIwaEI68uiEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W5ddae1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 63EF5606A31C;
	Fri, 27 Nov 2026 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W5ddae1+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4CE231F00893;
	Fri, 27 Nov 2026 22:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795819392;
	bh=vr8Cyu6OnN1kywiPQZaviQUiC/sNy6ZdV1ZpB2i7LQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W5ddae1+sL0M2BwMEOdWKEDvyU78Ny8CC5zKR352ZLpxUqa01Td+Izg20p0wQGrbH
	 kYcjC0YhQscAjvW+ApK3sdygTP8a7FLherXbJr0a4aU6HQkiL0/0KzbR2XYHXgrO9L
	 zTbNPmRsA/nZx161YRb4X85NouktelTHL8XkEOUlt8557iQkYLcCgtTCteVfbqrKNq
	 jAoUGNa7psyvgxoLT67SvgzE9A6+tIXgw4+05s+YjDB6qyZ1n06lLnwNr2H8/9mLyy
	 wPzuWkybJdpCQ1XDao0m0W2VH045/GO1mbqtmySdCWfE/02b7oG5tNg/QYvZ2McDsv
	 Ae5amWfVTo5dw==
Date: Sat, 28 Nov 2026 00:43:07 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awoHex4LVst2JwkO@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awn_Y7oI4ckfsjSv@kernel.org>

On Sat, Nov 28, 2026 at 12:08:38AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 12:05:03AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> > > Jarkko Sakkinen <jarkko@kernel.org>:
> > > > I personally think that "getting in" should not be a goal in the first
> > > > place. I care more about that whaever gets in has a high bar of
> > > > quality enough. It can be something different than this but
> > > > when I read the LWN article about Cells I was alarmed enough
> > > > so that I had to do this and prove my point.
> > > 
> > > I think that Bacik's patchset has better chances than yours.
> > > I think so, because (as Bacik said) it was tested in Anthropic, and also
> > > because Brauner reacted positively:
> > > https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> > > 
> > > So I suggest reading Bacik's patchset and say what you don't like about it.
> > > You will have chance to influence Bacik's proposal before it will be merged.
> > 
> > I've read it through and the way I'm seeing it is that it is overdoing,
> > and has somewhat complicated life-cycle model tbh. I don't like it.
> > 
> > This could be of course wrong way to see things and I did this just
> > to demonstrate that similar goals can be achieved with a relatively
> > lightweight core. And this is also demonstrated with a Python daemon
> > emulating Cells style containers (and alos relatively trivial SystemD
> > wiring).
> > 
> > There's no reason to continue this for the time being as it
> > demonstrates already how I see the world i.e., "I showed the
> > code". It's up to whoever decides these what they do.
> 
> And even if Cells is the ultimate solution since I had thought about the
> whole problem 1.5 years (mainly for my own entertainment but still) this
> was the best way to unpurge all of that. Regardless, world became a
> better place... New information arrived.

When it comes to containers and namespaces I even don't want to have
any opinions tbh, because it is so opionated area to begin with. Thus,
I pushed back sending anything using this approach for a year.

Despite the patch set tsunami (sorry about that, shit started to 
unpurge as I went on), I was not too hesitate to send this in the
first place, or have no motivation to compete with any solution.

I did all this really for the sake of rightful concerns about the
complexity of the mainstream approach; and in that sense I'm happy about
myself.

Br, Jarkko
