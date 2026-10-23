Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792769327;
	b=0+LV6aQnnLMfn7K5rk8LjL0Cm+8hcb9X0i+y5f2vgj0JJ0Dd3WFlgfN9B8tOtICZM4gw
	 5CO5fVUh2zJI3cwuHTdmzuSDLQDUzzn8QANsbhwX0GnxQOjc9w3a2CBVKqXFNPq0o4AMU
	 /oP2POLMB2yW8+jZQAbiBIX8jEmiGrhG2K75Ufem+Cf4Ed4lMS4lSO1u81gnOuhVMIlcW
	 3yZD/B9LjN7Z5I3WWEECBxbVA9lSg20nP2I7ne/C+TauvwK40UFa+yWg49UdBP1chm2gj
	 3RhlyyWGdyhMi9iHR4PxOmpto10RoMTZyPWchUeOEW+wV4JGUWczjWTMf64FJ9YTXcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792769327;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=6o9HAqgOadPvz3dZ4Qp6eGkpw5FrOU+edcMSRgYKgB0=;
	b=3r0d27n5/l/KRVn04ZtwH8+9olKI6NFB3b1LlfriifrH/36QndBT2EOSTfeOAN8rwCk8
	 N9QgOkwGX9+gRcVCTZ4gIQ5tj0ur+wiP+mfWVI7KtZIVbgXYHGrBXwO3xS1f223j5le6D
	 ecIkOf0Xc+XGuBmYHA3s3VhsSZGpmRFxwv94TEscWumG+9Rr5YGUOidN+uUdo0mpABAFk
	 mC9pO7RBaIlLbCmCQ9SDgIf2dCIDT9sQPggKa+KF15duiDz5jOUl74pPREw//UKMaFnFZ
	 klpM59mjZDcHa1QjafDwFdNZWVhPJq6ab2eTLXSrywFtxAJn3WvV+QjndyK5I21dCEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auQgonpq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EDF606A31A;
	Fri, 23 Oct 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auQgonpq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6AF1F01825;
	Fri, 23 Oct 2026 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792769327;
	bh=6o9HAqgOadPvz3dZ4Qp6eGkpw5FrOU+edcMSRgYKgB0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=auQgonpqQDl9Z8udPze90FdbsunEl16YaGHPQJYG/CvZXomZUoVtSLk2zzgglC23O
	 iaPBmqewIVN5G+RX8bvFpapm2zjSGlhjNrhT1OSPjol6vuDVKz4PYrc8wsrSxu7PrH
	 XO2+hLOo2a1a5DQwP+JGoNIjiizQ0hURb2FR0RyB/ptOA/tPgjd8NL5J8xXW3GwlrG
	 6pznEyMdnYI4+M7wEQhmDzaiOEZ8ogX7GQtF+gQeJWEiW8v6dPJlCczLgy9JiNxOXx
	 VU9H7sdXhFZ+SAaSX4PfaIQ0bn970AX2WU9tjK9MKYnBew75GKmWTR5Q58aLfyR56M
	 3PgTV3iWASKUQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
In-Reply-To: <20261023142038.GE3977851@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org> <atooh7uO2RauUTfY@FV6GYCPJ69>
 <yq5av76sj10a.fsf@kernel.org> <20261023142038.GE3977851@ziepe.ca>
Date: Fri, 23 Oct 2026 20:58:35 +0530
Message-ID: <yq5ase1wiggs.fsf@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Fri, Oct 23, 2026 at 01:34:53PM +0530, Aneesh Kumar K.V wrote:
>
>> CCA currently takes the device identity index during pdev_create. I am
>> investigating how to retrieve the certificate chains for all slots. For
>> now, I have implemented the sequence below.
>
> Yeah, I think the consensus at LPC was this may be a gap in CCA.
>

I checked with Alexey, and if I understand him correctly, TIO also needs
to establish eight separate connections to retrieve the certificate
chains.

>
> For now I can imainge CCA just doesn't let you query the certificates,
> and we'd need an ECN to correct it someday once all the kernel parts
> are settled.
>
> I broadly hope we can use the software SPDM implementation to really
> flesh out the uapi and make sure that everyone is happy with it. Then
> we get what subset we get from the first generation of products.
>
> Something like if userspace can't get the slot information early it
> just hardwires slot 0 and goes forward.
>


For now, I am trying Jiri's suggestion: use Rust SPDM to fetch the
certificate chain and return it via evidence-get. evidence-accept then
does pdev-create with the specified slot number and compares the
evidence data returned by the RMM with the value cached by Rust SPDM. If
they match, it uses the cached value for set_pub_key. This seems to be
working. (FVP only supports slot 0, hence only one blob-instance)

# echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/connect
[ 2325.581999] PCI/TSM 0000:02:00.0: connect via tsm0, SPDM discovery enabled=1
[ 2325.582080] PCI/TSM 0000:02:00.0: starting preliminary Rust SPDM discovery over DOE
[ 2325.594379] PCI/TSM 0000:02:00.0: Rust SPDM version=0x12 supported slots=0xff populated slots=0x1
[ 2325.594459] PCI/TSM 0000:02:00.0: fetching certificate chain for slot 0 via Rust SPDM
[ 2325.623625] PCI/TSM 0000:02:00.0: cached certificate chain for slot 0, 1668 bytes
[ 2325.623699] PCI/TSM 0000:02:00.0: preliminary Rust SPDM discovery complete
# cd ../tools/ctlv/
# sh -x cert.sh
+ ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 device-get
# device-get, 1 fragment, generation 0
  device.generation 0
  device.caps
    cap.evidence
      cap.min-challenge-length 0
      cap.max-challenge-length 0
      cap.max-total-output-length 369098752
      cap.evidence-flags evidence-accept,object-selection
      cap.object
        cap.blob-class cert-chain
        cap.blob-instance 0
        cap.format spdm-cert-chain
        cap.representation raw
        cap.representation tcb-digest
        cap.hash-algo 4
        cap.hash-algo 5
        cap.hash-algo 6
        cap.max-length 16777216
  device.info
    pci.name 0000:02:00.0
+ ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
# state-get, 1 fragment, generation 0
  pci.generation 0
  pci.connected 1
  pci.locked 0
  pci.accepted 0
  pci.tsm-id 0
  pci.dsm 0000:02:00.0
+ ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-get --json '{ "evidence.challenge": "hex:", "evidence.object": [{ "evidence.blob-class": "cert-chain", "evidence.format": "spdm-cert-chain", "evidence.blob-instance": 0, "evidence.representation": "raw", "evidence.data": { "file": "/tmp/cert0.bin", "data-buf-size": 16777216 } }] }'
# evidence-get, 1 fragment, generation 0
  device.generation 0
  evidence.generation 1
  evidence.object-length 1668
+ ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-accept --json '{ "device.generation": 0, "evidence.generation": 1, "evidence.accept-object": { "evidence.blob-class": "cert-chain", "evidence.format": "spdm-cert-chain", "evidence.blob-instance": 0 } }'
# acknowledged
+ ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
# state-get, 1 fragment, generation 0
  pci.generation 0
  pci.connected 1
  pci.locked 0
  pci.accepted 1
  pci.tsm-id 0
  pci.dsm 0000:02:00.0
#

-aneesh
