Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795437528;
	b=wVxPkYpsEjlTBf0mRudkITk4kUnTqyj7lbTj20sH2EyzARIfo7BYOO1/BsCYgj7HhXej
	 4RRDKIiVwz1OBwGFUsC6KAPaUu7AzFm+m08+oAswzdChceU15FmKQZ4CStiny+RZ4A/YR
	 ZCVYTwoMuUvV61NILtJxri3vGhySi12ad0C1eXvGc9P+83WzpGx3lTgJED7sMTmp73vMU
	 iAChR95rq23kg6u2BvSLO2MzgvCVLv1xnP6+VmbyhpewbMc9axcOOyoUfcYqAegrGB02N
	 /EdpU2dVz14B8ZuO5krHH7xxOppndqsqy0LDyGNLgMFVnDyB+KyvOaasFSBOjrx1K0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795437528;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wgdw9pPnqudyZcHtC7gRmtcks/LYJQ7P/2uuTiaSpCE=;
	b=vGOBZvEthuTrkMwrMAqpPlJZjgfeu7zAiEfFnlUxfwos7guufNgfxMNZGi3me9kqpgtC
	 FzPQ1Hc4hmbd/0WTfR1d47goDSFMCjmeuoFRhoO//ZTZYZXwswT1cBcl+moF9qNMV37AH
	 GbmHni5YTmZmmnhP89SnolhOo0JqVyTXJ0XO3+2a1zOxngYnMTen1VFYeyQu8lntYle0g
	 p8KLY4XN2xeAs1ETS2xjddWVIz4FzJL27D3bZJBl85g92j9IlCkYeuGd7Eei9EgMaKI1+
	 sp3AuUhnq1lFNljhSR7lmnR5Yixys6R+nHRzR/a0+n6o6HM1MS+tHxIGpefjA4zn4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7HwZ9ed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 761BC606A31A;
	Mon, 23 Nov 2026 12:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7HwZ9ed
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3869C1F000C4;
	Mon, 23 Nov 2026 12:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795437527;
	bh=wgdw9pPnqudyZcHtC7gRmtcks/LYJQ7P/2uuTiaSpCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O7HwZ9ed0qjYQGF+5m/LM7lsw9NNNpVO+v17o9k4r29ALiKw8N3+95VwUb1/W1MXm
	 uGX8o4caIIHC5itax3bCc6GPpKSPb5AxTQPCPeK13+axXc3B8fEpbZ0yYCRAm2Xv1W
	 dpgQXMFsEHbkPnmffPmlzCrKg8sTkbl038FJ6Kwp+vcIJWZ85dEb3uqAzJ2e/67VGO
	 BvZkfrUx9RwT20o2VE0VRxQhTTQI1adBVfD8/7jjGZeKsIE2JI2TQXqJzapWKUUbLY
	 IGoZOWG3CokgqlxdmKg6OwRBFgD6Up7WeWaxtwfNF5HEAPQ8q8yLJLr0SG2BpCLpmp
	 05HU5IQQ8VeTg==
Date: Mon, 23 Nov 2026 14:38:44 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	zohar@linux.ibm.com, aneesh.kumar@kernel.org, dave.jiang@intel.com,
	nik.borisov@suse.com, sergii.dmytruk@3mdeb.com
Subject: Re: [PATCH RFC v2 9/9] attestation: Add the TDX family implementation
Message-ID: <awQz1P6iXYrL8lv0@kernel.org>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
 <awQCrnD5CtEhKRWz@e129823.arm.com>
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
In-Reply-To: <awQCrnD5CtEhKRWz@e129823.arm.com>

On Mon, Nov 23, 2026 at 09:09:02AM +0000, Yeoreum Yun wrote:
> Hi Jiri,
> 
> [...]
> 
> > +static void __iomem *tdx_attestation_log_map(size_t *length)
> > +{
> > +	struct acpi_table_header *header;
> > +	struct acpi_table_ccel *ccel;
> > +	void __iomem *log = NULL;
> > +
> > +	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_CCEL, 0, &header)))
> > +		return NULL;
> > +	ccel = container_of(header, struct acpi_table_ccel, header);
> > +	if (header->length >= sizeof(*ccel) && ccel->log_area_start_address &&
> > +	    ccel->log_area_minimum_length &&
> > +	    ccel->log_area_minimum_length <= UINT_MAX)
> > +		log = acpi_os_map_iomem(ccel->log_area_start_address,
> > +					ccel->log_area_minimum_length);
> > +	if (log)
> > +		*length = ccel->log_area_minimum_length;
> > +	acpi_put_table(header);
> > +	return log;
> > +}
> > +
> 
> I think we don't need to dump log area with the log_area_minimum_length
> since the area would include none-event otherwise, pre-exist tool (i.e.
> tpm2_eventlog) reports error for them like:
> 
>   ...
>   - EventNum: 21
>     PCRIndex: 2
>     EventType: EV_EFI_ACTION
>     DigestCount: 1
>     Digests:
>     - AlgorithmId: sha256
>       Digest: "b54f7542cbd872a81a9d9dea839b2b8d747c7ebd5ea6615c40f42f44a6dbeba0"
>     EventSize: 40
>     Event: |-
>       Exit Boot Services Returned with Success
>   ERROR: corrupted log, insufficient size for event header: 3
>   ERROR: failed to parse tpm2 eventlog
>   ERROR: Unable to run tpm2_eventlog
> 
> 
> So, what about export *real size* of eventlog like
> tpm2_calc_event_log_size()?

Nothing in the patch (neither commit message nor any comment in code)
says that TDX attestion registers share the same format as TPM2 even
log.

I was just trying to understand where does this derive from but since
there is no reference, I'm confused.

As per the function, perhaps tpm2_calc_event_log_size() should be
relocated to lib and have non-TPM name like firmware_event_log_size()
or something.

> 
> 
> Otherwise, look good to me.
> 
> [...]
> 
> 
> Thanks!
> 
> -- 
> Sincerely,
> Yeoreum Yun

Br, Jarkko
