Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446964;
	b=SsEfjlV/jGPP+tepcOzUozHM8lG8ywXVBXeRCf0JbE4chkoWlucWnyuU3pDRH7SIyXNU
	 RuffR40pHeue7OwNi6zpJP7Kg4N0qQ47tQZO5y5v1NLfk7a9thfyR09Sg76BNrhbdD87c
	 2sf/hW8UfmVCvU+8x96K0M1gcM+nUnXmsHnWt8eE7alsWf/raxWRw2l3aoGeM/ZZx+zYw
	 82Gz3gWVAgAuK36Zme1/IqhjEgT1jpY+H74qoNeo+7zKlPb3i6Hhi5ecIW/yfu+8XHlhe
	 orYvw2+3HDJydKA3pU+RJ00DWwuX5pvg4tAEAo9D0IJNeEkLIsKFImV0tOemAclnGvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446964;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Yw9cCn0CIO0jjIfkfgWF97yMkgCCAH2a1Wqmh2ZFkkg=;
	b=2HLm5VPu18XuaFCtS3oaFo12tKryX/6luoPCeNYRgo+5/OEpTw88uyVXI2VUMCRaIouJ
	 vLA1bOVBGImJzeJ/riW16FEea9vP3yuKlLbr/Nk4UsDDWgg19Ni78NTIXomYMDbSlbgk0
	 Xk3+Z+py+YCH88O7jeqtrCt0DpdzLugz5ujA6HM/djWGsUCOGdMWSbhd4+qzxT3Tz3tXe
	 zyPohLlyyOi8riN1KWc68h8ixEu+AGC2Ew5rFDJ5JwwDkOjcB2JiGsLp1OXwK/4gbDYVF
	 YHeJSyUHnhEr0ZMSSEoccNeBQ2CYjTTHnfkB4bK825Hehxl76egucn3Sq2o4rG6FQLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfqzJa46;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CC8C6606A32C;
	Mon, 23 Nov 2026 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfqzJa46
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 437981F00A00;
	Mon, 23 Nov 2026 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446964;
	bh=Yw9cCn0CIO0jjIfkfgWF97yMkgCCAH2a1Wqmh2ZFkkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RfqzJa461hlxdRfUNStU6dOzBjnUTN27T5Pf8O5+h1yq37MBOix+RnogdWb7lwKkg
	 49QhbIxqPOmHbebgKIDDe0MGIZbybkzBVtZ8skfq5ni26BvhMY6DtZe5fu2nO/1JOP
	 3LJqvZJ/ZkBFM60f4ep4Av+m9nWOEOx9pD2GU3viUUU7pfAW8QkCJvvTXJoYvCphqb
	 McO0BTGs6ui9RupZq3oMnGY5jddUQqgR18Ti1vx1TbrSSF9LN+y60ez1466bw77Zad
	 ZTO3WVnmyEmPVDpaWxf2KMLsxnxz89OFUvWPYfF6tc0kw1gm8q5woM40NpZI4dBrdC
	 ed9frS/+EmDmQ==
Date: Mon, 23 Nov 2026 17:15:59 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <awRYr7yB8IWj7S3G@kernel.org>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
 <awQCrnD5CtEhKRWz@e129823.arm.com>
 <awQz1P6iXYrL8lv0@kernel.org>
 <20261123151128.GD179082@ziepe.ca>
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
In-Reply-To: <20261123151128.GD179082@ziepe.ca>

On Mon, Nov 23, 2026 at 11:11:28AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 02:38:44PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 09:09:02AM +0000, Yeoreum Yun wrote:
> > > Hi Jiri,
> > > 
> > > [...]
> > > 
> > > > +static void __iomem *tdx_attestation_log_map(size_t *length)
> > > > +{
> > > > +	struct acpi_table_header *header;
> > > > +	struct acpi_table_ccel *ccel;
> > > > +	void __iomem *log = NULL;
> > > > +
> > > > +	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_CCEL, 0, &header)))
> > > > +		return NULL;
> > > > +	ccel = container_of(header, struct acpi_table_ccel, header);
> > > > +	if (header->length >= sizeof(*ccel) && ccel->log_area_start_address &&
> > > > +	    ccel->log_area_minimum_length &&
> > > > +	    ccel->log_area_minimum_length <= UINT_MAX)
> > > > +		log = acpi_os_map_iomem(ccel->log_area_start_address,
> > > > +					ccel->log_area_minimum_length);
> > > > +	if (log)
> > > > +		*length = ccel->log_area_minimum_length;
> > > > +	acpi_put_table(header);
> > > > +	return log;
> > > > +}
> > > > +
> > > 
> > > I think we don't need to dump log area with the log_area_minimum_length
> > > since the area would include none-event otherwise, pre-exist tool (i.e.
> > > tpm2_eventlog) reports error for them like:
> > > 
> > >   ...
> > >   - EventNum: 21
> > >     PCRIndex: 2
> > >     EventType: EV_EFI_ACTION
> > >     DigestCount: 1
> > >     Digests:
> > >     - AlgorithmId: sha256
> > >       Digest: "b54f7542cbd872a81a9d9dea839b2b8d747c7ebd5ea6615c40f42f44a6dbeba0"
> > >     EventSize: 40
> > >     Event: |-
> > >       Exit Boot Services Returned with Success
> > >   ERROR: corrupted log, insufficient size for event header: 3
> > >   ERROR: failed to parse tpm2 eventlog
> > >   ERROR: Unable to run tpm2_eventlog
> > > 
> > > 
> > > So, what about export *real size* of eventlog like
> > > tpm2_calc_event_log_size()?
> > 
> > Nothing in the patch (neither commit message nor any comment in code)
> > says that TDX attestion registers share the same format as TPM2 even
> > log.
> 
> It comes from the UEFI spec's definition of CCEL:
> 
>  38.1 Virtual Platform CC Event Log
> 
>  If a virtual firmware with confidential computing (CC) capability
>  supports measurement and an event is created, virtual firmware should
>  report the event log with the same data structure in TCG Platform
>  Firmware Profile (PFP) specification with
>  EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 format. The index created by the
>  virtual firmware in the event log should be the index for the
>  confidential computing (CC) measurement register. It is CC vendor
>  specific.
> 
> It makes sense that the kernel would size it correctly.
> 
> > As per the function, perhaps tpm2_calc_event_log_size() should be
> > relocated to lib and have non-TPM name like firmware_event_log_size()
> > or something.
> 
> Probably under drivers/attestation since that is where all the TCG
> formatted logs should end up. It should be 'tcg_event_log_size()' or
> something. Maybe a tiny module for it like we would have done in lib/

+1 for the name, as it is obviously more accurate prefix.

> 
> Jason

Br, Jarkko
