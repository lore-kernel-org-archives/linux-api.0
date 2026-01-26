Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8138233B6F5;
	Mon, 26 Jan 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769435603; cv=pass; b=swnpi+4f0cUx3TTJEYQUqWvVXyIcIm1aq3jLNguLXS8yXzwg8Yiq+zmfpluyR7HXoJ5/uJTc3nA5aa55UpKBo4is4NFNQLUT/acRIO2zJ6cf7jVgrn6K1bZKJd9OJSIyPebb1siJc1sRANveTq/S+0QmQjeBJ3f5Qu5WNOKhSvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769435603; c=relaxed/simple;
	bh=5xyC33At/ybRJoiYDW3HNnwotdi3JbEr9v1+QqNQ+kE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bWcl7N7llm2/uri3vXeVeVEyH/hs1RxnSqn0uNAubMSafSs+xOYSc3R+BydiFBFU7Z/nmlbEfYywa12Vd/E09SMTV/8pziBQ6TFsrwBscWb24tDy4HGa/YYthy8Fs1VijvMQQmwVCfn7mabhIXKLecGsBvE9P6JfNA6tTna4e4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infinite-source.de; spf=none smtp.mailfrom=infinite-source.de; dkim=pass (2048-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b=ZUxUScE7; dkim=permerror (0-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b=WZ2H2xa9; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=infinite-source.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infinite-source.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b="ZUxUScE7";
	dkim=permerror (0-bit key) header.d=infinite-source.de header.i=@infinite-source.de header.b="WZ2H2xa9"
ARC-Seal: i=1; a=rsa-sha256; t=1769435593; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cThFVjYwLQTaJNxIAL+1KIgnLHF5xhio7CprsE2pPak7ClgLs76Cfm+UN9NgpVUn0O
    z957pisSgdCQikrXSbOez+TN9o/rJfMH5xAIbY0mPVFD5oRf9TNMV3sMvO2Y7TwqFmL2
    d36tvIg18XfIA2aNNpTMXw/KB1Zba6/E0JEf1WqrSj7zIQxfGFwGtCX/To4BKPCHsKgG
    e9pk/iDXwP0DNX5OXWnxAdywVgUUeNC/Pr+LoLvv+sKSa8wtpivd1FjgFaBGNGrX9TS0
    gqBpvsmYub1Dnw7jXOz0NTGKyoAEfRESVxOJHPUQJh3Eo0z9FvxIgWyqXzUJO3fnxkOI
    qVaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1769435593;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Ojkp+ZCZgadF4U1CzuGr9uOotTlgXHGtv0MD7TDKMvc=;
    b=blr9psxTEb3Hx+qHQZdv0U1L9q56e6Telxr3jCCQXYW9w2SkffGfzSnyvSpKLJlPPE
    XTOiZL8o8o9VY/FrHY+ijqdlvmxSkPyl4KsyYgiZzcaUBCFI+L77nHoV6fV7RRICW3rT
    1hAu5u0fsEWHSQVcYBa2JGXhiQCIB+KJ8Ka++UP8gVVwL3ryf/G0Jfi5H3xSepIr1jBo
    qWMgC+q2nQ30WoXTYAcHttcAXjMtR+ZloXtyVP2bGP6/+DjAFcNdJBxOPZGMxBW3eEo2
    ED8yTkTEqET+VY2OakWZFY1he0kjJGOjBSK0Ktej/WA/zoSPQ26YSyiUo3C7H8zU6wdv
    MpkQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1769435593;
    s=strato-dkim-0002; d=infinite-source.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Ojkp+ZCZgadF4U1CzuGr9uOotTlgXHGtv0MD7TDKMvc=;
    b=ZUxUScE79577WNHAhn4T5G8nm4B2TX8JBMH7DE3Mmk+l/v726s4ug/8U6z/XDvL5FD
    rID5nDKnm3ZX4F52fNi+Ihxu1WSz541AFkoae07sR/3b0X2O2CoSBeSzSkRLhWNUm3hU
    Hr3HOvsuWeAo1ASuhtYIcLM0do/CIywsY0LF8NYLI0aiDRig6eV/11BTVLhUj9JrjGJf
    B1PmitsctOfGpu7cMOSWD3VVK0nxpZSDxYWhy4q8ggm8RtoAZYm3vUcfr2nWTPxDHKwe
    IPH9/kfuhnzNoK791MtgtAUdcb0ppHH/Fkw6MuRncqMy9QVxIu60FErpv9nhofK11U/K
    QU5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1769435593;
    s=strato-dkim-0003; d=infinite-source.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Ojkp+ZCZgadF4U1CzuGr9uOotTlgXHGtv0MD7TDKMvc=;
    b=WZ2H2xa9Qdvvx5nojpyjrqD7cJI36VpgCrz30/aznPdnjegj9UPRV8ukaDZAHBIzUq
    yitgXChJFtg8+SZA8UBA==
X-RZG-AUTH: ":LW0Wek7mfO1Vkr5kPgWDvaJNkQpNEn8ylntakOISso1hE0McXX1lsX682SOpskKNgu1vdp7pXN2ayNAkR2kxTl8Z4is3C39It++VDQOZ4cpkTMma5+3/Lw=="
Received: from [IPV6:2003:de:f721:6800:da61:1e19:86ba:107a]
    by smtp.strato.de (RZmta 54.1.0 AUTH)
    with ESMTPSA id 20d7db20QDrCBhQ
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 26 Jan 2026 14:53:12 +0100 (CET)
Message-ID: <c59361e4-ad50-4cdf-888e-3d9a4aa6f69b@infinite-source.de>
Date: Mon, 26 Jan 2026 14:53:12 +0100
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1] man/man2/close.2: CAVEATS: Document divergence from
 POSIX.1-2024
To: Jan Kara <jack@suse.cz>, Zack Weinberg <zack@owlfolio.org>
Cc: The 8472 <kernel@infinite-source.de>, Rich Felker <dalias@libc.org>,
 Alejandro Colomar <alx@kernel.org>, Vincent Lefevre <vincent@vinc17.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-api@vger.kernel.org, GNU libc development <libc-alpha@sourceware.org>
References: <20250524022416.GB6263@brightrain.aerifal.cx>
 <1571b14d-1077-4e81-ab97-36e39099761e@app.fastmail.com>
 <20260120174659.GE6263@brightrain.aerifal.cx> <aW_jz7nucPBjhu0C@devuan>
 <aW_olRn5s1lbbjdH@devuan>
 <1ec25e49-841e-4b04-911d-66e3b9ff4471@app.fastmail.com>
 <0f60995f-370f-4c2d-aaa6-731716657f9d@infinite-source.de>
 <20260124213934.GI6263@brightrain.aerifal.cx>
 <7654b75b-6697-4aad-93fc-29fa9b734bdb@infinite-source.de>
 <de07d292-99d8-44e8-b7d6-c491ac5fe5be@app.fastmail.com>
 <whaocgx6bopndbpag2wazn2ko4skxl4pe6owbavj3wblxjps4s@ntdfvzwggxv3>
Content-Language: en-US
From: The 8472 <kernel@infinite-source.de>
In-Reply-To: <whaocgx6bopndbpag2wazn2ko4skxl4pe6owbavj3wblxjps4s@ntdfvzwggxv3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/01/2026 13:15, Jan Kara wrote:
> On Sun 25-01-26 10:37:01, Zack Weinberg wrote:
>> On Sat, Jan 24, 2026, at 4:57 PM, The 8472 wrote:
>>
>>>>       [QUERY: Do delayed errors ever happen in any of these situations?
>>>>
>>>>          - The fd is not the last reference to the open file description
>>>>
>>>>          - The OFD was opened with O_RDONLY
>>>>
>>>>          - The OFD was opened with O_RDWR but has never actually
>>>>            been written to
>>>>
>>>>          - No data has been written to the OFD since the last call to
>>>>            fsync() for that OFD
>>>>
>>>>          - No data has been written to the OFD since the last call to
>>>>            fdatasync() for that OFD
>>>>
>>>>          If we can give some guidance about when people don’t need to
>>>>          worry about delayed errors, it would be helpful.]
>>
>> In particular, I really hope delayed errors *aren’t* ever reported
>> when you close a file descriptor that *isn’t* the last reference
>> to its open file description, because the thread-safe way to close
>> stdout without losing write errors[2] depends on that not happening.
> 
> So I've checked and in Linux ->flush callback for the file is called
> whenever you close a file descriptor (regardless whether there are other
> file descriptors pointing to the same file description) so it's upto
> filesystem implementation what it decides to do and which error it will
> return... Checking the implementations e.g. FUSE and NFS *will* return
> delayed writeback errors on *first* descriptor close even if there are
> other still open descriptors for the description AFAICS.
Regarding the "first", does that mean the errors only get delivered once?
I.e. if a concurrent fork/exec happens for process spawning and the fork-child
closes the file descriptors then this closing may basically receive the errors
and the parent will not see them (unless additional errors happen)?
Or if _any_ part of the program dups the descriptor and then closes it without
reporting errors then all uses of those descriptor must consider error delivery
on close to be unreliable?
