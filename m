Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424950;
	b=Oq3caeav14SueV8SeQMLII990v/g8JLNE1kY0+aRwZkJcMKtc94Rl36Xnemq0w/0MvY8
	 BIbEv4JqN2RY+bVOwo/U5gXjPWZY4t6taPgoFAcrpsa8217JefTiQI9X+nJ7DrwqsHs3Q
	 crKnGi3npX6MBo9FVwaH+YJsCabkcVyvfx4/nCwi4MoKytsGOsDJ16tzBi6R3dGgcImFq
	 nIwKTxLYACJsSVydQ63eQoFKUb8yaLBW1I6wceLmu82noHp7QKdlgTin2ZFHAjJBxwcgQ
	 nbz5g6taZ+UQuMsGnPXBIR/nwOriCwg4i+F2GojWzeGWgh5Z0F1iQK04Wzp24p6M+/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424950;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=O02VVtRWSBlBTffNTMdkr0d21ECe3B1DyZ7TQUqkyYc=;
	b=Oy2uh9N1/2hIyADVX6XuWeQ7lrts8uz4Bxq9BhDWvY7agjOfk1wvSi6qdnivrgmuwjKd
	 bY/Ekkh6dRiRtf1UBDvKIXgf3WnolYwBa3GKUb/oCOBGT/UVm6H7M31kW7bmjvZd+bR8z
	 +lbk2KXCkOQe+xB8M0a/doSE/Sl3v0iCUayu4wiRLU8Tt4EBswYuiAzNImPmhVom33R02
	 OZb1m9CAZE8Ik34eXs1v4E8/gMffh8+GyERZwYHAkzgDSt0RqTxBt88OH80x0fqYivdhW
	 SiN2rDPatPxNQ8duJ+sI6cWd/n52nDtoDvDGinOTLv7E71OCCewdNebI16yJFCMYhuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qS0UZJq0;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A821606A321;
	Mon, 23 Nov 2026 09:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A821606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qS0UZJq0
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B53A1476;
	Mon, 23 Nov 2026 01:09:06 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08FBC3F632;
	Mon, 23 Nov 2026 01:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795424949; bh=jm/tu+I4qmiRATBKNiNwWj7t44LL0Pz4nclHyYCT45w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qS0UZJq0Kphetvr/RKKkXdDctKNYhKx2Lb7gDOhRTb+fw+Pt7bJLaCJFjIOCuaDet
	 WzNxU0kfTkTwgpy1gCegKFTBnvk5ksbsvMaHz3veGEgevLHwY3BpX9MKubSvB90g1M
	 OeAl6pNM3coIibp4WW/8Wwm3yziZe2NFBgy7L1Gg=
Date: Mon, 23 Nov 2026 09:09:02 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	jarkko@kernel.org, zohar@linux.ibm.com, yeoreum.yun@arm.com,
	aneesh.kumar@kernel.org, dave.jiang@intel.com, nik.borisov@suse.com,
	sergii.dmytruk@3mdeb.com
Subject: Re: [PATCH RFC v2 9/9] attestation: Add the TDX family implementation
Message-ID: <awQCrnD5CtEhKRWz@e129823.arm.com>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
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
In-Reply-To: <20261113160838.2512652-10-jiri@resnulli.us>

Hi Jiri,

[...]

> +static void __iomem *tdx_attestation_log_map(size_t *length)
> +{
> +	struct acpi_table_header *header;
> +	struct acpi_table_ccel *ccel;
> +	void __iomem *log = NULL;
> +
> +	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_CCEL, 0, &header)))
> +		return NULL;
> +	ccel = container_of(header, struct acpi_table_ccel, header);
> +	if (header->length >= sizeof(*ccel) && ccel->log_area_start_address &&
> +	    ccel->log_area_minimum_length &&
> +	    ccel->log_area_minimum_length <= UINT_MAX)
> +		log = acpi_os_map_iomem(ccel->log_area_start_address,
> +					ccel->log_area_minimum_length);
> +	if (log)
> +		*length = ccel->log_area_minimum_length;
> +	acpi_put_table(header);
> +	return log;
> +}
> +

I think we don't need to dump log area with the log_area_minimum_length
since the area would include none-event otherwise, pre-exist tool (i.e.
tpm2_eventlog) reports error for them like:

  ...
  - EventNum: 21
    PCRIndex: 2
    EventType: EV_EFI_ACTION
    DigestCount: 1
    Digests:
    - AlgorithmId: sha256
      Digest: "b54f7542cbd872a81a9d9dea839b2b8d747c7ebd5ea6615c40f42f44a6dbeba0"
    EventSize: 40
    Event: |-
      Exit Boot Services Returned with Success
  ERROR: corrupted log, insufficient size for event header: 3
  ERROR: failed to parse tpm2 eventlog
  ERROR: Unable to run tpm2_eventlog


So, what about export *real size* of eventlog like
tpm2_calc_event_log_size()?


Otherwise, look good to me.

[...]


Thanks!

-- 
Sincerely,
Yeoreum Yun
