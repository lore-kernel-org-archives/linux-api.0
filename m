Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793142564;
	b=PYyKsbAbDSCR74vKJQbF/By9Nqu2Fvv1WHuJkYhuFSmoCsj2TsOkokvH9Q1Qw1EcUy+h
	 jQ6ETh1+2mrlBFYbDQiSbHf0MXyih+gsVfT5EHNPZrL/dDr08DnB7dKQuKvOzN30eLbuk
	 RaG9ZJcigVmsUZ9RAne+fqGoveju8eHEHWBjy/aR3Si5qVtYZgLuBsf8/OfsIwzzKMwOp
	 Lg+AiNsdyuDO03MEP2k1MWB4tfIMVeG/LnPbCzErrcsQ3fUGjBwigYRIf4xiKB+o02K2u
	 hiPPeaW5ZegnamsINZPnxhIkUNzOtjdfCGdu23VxRmOyPGyMvOhm2Dma53il1xJ1/dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793142564;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PV2RT6jIH1WRbU7hSLbKZt++GuxkbZqxWqm1JGu5HoE=;
	b=KKfWo6SwSXvnAfELZ9gkBEcPrxE8y0ESfokPLB5bU8PT1iDtt1MRQe5XtY7fT+mZysUU
	 mwerWGAjrEMH/vkEufeqaU2IBjRd713kVXNVGp3CXPb6UZTvFA4uZjxE83Q2cP9RDtLDN
	 RAlDrTItDw8+54d+90VIwm64XKiXZSdIvRyW06YTs3inkEmM9N0D0WIJPmJ0IwmnGQ3U5
	 McbiScN5N1yU3HwxvxpnProA0/k3Za5Wv4Ht7/CO+1HK27WA/jNpkc25MRKAWqEf0ogmQ
	 E6doKF8pTijN2G2TAXtSVi8c9nSGL8VFA7hacD5SvvmOdWAbNlI1Cd5T10Yn2C+3BPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JIvT7bqL;
	arc=none smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB4606A31D;
	Tue, 27 Oct 2026 23:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ABB4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JIvT7bqL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793142564; x=1824678564;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RQBKrRd8W+UdFFloUvBdZhOEkrOVdVKDsQPlJex8VVI=;
  b=JIvT7bqL1M831tucFki87nLuaRHE8mE77kdZO6t7x57BsYUBgFx7swpB
   FoKbaqr7lXwzNFzPpj/JSm2MnpcVQjafsDa8djmRDzg+Kpx6Pg+lQ/DvA
   9MsKuKgFoztO4Q+Rcub8IUUg+gYYWZ90ajG9lQwNHcWuQkWpkdmUkDb4W
   vyJClk5hxLK+3C8CX18ld0zkUhptl59GejzWjb2DuvsdWfWUoSTYUG3JG
   tu5I+ioZ3Uis9Cz71KnOCWc2u7mqDspjA1R6IQzf0PoG1sFIVXX8CLZOw
   YAcmCAtJXEo+dHnTcgSGmAw/BaKliuSAYo0oKkJfn7YfI2QeckkXf/qyh
   A==;
X-CSE-ConnectionGUID: 0Y3BCEZhS++GR2HGfhWYiQ==
X-CSE-MsgGUID: qryDNBcFQZ2CFwctftukaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1844086"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1844086"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 16:09:23 -0700
X-CSE-ConnectionGUID: 2pNB8aHzQb6DVHvFCDzqJA==
X-CSE-MsgGUID: EjfxNES/QuKl/hZDbHfGbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="5014929"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.170]) ([10.125.108.170])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 16:09:20 -0700
Message-ID: <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>
Date: Tue, 27 Oct 2026 16:09:19 -0700
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
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261027193629.GK1685504@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/26 12:36 PM, Jason Gunthorpe wrote:
> On Tue, Oct 27, 2026 at 11:43:04AM -0700, Dave Jiang wrote:
> 
>> I built a proof of concept on your wip_attestation_all_1 branch with help of LLM
>> for TDX Connect device attestation to see how it holds up, and wanted to share
>> what I found.
> 
> Nice!
> 
>> What I built:
>>
>> - A ctlv-attestation-spdm family. As you proposed, the sysfs lock creates the
>>   assigned-TDI attestation instance; in my version unlock removes it.
>>   EVIDENCE_GET, EVIDENCE_ACCEPT, DEVSEC_STATE_GET and DEVSEC_RUN all go through
>>   your ops.
> 
>> - A provider (a 'struct attestation_provider') that sits on top of PCI/TSM, so
>>   any backend can use it. It serves the evidence PCI/TSM already publishes, and
>>   asks the backend for a refresh when EVIDENCE_GET carries a challenge.
>>
>> I ran it in QEMU with the devsec sample TSM, and in a TDX Connect guest on real
>> hardware with a real device. Both worked: lock, EVIDENCE_GET, DEVSEC_RUN
>> refusing a device without a verdict, RUN, and unlock. My tree has out of tree
>> code for TDX Connect to get things working.
>>
>> The model works well for device attestation. A few things came up that I think
>> worth a look.
>>
>> 1. EVIDENCE_ACCEPT and DEVSEC_RUN take any evidence generation since the last
>>    device change (attestation_evidence_validate()). Ranges would narrow that,
>>    but they need measurement registers (attestation_ranges_required()), and a
>>    device has none. So a verdict survives a refresh. In QEMU with the devsec
>>    sample:
>>
>>      EVIDENCE_GET, empty challenge   -> evidence generation 1
>>      EVIDENCE_GET, challenge c1      -> generation 2, measurements changed
>>      EVIDENCE_ACCEPT generation 1    -> ok
>>      EVIDENCE_GET, challenge c2      -> generation 3, measurements changed
>>      DEVSEC_RUN generation 1         -> ok, device in RUN
>>
>>    Any process that can issue EVIDENCE_GET can do this between the appraisal and
>>    DEVSEC_RUN, and the device runs on evidence nobody looked at.
> 
> We don't care about freshness of measurements. What we care about is
> that the device has remained continuously locked while we are doing
> this.
> 
> Generation should not have anything to do with the # of evidence
> collected, it should be tied to the lock event. We do a lock and we
> get a generation number. That number remains fixed and could be passed
> into run as a minor sanity check.
> 
> However the real security work is in the kernel driver which is
> required to actively detect/prevent any host tampering with LOCKED.
> 
> RMM does this with a trio of sequences counters maintained by the
> kernel driver: lock_seq, meas_seq, report_seq
> 
> If the host tampers with things then the sequences computed by the
> driver will not match those computed by the RMM and it will fail.
> 
> So, I don't care if we lock the device and then collect three
> evidences for some reason. It is not the APIs problem to make sure
> they are all the same, or that the one used for attestation is
> "freshest". 
> 
> While locked the device is not supposed to change its measurements,
> allowing that turns locked into complete security nonsense. How do you
> know when the measurements stop changing to actually measure it?
> 
> The only point here is to collect some evidence that represents the
> start time of a continuous period of exclusive guest control.
> 
> Have I got this wrong somehow?

You have it mostly right. The devsec sample has no real measurements. Its
refresh only puts the new nonce into a fake request, so the "measurements
changed" lines just reflect the nonce. I'm dropping the
attestation_evidence_replaced() idea.

There are two issues for TDX Connect. One, the device info is collected at
SPDM connect (TDH.SPDM.CONNECT), not at lock. TDH.TDI.BIND only returns the
interface report. So the measurements a TD sees at lock can be from well
before the lock. To get measurements taken after the bind, the TD has to
ask the VMM for a recollection with its own nonce.

Second, a device may take a runtime firmware update of equal or higher SVN
while its TDIs stay locked, unless the lock sets NO_FW_UPDATE. The TD isn't
told when that happens. The VMM picks the lock flags, and INTERFACE_INFO
bit 0 in the interface report tells the TD whether updates are permitted
while locked. Currently our host passes no lock flags and nothing in the
guest checks that bit.

With NO_FW_UPDATE set and the evidence collected after the bind, tying the
generation to the lock works for me.

On the RMM sequence counters, I don't think TDX has an equivalent set. What it
has is a bind session ID. The TD reads it after the bind, and TDG.TDI.START
only succeeds with that same ID. Before START the TD checks the device info and
report against the TDX Module's digests. After START it relies on the state the
TDX Module tracks, which can lag as I mentioned.

> 
>> 2. TDX Connect (maybe others) does not raise an event when a device drops out of
>>    RUN. The provider only finds out when it asks, and on TDX even that answer
>>    can lag. The guest reads the state the TDX Module last saw in a TDISP
>>    response. A function level reset, for example, moves a locked TDI to ERROR,
>>    but the guest keeps reading CONFIG_LOCKED until the TDX Module sees another
>>    TDISP response, such as when the host asks the device for its state.
> 
> Yeah, I bet this is common.
> 
>>    Could the core add a version of attestation_state_changed() that a provider
>>    can call while the op already holds the lock? Or let the provider flag the
>>    change, and have the core send the notification once the op drops the lock?
> 
> Sounds right to me
>  
>> 3. Jason asked on 14/20 whether anyone needs a variable-length challenge. I
>>    don't think devices need a range. A plain read sends an empty challenge, and
>>    an SPDM GET_MEASUREMENTS nonce is "NL = 32 or 0". Your TDX provider always
>>    takes 64 (attestation_tdx_evidence_caps).
> 
>>    A device needs exactly two lengths: 0 for a plain read and 32 for a refresh.
>>    struct attestation_evidence_caps only holds a single min/max range. It's
>>    checked on every request in attestation_evidence_request_decode(), and any
>>    range that allows both 0 and 32 also allows everything in between.
>>
>>    To work around that, my provider declares 0-64 and PCI/TSM rejects any length
>>    other than the backend's nonce size, 32 for both backends I ran. Could the
>>    caps give one exact challenge length instead of a range, plus a flag that
>>    also allows an empty challenge? A device provider would set 32 with the flag,
>>    and your TDX provider 64 without it.
> 
> I'd expect to be able to learn the exact nonce sice that the challenge
> can support. It should probably be a list not a range, then you could
> include 0 for SPDM..

A list works for me. It covers 0 and 32 for a device, 64 for TDX, and other
sizes later.

> 
> And maybe other lens if we do crypto agility here or something.
> 
> The challenge is formed into the returned token so it is a kind of
> ABI and we don't want things like transparent 0 pad or something, so
> userspace does have to know..
> 
>> 4. EVIDENCE_GET rejects any buffer smaller than max_length
>>    (attestation_evidence_decode_objects()), so userspace has to allocate for the
>>    worst case. Aneesh's provider declares 16M per certificate chain, so every
>>    read needs a 16M buffer. Could EVIDENCE_GET take a smaller buffer and return
>>    the length it needs, or offer a way to ask for the size?
> 
> Makes sense, this is also where someday having the memfd as an option
> might be nice since it could be dynamicaly sized by the kernel
>  
>> 5. evidence.challenge is a required attr of evidence-request, so a plain read
>>    has to send an empty one ("hex:" in Aneesh's example). Could it be optional?
> 
> I'm a bit puzzled by this optional challenge concept, I haven't tried
> to read SPDM spec yet, but it really has a way to omit the challenge
> from the reply? It doesn't just replace it with 0 or something?

SPDM puts the requester's nonce in the GET_MEASUREMENTS request, and only when
the request asks for a signature. The MEASUREMENTS response always carries the
responder's own nonce, and the signature covers the request too. An unsigned
request has no nonce and gets an unsigned response.

The empty challenge in my provider means something else though: don't
recollect, return the evidence collected earlier. So it's less "omit the
nonce" and more "no new collection". Maybe that's better as an explicit flag
than an empty challenge?

>  
>> 6. tdx_attestation_test's discovery_and_construction_fields expects an
>>    inheritance chain of 4, but the TDX family inherits ctlv-attestation
>>    directly, which gives 3. In a real TDX guest it fails with
>>    "Expected 4 (4) == ctlv_chain_len(self->dev) (3)".
> 
> I would have naively guessed this should inherent from some SPDM family?

The TDX family is the TD's own attestation (TD report, Quote and RTMRs), with
no device or SPDM in it. In wip_attestation_all_1 it inherits ctlv-attestation
directly, so I think the test's 4 is what's stale. Jiri would know for sure.

DJ
