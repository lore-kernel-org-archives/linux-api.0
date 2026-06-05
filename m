Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506563A7F4B;
	Fri,  5 Jun 2026 20:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780693084; cv=pass; b=F7xU38yboehSljPEAye5rWjJ+P/jXns0Ioasu5a6e70CjE+PFnkKeC49K84rnXElBFtL+E8diznB5zaCqp1trsbuEdjF4PJJnu4pXbWIzdgEmJUBHy2blgjpTK2Zb8btIp3dK+qQ6ENuJFLJZRv/+guSbWZcl3uPNRP5ePoqe6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780693084; c=relaxed/simple;
	bh=uRYDliO21fd15TPq957TbM5u9FjxvLcB64qva0Hutsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RP37II5Vr3i9M8AxlwSFoep37FBkX/S+eXsvIbREmnN9K5mKqX3Wz96kMXinxZU4IYwSSuoxIDl/Z3yTDeR2R8UndZYarOs8hR1nhlTLd+oTylyoqv+rgilkiJzvuFpGOnAVxdFBpsVbdm9lXKvsBC4lpQgG28KXNLzfMvppx1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infinite-source.de; spf=none smtp.mailfrom=infinite-source.de; dkim=pass (2048-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b=QN+LVqd9; dkim=permerror (0-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b=8WCLaVWz; arc=pass smtp.client-ip=81.169.146.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infinite-source.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infinite-source.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b="QN+LVqd9";
	dkim=permerror (0-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b="8WCLaVWz"
ARC-Seal: i=1; a=rsa-sha256; t=1780692890; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hh6lIgoTvUllGPKdx4NqM37Z3SF8LMp0ir6sZ5owEEk2q+iyku+p9P7kRvyaP5a5Je
    M3UWuwAPZA5fbGvy3uj6818OQdtroD2lLFkf3fuRCuFqcd2Xl64nwVAih7smIDfpUn0Q
    c7Eo7Vv1iGEygwBki/yfC8ZguabC+MPAxuGMTTKNFOWZtSl+bGQfabCP5TcUTI19kB85
    qNcTuzZgGOb2SJGKRylMVvx1qcHvH1y5+KftAdRHktrEnanFXMb943h2YwSTZn65ERa8
    GoUBTLXZfEFhl2OCSaUbPdwNnZ9JQFMETWQ7Xx4Il6DCg5V2HwY055f0aUjfSvtVcbM0
    ZaaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1780692890;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
    b=mW0kw25xNVqlyNoCKiNir7K4Wa6ubcpkH6PCelWgzXQPwunjJMVGM7/LcjVF8YXHy1
    yqPNxtmPyzg/t4B5lhMhMY+8kmO4A5kem9FUerITV6bn7GumCb4X92HDNo7jBvcyXDe/
    xi/rzkfvTRpyvV4BJi0xZV4HCsPohirJagixrEroGMqyNHAtdbxcBNNBLttSStQj0CMO
    iNrispwkk5pcEBWGvpfUMNuFXq711PgaG7p+azV290Qqs0flcOpW1ye+CZ8VFjKRi7j4
    zKA+ww//vjcofx3SV/4HQaVzT4tkvXmp8xOk1TyouzVXoC5EFRdPY/4ZhdcSm9baL8CF
    GvLg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1780692890;
    s=strato-dkim-0002; d=infinite-source.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
    b=QN+LVqd9GFndtvOCtdXeHdLoDQKUV99KE/r4wqHwhZj240RcZNueQdKolOkD1VpIVB
    Oc8Z0kOpEBJsH80PWib/FOzXyxjgiXNfxRQ9OzBkT5vJ7ee9kYSppu9cZYvrqRiY1WBv
    s/mGiD7HO9kD+dIFxfOw6XfM6fmVJT/OAHEtLdD91brHmwK5nWO4lPEc6+uqMGlB1882
    K3FKQvYlosYKDWdudFCB/16Z44IaD9PQXTA/knGRn6InGle36MKg3cc7wAU7muk9sh2v
    C35CyTzMG/N7ezxeVM0oD2TXAqdAdr3z8vnfk+Fdgg9Wr9xPxx4C3pUsDpcAu9z0jlPj
    Z8dg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1780692890;
    s=strato-dkim-0003; d=infinite-source.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=e5U4ig/uUW/ykznudNtIoLlpAxdXFMDfbHPHK9h+DFI=;
    b=8WCLaVWzkyF+FJqcLNijVyFBuhYUe+qoh+tOXBMn1wQUQAg06PmA5C7puyuyh3N7GY
    r95LcM6D6YmdR1gmxADQ==
X-RZG-AUTH: ":LW0Wek7mfO1Vkr5kPgWDvaJNkQpNEn8ylntakOISso1hE0McXX1lsX682SOpskKNgu1vdp7pXN2ayNAkRm8xGwNyBO1pryZlEoFdH8nUdt2z/2Kw21ZBog=="
Received: from [IPV6:2003:de:f737:c700:4ed4:78b0:5f62:98a7]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id 2b9b8e255Ksn2SU
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 5 Jun 2026 22:54:49 +0200 (CEST)
Message-ID: <0c9f58f1-52f6-481c-829f-6f5a70ffff7f@infinite-source.de>
Date: Fri, 5 Jun 2026 22:54:48 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 David Howells <dhowells@redhat.com>, David Hildenbrand <david@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
 <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Content-Language: en-US
From: The 8472 <kernel@infinite-source.de>
In-Reply-To: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/06/2026 17:58, Linus Torvalds wrote:
> On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
>>
>>> It looks like you're actually doing exactly the thing that I thought
>>> was crazy and wouldn't even work reliably: you change the
>>> common_response[] contents dynamically *after* the vmsplice, and
>>> depend on the fact that changing it in user space changes the buffer
>>> in the pipe too.
>>
>> No no, it's definitely not doing that (or it's a bug, but it's not
>> supposed to happen). I'm perfectly aware that one must definitely not
>> do that, and it's a guarantee the user of vmsplice() must provide.
> 
> Whew, good.
> 
> In that case, can you just try the vmsplice patch series (Christian
> already found a bug, but I don't think it will necessarily matter in
> practice - famous last words) and that test patch of mine, and see if
> it all (a) works for you and (b) if you have any numbers for
> performance that would be *great*.
> 
> There aren't many obvious splice users out there, and even if they
> were to exist they are typically specialized enough that you have to
> have a real use case to then tell if the patches make a difference in
> real life or not.

In the Rust standard library we use splice as one of several strategies
in our generic io::copy[0] routine. It selects the strategy[1] based on
source and sink types.

It tries

- copy_file_range
- sendfile
- splice
- fallback to userspace read-write loop

sendfile or splice are skipped when we can't uphold the "callers must ensure
transferred portions in_fd remain unmodified" condition on the manpage,
which unfortunately includes some particularly desirable combinations of
sinks and sources (such as mutable files -> socket).

We primarily want this for reflink copies and to avoid the syscall
overhead of a read-write loop with a small stack buffer.

Any additional zerocopy benefit, when it doesn't lead to unstable data, is
welcome but not critical. E.g. it'd be nice if sendfile could do the following:
For a 1MB source and a socket with a 64kB sendbuffer it could zerocopy first ~900kB
safely and then memcpy the last 64kB to ensure it can't be modified after the
syscall returns. But a "just memcpy in kernel space instead of zerocopy" flag for
sendfile would be ok too.

We're currently not making use of vmsplice. In theory we'd like to use it for
copying from `&'static [u8]` sources since the type upholds the requirements of
vmsplice, but type specialization currently is not powerful enough to
select based on this lifetime and it's unclear if it'll ever be.


[0] https://doc.rust-lang.org/nightly/std/io/fn.copy.html
[1] https://github.com/rust-lang/rust/blob/ac6f3a3e778a586854bdbf8f15202e11e2348d9f/library/std/src/sys/io/kernel_copy/linux.rs#L210-L259

> 
> So you testing that thing would seem to be a great first test of
> whether any of this is realistic..
> 
>                 Linus
> 

