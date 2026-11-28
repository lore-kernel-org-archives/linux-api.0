Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795835668;
	b=iiaB1KBGIHk9u+Y4rk8bBmT/Q/5CYzc1GJPX4JCUdt9TmRYZfFI+qWesrF+wdRRV7gi2
	 rrAuc2IDyd5pwWZ+9fBMnu+8EGc/NJ1wlvEHBWeOjf4nQzHfXk2GiIgT+kqogWKALMeYr
	 jwtREIS3HV8ItUmPA2TmNwp0sn99vePVzjg4f7LeO5tNo0UmMnAP+fA3fULZbeym1LZ2E
	 my7y4Vpo2Xlimcpglxm0YnmnhvyQFIY/4CKzCI3vzaeRPJJFdS5IFaqRudyh6zptJM2Og
	 oJZnV5HROF9NPO2KxZ5o+fMOxq3WrslzTO7v2y/S5oTaW+BW6FLflgofqGjpZ7eNl6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795835668;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Language:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=KTKPmpu7cQqp9OdU/3u1dQB38lywShDeIEXeWARcue8=;
	b=MPqxMfI0fBBE2RQAry8HdueMttpMAB8tG0U6rZ6TcNAKZglxAyAJZwt3GuJwd39g1JWB
	 G78lmN3+cKdE/kTTmhqjYOLd+G6aonuOY4u6xyPZbn+VcisJrJ10Y3JzKS4cCbLPise+d
	 t4vcn262Cr0sojy2vFq4khsPlRm2vOSVIXUkdAqlnn+P8wSTMyD/c8f6diQTCBUzgU34T
	 5IVqWr5SiGdTZxOPOxwiHyGk3Vl8M8Oxpnm8gXBdGFWn5jHGoGu454lxUFy9HZkpZ1gqc
	 bneGn/J9WoCXZWjcFurx/h72nawLgb5anzivLBDBKVl8dVgfzrQbM8LFyj5sDUE15eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=na6IyvOs;
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF5606A31F;
	Sat, 28 Nov 2026 03:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCBF5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=na6IyvOs
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KTKPmpu7cQqp9OdU/3u1dQB38lywShDeIEXeWARcue8=;
	b=na6IyvOsUpAhRUvw5wJnlVmOZKwpv4u7S6ZFdiwUVU7aJuyZBUXKW+lpp5xZRI3qEPLqWRbgG
	kz0oEqWY6ghGjwbDxUbm/zLdpiPSbDMcSuFJ1tiNx4TAbHIzwwT82F2xecmJZ4POLREdUtv0zpK
	0mx4Pxf0e4m+Ze/0a3pN7XU=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jbwNB54phz12LCv;
	Sat, 28 Nov 2026 11:13:30 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 46203202E6;
	Sat, 28 Nov 2026 11:14:17 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sat, 28 Nov 2026 11:14:14 +0800
Subject: Re: [PATCH v4 1/3] mm: memfd/hugetlb: memfd-based userspace HugeTLB
 MFR policy
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <william.roche@oracle.com>, <ljs@kernel.org>,
	<vbabka@kernel.org>, <tony.luck@intel.com>, <wangkefeng.wang@huawei.com>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <osalvador@suse.de>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<jgg@nvidia.com>, <ankita@nvidia.com>, <peterx@redhat.com>,
	<sidhartha.kumar@oracle.com>, <ziy@nvidia.com>, <skhan@linuxfoundation.org>,
	<corbet@lwn.net>, <david@kernel.org>, <dave.hansen@linux.intel.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-api@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>
References: <20261115160105.2507650-1-jiaqiyan@google.com>
 <20261115160105.2507650-2-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3dbb102a-9860-f5db-28ae-801bdb3ae8c5@huawei.com>
Date: Sat, 28 Nov 2026 11:14:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261115160105.2507650-2-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)

On 2026/11/16 0:01, Jiaqi Yan wrote:

Thanks for your patch. Some comments below.

> +static inline bool mapping_mf_keep_ue_mapped(const struct address_space *mapping)
> +{
> +	return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> +}
> +
> +static inline void mapping_set_mf_keep_ue_mapped(struct address_space *mapping)
> +{
> +	set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> +}
> +

Is mapping_clear_mf_keep_ue_mapped not supported?

> @@ -1229,6 +1259,15 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>  		/* The page is kept in page cache. */
>  		extra_pins = true;
>  		folio_unlock(folio);
> +
> +		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping)) {
> +			/*
> +			 * Page cache keeps the folio until
> +			 * filemap_offline_hwpoison_folio() dissolves it.
> +			 */
> +			folio_put(folio);

There is a has_extra_refcount check below that may change the return value.
Is it problematic to return directly here?

> @@ -2070,7 +2122,15 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  		count_increased = true;
>  	} else if (folio_test_hugetlb_freed(folio)) {
>  		ret = MF_HUGETLB_FREED;
> -	} else if (folio_test_hugetlb_migratable(folio)) {
> +	} else if (folio_test_hugetlb_migratable(folio) ||
> +		   (folio_test_hwpoison(folio) &&
> +		    hugetlb_should_keep_hwpoison_mapped(folio, mapping))) {
> +		/*
> +		 * A kept-mapped HWPoison hugepage is
> +		 * no longer migratable (cleared by
> +		 * the 1st error), but it is still in use

hugetlb_migratable could also be cleared by folio_isolate_hugetlb. So when a kept-mapped
HWPoison hugepage is no longer migratable, it still might be the 1st error.

> +		 * and should/can go through same handling.

The folio has already been handled in the first pass when 1st error happened. Why does it
need to go through the whole process again?

Thanks.
.
