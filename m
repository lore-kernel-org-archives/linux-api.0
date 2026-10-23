Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742704;
	b=gDTUeM+Aosq/BcrgQnV7U1Iy1SO4lD+N8R7Mz+cdydRqjb38xA/hp1PeheUhG+vHfwsn
	 GCAaqLq1iOoGij+XVXnha+iwvxr1PCfv8bZYPt5oy0u2k5Ki9TJUnVjMV8CgSY4IlDYGd
	 MI19fJEm0WoLTfl9QPolDC7R+Tbf20d1d94RFrXZ5TugTfvd+54jtjl0RCJsPDMI29wBT
	 sHv+GHHaJycecJw7/WJq9LteYj3gR8kTnK9bW9pdX7Uo2veT9kxk1vmXKzqWkfcC14PW5
	 o1cLSyP3S29fjOWpfoBH0Upe7Geq2wI3jVlel9wIUxseVfxLdFmwO47Ff0lzaeP42vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742704;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=m2tmSGXuQRVKV0r4MiiAuAOPVUluBMUb7eqsLcZmIXU=;
	b=FUeZVafAaoiU5FIe+bjFddaMHiG+RM7LoMC37SNkhLkfncEtr4ff8EuaVbS9YtCaoacj
	 7T9yrXF822KhBAjpd7Ti2iVaFFBnTZf0wIsi6MS4KZ4bC1sT+aYjUfqTvC6I955zOwWQE
	 rK6CkO7NPnL9emWuJC01thItBu91tuvafBC7D7uuoArkPXLoze20HAaw3DUBv6MktETZE
	 /5fg4OxZSqBSs47a2olag23pU3SaMQtkDOCa5CeF/cvSdQhFOz115U+rO86A3b9wQwFEo
	 snLXTE2LE4m3QwaEPzHpv43wiLe+FSJUwBDzKicktNDW0ezCnJoXRZdnDHdex1U0mMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lBruzr1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0DF606A31D;
	Fri, 23 Oct 2026 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lBruzr1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D521F01825;
	Fri, 23 Oct 2026 08:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792742704;
	bh=m2tmSGXuQRVKV0r4MiiAuAOPVUluBMUb7eqsLcZmIXU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=lBruzr1ee/0GkWnTWhoGc3vOszw1v2kglMLuJvfcNuqHtY/xPVO2mI6cP0MfiS6Aq
	 8gdL6khYEHCDWyhE4rqSPItnrbF2BSSK8O1qTqBFnL8cOLwBpLhz/EgwUL9XaN22J9
	 QqRxo2Ye7X68+GtPQcWcDWfwal4n/Ss0UA0oeOpoBJLZhwX/JBgs2CuUIPeUcecC/6
	 kjj95Pc51jlPFVehIFzBeUF9QyR8VtHy3svgRAqLLvqnpyWiCSh0f4kUl6Nb4kpS1r
	 jmbxXesjaIirUOBO+URQbV5l3DU/3NKgJcIu2o6ZGdKG9otHiiNnyI2D3fh8fAF8ow
	 U9c7g+3FcDh+Q==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca,
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
In-Reply-To: <atooh7uO2RauUTfY@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org> <atooh7uO2RauUTfY@FV6GYCPJ69>
Date: Fri, 23 Oct 2026 13:34:53 +0530
Message-ID: <yq5av76sj10a.fsf@kernel.org>
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

Jiri Pirko <jiri@resnulli.us> writes:

> Thu, Oct 22, 2026 at 12:30:47PM +0200, aneesh.kumar@kernel.org wrote:
>>Jiri Pirko <jiri@resnulli.us> writes:
>>
>>> From: Jiri Pirko <jiri@nvidia.com>
>>>

 [ ... 67 lines skipped ... ] 

>>>
>>
>>I am using this to understand what the IDE setup flow would look like,
>>but it is unclear whether the connect flow belongs in an attestation
>>framework. I understand the desire to pass the certificate slot number
>>as part of connect, and sysfs is probably not a suitable interface for
>>that. However, is CTLV the interface we want to use for connect?
>
> I was thinking about this and "connect" really does not belong in the
> attestation CTLV (same applies to "lock"). I was thinking about some
> parallel PCITSM CTLV instance, but that does not really click as well.
>
> Currently I'm thinking we can maintain existing "connect" in sysfs and
> extend it with "lock" sysfs knob for Realm side. Both would create
> ctlv-attestation-spdm instance. The same spdm instance may be created
> for other non-PCI-backed device.
>
> The proposed host flow is:
>
>     sysfs connect: select tsmN and prepare the connection
>         -> negotiate SPDM and discover certificates
>         -> register ctlv-attestation-spdm instance in DISCOVERED state
>
>     SPDM_GET
>         -> populated certificate slots and digests
>
>     EVIDENCE_GET(CERT_CHAIN, blob-instance=slot) /*optional*/
>         -> retrieve candidate certificate chain for appraisal
>
>     SPDM_AUTHENTICATE(device-generation, spdm-slot=selected_slot)
>         -> authenticate the selected chain
>         -> complete backend-required session and IDE setup
>
>     sysfs disconnect
>         -> remove the attestation instance
>         -> destroy the native connection
>
> The slot is therefore selected after discovery, rather than supplied to
> connect. The attestation instance represents the prepared connection; it
> does not exist beforehand as a controller for a disconnected PCI function.
>

CCA currently takes the device identity index during pdev_create. I am
investigating how to retrieve the certificate chains for all slots. For
now, I have implemented the sequence below.

echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/connect

./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 device-get                                                               
# device-get, 1 fragment, generation 0                                                                                      
  device.generation 0            
  device.caps                                                                                                               
    cap.evidence                                                                                                            
      cap.min-challenge-length 0                                                                                            
      cap.max-challenge-length 0                                                                                            
      cap.max-total-output-length 369098752                                                                                 
      cap.evidence-flags evidence-accept
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

I think we can use evidence-refresh to select the blob-instance for the
desired slot once the CCA specification supports that.

 ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get                                                                
# state-get, 1 fragment, generation 0
  pci.generation 0                                                                                                          
  pci.connected 1                                                                                                           
  pci.locked 0                                                                                                              
  pci.accepted 0                 
  pci.tsm-id 0                                                                                                              
  pci.dsm 0000:02:00.0                                                                                                      

device is marked connected, but IDE is not setup as indicated by pci.accepted = 0


./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-get --json '{
"evidence.challenge": "hex:", "evidence.object": [{
"evidence.blob-class": "cert-chain", "evidence.format":
"spdm-cert-chain", "evidence.blob-instance": 0,
"evidence.representation": "raw", "evidence.data": { "file":
"/tmp/cert0.bin", "data-buf-size": 16777216 } }] }'
# evidence-get, 1 fragment, generation 0                                                                                    
  device.generation 0                                                                                                       
  evidence.generation 1                                                                                                     
  evidence.object-length 1632           


I added the file: attribute to verify the evidence blob's contents. ie,
we can do:

# file cert0.bin  
cert0.bin: Certificate, Version=3

./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 evidence-accept device.generation=0 evidence.generation=1
# acknowledged
./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
# state-get, 1 fragment, generation 0
  pci.generation 0
  pci.connected 1
  pci.locked 0
  pci.accepted 1
  pci.tsm-id 0
  pci.dsm 0000:02:00.0


I am wondering why we need 'devsec-run' ops. Isn't that already the result of
'evidence-accept'?

-aneesh
