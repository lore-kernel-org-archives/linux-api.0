Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214966;
	b=LoE2T0oMymMA+TyFWsK9G0ob2o1NX36w9V4AMYptNu4N8OZRJags4rjBJQACdl9rRVWW
	 fo9+7ubs+7i9lFiXaG0KElj10FYTQsV8RIEl5SwxFYzpZlUXYeYTA3ko5RWDtYtckc8BX
	 U9pHKT32Fh+ZmPnH4ovGr33pt976Rl2wqvac0/NXfoH/cccaD9bSNruksVXtJ2cmWFKpP
	 4b6Edq6WOApZzK6Wkj9HOuDeU9ugY1vH6Rqn8Z1RuUoSAaJP0yQknFw27KE0YPvZRMKV9
	 WUScb92U7YVWd8v/COzTjIEm1JtSEBXuulIe1Fnmlps+aB5ENjEWQCqdQuORaJJg+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214966;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qGezakZ14m2S2fBQBFRj+wGiFP2dTv5zD8y12G0rUYk=;
	b=2GZLSHDIljejuGewTekxce/iGkE7szgKFWKuWM4ZX/ZsnBIfOGOZCaro6m8c/OkGd2wr
	 cEcYju55I4zutfGXYDjNEnBO+jwdy1P4ZX0XqAj/SwKh0Tul7UiY5m9DURY5Gedo6KcJb
	 tyoLctwcxL1KmILcwk+5i6JXRdlpq4EclwtSn9bWc+za5zFf8xqrTx/Bafte0Eo1IBLDH
	 NaMbYixSQOE99KrCeiX1qpOLtVYbkD+Gja/GtBfF1G3SbddEZrzcTu9dg7OogBUpgY4hp
	 QXgvICzkwEuodKVdes5bFhPMhU1JXKDFbQWS4+1bOF44C8ylGyLtxj00Sx9ysu2fMBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WTpmk2h7;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9C5606A31A;
	Wed, 28 Oct 2026 19:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF9C5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WTpmk2h7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793214965; x=1824750965;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rRZl7q5Yb7g0I0jNr9cXRIGHWPDX6gfnH7Raa8Tf3Aw=;
  b=WTpmk2h7GCigQjqCLBxWyahsrnr2uqPKkkZVDaJkHcVaZfxrQuljiUDf
   cjqYYVTz3cNpH/1ODUzZXSwnyqMBJMPFOx34unWGoNcjkyCZjnz03e1f5
   qldEzfIyf8kIRaPqHJGEcItNdR+8zExSx7l6K5MD2t85HLQoHcy9mEUna
   ftI61v+YNp28T8hVPNUZXr6jQ7Y8Y8Dif8HrjU976ftNCKDPX/9yuopkh
   yS8JQj6Ziwemod8q4aZhUymOvAz6FaXJ798CWNxr+l4Rgsb2L0z1CrDzQ
   C8H2n/FgSqZrZ03N3bL2vg00Xrb0ysZcLiPguXUrpgyU9e+bBjAuWS2NH
   w==;
X-CSE-ConnectionGUID: 1x4qVIq3QQiCT/9xlP9y3A==
X-CSE-MsgGUID: 3vvemW/HRhK+k3s0oxfnyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1859741"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="1859741"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 12:16:04 -0700
X-CSE-ConnectionGUID: 20RWCkcZQhGqvEM8MSfJZg==
X-CSE-MsgGUID: FZXQX+YnQMKd+y8FCbeiDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="4987771"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO [10.125.108.227]) ([10.125.108.227])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 12:16:02 -0700
Message-ID: <c57c45bb-5047-4aa9-9f06-6ac5f36ff3ce@intel.com>
Date: Wed, 28 Oct 2026 12:16:01 -0700
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, jic23@kernel.org,
 alistair.francis@wdc.com, ankita@nvidia.com, suzuki.poulose@arm.com,
 kas@kernel.org, rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
 <20261027193629.GK1685504@ziepe.ca>
 <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>
 <20261027234658.GL1685504@ziepe.ca>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261027234658.GL1685504@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/26 4:46 PM, Jason Gunthorpe wrote:
> On Tue, Oct 27, 2026 at 04:09:19PM -0700, Dave Jiang wrote:
> 
>> There are two issues for TDX Connect. One, the device info is collected at
>> SPDM connect (TDH.SPDM.CONNECT), not at lock. TDH.TDI.BIND only returns the
>> interface report. So the measurements a TD sees at lock can be from well
>> before the lock. To get measurements taken after the bind, the TD has to
>> ask the VMM for a recollection with its own nonce.
> 
> IMHO measurements taken before lock must never be made visible through
> this interface, it defeats the security property of evidence within
> the locked session. I would expect the guest kernel TDX driver to
> prevent this.

Agreed. I'll change the guest driver so the lock asks the VMM for a
recollection with a nonce the driver picks. Each lock then costs one
recollection.

>  
>> Second, a device may take a runtime firmware update of equal or higher SVN
>> while its TDIs stay locked, unless the lock sets NO_FW_UPDATE. The
>> TD isn't
> 
> Sure, any of the live update things are not really relevant, the
> evidence can change asynchronously and without notification, so we can
> just ignore the issue. If the guest opts into live update then it can
> only rely on things like min svn.

makes sense

> 
>>> I'm a bit puzzled by this optional challenge concept, I haven't tried
>>> to read SPDM spec yet, but it really has a way to omit the challenge
>>> from the reply? It doesn't just replace it with 0 or something?
>>
>> SPDM puts the requester's nonce in the GET_MEASUREMENTS request, and only when
>> the request asks for a signature. The MEASUREMENTS response always carries the
>> responder's own nonce, and the signature covers the request too. An unsigned
>> request has no nonce and gets an unsigned response.
> 
> Returning an unsigned collection seems like an interesting use case,
> but why would you want to do that in the first place?

I don't have a use case for it. That was answering whether SPDM can
leave the nonce out.

> 
>> The empty challenge in my provider means something else though: don't
>> recollect, return the evidence collected earlier. So it's less "omit the
>> nonce" and more "no new collection". Maybe that's better as an explicit flag
>> than an empty challenge?
> 
> I'm not sure 'no new collection' is an especially useful thing. Since
> the kernel won't be validating the signature you still need to pass
> the expected nonce from the prior collection back to userspace so it
> can check it.
> 
> Is there some specific use case for this?

Getting the lock event's evidence. With the suggested lock change above, the
guest driver collects it during the lock. But the lock is a sysfs write and
returns nothing. Userspace still has to read the evidence to appraise it before
run. The device was already locked when it was collected, so the read needs no
new collection.

Userspace doesn't need the expected nonce passed back. The guest driver picks
the nonce for the lock's collection and checks it before publishing. If userspace
sends a challenge instead, that nonce is its own. The collection's nonce is in the
evidence in the GET_MEASUREMENTS request that asked for the signature.

> 
>>>> 6. tdx_attestation_test's discovery_and_construction_fields expects an
>>>>    inheritance chain of 4, but the TDX family inherits ctlv-attestation
>>>>    directly, which gives 3. In a real TDX guest it fails with
>>>>    "Expected 4 (4) == ctlv_chain_len(self->dev) (3)".
>>>
>>> I would have naively guessed this should inherent from some SPDM family?
>>
>> The TDX family is the TD's own attestation (TD report, Quote and RTMRs), with
>> no device or SPDM in it. In wip_attestation_all_1 it inherits ctlv-attestation
>> directly, so I think the test's 4 is what's stale. Jiri would know for sure.
> 
> I think TDX report/quote/rtmrs should be a different familiy from TDX device
> assignment SPDM. They are completely different things.

Yes. That's how wip_attestation_all_1 has it, and the device side is the SPDM family in the POC.

DJ
