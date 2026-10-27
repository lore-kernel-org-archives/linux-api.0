Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088145;
	b=vpbMeScvccWcSdae+Tr7JFZ+2djCo+ozpUNOe9YY8Gt9TNfamEmm+8VmbJMPuyHj916o
	 U4+ZGDzVB9OrkaJnEXkN3dku0QDWVh5ZDUpF+0sF8czL5riFQ4HNS2bSUl3Q8LWNeyCxq
	 NyM4bCzxNJAbhDHWU/yP8xji6WLVuSQbe73xjlx5n2dvfypd58HKGTZKcTgMcmQ1PQ5AJ
	 4WlXqy6O45XPgLvXw+H5eh7XFq5mKpStF+eEcLghIU3SUH1hMz+qhIRCsKAjelO4xkS3m
	 naDbK/QBeN8es0bjzes4b6RHF5qa9l5zQs9scXV7cezZm6eYA2iAYn9ZS1qbsYNVcXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088145;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=OscTJ3e2MwqNjRkFK+nwymaDOQ752snX6yOO/B0QxfQ=;
	b=no8nqyJ82X9nlugq9PaXI749mcwouFksMyoCJs8SgskUM9F5DEbztfxbako/hZmlqXTi
	 5/HTmo5+6he2ondh0bReh9YANTqSOX5LVsvXIqpweJMqthB4k8gYxYcukZ5+d9IqGPrgj
	 up02KjGt8H6xWcsjHJI73O9je79snwisEQPdQGOPC2f09Y6LrqaaDVsz9Y+IbgvccXk0V
	 5gyntqW9EqXmRr2M4c0PkbyJJrzqj3MQSGRpe94fAWBWLoq3uW5YgK/0B8AT0Vz8l8Hn0
	 yiy5I9ysG2mKdlj3A7FVrFDsORZEjEPD0d9/IxwURJXSKuKbeo3GiRz/9/8Sjvd1Qpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6380606A31D
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 08:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6380606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b486e1d02eso208131a12.2
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 01:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793088142; x=1793692942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OscTJ3e2MwqNjRkFK+nwymaDOQ752snX6yOO/B0QxfQ=;
        b=NMolLpc0FQhsbKyPXNo5vD2Cg/BWu9T4qNEcyg+3upoDCV1i8kqFJu94GbYuaYaXI5
         6+weD5fjAM++wwTRv8cnloMadOuoPEYhXVjfzw0pQw4FM6O8rCvPezIKWkX3EN5AnQXo
         oxBKOk1KCeHT6g12Bzu3kgqdZKaMVF2DpbUsqVhRdEijIE65ENncgcux89BxZu92khyP
         mhKFEYHqyf3lF/OiBN7enB1E5XfpoxHnaUgG1pmH0KyKEqklYKNpHU47YfTGJdpowBCZ
         LCAL1qW/7D4gjRPK+mBsDM7hr4CQjEqUjhbE6HMUtWiMBY9Z4+HqxYMWagUsowXBnwkz
         HOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793088142; x=1793692942;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OscTJ3e2MwqNjRkFK+nwymaDOQ752snX6yOO/B0QxfQ=;
        b=WdXu1nkdrLS2O8mIp8cqabz7r8r80S0y6gHSRYtH+K8R9T+928En707p2GyVpCFzmS
         VzuNpxS4oxjxt1/b81kv18SqMCgyuggG55rMHqgGEWixxwoiq9Et4u1x83WN9fR8F0Yi
         jqpjlxBXcTFuzuVMVYktjL9X7Qud7MpUuvRpzgs3SxxBu2OloVFovpzlLkBy+Bw1vexg
         H9FDKQy/18u/bJV1BKtu3KU8OVXibfGRN1bu5SY4O80Fq8YZV+dBtG63QRBMf8+h6zmT
         fHEYyhvA3dtR6OS84EbmPYAZ+0Qr3Q/1VGHWgn9sXK+MY+inHE8IugQ7C081uYvQRyj2
         pEDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKP0WjBP21MGMzCPpk5m446O3ZMl08xbxfmzE7wtsV9EmU1GUirErFsaxfHvS5c+CG+8PyPoOlVP4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKTP3EPDfmYwPVTv1SYxBh25dZxeNNAP/xTho4zXy/EaifpHlXd
	uMKu5eCkhpGn9bElzMAcm0YKGVMWNvBg8bo5qBwwrSrcu9Jtt6zcvez9uIvppbTwZXE=
X-Gm-Gg: AYBFou0Da5G6VasrJbWb/GUE7p8TXVHxuXMTUnru8wp40RgOwTZHxHRWOx468DB5O2k
	Y57LBfrE56iMEf+mJ8dAOLEh/3M4UJ0pYAdsdb4rPkQ0ghSz3+trnz3Wgpks8o9e4sufakDRCRw
	qu1ho+X0gRFq+BaMMmTyrRsPsX+0FMJpy1x3LZ/h3hqiWNVrUjipF02vL8fXwVE/GJ/EibvnlG7
	WVJipHBTq7nZWwpxsAryD0RS1nD3ZPp8FN8boe3qdFcq0d70OofH1uYNPN2gQ8T3ykqZJuFaWWD
	6eFoM26ZukVqQTu9InP1iw7oClPp/UwHZIbV0w4arKFZ416e8pRi3DagTpDW/Auqy6an4Ov4q8U
	wSg59xvkwBnz7UgwZ/krvTZtPmtMJLrAMq2Fwjnrbx4HIOv5uiOdomVpix5dJs9Nq4aLfEmAqW/
	/Tq0vmdxDMHcNlm+4wXgTOoaOZmsxy780jx8R+Rv2m0SBpto6/05vDjV9dZ/q5zl1lMsQLO8jb4
	HAUcXHI9tClFzD7hBTElRAKy2EJZfJzROOyzDrJa1iu0dkVK07ocvkEV394CpQx
X-Received: by 2002:aa7:d286:0:b0:6b3:8018:7643 with SMTP id 4fb4d7f45d1cf-6b44300a8d3mr6891627a12.45.1793088141026;
        Tue, 27 Oct 2026 01:02:21 -0700 (PDT)
Received: from localhost ([128.77.52.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdd5b3sm21058785f8f.53.2026.10.27.01.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 01:02:20 -0700 (PDT)
Date: Tue, 27 Oct 2026 09:02:14 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <auBaROC0XdWpILEI@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <at-iEMxN98nie1Qr@e129823.arm.com>
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
In-Reply-To: <at-iEMxN98nie1Qr@e129823.arm.com>

Mon, Oct 26, 2026 at 07:55:12PM +0100, yeoreum.yun@arm.com wrote:
>Hi,
>
>> From: Jiri Pirko <jiri@nvidia.com>

[..]

>> +#define CTLV_MAX_NEST_DEPTH		32
>
>JFYI, when I tested with CTLV_MAX_NEST_DEPTH as 32 and try to run
>ctlv_msg_test_as_deep_as_the_core_allows() message_kunit.c test,
>It experiences the *real stack overflow* on FVP
>(lesser value (e.g. 16) is fine):
>
>[    3.834419]     ok 22 ctlv_msg_test_the_bit_where_it_means_nothing
>[    3.836499]     ok 23 ctlv_msg_test_a_bit_no_version_declares
>[    3.837852] Insufficient stack space to handle exception!
>[    3.837875] ESR: 0x0000000096000047 -- DABT (current EL)
>[    3.837916] FAR: 0xffff800084efffe0
>[    3.837953] Task stack:     [0xffff800084f00000..0xffff800084f04000]
>[    3.838001] IRQ stack:      [0xffff800083d50000..0xffff800083d54000]
>[    3.838049] Overflow stack: [0xffff00087b7c3150..0xffff00087b7c4150]
>[    3.838114] CPU: 7 UID: 0 PID: 257 Comm: kunit_try_catch Tainted: G                 N
>** replaying previous printk message **
>[    3.838114] CPU: 7 UID: 0 PID: 257 Comm: kunit_try_catch Tainted: G                 N  7.3.0-rc4+ #1216 PREEMPTLAZY
>[    3.838219] Tainted: [N]=TEST
>[    3.838249] Hardware name:  , BIOS
>[    3.838279] pstate: 21400009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>[    3.838360] pc : __kmalloc_flags_noprof+0x10/0x540
>[    3.838433] lr : __alloc_empty_sheaf+0x48/0x88
>[    3.838501] sp : ffff800084efffa0
>[    3.838534] x29: ffff800084f00030 x28: 0000000000000400 x27: 0000000000000400
>[    3.838657] x26: ffff000803d721c0 x25: 0000000000000000 x24: 0000000000400cc0
>[    3.838780] x23: ffff00087b7e3398 x22: 16e0800080564b98 x21: ffff0008000a0900
>[    3.838908] x20: 0000000000000000 x19: ffff000800013600 x18: 0000000000000000
>[    3.839029] x17: 0000000000000001 x16: 0000000000000002 x15: ffffffff00000001
>[    3.839150] x14: 0000001c000001c0 x13: ffffffff00000001 x12: ffff000800013500
>[    3.839275] x11: ffff00080370a800 x10: 0000000000000060 x9 : ffff8000805627d0
>[    3.839401] x8 : 0000000000000000 x7 : ffffffff00000001 x6 : 0000001d000001d0
>[    3.839521] x5 : ffff800080567b68 x4 : 00000000ffffffff x3 : 0000000000000004
>[    3.839640] x2 : 0000000000000dc0 x1 : 0000000000000008 x0 : 0000000000000080
>[    3.839761] Kernel panic - not syncing: kernel stack overflow
>[    3.841533] CPU: 7 UID: 0 PID: 257 Comm: kunit_try_catch Tainted: G                 N  7.3.0-rc4+ #1216 PREEMPTLAZY
>[    3.841783] Tainted: [N]=TEST
>[    3.841877] Hardware name:  , BIOS
>[    3.841980] Call trace:
>[    3.842065]  show_stack+0x20/0x40 (C)
>[    3.842246]  __dump_stack+0x28/0x48
>[    3.842427]  dump_stack_lvl+0x28/0xb0
>[    3.842609]  dump_stack+0x18/0x34
>[    3.842788]  vpanic+0x208/0x5b8
>[    3.842944]  panic+0x54/0x60
>[    3.843096]  nmi_panic+0xc0/0xc8
>[    3.843273]  panic_bad_stack+0x10c/0x128
>[    3.843466]  handle_bad_stack+0x34/0x38
>[    3.843622]  __bad_stack+0x98/0xa0
>[    3.843773]  __kmalloc_flags_noprof+0x10/0x540 (P)
>[    3.843950]  __pcs_replace_empty_main+0x2ac/0x3e8
>[    3.844139]  __kmalloc_node_track_caller_noprof+0x440/0x520
>[    3.844328]  krealloc_node_align_noprof+0x178/0x390
>[    3.844509]  kvrealloc_node_align_noprof+0x98/0x130
>[    3.844690]  ctlv_schema_index_scope_add+0xb0/0x3f8
>[    3.844882]  ctlv_schema_check_indexed_nest+0x1e8/0x958
>
>(repeat ctlv_schema_check_attr()/ctlv_schema_check_indexed_nest())
>
>[    3.856919]  ctlv_schema_check_attr+0x3dc/0x538
>[    3.857105]  ctlv_schema_check_indexed_nest+0x788/0x958
>[    3.857301]  ctlv_schema_validate+0x88/0x180
>[    3.857482]  ctlv_msg_test_as_deep_as_the_core_allows+0x11c/0x1e8
>[    3.857698]  kunit_try_run_case+0x64/0x188
>[    3.857878]  kunit_generic_run_threadfn_adapter+0x30/0x68
>[    3.858086]  kthread+0x10c/0x140
>[    3.858245]  ret_from_fork+0x10/0x20
>[    3.858398] SMP: stopping secondary CPUs
>[    3.858630] Kernel Offset: disabled
>[    3.858720] CPU features: 0x0,00000000,00b0802e,9f190bc3,2affe72f
>[    3.858872] Memory Limit: none
>[    3.858976] ---[ end Kernel panic - not syncing: kernel stack overflow ]---
>
>[...]
>
>I think it might be good to configurable according to architecture
>unless it's not good to reduce the CTLV_MAX_NEST_DEPTH number
>otherwise, increasing stack size when CTLV is enabled seems unresonable...

Agreed, will lower it down. I think we should be okay with 8 for start.
