Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623752;
	b=btC8fw7dG+ZqeJiyO+fctrZz/eArAfowDyi1U05nRzldQy3lRg+6PJJPiFWlR1TWGAfl
	 IzHzDSatBnswurOq3Y+61QT+Ax/55fkwO95U553/h/hi1II5OKrwwuJI1MFJbtsYq1ghi
	 3/pmCwGlgs9k35IMH4KgYN4j4YTbuc29j4Usyb/0k9efLQvGYumcrYyoYuEeTg3z32VSQ
	 T++pR+wqTbkb8biDgM8WzLj+Abr0ULsn4RlglDmHCnDMNsUlTzAM9S7Lqurv3kTdA463s
	 E8Io1ygS+wCqjZKc2RgAs+BpnQtZhuba/nWIJvEcfrgD5UmvqWd6E60IEhCcRVTJE6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623752;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=i8NTQB3dN2QpIdebJsLSmUNNG/IYt0L9NmfBKr3dfDw=;
	b=wl/zEG9zxvfWc+0Fj/Qf2MHm62u2B1g5287jJ4w1JgPzYBumq068bjknCcrt8bgghkcW
	 kTxFEJB1R7mp/vxfy2uv0qOAkDSPNkuQGsd3c1G+A+48CrseZ2m7PwhcZpt2L0JVZh34P
	 O67ZCyBgDu59ffxP7xjdTybLDXjFnZ14NADbNPktVAyxQZbdL2WDOl5LZ8t54FOCXoBkz
	 8z7fKY2zX4Getr9I7lGRQRsLS/YfEkEtwY0rWX0eQvWV4vnfvNRJgM/hN26G71f+IvNJp
	 KYaldD9j6gMZauDjwrN1lFBvbtQr460L7IVKi9mM/l7zdd9FziU5hg0CI+QV7P90sjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=NpuobCOD;
	arc=none smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6442C60A3828
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 12:49:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6442C60A3828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=NpuobCOD
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5bccb867d6fso2608815e87.0
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 04:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793623749; x=1794228549; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i8NTQB3dN2QpIdebJsLSmUNNG/IYt0L9NmfBKr3dfDw=;
        b=NpuobCODsaeMaWK3KSJ7CYeFzFjejBe/CdpSaMImxO/psFfYWNgksAz6IaQBHVoGnw
         yG4TCf9GwWszKn5P0wcTjS5/F7bSf5w6P8cLbEzmHkhdfS4xOg4xf7JMiocrxffE62mH
         DVHo0o1CX5jLPh/fOcr4yzR01YrMQb2/9QMO2M4askf2lmuroalMbTS/uP0jeYTWWaUI
         MeE6SgTJTPiWBhC9AUU5hmVaAXjzy50bPM6LOV17JjqC+4inRl/4yDJxVhRxuDK40T5A
         vGvZhmz6TCJp+zWhB42LV9spfusWTm3gQ9YT7of8ECrFocRAwvhVwM0uOZ6rJaD5eZkE
         XJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793623749; x=1794228549;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i8NTQB3dN2QpIdebJsLSmUNNG/IYt0L9NmfBKr3dfDw=;
        b=dRQEfpFBwlviuq3p1IOgp1l/Fvm5jf1fLP/BzJObZssGE82RKw3EyPgLjSdGfuDVLy
         LKQyV1HW7r0JTp1ATpYdEqU+CyFGwt9AnIWgtGqX6mCwv7JPLkf/WWOnUgyHhugjzBOT
         /ht2SdMsZwibkzj/YXfSM7AlsfZIsWDYQfr8CO5qq/GsTn6wPcmYgl9mtnOLPyXbQ7NV
         xmVMYFNHgTxd3T81EUsnEKmDpzbPXdJ8gzBpHjrIYmjhVmlxm7TT8l6MOIYBOdA2XbBr
         5ZpRb9YK10Nw3FBb0zgRR1AMJdzAXSSYEQOREXFmT+3Z5mwcyAAtBbBUIz1/05OLGdo7
         XeYg==
X-Forwarded-Encrypted: i=1; AKwUvBxB5KZRuLQ78+Oi8bECOZBiZttx+oEvhEsP76PHjFw2osMI0tuBdroE5svoMJbU4cMZBF9t1FMQXu4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+VHAnmccUJvb8Ua3nd0xZOsoUEX09nX4T8YFq0347zb7qGhdIP
	VAXfpieestSfmxgR8ydENtRJ808Kg/nnk9YvIMxYqBE8X4UD5ctB4TZmyIO3k92nPQw=
X-Gm-Gg: AYBFou2oxZ8dvJIdkc9oy8/EJCAY2WQEvvbFAIx5OnZHSvsoG3f8drBWf298dPxhl49
	xMdQPhOhnMzwRVOIWPagaW19w+wbHq7tefrlif7rhshf9Zs5BL5Fnq0IGvyUDdqoWPG0NRBwx4Q
	95GNvQaaiDfrorXa8ZWi6gzFlc6KXAdkFd+J5Z2UT+12pXseKU6miT4XBu1ixPHZqWXEXpGqbRR
	e8THlCBOZ8H8AXF84ncNbDDf2quHsu4ixdvaIvBPPs8MIxH97tubwdaEANxWlQbj+hI3+V1QYDV
	wxF7XQPWKS6E5IdmusKGRn+7MdsOOmL1aL+/v4SiqezLFI44O2kmpAD/rssO4tZTSV5OsUK82A4
	8BJIpZP5/x3qZJ2/8/BXXhd83xpOBj1VYqO+tJXkA5gkZiyzqmO8udVN2tYC5KyEa81nd3rDiBL
	sIscdNg0N1htksFIKJ5CD2WmdVx5sDHAazJTSXpRaOqzAvmgcvJAbxi110OqOIqFjXhnqzXvWr1
	KO2l/NSGWdkcQrAhvDuddO6aoVEI+k55dOB4X4m6U6LSzLShhylI0WLrmUc/Bu99pbpHQQney3N
	0H/eRs0A2TfWO0CjEsHzmv2bKmyFxuqT34ghQQw=
X-Received: by 2002:a05:6512:158d:b0:5bf:e799:c7f3 with SMTP id 2adb3069b0e04-5bfe799c920mr1589103e87.61.1793623749527;
        Mon, 02 Nov 2026 04:49:09 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe04ee003sm1638014e87.7.2026.11.02.04.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:49:09 -0800 (PST)
Date: Mon, 2 Nov 2026 13:49:05 +0100
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
Subject: Re: [PATCH RFC 10/20] ctlv: Prepare event queue support
Message-ID: <auiGL-Xq72i5K8FT@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-11-jiri@resnulli.us>
 <auCbPdoaMq9oWoQ_@e129823.arm.com>
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
In-Reply-To: <auCbPdoaMq9oWoQ_@e129823.arm.com>

Tue, Oct 27, 2026 at 01:38:21PM +0100, yeoreum.yun@arm.com wrote:
>Hi Jiri,
>
>
>[...]
>
>> +int ctlv_event_emit(struct ctlv_op_ctx *ctx)
>> +{
>> +	struct ctlv_device *ctlvdev = ctx->ctlvdev;
>> +	struct ctlv_event_record *rec, *next;
>> +	struct ctlv_file *cfile;
>> +	u32 len, wanted = 0;
>> +	LIST_HEAD(spare);
>> +	int ret;
>> +
>> +	if (WARN_ON_ONCE(ctx->file))
>> +		return -EINVAL;
>> +	ret = ctlv_event_finish(ctx);
>> +	if (ret)
>> +		goto out_free;
>> +
>> +	len = sizeof(struct ctlv_event_hdr) + CTLV_ALIGN(ctx->output.root->len);
>> +	scoped_guard(spinlock, &ctlvdev->events_lock) {
>> +		if (ctlvdev->dead_announced)
>> +			goto out_free;
>> +		list_for_each_entry(cfile, &ctlvdev->files, node)
>> +			if (test_bit(ctx->op->event_index, cfile->subscribed))
>> +				wanted++;
>> +	}
>
>Suppose at the time of here, the number of subscriber is 1.
>However, before calling the ctlv_event_deliver(), another task hold the
>event_lock() to register new subscriber. for example:
>
>
>Task 1 (emit)					Task 2 (new subscriber B)
>
>wanted = 1
>unlock events_lock.
>						Register subscription.
>allocate one record
>ctlv_event_delver()
>
>  grab events_lock.
>    Deliver former subscribe event to old one.
>    new subscriber B will call ctlv_event_queue_event() with NULL.
>
>When this happens, new subscriber B would receive overflow event
>via ctlv_event_queue_dropped() though it was registered right before.
>
>Is this intended? It doesn't make sense that subscribe B receives
>the overflow event in this situation...

Not intended. Will fix.

>
>
>> +	if (wanted) {
>> +		ctlv_event_copies(ctx, len, &spare, wanted);
>> +		ctlv_event_deliver(ctx, &spare);
>> +		list_for_each_entry_safe(rec, next, &spare, node)
>> +			kfree(rec);
>> +	}
>> +
>> +out_free:
>> +	ctlv_event_free(ctx);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_NS_GPL(ctlv_event_emit, "CTLV");
>> +
>
>[...]
>
>Thanks!
>
>-- 
>Sincerely,
>Yeoreum Yun
