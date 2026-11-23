Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446691;
	b=2DWbpuZvEaTxdI9+6AE2o/A8a3IawwIMA5Jbol+4TRnQsxpPMHx+FW30Txr9vQtNkHrP
	 fr6HoYu8V83YE9mPBq50iDWpl+6gFmnEq60u6z+SKOFwnFZGh/1SbLfclndbtqsuOorml
	 kR1+jee/JvAQmfAhD2w9cL3W34lHPCyRqkZtfAteN6IT4BtEr/F6xc/7SleyZ3+wa3s5S
	 UgTDsZgQ9eggNCZg58aW7mqUK/pePNUAee1kCkHjgkzy16lRiDxU6XVC9Gt/qE4WBrzyb
	 LhQbjkOAlv43Wd/LRLirC4drb8fvmyTf8lNrik7aWW6L/A6zXK0SSYyDXyC2U/vkefg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446691;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=S6J608SnbhlVzTHO8nTfTbyQzCC0Wef9AXmftuQK8FM=;
	b=Z8o18N0UGAYHYrIndc8GiNxcQDp4vwFYkanl3q56ULdrTI688HGwABbwCFYdY0C7cy/P
	 uCqbO54etpWt7CNtl3HRvfQI9LpQQatgDBsad+NV0KPGG41/ENM9dxnpyp/xJXCRkIBM9
	 V0d3BkCLQbh1c2sYgwPiuf+xWgviHhttkPszRuWkxDHNNkridW4AXYZ0ikAiQ0Kb8dpp6
	 HTstJi7w/kpf9P7bGNKwuK+9zR+0OgpBJ3JSm/NL/Sc3NHFZb5OYBTCavf6pIPRSx09Ly
	 kvmdmu1hprxp/Z4PbTHcRMJLDhAacZ8fyOIuw2YYE4r9R3gDA/BqwL611U3Iqdz+KdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=ULnOCYsQ;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5B7606A682
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 15:11:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC5B7606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=ULnOCYsQ
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-92123971d1bso28366776d6.1
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 07:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795446690; x=1796051490; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S6J608SnbhlVzTHO8nTfTbyQzCC0Wef9AXmftuQK8FM=;
        b=ULnOCYsQhWIKDt7pAFJxN5BdezB6uuwO2wH7M3H75HnvcnHu0ePPTzZKt+/E8HJbsq
         8xNQcunddG9jd5Lyy5gXDUoI6tNcqkgliwQBuS09bcwR4F/99g5XmNioCqy1g81xleyk
         LHhAxO/sQfFLnE4JLEDu/YBjhGAidQN37cDWd2dzzVWGUITLsdgtKfpXw8jO/nNEuElh
         tyEhFp/7OKJTeRItfxiGqKUkSnpdV0wQ/c4bCV2HFB7OEb8h0vw3dWK2Ty+VuV9E6Ewn
         yDkmNQkEnylRuyYGR1sqGLaQPOKxcWwfhEHqIAlHska+tD6+MsFsnDzdHU0merc4Sqat
         NOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446690; x=1796051490;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S6J608SnbhlVzTHO8nTfTbyQzCC0Wef9AXmftuQK8FM=;
        b=K+MY7TKgy2gGJ1rzXcY6mRniBiSvzmICS225Wk9esl8Qw0cnYvu4XKRsD0V5iuMrGg
         xeJo/n6WLj5K50gs+BSb1l2qh1yTYL9+KJdJqngxvMCRlJUjPjuEiTaPzT6IalwEmXA3
         D8pSERk1wWYqJqw2RdTBLm/k19yjxEaK/aj3VddPXW2UKzHMQlU4pmvBsfNlpgsJptYu
         xTYK+tA6h3McE1/5OcEJz5vStkpK0FH18LTmpOi65IQYSXWH6e2GobMjWAip5EzJSJsC
         gqAI2TxWIRcIRD0rN1aELk6Q+ggZhWzs1owIU5kuvugqt3WBdChd+CqcBZXEsJX+GdUb
         EsKA==
X-Forwarded-Encrypted: i=1; AL+hErGBAg9mo4/DRi3kCeImYMvA4ijKnc3hVZgEwxhJ0xzr1hRC2vsYoX9hQmd/GKw0LfNg/Xi3XVGcAZ8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9cL4yFmk53qPLbjyYy2Qlk27jypETjZZTtyUaiHtIzw7L+Ii3s
	ETc+IVQIxfvoHH/uQHryvaGa/UOgLkGAa3+AvdGZLyh0vG/jlLWZu2mUHv3Vt9bspyw=
X-Gm-Gg: AZFdTZfFvM/3A69H+74gT/gqfCi3tgTNN2I+Qgqf4xT3xaL6jxU8MOUhMhRhPdb0aHV
	eVGl9mqnHcgrdFeJtJ2IQaX6TaCXb8zJJIm8Ya+oMD7K6JoyiPW61sfcxCJ4hGQuEpygukNaD0b
	O/qD2gzDu4iG2xO7A0Ayyp6+gwEHteLQPcWD6voa8XaPzpfHLqZtOs173zT7vYgVCPba5RJnEUV
	UJuh0Td+wzj2FkGNb6egzEd9uTf53GhfwrBYbRr3oq+AGc/DF9tbn2yP50kw/s6DOj78jYRB2HY
	FnDVauiWyASDH0/4T/vV+n+wvtX0ebzvdQjbDfTXRg/31clUZCR9LPbsgBUBOAvTT3Emq3Jvqfc
	GFhHP7m/m5y860iAQ2FwDOkb44jIfW3oBvvGrecbEHTZQYW4JKS/58N80fMx1ph1Ymj/FLG6VUu
	cpHBRG101hX33DZiJvbCAuG2taPizzE70Aju9/vdpeegT/TNRn6Xjp47qIbcDNJb34JGNZ2iPQC
	ccbzEnlv0BdfNlbT+Iy7vyFDzFOKnXJdBpJiBQEIraR7UUZ/+kbktSTuI724yw9dGyKayf6n01A
	ybkttXxgLGEAM6oWnnmChmGDu/GGYvJaYw7XrZ0s6DogVX3lnwnNRXEQ6YoCoZrWY+ZcX0goU3c
	732I=
X-Received: by 2002:a05:6214:4108:b0:921:266f:50ff with SMTP id 6a1803df08f44-92134b3f207mr208575596d6.52.1795446689538;
        Mon, 23 Nov 2026 07:11:29 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b50besm106533186d6.9.2026.11.23.07.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:11:29 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVhY-00000000ro7-1hOk;
	Mon, 23 Nov 2026 11:11:28 -0400
Date: Mon, 23 Nov 2026 11:11:28 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
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
Message-ID: <20261123151128.GD179082@ziepe.ca>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
 <awQCrnD5CtEhKRWz@e129823.arm.com>
 <awQz1P6iXYrL8lv0@kernel.org>
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
In-Reply-To: <awQz1P6iXYrL8lv0@kernel.org>

On Mon, Nov 23, 2026 at 02:38:44PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 09:09:02AM +0000, Yeoreum Yun wrote:
> > Hi Jiri,
> > 
> > [...]
> > 
> > > +static void __iomem *tdx_attestation_log_map(size_t *length)
> > > +{
> > > +	struct acpi_table_header *header;
> > > +	struct acpi_table_ccel *ccel;
> > > +	void __iomem *log = NULL;
> > > +
> > > +	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_CCEL, 0, &header)))
> > > +		return NULL;
> > > +	ccel = container_of(header, struct acpi_table_ccel, header);
> > > +	if (header->length >= sizeof(*ccel) && ccel->log_area_start_address &&
> > > +	    ccel->log_area_minimum_length &&
> > > +	    ccel->log_area_minimum_length <= UINT_MAX)
> > > +		log = acpi_os_map_iomem(ccel->log_area_start_address,
> > > +					ccel->log_area_minimum_length);
> > > +	if (log)
> > > +		*length = ccel->log_area_minimum_length;
> > > +	acpi_put_table(header);
> > > +	return log;
> > > +}
> > > +
> > 
> > I think we don't need to dump log area with the log_area_minimum_length
> > since the area would include none-event otherwise, pre-exist tool (i.e.
> > tpm2_eventlog) reports error for them like:
> > 
> >   ...
> >   - EventNum: 21
> >     PCRIndex: 2
> >     EventType: EV_EFI_ACTION
> >     DigestCount: 1
> >     Digests:
> >     - AlgorithmId: sha256
> >       Digest: "b54f7542cbd872a81a9d9dea839b2b8d747c7ebd5ea6615c40f42f44a6dbeba0"
> >     EventSize: 40
> >     Event: |-
> >       Exit Boot Services Returned with Success
> >   ERROR: corrupted log, insufficient size for event header: 3
> >   ERROR: failed to parse tpm2 eventlog
> >   ERROR: Unable to run tpm2_eventlog
> > 
> > 
> > So, what about export *real size* of eventlog like
> > tpm2_calc_event_log_size()?
> 
> Nothing in the patch (neither commit message nor any comment in code)
> says that TDX attestion registers share the same format as TPM2 even
> log.

It comes from the UEFI spec's definition of CCEL:

 38.1 Virtual Platform CC Event Log

 If a virtual firmware with confidential computing (CC) capability
 supports measurement and an event is created, virtual firmware should
 report the event log with the same data structure in TCG Platform
 Firmware Profile (PFP) specification with
 EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 format. The index created by the
 virtual firmware in the event log should be the index for the
 confidential computing (CC) measurement register. It is CC vendor
 specific.

It makes sense that the kernel would size it correctly.

> As per the function, perhaps tpm2_calc_event_log_size() should be
> relocated to lib and have non-TPM name like firmware_event_log_size()
> or something.

Probably under drivers/attestation since that is where all the TCG
formatted logs should end up. It should be 'tcg_event_log_size()' or
something. Maybe a tiny module for it like we would have done in lib/

Jason
