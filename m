Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793096476;
	b=D9XOKVRPNdkT5qGrj+v7v8UZ/Tk29ZYysS594FVB/oa7dJkzm/UwyYVCKkDAeFhfwfts
	 g/42Cpz5JMauvzpWMpoEVXCFDCpHC1mJ3QXHaO3ttN7HGWe8FuoAmvvvSZ8hwbtrJaXkN
	 IkjQ0HWgZviQvUhj00evpJ/q/VsDNzrsU9Dz4WEt0MDxHCYho9Z0iWXnM0OpzNKxPx8St
	 B1zT8yiOyWPzBDfG6zp6vO25WesTm5cGmGUJz5SgkIdRCpzbcLLZ2FyIuuFDMrNSKABRv
	 w5EuEYcEWslSjylCz15skN0lMPccDAdQAEmYWC6G91x/YrS9P8fEbrD96iSp+zmm7Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=UcwPjZxaDPQUX38SRpQk0U6z694ngHdtvb+qpNBNolI=;
	b=Pw3IQKn/NAl/AQmkQEd1oEhog/ljIcBnbJAXaHN6K0VPeeEQ4jvx9YB03OCU+Azq+ENt
	 +tVmqlwa3zB7UiJAoxXaNcxarVQkFmr6Nna8D3ah9Fg80qWt1/+nmc3qgEWmK1JTbFM6W
	 QJEIwPYVXBuNkIzOFOGXsb2a+RM3HCIqleYzlkgkY/NythMp5fy+3iuC7w6alVuOeP9wx
	 uLc2dB5GJenp0Lq34fkt5R66zgl94P4KjwXanHfG0WuO6FyNB5zSoy/L2HUPlk8QaHe7k
	 rL+dvKOe2TFLBJ8bGNUYhTKTTRPxZDvRL1yaaoIqJvyhGL6JIvwMB1ZPGvDCP4asaag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.167.53
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20EC606A31F
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 10:21:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E20EC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be4a2d94adso3365996e87.0
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 03:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793096469; x=1793701269; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UcwPjZxaDPQUX38SRpQk0U6z694ngHdtvb+qpNBNolI=;
        b=U+w+DA7TBbOTsHJ6Enxe39JVFHvrncv5jY+jSoyIQ2z35qjZXvHp3LNnblKOrPL29A
         y7RE8O/DkYqgtM6po8VciEwy++8yrr0fF30EYhF2VKGclIBsioakCbCgAaR3HRFnnwZB
         fNYBW+FeTixill9nrDRoI+IpNCTqA55IxLFeHUBlMQlaa8qrSxKDiIACxU0UkJDj8UMh
         lR0on/o9rFsPmneK/FCtabwWiYP65MsxMx5JUTisdHYPgy2j9M05xRVHhql1vdZyRtw4
         WoBKFMRyWdL7bNEs8rMdYK3MSTXgnm/TWIMlL9+E1AX8il/kxYBgNEFH0Q32f/iPJK2Q
         TN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793096469; x=1793701269;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UcwPjZxaDPQUX38SRpQk0U6z694ngHdtvb+qpNBNolI=;
        b=rM6zm9JiD1IDEUYHfc+71VxZnNvynhNijJ+Frx5HDFfOnZpWcmlXiCZ+qgjiYRqtdc
         6yIiHqm8p3ROvIo+wVecil15TzQjsx+ulyOZ4SkPF3SsrcEJJ5COF+WaUlIIRlNYISqD
         nG5P6doc0PQnVAJ1NeMOhmppIu8Y3p7DkFKrVMXrDmqT/hC/q7LokmshI/JRAuhJtdkj
         X4SbecacJnWB5HQWgJinGRKLdP3ZfcoDN/ZsgW9FFLQimp2+YbNO6DwahUW2BWX9dGzv
         XBXZXIeI0GppeQdi1xMXiCrBPl3Xfm67OsdnKeACZGiyaB5XptsUqN7X9HUEnCPr7kNf
         7uAA==
X-Forwarded-Encrypted: i=1; AKwUvBzLSP2N2+FjHxYzxu2sbasADcz9qD7jWJO0HLYFOxOc19v8jRIL3OcLW2FuFF1BnKFcGX4FL6Oxi60=@vger.kernel.org
X-Gm-Message-State: AFq9FYJaCJjlHkWR9HQ5ZZnn+HqOWnd/MWDnM7vF9ZLItI3t3Lpp4bzf
	xbFPBEeDMApoLXH8ruDLywII6wdsAtlqCPXoQ8tz26j/tEGmWpmUS7MRxEfvsZ+zARQ=
X-Gm-Gg: AYBFou0F2DcJ037Vkj7Z3Dt4MDMF07Tybpuz1sRuuIZG5jKHg5H/LU3g8+Dswxu0Xy7
	Lo4tD4HE/byj0fsnm2usFCfxTPGo+SvIs8N2WsZqUbqSP92kyT0LhOG6pyA2vgZdsRRr8Y0sNqe
	Itl5EQKbbApwDWkVaNHqOh44neQ1ZYcjsn+pXaM0FHM4OObeTra5UQdX/Pei4slnl9iM+7xX/DI
	IaUiqlg5CHYDGO9fPulXYLDJ0pPWa8jVKIHpvObp2XjvF4jilfSeVFhKqMEYW9i23f9UiCsCzB9
	V+zX8JKMyiVIcSpT0+lIA4MHTLnaYjv0SpT05OvsZyywaz4aGAqqODsaZVkUgfacR3NEUjAXxJ/
	sjOt/6SCKpW+Sa4bKQBDzNDda4anzW4A/JFJqfOTBy5+T1awZpAsPAmXbjQUfKYsPv/VUqoEyWk
	hAl2rQmEfh+TvnqJLOXr6WP0s/wpXWQjOLvPlwJBMts47N9VJkxYdAUJfKQ/9o8vybQbx3dvRGx
	idzS3sOBIKtrCIrjyB9Z+GhwPCY0ObDjHjEwnmQGmFZcP7TQ9PwcOoLul5PvtFB
X-Received: by 2002:a05:6512:2211:b0:5be:4d37:3bc0 with SMTP id 2adb3069b0e04-5bfb71fe90cmr3245577e87.62.1793096468475;
        Tue, 27 Oct 2026 03:21:08 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfb7a6aca4sm2051901e87.15.2026.10.27.03.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 03:21:07 -0700 (PDT)
Date: Tue, 27 Oct 2026 11:21:02 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <auB61re2C6eN3BmW@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
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
In-Reply-To: <179302367452.58760.11808905856343064399.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> [ ... 53 lines skipped ... ]
>> +/* A cursor packs the record and member where fragmentation resumes. */
>> +#define CTLV_INTROSPECTION_MEMBER_SHIFT 48
>> +#define CTLV_INTROSPECTION_RECORD_MASK GENMASK_ULL(CTLV_INTROSPECTION_MEMBER_SHIFT - 1, 0)
>
>Use genmask for everything:
>
> #define CTLV_INTROSPECTION_MEMBER_MASK GENMASK_U64(63, 48)
> #define CTLV_INTROSPECTION_RECORD_MASK GENMASK_U64(47, 0)
>
>	pos->record = FIELD_GET(CTLV_INTROSPECTION_RECORD_MASK, cursor);
>	pos->member = FIELD_GET(CTLV_INTROSPECTION_MEMBER_MASK, cursor);
>
>	return FIELD_PREP(CTLV_INTROSPECTION_RECORD_MASK, pos->record) |
>	       FIELD_PREP(CTLV_INTROSPECTION_MEMBER_MASK, pos->member);
>

Okay.


>> +
>> +struct ctlv_introspection_dump_position {
>> +	u64 record;
>> +	u32 member;
>
>Maybe a comment describing how record and member are encoded for each
>of the users?

Okay.


>
>> [ ... 13 lines skipped ... ]
>> +/* The immutable root-first chain always has generation zero. */
>
>This comment seems out of place, it should be closer to the 0's it
>refers to a function below

Okay.


>
>> +static bool ctlv_introspection_family_record(struct ctlv_cursor *reply, struct ctlv_cursor *entry,
>> +					     const struct ctlv_family *family,
>> +					     struct ctlv_introspection_dump_position *pos)
>> +{
>> +	const struct ctlv_family_schema *schema = family->schema;
>> +
>> +	if (!ctlv_family_entry_start(reply, entry))
>> +		return false;
>

[..]
