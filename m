Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794891034;
	b=HHPoizDmILB9NNmeDwywovGfguox/N3TSkr37t+Hpv2oLRaqjtf2v3348dgzXchKHqc6
	 fse4gpQzDVsLOp0rNxk0MpOp5aCcxEefe/TV7LbfIUnU/seFVUIA46H76SdkjOwrdoSXW
	 H5XWLyS09nTwg0zcA/yw+eJOLEW1zstdXudzG2a2bIHkMjjoGK5eiKLT5OS9aGfDnWu5s
	 EHi44Jdhb1Mhqq4dOUBXiQ2D2Wjg4Pndc68/SeLUXsY+9/nbk0+9aVR3N0FQz/oteD4cR
	 1rt1krOcA1QuDVatGpHMxwGNUJ3Xn4DIk4j1ASUYaSXtOEBzmyzSzHAULW2iQD6iwNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794891034;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=yUYUZ2LlOsiIpdrbhk1wJZRY3ayR3Noi9TQPGtDKtP8=;
	b=lfbrFXrVqUT/EnG0SljpCagpN2Zf/JFWkM9Wsg+INUTEJKaniPF41VxMfs99IDZRPBoV
	 4EkQMPY6viPzmcIYUlKSrfwA1zZIQNfNok/Czr/KKjDlS1Fa/bBmhVygBikqXqZiqfaEt
	 VlS3WIay1cPf1067mV7gTuxwlYpfeb9khiMQIPPge5WfTJRT1UTpsVR3hFMnHHfhzbo9U
	 rGz9JD0rnEYZIYx9DAOb7hl8NcKU0dqdiESdEY00OPU86dYDanbu+JHAr+1iNpfM7qdB2
	 YnDeS9srgEj+29cjvrbP0YlUnXxxet8Grpzt/+Pag/CBjQordmtU3QD7a3JbWSwDG2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=xGusYjGi;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB38606A323
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 04:50:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EB38606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=xGusYjGi
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-170135e43c7so6784087c88.0
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 20:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794891033; x=1795495833; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yUYUZ2LlOsiIpdrbhk1wJZRY3ayR3Noi9TQPGtDKtP8=;
        b=xGusYjGiAdnGxncVaBVneIpjK1Ph9eHqEeeWt7lnJOkMFdfkTt1BtipRJ++rtd7axm
         TNY7mXokRzpdPDScm4nkTWyZVHSDCLj45TjHq4Sbviprep7R07QzTsdMPDa4KrXp2Rvn
         8lsnvqGG1oEchDAwidDM03GPkgBCly20w/qqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794891033; x=1795495833;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yUYUZ2LlOsiIpdrbhk1wJZRY3ayR3Noi9TQPGtDKtP8=;
        b=UACwsLWpoiU1aqqsIUJl6Gtsg3zZdaxcZYxhkbvo4/7jJK/ZpZJfh6qvCbDlEZcGHy
         HaSRAXJaQQBx5/Spkw3Hwt3xw8tzpwDOUZjbcP+pEbE1SijT6rsmYIS74zDGkncaa4xq
         O94ebVaXsy/3jQEfQA+BukQmBJQUvbtLpLyG4Ah+wWHFItm4hQbXn2olNISX9vbBcCY6
         QATFl3huDiT8SJDKA1mj6mCLChKSUU9iDGi0RNpYIWOHdXCUsmy3LdIS/c0s381gwBS4
         hzERJDkn3xr/2djlEs5H2cvh3lwGHplKEO3uREnfI/SnA3LKm2SLBvkEI4MimJhxzUw0
         BX5A==
X-Forwarded-Encrypted: i=1; AL+hErEivf4txWrzeuQI2nLXtcuHbXdpx+rfYkwZ4T7CG44oAXDKXaAhrYEIkWE+92WKMHT79iKWPL/oAC8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9IH1SOVDIy7omH8d7H+il7yVrRH+an2odv0ulp6cNsZplMrE1A
	K+4RBkaINQrqD8gzE26HFivjmjbGvVS/HGBhG4MskOGp0BlMd74RE2EsMoSudQzTjPE=
X-Gm-Gg: AYBFou1492t8x93P72NUU9feopjqOA6a3vamwqcgZbmZGpo30B5AiKREn8jJdcCt8Sw
	9C3tCnGcaaFmXRIAO0ypyQwStp9V8d+OS0+EZOpl6JKFgR91HWJXgjcHME+IbAbhOpIsY7qL/KB
	E+Eh1iAO25FJp8MiKUu8ZoHaxFQRFRFb1yO4AD20CXkOCV/Am/AzS4b/YBSRVefINCo1rI0Gz4F
	uCTe73QopL/t1/y6whsXfLxSsXMRcaf4uauySLorf8Ls1Z4vfekBvv2MhxpkNByDnHcziQsjE3/
	1eB4omBgOargtEdpwASu9oQM72mKE1N2IcrJQ0bkDdtHkrFKHAdcLADuW4gSip/oT1nmMP/Z5kR
	SitsliQ4E/3hv6c0qWIESXFYrWhYROFMNIvXOU5bzsyOEF9Skh6rizcREbBJJ4/ckKDbnWxDH/K
	GPJ98uKMS9RDGelHlKYuFFaW2iQ9Z36RHKJQlaN8s/IJzV3zc0yp9EmWWcuYE7Hjgf63iEBTZ43
	/mxXcostwtKHLrIFnv4Qo3/eftHdT0jipIeFE6DtoRexydlESVJS+B5qEjVuNlehzvJSv//najh
	kI9ysTXXm+mm9BSpRh6Uy5+p9mW/I74ikGZWUatq4VV2KXtLJTYkswvmrOu7M53Jz6mTWTmDobh
	1Bv2zspGdJZSFLAx2xVoUSOrBlaicPrHb95ebHVMjMUgPOnZXP4UHWGApeY9MZYfw/IP/Z9WWvs
	NI6gEtlGdAVY7SSm3uErjuLTtR/5qADTphJ6DDfb7HznDD1JiiJJLLPsQdXbQzKv0Z
X-Received: by 2002:a05:7022:1583:b0:1ac:1343:fa54 with SMTP id a92af1059eb24-1b503112a8cmr13989391c88.14.1794891033256;
        Mon, 16 Nov 2026 20:50:33 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm43375533c88.5.2026.11.16.20.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:50:32 -0800 (PST)
Date: Mon, 16 Nov 2026 20:50:28 -0800
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
Subject: Re: [PATCH v4 1/3] mm: memfd/hugetlb: memfd-based userspace HugeTLB
	MFR policy
In-Reply-To: <20261115160105.2507650-2-jiaqiyan@google.com>
References: <20261115160105.2507650-1-jiaqiyan@google.com>
	<20261115160105.2507650-2-jiaqiyan@google.com>
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
Message-ID: <avvdFHtnw2BlE5Vq@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Jiaqi,

This generally looks reasonable in principle, but some comments.

Jiaqi Yan writes:
>+			if (!mapping_mf_keep_ue_mapped(mapping)) {
>+				ret = VM_FAULT_HWPOISON_LARGE |
>+				      VM_FAULT_SET_HINDEX(hstate_index(h));
>+				goto backout_unlocked;
>+			}

This doesn't look right to me. For example, hugetlb_mfill_atomic_pte() also
checks folio_test_hwpoison(), so UFFDIO_CONTINUE on such a folio still fails
with -EIO. Also, do_migrate_range() calls unmap_poisoned_folio() on any
mapped folio with HWPoison set, so offlining the memory block unmaps the
hugepage after all.

>+	folio_put(folio);
>+
>+	/* Refcount now should be zero and ready to dissolve folio. */
>+	ret = dissolve_free_hugetlb_folio(folio);
>+	if (ret)
>+		pr_err("failed to dissolve hugetlb folio: %d\n", ret);

This isn't a good idea when somebody else still holds a reference, such as
a long term pin from io_uring or iommufd (Jason was asking about the latter
in [1]). dissolve_free_hugetlb_folio() returns -EBUSY, and when that last
reference goes away later, free_huge_folio() puts the folio on the free list
with HWPoison still set. Now, while this sketchy page may well never be
handed out again, it is nevertheless counted in free_huge_pages, so a later
mmap() can end up getting its reservation against it, and as a result, a
SIGBUS when it faults. That seems like a real problem for a VMM with
passthrough devices.

I didn't check in detail, but since the folio has to be dissolved when its
last reference goes, wherever that happens, perhaps one way to fix this
would be to do it from free_huge_folio() instead, and treat a HWPoison folio
there much like a surplus one? That would cover the pinned case, and I think
it would also let you drop filemap_offline_hwpoison_folio() and the
folio_batch changes in remove_inode_hugepages() entirely.

>+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
>+			/* A new raw HWPoison page in a still mapped hugepage. */
>+			ret = MF_HUGETLB_IN_USED;

This also looks a little wrong, because a 2nd error now gets past here and
reaches the hwpoison_filter() check in try_memory_failure_hugetlb(), which
calls folio_clear_hugetlb_hwpoison() when the page is filtered. That clears
HWPoison for the whole folio, earlier errors included. I'd suggest instead
that it only undoes what this call added.

Thanks!

Chris

[1] https://lore.kernel.org/r/20250120172626.GO5556@nvidia.com
