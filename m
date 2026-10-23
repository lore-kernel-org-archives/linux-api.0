Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792765242;
	b=i1gK6gmv7akl66Zgw78aLzlU9jDDgoACHIQdKw9FKaCnqF/Szwo219hIvjYHFnQyO9oq
	 LuE6ZrXzj0lG4HvJpRYMQifXscNxWo9rF2iw/Bvo6IbWouWr6rQykTbuNt0DqttzDTygv
	 wCUlaFKZSmKn0p+zdPiQhzur7GqljtabS/IBLbojDm16coZ0uEpwWvPgQ1wR5T07IGN+f
	 PY67+mGleRu2nPdZQtxUGW+XoCcq7zSeyHcQKdZf16uw/ufLZ2yZN/ddhA3h/Z+ECq/dl
	 LB01IhcCQSncSXM78B1Hu73SPG7B9YmYB3nUdtBK7eX9ugHis6A+zmRIqxR3S6Zf1gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792765242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/6hrkJLl8+7F6s+nQ7oM4f8Xx3u++n7ObY70TM6xwZM=;
	b=mNmKqPt3scEfRpQNJDnBpIpioEZV8wAau+9lpLqPS87V7OjWZLdSPvsbB++n8BGG6jEO
	 +/3YtHhGRIRDUYw6PF8MOyHQFF1T0N39FpMqKll+psRAVQrTAOF9ap5PLGWtqIS6Q02L2
	 YE76eKe7guFK17ulL+Z9m9Geu5bZhHvHGbPpe/nVHFY9591fsIqvf1gBd7CvNq8AjNSE3
	 N8kXfeHicTTq5TYRbzhYdogIo7UocsEXrRi0+rWtthR5wkt+e6jC7klaxIUS9xMqTRBNN
	 8wVtenTc8dYt6z6TM8Pq8pUE6rN3DGY46i58EdS0Wz96bGEL2Kd3lDFrM1lr4kHxnrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Z24Tmepm;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C671606A31E
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 14:20:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C671606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Z24Tmepm
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5366ae57896so9140331cf.3
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 07:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792765241; x=1793370041; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/6hrkJLl8+7F6s+nQ7oM4f8Xx3u++n7ObY70TM6xwZM=;
        b=Z24TmepmqvR1bRh/4zM+g2igTOR83MH9soRnIdGRSlAfFQDPUGRtFOY9hIiE///81M
         gn1/oeDUKKO5QvidSRSIWE23M60jPneoos4wvqV9I4e+WIBRQ7nZbEx3u9pGTbZ+93mo
         v29+lwhRyxercl5mWfe6Lw6ns5PNvqZ2WVy/STNJGyhe9GkO6+u43vn+OgWZlPzn7brm
         KupP7TBsEpn/837/k/d6XjDcCZUehB/rdoMXI/Bx+gclxYRi9m7A+0ETt91nuQqxDW8H
         JSf2ssQUryFdfHbm8dPWKZA9612PpU/6R+wt+M6hxFMCrJYA4E1yt1pYxw8IKTQEWl4v
         iU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792765241; x=1793370041;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/6hrkJLl8+7F6s+nQ7oM4f8Xx3u++n7ObY70TM6xwZM=;
        b=ZpUg6J5S2itgSvX42SrBBxUY496/IHL/MsNVXXmP8ZecMs2TqIOm80+Gfx/Q8FnWfH
         qDBN1Y1J5c1hzd3R+ZsAmJ1VrBDpmm1Zdgye/xQ9oki3zzJOKX/UmnY4MJyT+tDE4YNt
         W2AgU4reRIH5u7CX/CWIIuYJ7C/Sxct4uugD9Hx/S6QBQIrxu/B3msdeE3c1O84SF6aY
         aS3rqZkyK2ZWNSqkwo5ci1kGG1Dhf8eMDdyVtg7R0ufmPVsrXGD5RCA12ywzGn/0fFlB
         g4owEJT4cPAzLhGc157fRNHBYNW3t5vf1daRphSo4s//T49VL63TO2xBYX784gbq6Rp6
         1LSw==
X-Forwarded-Encrypted: i=1; AKwUvBzVcovwpxR4PGuD9ICnS7Mjo/UlVmb4CoU8Q/mbM9qPYmhcyvDD0u9D9iHLs8FBx790dVZchMCLchY=@vger.kernel.org
X-Gm-Message-State: AFq9FYL/88aaus0Q/+rGpr0Hg8YD+Fpd2Ww9d0DZNSYwgNOqcckx8tq7
	2bjBnuk1p7cG4dcfsk6dwlGxNiDv6lbNZwfyfPMGuR1Dk1tSWie/KYxo1rJFaAgndKA=
X-Gm-Gg: AYBFou1C2cPQZSZUxchW92ofsM9yfRu1UjRjN2Il47HSEAPkUnZjOM7JhauRwfrDkde
	f/a2GR66THaUUFv862/TMQEU3OaLTrBlPuO6k7hSTlbvsxgT2iUntc5UaBVzfKtxky5qBRnLYju
	8UYS/oNMG3H4fPU4DWvZyfiLz8CRcqbFIL/fA6jk++nrTgE79guLGYdH1yE3QJULeJt0A5saRpd
	cI8EPPNzPo/5liFg5Q11+3L3mRS8Txc5vFUtxJ0CmBypi6vyWJj0MhIhSZsw+WtF0e5zQJRtDHe
	Ei2A1XdT6MXSj68sBBKlEKI8qREvPxp+I2vWIrVcL9IiACd2tYa8jH0iHwZTg/9WiDr1msK+X9X
	AGp4PW/A90vsALhpf5yMwojrMFM++6ws5Dwcd3x943uORCJL2J0Nn7Iz1gGJuUuux029OcHRlxD
	weDE9v320r+4dFq8ni27fK8N2T4/JcMUjWmv+wgQOSL0nLR/tNtuwtn+LCVd6geChpL4fFCl+H1
	4TAMJzrO3l7MEcO3eRPZBg5vlN5xPpL86nnjwxG2jNHdu5M7UJdDXlzQfU1P/FVU1BQHy+LqNxE
	ZuIFc94Csjag0TmNJ1VtofHPEt/0Wd1ktc1QHA==
X-Received: by 2002:a05:622a:1246:b0:533:32f3:1db9 with SMTP id d75a77b69052e-536c2696164mr33421181cf.11.1792765240843;
        Fri, 23 Oct 2026 07:20:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c1872a8fsm17665301cf.23.2026.10.23.07.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 07:20:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKG8M-0000000Gj4Z-31qZ;
	Fri, 23 Oct 2026 11:20:38 -0300
Date: Fri, 23 Oct 2026 11:20:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	drdeeglaze@gmail.com, James.Bottomley@hansenpartnership.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261023142038.GE3977851@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org>
 <atooh7uO2RauUTfY@FV6GYCPJ69>
 <yq5av76sj10a.fsf@kernel.org>
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
In-Reply-To: <yq5av76sj10a.fsf@kernel.org>

On Fri, Oct 23, 2026 at 01:34:53PM +0530, Aneesh Kumar K.V wrote:

> CCA currently takes the device identity index during pdev_create. I am
> investigating how to retrieve the certificate chains for all slots. For
> now, I have implemented the sequence below.

Yeah, I think the consensus at LPC was this may be a gap in CCA.

For now I can imainge CCA just doesn't let you query the certificates,
and we'd need an ECN to correct it someday once all the kernel parts
are settled.

I broadly hope we can use the software SPDM implementation to really
flesh out the uapi and make sure that everyone is happy with it. Then
we get what subset we get from the first generation of products.

Something like if userspace can't get the slot information early it
just hardwires slot 0 and goes forward.

> echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/connect
> 
> ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 device-get                                                               
> # device-get, 1 fragment, generation 0                                                                                      
>   device.generation 0            
>   device.caps                                                                                                               
>     cap.evidence                                                                                                            
>       cap.min-challenge-length 0                                                                                            
>       cap.max-challenge-length 0                                                                                            
>       cap.max-total-output-length 369098752                                                                                 
>       cap.evidence-flags evidence-accept
>       cap.object                                                                                                            
>         cap.blob-class cert-chain                                                                                           
>         cap.blob-instance 0                                                                                                 
>         cap.format spdm-cert-chain
>         cap.representation raw                                                                                              
>         cap.representation tcb-digest                                                                                       
>         cap.hash-algo 4                                                                                                     
>         cap.hash-algo 5          
>         cap.hash-algo 6                                                                                                     
>         cap.max-length 16777216                                                                                             
>   device.info                                                                                                               
>     pci.name 0000:02:00.0                       
> 
> I think we can use evidence-refresh to select the blob-instance for the
> desired slot once the CCA specification supports that.

Jiri these ctlv outputs are really neat, it would be nice to include
some of them in the commit messages so people can get a sense of how
this looks without running it?

>  ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get                                                                
> # state-get, 1 fragment, generation 0
>   pci.generation 0                                                                                                          
>   pci.connected 1                                                                                                           
>   pci.locked 0                                                                                                              
>   pci.accepted 0                 
>   pci.tsm-id 0                                                                                                              
>   pci.dsm 0000:02:00.0                                                                                                      
> 
> device is marked connected, but IDE is not setup as indicated by pci.accepted = 0
 
> ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-get --json '{
> "evidence.challenge": "hex:", "evidence.object": [{
> "evidence.blob-class": "cert-chain", "evidence.format":
> "spdm-cert-chain", "evidence.blob-instance": 0,
> "evidence.representation": "raw", "evidence.data": { "file":
> "/tmp/cert0.bin", "data-buf-size": 16777216 } }] }'
> # evidence-get, 1 fragment, generation 0                                                                                    
>   device.generation 0                                                                                                       
>   evidence.generation 1                                                                                                     
>   evidence.object-length 1632           
> 
> 
> I added the file: attribute to verify the evidence blob's contents. ie,
> we can do:
> 
> # file cert0.bin  
> cert0.bin: Certificate, Version=3
> 
> ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-accept device.generation=0 evidence.generation=1
> # acknowledged
> ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
> # state-get, 1 fragment, generation 0
>   pci.generation 0
>   pci.connected 1
>   pci.locked 0
>   pci.accepted 1
>   pci.tsm-id 0
>   pci.dsm 0000:02:00.0

I believe this broadly matches what was discussed at LPC.

I really like that we can break down the steps from SPDM setup so we
can get more information to userspace to have better logging if things
go weird.

Seeing this makes me much more comfortable that CTLV is really adding
value here, these data formats are pretty complex in the end..

Thanks,
Jason
