Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792760497;
	b=IyqYJlPP2tsuxpI89Zu+t0xx9BAJ/m2eLr8xVH7RJZnIVCkH/Dr1/D02aIN8zmEDn9su
	 1ly4FwROFa59hZowXv30nM8chGf1LCmYQP3qqwU8RlP+WRnin1E7B7/RdhjN82nm9Vi5I
	 l9kM5s/5uc2/U8axCcnTIx3Aw9I4f4wy/Ttv+KWn/118Hbxv9ZwdS7gMu8Bv65DDNq/BC
	 MkxrPhhFY06dtB7gt+mEmt63xM9CgLKIAQ3uV8ne/+4ChqE9GDVhKDoTEuaUbu3iHsgHT
	 nSFxDzt9bQpOIXBpCTp1khoIpClV2X4ex4/RMFHGUX0j1lKEln4T4aus7xh+rhdP7Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792760497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=1f6kYcZtrUYkUfjtStdqQg00V0eNduZavh/6mKW3Q/4=;
	b=LSWVRkBh0fl0mv/HSYNUEtcNKH2zQY2NBZOiHTwLy1+GhIG3AW6gkE80JGclANmghGuo
	 f1I4rU2fN4f7tQsZtNC/Ry/uJ4xdGWuHfPOsf3hU3Sj2T4EQgAtY3C3w0wFhMExkcUv7E
	 dYr5cPOlfjjDxpDAsf1Qyk+R00sbQQk6qhUxryA46ViK167ZUsNc1VXdpuzEDNVUTRGy3
	 +EJiqfJIbyy/PRefjGY/iCk5WeB7NpoGV24rP07gAb4oLXva4JQpdM0VVjeeKGGMWP0cb
	 DPjicauS9EFO01aGLtdPfAq3auF19ZlyP0EZb3EQwQq+QOjAnaeEAirkMJ330hqFT5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=dA+0fYF5;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FBB606A31F
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 13:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8FBB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=dA+0fYF5
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e09aa5264so505751f8f.2
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 06:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792760495; x=1793365295; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1f6kYcZtrUYkUfjtStdqQg00V0eNduZavh/6mKW3Q/4=;
        b=dA+0fYF5NJO5vxhD6WsfE3GuOrunJPEPXuH20p/OWeGyCAQgyez/yng8gcWtHHKDRW
         aNNEpTkgJ/DjomFukcZkpeb6Q7E/kWVRL9G1dBUB0P9OUUvF+ziO60N0H3rvhfPEkMkS
         8IPds4ztnx4D+xQpBrTJ0QwMrWzos9Yj4MBRMbVDPujBjU79BQGF9Oxb7qG76rknzGE4
         a5iwk9PZe8SqreUHjx76aszDfzAo9TOoODm74vaYhGYt/lMjoiSK1vLwpZFU3R4Zw7F0
         7HoIGhXLOxKs0+6hz0CBwmLnam0DcpMdiubzbHtmfRhLHWC4gJvsvSCGUFlitbgTI2Kv
         /hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792760495; x=1793365295;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1f6kYcZtrUYkUfjtStdqQg00V0eNduZavh/6mKW3Q/4=;
        b=C1d6svaOvJ1dIVSQjqSF5KNElybB9emW9VYO07WHJWezMAR1s9Speq0bL31CuVI6tJ
         0Il3COM6VrWb5bfWPqED1qEt0htCbstxTLiHYIwMeEBfuo0V0Uay9odODP/ErDxghAKZ
         GSp0K6lkkB5/MIcRl4HZwmlsLxg6A64mwz7nQUD4wYY7+d6Yorjro0K/GGSlRqXwfhVt
         +njBtfeQdR1YWBqsZuAPnqb+uzRhGMDmNzagpp/VvzFsPABmb7z9jTwJae9POrENYqNY
         ron7N8c2u4xO08vB22ujiyo59/h3qqyz0kjo0MQi/K3mhO94WtLKmHe7EicH18sN76bv
         oS9w==
X-Forwarded-Encrypted: i=1; AKwUvByiTrpYCxFWwMxfypgVY8LBaeH41wHyUkb6ucx5vZFk6Y075+LX+BbpASyntp3oJ2jnDKs/uGhDZPE=@vger.kernel.org
X-Gm-Message-State: AFq9FYL23uLHE4raAALM17y35WpWPVzh8NpjIdw4zry+bAjaLticWWig
	vA0M+uTMPD0a2A2O/gRhYnW7YPXxaszVTPuM0sj0YODgoTlHxtnygRmhfiD1pZk9F7U=
X-Gm-Gg: AYBFou1bKN1xeZCdGfRjaZBjW53Qp+SGUGLnvFbSo8bi2170lOpRF886GeYnj6QmCoH
	b9jzSysc2OnTY7Pgte6sVWod9yH95CRbMYVLFbmFGrW/e3kCb9Zw27tznghFthfzM6tJFKkuxw4
	rosZdBrb1MiSKXo5zDVkdXEQCrZgI9ANN/T92wMlbLHb8S/9IqezwR0pc0B15SDdfAXrK+5ATxK
	nD0Uw6cX4mWXMQXqw9NAzLnkiLl0lagWx0CoVZxinuar14XLESmkDCg74IP6n9+Tvlu1LIDU8OL
	cMB+qsFQiaGmAu7CFjKHvpkEeA5nPvULgCTaN5LyXRce+ky0JgHzlwqjCiQnu+YuAOJfcroTvVq
	MwTcsx6ki5AkeTEHwF6Onub79l6M8M87neQYc/8SnimbFreQsdIDpG+BtuU3qS8qN9yBCu+IT6v
	4lFD2I386JfUTq/RS4eb0d9MW1HTI54yLU1TbkppzjmnFAFMhUZHbwo3N+Kk93026DUDFYteSy/
	NzoV/kK84LSYQi6v4RjR5yQc+wDTrzcrmZ/TBQC6qDaTyLybbkZhQzg92qom/4pDPg=
X-Received: by 2002:a05:600c:19ca:b0:4a2:397:73f6 with SMTP id 5b1f17b1804b1-4a211c8fa81mr35809955e9.8.1792760494721;
        Fri, 23 Oct 2026 06:01:34 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a29cdb75cfsm3940865e9.9.2026.10.23.06.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 06:01:34 -0700 (PDT)
Date: Fri, 23 Oct 2026 15:01:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 13/20] Documentation: ctlv: Describe how to write a
 family
Message-ID: <attaLkZFIGSKLmgZ@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-14-jiri@resnulli.us>
 <179245258505.58760.3972297562218204862.b4-review@b4>
 <atjEgLYpgbZNzfkZ@FV6GYCPJ69>
 <20261021144951.GR3008132@nvidia.com>
 <atjiW8bnqDZ8zb5t@FV6GYCPJ69>
 <20261021164857.GT3008132@nvidia.com>
 <atnGniIHxIV-vzVC@FV6GYCPJ69>
 <20261022192118.GC3746973@nvidia.com>
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
In-Reply-To: <20261022192118.GC3746973@nvidia.com>

Thu, Oct 22, 2026 at 09:21:18PM +0200, jgg@nvidia.com wrote:
>On Thu, Oct 22, 2026 at 10:22:55AM +0200, Jiri Pirko wrote:
>
>> >But it does work well here, and matches what rdma and fwctl did as
>> >well. So maybe iommufd is weird.
>> 
>> Well, one CTLV chardev is always backed by one device. I think this 1:1
>> mapping is clear in the device model. Iommufd indeed looks weird in this
>> matter.
>
>iommufd doesn't do 1:1 with a device..
>
>It is more like netlink where it talks to all the devices in the
>system concurrently.
>
>> >> Depends on the user/subsystem. Either families_dump op could be used of
>> >> udev uvevents that also carry family inheritance chain:
>> >>     CTLV_FAMILY=ctlv-attestation-tdx
>> >>     CTLV_COMPATIBLE_0=ctlv
>> >>     CTLV_COMPATIBLE_1=ctlv-attestation
>> >>     CTLV_COMPATIBLE_2=ctlv-attestation-tdx
>> >>     CTLV_COMPATIBLE_N=3
>> >
>> >I wouldn't try to link it to udev either, by the time some userspace
>> >uses the cdev the udev information is gone, and may be unreachable
>> >from inside a container or similar..
>> 
>> This just gives possibility for udev to work properly. Depends on
>> the user/usecase if it's going to be used or not. Not sure what you mean
>> by "udev information is gone". Udev might use these uevent info to do
>> aliases, similar to dev/disk/by-*
>
>I don't know if you can encode N compatible strings into a file name.

Yeah, the udev rule would have to have some logic on top of them, sure.


>
>And in a container or something you can't get the uevent, so no client
>software could rely on this information.

Okay.


>
>Jason
