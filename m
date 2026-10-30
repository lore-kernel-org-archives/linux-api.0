Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362278;
	b=15MUzX7e2UovNv5TqLdou8nOJrLeBP/I+H1/DZgYHDQrExC4tV+OciTgjHnG+HVTARND
	 4S6gtxlUoT+FCi6o3bHbnMSQ0O9u/aMCqhXoCBRngUxwAxNHDEFN9tKEG4X58faFrXK01
	 gMT/7QYZHVEITfIXFRbeA0KenvkKGLHtGUD+EosTkoYywtlJixT0x59kZo0xQEyX/0rCe
	 y2YPX/CWi2OuxKDIt6gb6LUCWrMAUVgR/OBdKXvILtj6YSoiN1X3QBxZpFEuuVQ5Gf2V9
	 YiG9YXQ8OlVFzYcCTcD2bU1CW+RYw5gBCzEtY8NbYJ7LtZFfOfhp4+B72ebnPSMMGOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=G/h51dJLYeoxkjlU1HlBvF+u6DEcazEkF7G3j/5sadA=;
	b=x1fhf7jjvlrpCBTE/Icai+HQvbzt68lqd0IXw4M52KHLFxflyAFfBvXXQL6qETGvG/2E
	 +VgQQE+L29O7r+tH+apG2BCr0C/BjYKBmXcRI+Jls24sZGPCU/BXKcPVi2GGJHFUfCwQy
	 jt8LLc4+FBFnJEYVo903um1uO+4QFRLTL+dkj6F0LGp6ZaYE/UP6b/S2ULy/FVpMmInOI
	 ZT1UNWzCxq0SipfCK93rSUqeR9gZ4RJky7yFc2aPE0MiedzJOMuoUt0RO2ZptbDC+QpRm
	 hzprGnA84+ITPGNa0Tcm879gaUEKykuevYygtuVdNS4defsgW0CN2Mbt6fDKvqAR/Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=oA0v8sIN;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA01606A31E
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 12:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CA01606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=oA0v8sIN
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91c5e31bea9so11020416d6.1
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 05:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793362277; x=1793967077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G/h51dJLYeoxkjlU1HlBvF+u6DEcazEkF7G3j/5sadA=;
        b=oA0v8sINgPPBKIONlsdYbjsJ87rAJ5i6eE5Q3YCIsLvFbiQJhGexz0GbyEDNCCZD6a
         p0MV5c3Uczdjv1XhsiIbQTtQi5Vp2z9yQeVX4ao9fyJVBycBF5kXx6/mTl70TjzMnCok
         G05SbrF0c9k6ZAJLXKzphYMVEDDK1GKw8OzgWBjmFyaaEHgwUvrNLYQr0skqHxH3T6Yc
         OVQx4BFegmIqmLOk6yQ05bXf4dIWwIB1X0cX+CWl48PDaxZ4x/cigd0Ch6rsN8lEPgGi
         dYcgWMLfovRlIlaP8ltfoaB26Jl6NCQ4kppLz5tTRxjKHm2+76osmnaM0MUb41a3+Q82
         f1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362277; x=1793967077;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/h51dJLYeoxkjlU1HlBvF+u6DEcazEkF7G3j/5sadA=;
        b=gFo5uas/YjxNhTgTEDeHB/OkhreeAVt6ykFQnPWLViI+SN/E/g0Q6TudDT1rdGbj6o
         WTSl+8Nm+W62czRTb75k758jbXVxyQ/w9Gd9havyzIn5BzWAb4qyh3fecomK1H3fshZt
         uyj5owebViZYOdjwQ1uYbOhdu7vhVKNkBJBauGtEz1YjK5cOv5ivNA8QPSpNroyvfc9H
         Pf2JD+NpgR2oXd4POjQgPhq3wKGMvUwUzELvyvyQwlHJmRBEfWXIMzSAQwmJkPPJu8d4
         Ffg+h6TtT57RlISolxSfkVuzlBBVreJv7SGRAcngburRn3BrS1nwzqLece9VYaw22l4o
         4GWA==
X-Forwarded-Encrypted: i=1; AKwUvBw3ip4vjKcaUA2QHAw2oov9So83cjQKwhr6gSzo5/MuARWDFPBipuJYYUA5SnouAkWTo52kcQwuc68=@vger.kernel.org
X-Gm-Message-State: AFq9FYJwD4JXkALOyjIkubrS4H/CQox3UcNQcaDjGRH8gjyz4+H2YVWi
	ii71in+gU7Pe4mMzgDD37BPMiEe17ipqm3fkia2ayaipdkSckiYfw799mxp082WzIew=
X-Gm-Gg: AYBFou1ZMykoOJH9ag0DD0l7xt7fsajOzldRpax/U6nyCfAtiLOWgvzw6QaW6m0d9Lq
	49nvDct7Z55JQrG/W8NgTsomF6Z8Bc0SHKA55pn9H/vkSiqEoqk0LCyVOtU58BuqLVtxc//lYU0
	UnXLKP/30l3REH8Ttr1c3w0lenZ+gLVIi5fiBMPzg+6sSXjze0+0Dp3PsZge6YiQYpfP6aWgcAd
	XuNCP5W1uudLY05+vV+0wQpt0NsrxBvcpWOqkf7eVkuFJzcMyiGD4qe7vqCVHiu7lnlyKNHydjE
	JqPFzbjdZWtefOdiie2Fjrc9+PsFNCBF1GzpPNV5ELKXuikWZO7NxNbW1p5Tbt/DkO5/KOWBXyM
	dQDTSTt5qcpEh3dnoyj4Jr1tMRIxRG4VDTBKoMuRnjjlIZpi3AGdPTMnOTHqYMj4Kq04pkPkvYG
	IN0UepnPaqAqGJyvQgPSWHCfGwLmZ4gC/7CfpfKstz3WcMwNZSuPRp/PNwJFyqOCkPBmpKART65
	Rqech2sg0aOU5DZ9GwgZB0kCLte68/GqUTirsEU9F33ni3yWDUtKap9gcKcBbeF2h95ZJox2HG5
	ggptqpB5oh3UlJcletVHKCgudx4b2OgGRH/P4gQ24LfKntjQrgi2HC4T3p7MiV0MoWJcHIeJvaO
	vCKW+LGKWdXcYuucurU6XvaHAQEApLbH0
X-Received: by 2002:ad4:5aa5:0:b0:917:848a:43de with SMTP id 6a1803df08f44-91ca49e9300mr29477496d6.8.1793362277155;
        Fri, 30 Oct 2026 05:11:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca804ee76sm14028506d6.26.2026.10.30.05.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:11:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMlRx-00000000ZRR-0Qze;
	Fri, 30 Oct 2026 09:11:13 -0300
Date: Fri, 30 Oct 2026 09:11:13 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
	Alexander Aring <alex.aring@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <20261030121113.GB3889730@ziepe.ca>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
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
In-Reply-To: <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>

On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
> On 10/26/26 23:05, Samiullah Khawaja wrote:
> > This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
> > holes from being punched into a shmem or hugetlbfs memfd while leaving
> > the file fully writable.
> > 
> > Background
> > ==========
> > 
> > Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> > memfd_pin_folios() to pin the folios backing a memfd and hand them to a
> > device for DMA. Pinning keeps those folios allocated, but it does not
> > keep them in the file. If userspace later calls
> > fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
> > the folios are dropped from the page cache while the device continues
> > to use them. The pin holder is never notified, and from that point on
> > the device and the file silently diverge.
> 
> We have the exact same situation when userspace maps anonymous folios into vfio
> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
> used for such purposes.
> 
> User space must not zap/punch things that might be pinned elsewhere.
> 
> That's not specific to memfd, udmabuf, iommufd or anything else.
> 
> I don't see a reason to make userspace (that should not shoot itself into the
> foot) a kernel feature it must activate itself to not shoot itself into the foot.

The issue is live update doesn't preserve those background punched
folios and now we have created an UAF attack on the kernel across
kexec if you don't do something about it.

There was some notion here that with the right sealing flags we could
tell if everything was 'live update compatible' and then know that
these attacks are impossible.

Jason
