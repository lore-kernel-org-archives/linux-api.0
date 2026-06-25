Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E7130566D;
	Thu, 25 Jun 2026 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411848; cv=none; b=eG8zCSo/mkPwACsvYBZWSX9OKJxNFF9Gqf57OEjGv335JnnY3zJKArdgcYXvh66+UVWRYznD9OZQt/jWJapDM7AbytqW6iWSWsivvk6Kx+f2XV2BHGH6BqQI4LhvxVOegxS1WOWRjouURLmTq3FiNUu7BlixnEVm8+AbP2z3F1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411848; c=relaxed/simple;
	bh=FxbkPs6VOjJEhJrxoI/4FTDTG7hckuRIEReabgvOAP0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QNiCtVoi11EbmLhsNmh9U3xLu1szFOijP0NwZ2AV2U7jPo+aIMm7HedO6+5aWhO83VG9WQfcvsFtW7nOsBENtSfkDX5mveOjPJqc/bQvV158MzsYHA7o3BJR8F9WdMBn2BCA+QlNiy7Ve1KGCVsAP3hhKYlFNgJgIHh4bTsH2aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me; spf=pass smtp.mailfrom=johnericson.me; dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b=fPrig3KX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=U0Ki/W1F; arc=none smtp.client-ip=103.168.172.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnericson.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b="fPrig3KX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="U0Ki/W1F"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 05A791380923;
	Thu, 25 Jun 2026 14:24:05 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Thu, 25 Jun 2026 14:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782411845; x=1782419045; bh=m+Vo2gCieDBsezt/WtRstmVlDLfhdQBZ
	5OOOQny6uNo=; b=fPrig3KXrFd/rGV3bv52ys5LKfDurXDKhX/ELM+7I3U9NfuQ
	Y+gEvJA+Jno6b07JbxGRlspTVYgfJ3F3Rcubr0WIfghfABaDVOtDkJZAv4spExnr
	q/Ug7opOpLRBTlXYb9+0vHVYQIuhSC0YXe/HvE0hhZmg02Ld1eONlgYOAdpbGBls
	/NQ/h6pTh8qm8hRvh2BTzdWF86FFXz+n0W/SJqWvTPm3/JkLnFY+bWEov3BhxFuH
	UFvIdmJnPDXCzYXDjoSUv0LriWkpD6bnoqHlCsJEKrKTk+1JcGCNJX4YTw/+j6Kr
	NEE5zMiYs8nNDBQFi6IX6RQO3nr/5q5kidKTbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782411845; x=
	1782419045; bh=m+Vo2gCieDBsezt/WtRstmVlDLfhdQBZ5OOOQny6uNo=; b=U
	0Ki/W1FjTNtxYNqKU4vKMUlYvANglhLeNHrUI1gKy2reTy4+cHq+AJr2OIBQtPCs
	R0isubLk5GH5U2pr5EzXa7TWhgDHxODxFiYRQqblJWwabJ62HYNIR9wwB2+JuGq5
	zV5kUJdHcf21i/reIkepyODko7OdjwbFGmMxY3WtdLGI/5OsaHyiPX4DJRr8rlG1
	SJHzOhriI2azsW5UCtq+tX84HSaD8UkZjIz1ultHg8LwHfp8Z/HRFNJztD9CSv6/
	IDTfp57ZBOjUTkjPhaUYM3HoywO0wyiw025G53X/6ey9/5BRl/EfOA6WBGmYdH28
	tICPEO2bYjuUNRrcXL03g==
X-ME-Sender: <xms:Q3I9ahto_UBYzml4qt3RUvPyJrgPvZ8LcW3GqFKT8oZtV4ydGdBRig>
    <xme:Q3I9alRp4JUEqQ12M4UnV-pEEcUv7QKcMftQauxRww-fcoat2YaIaCcqPixuyo1MN
    pHhqbD1xTC3INGQ6MAF2ma8eInLyuXirzC1o1q1xHVX3hJz2gRrT2g>
X-ME-Proxy-Cause: dmFkZTFyeIi362Iqgeflrx8SfWAUimV8NIXGDAs+oBvs4keGPehc5LIzevdlDF0NWjSyQe
    rjGOMj50/KDiHVtZOqMyMBNvHW2R+Hk9mKiNHsA809U87AAei98vwrZfj+SF+BxrBfw3BH
    DGa9FVsenW85K+hrP0YbDmL8jDLqb14lON88z8hgHIiUF1/tugD1lJWE2yCw4QwNc3AK19
    XkVh8vdvrtZxIdo5ZkFG3SdpfiR8BHfahKU7c/IpRWZodUAE4QWkcdH/cPUjie2XMxkf2W
    LZxcLMTKYscUj8LMA452mVjsF6Z1N+EavWYsvbSKavRMKBZYO1qk030/WuVljWBZTt0noO
    V25ok3cp+J+f9se3nVgiOrW/95O1228fxtVxvVASCzAIIwnKuwu0TMve6p3gHtHwsqXTiV
    npPMWjLAxJRggUkksQGraXveoEm3MforjDhqXB6WzeVyixLJy/UqTbShs6FhgrbIc5B5K2
    R8Xe1aUmz053Gf43Qy1iJlbrd1mMYxkqbbuL2o/Ix72e4BCsFzZ9E9faIdK8Ltv4xvu76z
    m6tKpO/po0RjOXPtNHY9bMOBLdUvfn3rmGz++o//x6Y4N42JWiFyPo7rB2W2N8kjX1c5YS
    63jKXAElC9xow0rwAIljNLJsLyxdHnR/WbmxAu9ZG0MTWx49BRiwEM+xmv+A
X-ME-Proxy: <xmx:Q3I9ag-X5qKkM7bORdpbEc6XpVZAKGllEfkV0CqslKokBwbB5XTCMw>
    <xmx:Q3I9al4i8uEFpiTxfPe8aYPwtSTb_3F0oqGAhb7h9cqt8V-7CqqlAA>
    <xmx:Q3I9aqiOWOmXm07JkazGreqPeliJw18i1gixMh3WKPkFnk3Gb_mp4A>
    <xmx:Q3I9asq0iDPnLh87nImobuUTHUJg2LsnTCez2mVVbCnz3hMZnz6ZlA>
    <xmx:RXI9aq-l3-MAhBirN22asZ7Ce3DwCW_VDvpzKMKk43cUvFfm0pROoRkG>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 53D2E2CC0088; Thu, 25 Jun 2026 14:24:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AG8qDlxFSDr7
Date: Thu, 25 Jun 2026 14:21:01 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, "Li Chen" <me@linux.beauty>,
 "Cong Wang" <cwang@multikernel.io>, "Christian Brauner" <brauner@kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-api <linux-api@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Kees Cook" <kees@kernel.org>, "Sergei Zimmerman" <sergei@zimmerman.foo>,
 "Farid Zakaria" <farid.m.zakaria@gmail.com>
Message-Id: <829ad432-8312-45af-bd8e-8b079e8c6226@app.fastmail.com>
In-Reply-To: 
 <CALCETrVdtYeJ7rXmvymLpOvn6X4LsfHYoVmbL6XgTqnjcP5n7g@mail.gmail.com>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <CALCETrWhXNetw-BsAaoyT31suMmjYLdMh9MAuLB2Lvk2ac-31g@mail.gmail.com>
 <CALCETrU3bgUxp0k1y-U-uL0-fW2016Gmsyu9O_=830czEUGMcQ@mail.gmail.com>
 <103524f8-1658-41df-88e9-cf49c628a721@app.fastmail.com>
 <20260625011023.GM2636677@ZenIV>
 <a75a9b82-a15b-4893-8f92-62b62664ea83@app.fastmail.com>
 <CALCETrVdtYeJ7rXmvymLpOvn6X4LsfHYoVmbL6XgTqnjcP5n7g@mail.gmail.com>
Subject: Re: [RFC] Null Namespaces
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026, at 11:51 AM, Andy Lutomirski wrote:
> On Wed, Jun 24, 2026 at 8:41=E2=80=AFPM John Ericson <mail@johnericson=
.me> wrote:
>
> It's sort of a combination -- read the data structures :)  Other than
> the propagation part, they're really not that bad.

Are you saying path resolution *does* depend on the mount namespace that
the task belongs to? I certainly hope not! I did look over the data
structures along with my patches and I didn't see an example of this ---
just path resolution depending on the CWD and root directories (as one
would expect it to).

> In any event, I think this discussion is sort of immaterial to the
> proposed API change.  No one is about to remove the concept of a mount
> namespace.  But maybe it makes sense to have a way to have a task that
> doesn't actually belong to a mount namespace.  A mount namespace is
> certainly going to exist.

I am not sure if that is addressed more to Al or me? I certainly do
agree with all that, in any case. Mount namespaces are absolutely here
to stay, and I'm just trying to make a process that does not belong to
one; that's exactly correct. Sorry if my motivation by way of historical
analysis veered off topic.

> There will definitely be subtleties.  For example, what happens if a
> task with "no mount namespace" tries to do OPEN_TREE_CLONE?  In some
> logical sense it ought to work but it ought to be impossible to
> actually mount the resulting tree anywhere, but this risks running
> afoul of all kinds of checks.  Maybe you get a whole new mount
> namespace (that does not become your current mnt_ns) if you
> OPEN_TREE_CLONE?
>
> This stuff is complex and it probably makes more sense to keep changes=
 simple.

Yes it is subtle; I definitely don't claim to fully understand the
permission model with mount namespace modifications yet, for one. Should
we switch gears to just discussing the null CWD and root directories,
then, and return to mount namespaces later?

I have started to rework my patch series accordingly, so I have a new
draft first patch for just that, before changing anything else. I could
(after some testing) submit that next; it's pretty small.

John
