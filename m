Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792755184;
	b=QmmTJR+tt6tRuzQuy737D54JZfLQ9UAdAFG+gql0z6JBqbFhXMyZPARyenuSp7k93J3u
	 fcf42wtXFaxTI/8KB8ofdttbboBAUU4s4G6VX09wbc/vvRCSvYp8e7FLxAV1uQWbvWIVJ
	 pirdwAFdBSouyKscm9pI1SK52hzAhEuu1sluziuyiCSyjHI8qHBFlGHb9em2GDOj8WqrV
	 YUW2fdNKEClctcEEoFfdEkoa4FJXQ8tYDIKMoSLRwtXi0X8Wq9koM07fWvBVV5nbuC37/
	 Y8tJbSD5RgVpOpc6xjDhRISoxPrUdPkKRToP0Q7MGN7Glf77irme0W1I4tNxT2x6kKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=fdSFKhLyq+f/LPR+Elw+N0tvbajLhBax4+wIFI94BGw=;
	b=io2/7QDpUHgO5W3tjf6uLQpeRvNND9eYpVPIhdWbW2PM/YOVPmbR2Wkf2XOFcDxwYntJ
	 tjpWA1EvaFM8wiNYVlXGu28jSVvP8xnDd0EZWiVRb1hwBAJ3CwCo7rOm7HWmdydw+OPfT
	 uUyf7Eo4ptUseZauptOFNvdajr6oN53CbUyVLscbk2Jk5i9m7n572wMWV6MVsXEDM4ZrR
	 oG1UW8gaBqqfQrD9+zalfcb0yOLQ2g5zN/DY4z2jhpiguDi9W3YhwpdmxSqmn/QnaG+vU
	 sJtK5d2GZQtWMvJe9pM4bBSsqTc/Z+fqcmwdlTIMv532tt+K4e7uzSdqZe0MhJ+efkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=o5mqCZ00;
	arc=none smtp.remote-ip=209.85.167.44
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDE5606A31B
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 11:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEDE5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=o5mqCZ00
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5be3d5927ceso588131e87.3
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 04:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792755181; x=1793359981; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fdSFKhLyq+f/LPR+Elw+N0tvbajLhBax4+wIFI94BGw=;
        b=o5mqCZ00odCrExrD11a8TQy3EW58HclX7IVqpQJ0aDtWC4PHIEIWoOWOKvywUDnzAd
         DQRElDaotMo1+P0QYKFYd7s/m1DcEvsPXoKyUDjFbS67qQgaccU7N/EGQ2BCSpSiy8aP
         a6hS5FA7hu4/XfqlZBvoNYutK3cEe/AuVErU6MbQoeIRB1x1AgJsVLaFu8PPHqGRh4u+
         gpsm4WnhyiJs7FgKmNvEmjXOsa60lWScECOtP086oMSK75U/Dw1vjafZ52OVaqhQHXGM
         3vdOCLXG4w2J3qPGDr9aTud0qm6dhzAvgBDNwzKDcyit/0arZwp80ul9KDr+al2XIQVE
         sHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792755181; x=1793359981;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fdSFKhLyq+f/LPR+Elw+N0tvbajLhBax4+wIFI94BGw=;
        b=g+/Tojjy8v5EAEVUWM4HxyavkuHF4+3dNn0MAkLhq/kN8ghDN9Wsu+tQ2g/wEEKz5p
         WgSZBJeMHvtttC8vFLol1UwbrFDijaRjS1wt9OFpWguO6U4hjiO7+iP8gxDCYcwiRTyg
         6exYYRwHO+AvfcZ6gD1df6qtTaqk88fj7N2d5Fmmjo+/QF4ZmYRLTd/X2y5nCjfcQRGY
         Tl6TTSAkLBWZItjPyz+diweG3UkLUtOc0wJ52KoYzHuuLUI/lmDDyzXpHwVtgRVzHf6G
         fGTVci1LnCgklpF1dscIwJDMjp+BBGjKyL93mADzxqj4aBdbDZezd6fjkUNcJe57RdJa
         3M9w==
X-Forwarded-Encrypted: i=1; AKwUvBz3VEzbvem+IbmWWQP1E3vcoNkOnjKa9M+uTQdkFhCsLE1PUt02VLDtGIrbRCytYF+OcTNhBuRC6R0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIxP/MiBYrJdMJIU/PN+yakKxmubyKBjs7TDm98aZG6+VvBE3ub
	3IiTmYz0NbLsa68rCXjLsUXV68J3YwHFrORI3QlMCHHEAjuMb2segUSjaTnNyEeX4H0=
X-Gm-Gg: AYBFou3ZE6IcSG/uMIzlvFl7WYyUK/6GdLThn16ptji+0VEiBv0UJi2qIfArUKbB64w
	tfL33Wozw0QDl6BvmaG5X2Fg6BqgbHKCrccS/zzSZGhD4cXuZjpfpL83UmdIUX/UdZum6uhO+UF
	ZIsKlE23jB1B265W1RGmfIndLKfg8Y8vporq+BgR+//q/Y8J2++jUBGDRNwoXUkNYtjW8fmuVov
	Xa8qgK7g+VWOIfMs4PyidO7ZibmUJmzBuczQC/3/B7z1PzYGhmvyYh3wMO5PJxn4c9x5ZD2VWzj
	JgQbdHXVIA954AMwDwNHsvJdmiKoXbF9MHYqElG7EEMTSFPS+m675G6WKR/eMXAgRR/ryAReFKR
	eTQNMHFOyOHO6B2X4d+hscqpFyfZJbReBQ8Zr+dcDPhpR0/CZ/RF7p9aXUukrv16HM8+7v0gPms
	kaKT/R4OvZb5Oe5f90D7O/wReMoeTplwF/6asLQ2V1SghyjrnPT2kMBgSj4X3iWZanGQmM7Milu
	ee+EvDM+RIGcDW2jLGcDP4H/tldZw9eZ6yFKbe6Wm6GDUhJnu061mHDy0eYb49uKdo=
X-Received: by 2002:a05:6512:3b94:b0:5bf:aee8:7b4f with SMTP id 2adb3069b0e04-5bfb0b35f08mr746484e87.27.1792755180559;
        Fri, 23 Oct 2026 04:33:00 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfb02732f4sm349248e87.27.2026.10.23.04.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 04:32:58 -0700 (PDT)
Date: Fri, 23 Oct 2026 13:32:54 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <atspV8U9HCw68My9@FV6GYCPJ69>
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

Fri, Oct 23, 2026 at 10:04:53AM +0200, aneesh.kumar@kernel.org wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> Thu, Oct 22, 2026 at 12:30:47PM +0200, aneesh.kumar@kernel.org wrote:
>>>Jiri Pirko <jiri@resnulli.us> writes:
>>>
>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>
>
> [ ... 67 lines skipped ... ] 
>
>>>>
>>>
>>>I am using this to understand what the IDE setup flow would look like,
>>>but it is unclear whether the connect flow belongs in an attestation
>>>framework. I understand the desire to pass the certificate slot number
>>>as part of connect, and sysfs is probably not a suitable interface for
>>>that. However, is CTLV the interface we want to use for connect?
>>
>> I was thinking about this and "connect" really does not belong in the
>> attestation CTLV (same applies to "lock"). I was thinking about some
>> parallel PCITSM CTLV instance, but that does not really click as well.
>>
>> Currently I'm thinking we can maintain existing "connect" in sysfs and
>> extend it with "lock" sysfs knob for Realm side. Both would create
>> ctlv-attestation-spdm instance. The same spdm instance may be created
>> for other non-PCI-backed device.
>>
>> The proposed host flow is:
>>
>>     sysfs connect: select tsmN and prepare the connection
>>         -> negotiate SPDM and discover certificates
>>         -> register ctlv-attestation-spdm instance in DISCOVERED state
>>
>>     SPDM_GET
>>         -> populated certificate slots and digests
>>
>>     EVIDENCE_GET(CERT_CHAIN, blob-instance=slot) /*optional*/
>>         -> retrieve candidate certificate chain for appraisal
>>
>>     SPDM_AUTHENTICATE(device-generation, spdm-slot=selected_slot)
>>         -> authenticate the selected chain
>>         -> complete backend-required session and IDE setup
>>
>>     sysfs disconnect
>>         -> remove the attestation instance
>>         -> destroy the native connection
>>
>> The slot is therefore selected after discovery, rather than supplied to
>> connect. The attestation instance represents the prepared connection; it
>> does not exist beforehand as a controller for a disconnected PCI function.
>>
>
>CCA currently takes the device identity index during pdev_create. I am
>investigating how to retrieve the certificate chains for all slots. For

Yes, that is the ordering issue. My current proposal is to perform
preliminary SPDM discovery in Linux before PDEV_CREATE:

sysfs connect
    -> preliminary SPDM negotiation and discovery
SPDM_GET
    -> report populated slots discovered using GET_DIGESTS
EVIDENCE_GET for each populated slot
    -> return its certificate chain obtained using GET_CERTIFICATE
userspace selects and approves a slot
SPDM_AUTHENTICATE(device-generation, slot)
    -> PDEV_CREATE(id_index = slot)
    -> RMM performs its own negotiation and retrieves the selected chain
    -> compare that chain with the selected discovery result
    -> SET_PUBKEY and complete SPDM authentication and IDE setup

Makes sense?


>now, I have implemented the sequence below.
>
>echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/connect
>
>./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 device-get                                                               
># device-get, 1 fragment, generation 0                                                                                      
>  device.generation 0            
>  device.caps                                                                                                               
>    cap.evidence                                                                                                            
>      cap.min-challenge-length 0                                                                                            
>      cap.max-challenge-length 0                                                                                            
>      cap.max-total-output-length 369098752                                                                                 
>      cap.evidence-flags evidence-accept
>      cap.object                                                                                                            
>        cap.blob-class cert-chain                                                                                           
>        cap.blob-instance 0                                                                                                 
>        cap.format spdm-cert-chain
>        cap.representation raw                                                                                              
>        cap.representation tcb-digest                                                                                       
>        cap.hash-algo 4                                                                                                     
>        cap.hash-algo 5          
>        cap.hash-algo 6                                                                                                     
>        cap.max-length 16777216                                                                                             
>  device.info                                                                                                               
>    pci.name 0000:02:00.0                       
>
>I think we can use evidence-refresh to select the blob-instance for the
>desired slot once the CCA specification supports that.
>
> ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get                                                                
># state-get, 1 fragment, generation 0
>  pci.generation 0                                                                                                          
>  pci.connected 1                                                                                                           
>  pci.locked 0                                                                                                              
>  pci.accepted 0                 
>  pci.tsm-id 0                                                                                                              
>  pci.dsm 0000:02:00.0                                                                                                      
>
>device is marked connected, but IDE is not setup as indicated by pci.accepted = 0
>
>
>./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-get --json '{
>"evidence.challenge": "hex:", "evidence.object": [{
>"evidence.blob-class": "cert-chain", "evidence.format":
>"spdm-cert-chain", "evidence.blob-instance": 0,
>"evidence.representation": "raw", "evidence.data": { "file":
>"/tmp/cert0.bin", "data-buf-size": 16777216 } }] }'
># evidence-get, 1 fragment, generation 0                                                                                    
>  device.generation 0                                                                                                       
>  evidence.generation 1                                                                                                     
>  evidence.object-length 1632           
>
>
>I added the file: attribute to verify the evidence blob's contents. ie,
>we can do:
>
># file cert0.bin  
>cert0.bin: Certificate, Version=3
>
>./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-accept device.generation=0 evidence.generation=1
># acknowledged
>./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
># state-get, 1 fragment, generation 0
>  pci.generation 0
>  pci.connected 1
>  pci.locked 0
>  pci.accepted 1
>  pci.tsm-id 0
>  pci.dsm 0000:02:00.0
>
>
>I am wondering why we need 'devsec-run' ops. Isn't that already the result of
>'evidence-accept'?

I split it into two steps to record the decision first and then trigger
RUN. But you are right: unless someone has a use case for keeping them
separate, the split is not really needed and we can combine them.

