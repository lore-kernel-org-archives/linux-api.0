Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792683512;
	b=u6Mi1worTm4+ccWn+BJx/QLtUSUc+NAve/01JGAqy/Smj5ORvnP6497SzbvDXPsbn0kr
	 7Lvh2hWZ3zPYjeKu5q5OzkvlajRZU/bqoe7OiiM9fJA+bhYmJ9mDuvVh452Y6XoUsK+FS
	 3sVSeIfs03AXnbvbw205SOfM7aZxNjD9LTINs+4hdSQT6UFIwBvEI7AxUawSUK9PE53Xm
	 JbMhBb1zifNAj1HJBBOTsOgaYIT7qVxbI3lDCRv1U1uO6TcllZlMoqf6Cd8pkLdx4c0ha
	 wkdwo7mMjpeLV+MhDP9ovf5gPVhcdyfw5Wg3LdzHiKLSUxZTgpjJpb5dtCxqDo9x7Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=THWbJhv2Q5jbET1QHUfSXWDLSqDqi0mWlN0MWSjDZMo=;
	b=D63MrFu713cKGDC29A3zHl3D77Y9Ud4TI6VvNC0mPVIEnSLDewH2NGqxqYLH7plm9RB5
	 3kW5+OR+opSG42yfnnbj7MLXRGh/3Pkpk6mqDx9h91kAiL4zNqIcH8spKo/x6pKCID/9a
	 x5bb7CzUBvo3eOmU4cKgPQ5Ew6CKygeMiPy9/U3TgpGGo2XkUpcdlYOJRLt+NOSmYmsuX
	 Exfbvzn+DNSShY0Y47JzWe1QVjV8oRtraD787S/cXeSCYEY9KRiHvZI7NvlSVM65qP91V
	 NpCI5Eb7+gpRRY2IPFTd1P0t02Y9JOiKTtk0Ax7Bve6H71Lo7JnqN4eUkEuLbzPk0Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="QYUAaei/";
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAB7606A321
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 15:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFAB7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=QYUAaei/
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so5710655e9.3
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 08:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792683509; x=1793288309; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=THWbJhv2Q5jbET1QHUfSXWDLSqDqi0mWlN0MWSjDZMo=;
        b=QYUAaei/oEpBdPK29lyAgt3WaIjE8xnUfNnM6i9wRuCO6sNUu1WXGnEJY4UwSlTCyG
         3wGrdSOearuuXh6VPWSUboEE1uFUMxxOKzOBQHx8wLpldv1shYxYaj3sE9X+GEVaRzF+
         jRoGtmImwa5JSCcWfnjdvNELJLF8AmhaQBVWuhrHNv4ClYORSdzrf44cUE6H2p01v+oC
         d6DYETd+DkavhEfMqdHDYRzskkO3pFkojAdw6O5EEAsVD0gOewBzmc8l38ZgYG6sjWAU
         NVVPLN7Hz/cRT65qPQ+PhPgY19WGfyVt2rswNlUx/YeV/SbECc8THF3Ud5XLfhnx4Rxg
         4ANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792683509; x=1793288309;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=THWbJhv2Q5jbET1QHUfSXWDLSqDqi0mWlN0MWSjDZMo=;
        b=vQjCml0IMP7zreylrmzjaVcULwRj3cFBEKoheYp6LUZKxnUS8qLfPrN+JHVYLvEjgK
         tWcq633nyygpE6DWaO3Hgy5F1CUg0ZGjWAVqRNt2saKxCfPTKlRAfFT3nnFEJya68dwr
         NFwko9OWpAUz7/SZOVW9NugZOvpvNklBsOkigrQ1YAqyp9eoVv9/gAQZvmbPg9vs+MiT
         PKzW09SoxyOg5yUMUaDJP0GxrzqtzdKVPZ9kph+cgsPrBNSAe5VSK3ITM+AgDxnUoZFg
         pslzgZNScPJwOqQJKv/uKVxgh82YuMPKOksp0K63hLub+ZeO+wyFbtMNs7pkYEwjilqL
         Wxag==
X-Forwarded-Encrypted: i=1; AKwUvBxyqjrMrGEsuvqkLNJlwoijAAGY3gn3344ytTQYMZ+AvWfK/XmjkaF5MBtCdJ/PdRnynW8pNBX5XkE=@vger.kernel.org
X-Gm-Message-State: AFq9FYKMpjGy0QF5+V/vVJBT/lUfYNMo+ImlilBsJcsPnOweMC0BzdfN
	FQ/cX5p32YcfyD0fMiFQgYApjntBIGt0BntsKNahAIMUklNRgkMjfD8DusF1Gi1D7qs=
X-Gm-Gg: AYBFou11rCTBcA0PFdBKkfFx2DS8JpnlUYqmvd1HDijdH/e34IIYFzIhQh+8gxuQyJ0
	ws7abi8FSBCj2t8bOMrNqVsgS7VfQO9DbDFnm5HzgpLS1DNsr3YH//1Py89s7uUqnu0/0Zt7ufX
	DBpvwLTEaBTdOJk5NQfqitGv4LvrNyQQE5RkelE60fX8DplodLZ/agWzL/1p4yJwHR0b0MbbGfp
	Ks3fQ4nIzPAU5L5y/EZ+BspoxJb6DMey9G05CCChkB4Z9Gp5eGD/1EIELibzXE+Iq5YEIEl8XLC
	43PcGHXdZ8X9SgrlDjiPEe/PR04k3ucEH5jDLsq6ieAwQrALJmUSdUEgYWQFH/0I8iXpqRwUHMb
	cvUpIbWL/FI4Dp64+pDnPP9Tn9fctvS3tDBhfA/KsHPuIZoGNXbxyZnTK7o7G58nFZZHbAWp2E/
	Ide2C9mH2kgKZz50+cC5BfIX9GMKr/KdDa9c1278vO5enhIVy+E3Iel5VPjc5fSjHZXxodMBy4g
	ts9FFg98806jvSJ0xGdcHLWDDLZN/jcemJB6zExwGJTtd0lAI7bGoDiuvtlYknQKMY=
X-Received: by 2002:a05:600d:6413:20b0:4a1:80d8:aed5 with SMTP id 5b1f17b1804b1-4a1fdd20c95mr82878645e9.6.1792683507910;
        Thu, 22 Oct 2026 08:38:27 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2a034fc2sm8929342f8f.5.2026.10.22.08.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:38:27 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:38:22 +0200
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
Message-ID: <atooh7uO2RauUTfY@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org>
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
In-Reply-To: <yq5a7bjajaco.fsf@kernel.org>

Thu, Oct 22, 2026 at 12:30:47PM +0200, aneesh.kumar@kernel.org wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> Linux has several attestation interfaces tied to individual technologies.
>> That makes evidence retrieval, measurement registers, device state and
>> kernel consumers provider-specific.
>>
>> This series introduces a common attestation subsystem. Its goal is to
>> support platform, TEE and device providers through one model, including
>> TPM2, TDX, SEV-SNP, Arm CCA, FIRME, Caliptra and PCI/TSM-backed devices.
>> This first series implements the common subsystem and a TDX provider.
>> Existing native TDX tsm_mr and tsm_report interfaces remain independent.
>>
>> Attestation devices use CTLV, a schema-driven character-device TLV UAPI.
>> Compared with sysfs or configfs, CTLV executes one validated request
>> atomically instead of assembling a transaction through several files.
>> Compared with netlink, an opened device fd directly identifies authority
>> and lifetime, can be delegated normally, and owns its event queue. CTLV
>> also provides:
>>
>>   - generated kernel metadata, UAPI constants and documentation;
>>   - strict type, bounds, nesting and required-field validation;
>>   - runtime operation and schema introspection;
>>   - family inheritance and extension points;
>>   - fragmented queries with generation checks;
>>   - per-fd event subscription, overflow reporting and removal notification;
>>   - large input and output blobs.
>>
>> The attestation family exposes capabilities, evidence, measurement-register
>> topology and operations, an append-only MR journal and journal
>> notifications. This first ABI contains the paths exercised by TDX. Extended
>> evidence classes, dynamic registers, record payloads, verdict recording and
>> device-security transitions follow with providers that need them and are out
>> of scope of this initial patchset. The broader direction is illustrated here:
>>
>> https://github.com/jpirko/linux_mlxsw/commits/wip_attestation_all_1
>>
>> That branch also contains additional providers (test and sim),
>> attestation core extensions, libctlv and ctlvctl. With the tools
>> and kernel specifications, an attestation device can be used as follows:
>>
>>   # Discover CTLV devices and their family chains.
>>   ctlvctl --spec-dir Documentation/ctlv/specs list
>>
>>   # Inspect the root-family lineage and attestation capabilities.
>>   ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 families-dump
>>   ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 device-get
>>
>>   # List the measurement registers of the attestation device.
>>   ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 mr-dump
>>
>>   # Read RTMR0 (MR 1).
>>   ctlvctl --spec-dir Documentation/ctlv/specs \
>>           query ctlv0 mr-read mr.id=1
>>
>>   # Extend RTMR0 with 48 zero bytes (SHA-384).
>>   digest=$(printf '%096d' 0)
>>   ctlvctl --spec-dir Documentation/ctlv/specs \
>>           exec ctlv0 mr-extend --json \
>>           '{"id":1,"value":[{"hash-algo":5,"data":"hex:'"$digest"'"}]}'
>>
>>   # Retrieve the RTMR0 journal.
>>   ctlvctl --spec-dir Documentation/ctlv/specs \
>>           query ctlv0 mr-log-get --json '{"selection":[{"id":1}]}'
>>
>> The 20 patches are organized as follows:
>>
>>   1-13    add CTLV, its generator and documentation
>>   14-17   add the base attestation family and implementation
>>   18-20   expose the native TDX service and add the TDX family
>>
>
>I am using this to understand what the IDE setup flow would look like,
>but it is unclear whether the connect flow belongs in an attestation
>framework. I understand the desire to pass the certificate slot number
>as part of connect, and sysfs is probably not a suitable interface for
>that. However, is CTLV the interface we want to use for connect?

I was thinking about this and "connect" really does not belong in the
attestation CTLV (same applies to "lock"). I was thinking about some
parallel PCITSM CTLV instance, but that does not really click as well.

Currently I'm thinking we can maintain existing "connect" in sysfs and
extend it with "lock" sysfs knob for Realm side. Both would create
ctlv-attestation-spdm instance. The same spdm instance may be created
for other non-PCI-backed device.

The proposed host flow is:

    sysfs connect: select tsmN and prepare the connection
        -> negotiate SPDM and discover certificates
        -> register ctlv-attestation-spdm instance in DISCOVERED state

    SPDM_GET
        -> populated certificate slots and digests

    EVIDENCE_GET(CERT_CHAIN, blob-instance=slot) /*optional*/
        -> retrieve candidate certificate chain for appraisal

    SPDM_AUTHENTICATE(device-generation, spdm-slot=selected_slot)
        -> authenticate the selected chain
        -> complete backend-required session and IDE setup

    sysfs disconnect
        -> remove the attestation instance
        -> destroy the native connection

The slot is therefore selected after discovery, rather than supplied to
connect. The attestation instance represents the prepared connection; it
does not exist beforehand as a controller for a disconnected PCI function.

This requires a staged native backend. It is not how existing automatic
sysfs connect behaves today, and those backends would retain their
existing behavior.

For Realm assignment, as written above lock is sysfs interface.
Lock creates a separate assigned-TDI attestation instance for evidence
retrieval, EVIDENCE_ACCEPT, and DEVSEC_RUN

Protocol authentication is distinct from the userspace attestation
verdict: SPDM_AUTHENTICATE does not imply acceptance or TDISP RUN.

So the main difference from your implementation is the lifecycle boundary:
sysfs creates/removes the native contexts, while attestation handles
discovery, explicit authentication, evidence, and the evidence-gated
transition to RUN.

Makes sense?

>
>My patches end up doing the following. I am also unsure whether this is
>the intended workflow for the attestation framework.
>
># ./ctlvctl/ctlvctl --spec-dir=./specs/ ops ctlv0
># ctlv/ctlv-attestation/ctlv-attestation-pci, generation 1
>families-dump           query   read    fixed   request 16      reply 112..65536
>ops-dump                query   read    fixed   request 16      reply 56..65536
>op-schema-get           query   read    fixed   request 40      reply 552..65536
>subscriptions-add       action  read    fixed   request 6160
>subscriptions-remove    action  read    fixed   request 6160
>event-queue-get         query   read    fixed   request 16      reply 40..65536
>event-queue-set         action  read    fixed   request 40
>op-changed              event   record 112
>event-overflow          event   record 112
>device-removed          event   record 40
>device-get              action  read    fixed   request 16      reply 12984
>evidence-get            action  read-write      dynamic disabled        request 26800   reply 472
>device-state-changed    event   record 64
>mr-log-entry-appended   event   record 73416
>evidence-accept         action  read-write      dynamic disabled        request 64
>evidence-accept-clear   action  read-write      dynamic disabled        request 16
>devsec-state-get        query   read    dynamic disabled        request 16      reply 40..1024
>devsec-run              action  read-write      dynamic disabled        request 64      reply 40
>evidence-state-changed  event   record 112
>state-get               action  read    fixed   request 16      reply 184
>connect                 action  read-write      dynamic enabled request 88      reply 40
>disconnect              action  read-write      dynamic disabled        request 40      reply 40
>lock                    action  read-write      dynamic disabled        request 64      reply 40
>unlock                  action  read-write      dynamic disabled        request 40      reply 40
>evidence-refresh        action  read-write      dynamic disabled        request 88      reply 40
>
># ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
># state-get, 1 fragment, generation 0
>  pci.generation 0
>  pci.connected 0
>  pci.locked 0
>  pci.accepted 0
># 
>
># ./ctlvctl/ctlvctl --spec-dir=./specs/ schema ctlv0 connect                
>connect (action)
>request:
>  root nest
>    pci.generation required uint [0, 4294967295]
>    pci.tsm-id required uint [0, 2147483647]
>    pci.cert-slot optional uint [0, 7]
>reply:
>  root nest
>    pci.generation required uint [0, 4294967295]
># 
>
># ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 connect pci.generation=0 pci.tsm-id=0
>
>-aneesh
