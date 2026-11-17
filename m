Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794891038;
	b=dWl7uq1okdtac+jGw9roHw54MwI3qb1hV2Me4bqqRW6mszDTxvfxJU29RTL7cSzUbkZE
	 za6kuMEeaG9+4G1Xkyn20PQUBo+ZQQXF0N+m7gNw5taW9MRtwzczc6xWju5Peo+Biam2v
	 p9u1aPepB/xbYF9gUJGmnuSKKEy4sPuKsHeuxesjg1LaKXBf5/WApUbs8NqjBFB0M0/E4
	 6W7PD4VfyjQiyMNuPM8nQqmnGAkVI3QdKbHE2fjUOjQvX1Rg36OHc8Oy8Dq9YQKqph+zE
	 zqCnOu4NoYC6L/PC6XfA4EGkfnoQL788hgcczKjV8IVggszFoiTEv0mpJATSvAHazjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794891038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=9bqqmMB4+kyoRGHHPejEHuADL6UxgHY0xArC5J1XYUg=;
	b=Rxw3IC4v4hZE0bfI/IsqbKOx6fbN3zqTNNzkKMDhYa3LEukICASt3tKZuB/wNclGVjfJ
	 NSugYFn5BmraT4i4dm60lmigfRO6i5fTVpS5TfwA09fw5eig6nRCaPRgkkjCmcrA2ejiP
	 +t6SCbrcU8Vj/cyP3Wn/xOzR3T9lB73CSBDT3nr+ltxwGkO35x6cAab8ESNh8dr6G+hrw
	 oaomyOxPzD6nb8V6qoZUn4wO6E4OJgK51rWhUGahWIcOHsip+byy6353Yj79qOvbv2Iuy
	 heZzblvKDUE37M/uX0bsARxrhKAUZU3FKqmdgbywiW8DUmXpQ0t9UNLVcYql0ZpNjTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=JVoEkBuR;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4CC606A33A
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 04:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A4CC606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=JVoEkBuR
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-14394530ec6so5373834c88.1
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 20:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794891037; x=1795495837; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9bqqmMB4+kyoRGHHPejEHuADL6UxgHY0xArC5J1XYUg=;
        b=JVoEkBuRB7FQiKYHvBCxvAxh9Oaxf01xN5UIrTjfVi6OU10CeKbp241d27RcBRcSsk
         /Xi/x0gE95b4H/4imd4d7XC7TvMqKuqGtZq30FdKfitiezpDW1A26JSOriDXlFFBwZBZ
         HwMfdVtpba397eVPFTvqZp/IbohPL8IT2620Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794891037; x=1795495837;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9bqqmMB4+kyoRGHHPejEHuADL6UxgHY0xArC5J1XYUg=;
        b=Z/rtobVnIxp1ROAWwQk0o3j/9t4M9OMiBU68rD2ILznFpeoOzPAr9K2+ilKRAmgt7c
         IkF7BojaO84kOzCF/3q+bnntmUc2WwSO4oZ1u5y3antCPy3np9xTx624MMCi0OA9cmAy
         4zVhwEXOJxTSRiTIMZ+OZIHHG5yP2xlah0Kkiadzutgjadw33AVnrx44twx8WyM77Tsg
         6sbFycMFZomBwjCBd3bt6R5WeTSbov/BeV1VUiwwwJy5mLS0fBR501b4aFqyrlz56SLy
         Q/FVEdXlFQZwzuXVNiKk2jN/MOukUSSSxiQ8r2H/EVwianYBn9VASYV/JjoJHiPXMQRA
         Wuaw==
X-Forwarded-Encrypted: i=1; AL+hErHWYx8Gr7FxzP/lRcwPJBULWkfTGLOkSOpDL4fUM4ZlkH6g4LIrr6xzVBJLWisWM7cWXC+nrmSyqz0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+agl/syx5kM6//Qzd9ZKvRtQTwgieaZmLJQCguyRbiU/V5j3I9
	ERovkpCvtnjUFU05ieVtiavOXo7x558vM6LvQoVcR3p6FnimYhxDN1ax6wayBLJyrzM=
X-Gm-Gg: AYBFou2Zfc83iMahvOkHe0/6YbK53lDoFC31I+G+a0DKoORB6HGBQ++ajhKniq+9yk7
	Rxdplt2u2oD9oVG7XaoyzozqetvhtPTQnkn8yJmviDl3GNgHldvqKuf9zmOaoxDq8Qlw95Ei9bU
	MLcwwOALEbohiqrb5MHQxKeFUuCZcb7O99Dby6EqnIQHrvMXKOW1TyZZkUelP8FILFhd3V08LlZ
	DvGjqHiLPvueORgphtwme6OVYtNLohPzQdcOjNBIRSlS7nvQvgXvsIjOzj+C+3VvUpEytI1E5v9
	c4MKy8Mp3hII4m7n9glqQgAGcmPyOYYT6cmtV1VHFgqECl3oLurNVULTnd/h/F0Z9BskP/1OlNv
	ucPQCszhp5Kcms1L6t1inMHjO+75h1ZMKTg5IG2VMuAk+924C21DnY3yjrV041Cj5Gk3hshYVds
	FlLEyn4Vc6oZiL/UnQpnQY1nhwlrMJMRrLCGijLtK+nD36sdKAb3mH/zN+mxAEN2yLgpgrpv/XQ
	GhayhjAnF1Xm67RCXMh1Wp7Z9MB3B4DJKK3h/GOPrC5gQ793H0SKD4G7kMKgSqe8y2lpdapf+oN
	Jn3LnE9UAbwb0HlrmyRteciNrd18ddwwiH5rWak8jxoTo7gZMw9daJn8LBTuaH8rJKwMAHmvooU
	psB3zLq8STF6UYIcdtXcrx4/FrT8aBUG01hUAlQ5L7uPdrwu4K0lGWH3JM7wsrkABaRQ+lLOfe4
	ODhj+4yEuQiBVr7MIMfbberHZpwc93tcz2gAnX1Luy6/0I27KmpIP4c+AxCQ+e5mOk
X-Received: by 2002:a05:7022:96:b0:1a8:4997:65f6 with SMTP id a92af1059eb24-1b503105175mr11734678c88.20.1794891037361;
        Mon, 16 Nov 2026 20:50:37 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm53517692c88.9.2026.11.16.20.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:50:36 -0800 (PST)
Date: Mon, 16 Nov 2026 20:50:33 -0800
From: Chris Down <chris@chrisdown.name>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, nao.horiguchi@gmail.com,
	william.roche@oracle.com, ljs@kernel.org, vbabka@kernel.org,
	tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
	akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
	duenwen@google.com, jthoughton@google.com, jgg@nvidia.com, ankita@nvidia.com,
	peterx@redhat.com, sidhartha.kumar@oracle.com, ziy@nvidia.com,
	skhan@linuxfoundation.org, corbet@lwn.net, david@kernel.org,
	dave.hansen@linux.intel.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/3] selftests/mm: test userspace MFR for HugeTLB
	hugepage
In-Reply-To: <20261115160105.2507650-3-jiaqiyan@google.com>
References: <20261115160105.2507650-1-jiaqiyan@google.com>
	<20261115160105.2507650-3-jiaqiyan@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvdGec7NCt5oAFr@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Jiaqi,

Jiaqi Yan writes:
>+	map = mmap(NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);

This isn't right -- a private mapping reserves hugepages of its own, but the
4 hugepages that setup_hugetlb_pages() asked for are all in the page cache
by now, so the seal mode fails with ENOMEM when the test sets up the pool by
itself. I think we either need MAP_NORESERVE here, or to ask for twice
NR_HUGEPAGES in seal mode.

>+CATEGORY="memory-failure" run_test ./hugetlb-mfr

Probably worth adding a 2M line or two as well, since this only runs the 1G
case, which is skipped when 4 free 1G hugepages can't be allocated.

Thanks!

Chris
