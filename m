Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792665058;
	b=AM/WaYnQQIo/cGJUnEK2D7n/FB885lzckMb+gqllqamkf/uGfsN2pGB0do6kLgnbGW3+
	 A5uWBb39rwekyGnTuxkmxqVjQZ0yjrRzOiGsEgHp3ZKSPB3tIwL5crR8QQ1kVp2oElJk9
	 gDu2oaeTjkLk0Zx49fIyq1/8Qv2kfjFgZc+9FFNj/cwGp0f6C32Uw/obTQK4zrTL4qqNT
	 UkTvT56Dt4wD1Y/vRII+Ouscflb9KkFQ6W7BxOl+c0qmHMoHa1IzO6PskwdbWqQIqZAp6
	 oREgnpC08G7npW1lt0I222s5K+FrZbgh5qaRHcyPzYmEsCWusoVLKJSnMIoCmtEqiQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792665058;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=cAdUEYTyoJImjLe4kG0fs9d/mimG75V4j7IdQG63j78=;
	b=xHXN06dzvrardeULtr40DacLDVaEiBfjSyHqqi+k6LRwBc9cWIloqahmsJy4nAeYpxbF
	 /Pg/Tki5CSVqukSp2sptUlQUt5EwnvUbYXYlwmbI/okDBVqeTaHGI6X1peCN8hCUTrZHx
	 CJon6WzZwDrEBz+mN2PTEE15W87jMxQUuvvKMJKG065CbtvWsDQ/4cioZPmwb0k5ysZ5+
	 ZLhjUxAbExQQUbrfmmSCMIG7pUi3pckEAtTmLCRFHmzWGB/BhiFKvPgu/Kf6tAXk/q01u
	 I5QFCL1VbnUjvxp4SGQY9/NDJU5XZ1OCbiF+y3671NRstS3B9VdURc0bfTEoJRHUaZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AugG4S2f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299EB606A319;
	Thu, 22 Oct 2026 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AugG4S2f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620D41F000C1;
	Thu, 22 Oct 2026 10:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792665057;
	bh=cAdUEYTyoJImjLe4kG0fs9d/mimG75V4j7IdQG63j78=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AugG4S2fl9ZI1ikXQgoMQEAel//Gz6cQMDUvE51bYXTbvidiwPlSQBCxdxm+Kq9RM
	 dq8oFYELOKPEWxsU+r0ve6TVIc0cm8l0m1+5Tcy3/sm/kS1wGtA+jiXPVus8iIF7gc
	 0zoILL/U70KVeOQNzp3sq5N35I9xLgAExuAKj7PbwKUedAaByW3xIo0qWopytpmZO0
	 zehL9I+iov8lCqw6RdYBcN/pchtgTVbYALHB2VQVtk9H0ryPEdr6Vi01DE9CCCl5Qz
	 pGwCxgn1YU2YsuLUMZLGI3uvHnwurh4DWh8lB4lBGWFiGQqIc94kZy/ceLfldGhP3U
	 +DvCq1We37oew==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@HansenPartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
In-Reply-To: <20261015145053.3664509-1-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
Date: Thu, 22 Oct 2026 16:00:47 +0530
Message-ID: <yq5a7bjajaco.fsf@kernel.org>
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

> From: Jiri Pirko <jiri@nvidia.com>
>
> Linux has several attestation interfaces tied to individual technologies.
> That makes evidence retrieval, measurement registers, device state and
> kernel consumers provider-specific.
>
> This series introduces a common attestation subsystem. Its goal is to
> support platform, TEE and device providers through one model, including
> TPM2, TDX, SEV-SNP, Arm CCA, FIRME, Caliptra and PCI/TSM-backed devices.
> This first series implements the common subsystem and a TDX provider.
> Existing native TDX tsm_mr and tsm_report interfaces remain independent.
>
> Attestation devices use CTLV, a schema-driven character-device TLV UAPI.
> Compared with sysfs or configfs, CTLV executes one validated request
> atomically instead of assembling a transaction through several files.
> Compared with netlink, an opened device fd directly identifies authority
> and lifetime, can be delegated normally, and owns its event queue. CTLV
> also provides:
>
>   - generated kernel metadata, UAPI constants and documentation;
>   - strict type, bounds, nesting and required-field validation;
>   - runtime operation and schema introspection;
>   - family inheritance and extension points;
>   - fragmented queries with generation checks;
>   - per-fd event subscription, overflow reporting and removal notification;
>   - large input and output blobs.
>
> The attestation family exposes capabilities, evidence, measurement-register
> topology and operations, an append-only MR journal and journal
> notifications. This first ABI contains the paths exercised by TDX. Extended
> evidence classes, dynamic registers, record payloads, verdict recording and
> device-security transitions follow with providers that need them and are out
> of scope of this initial patchset. The broader direction is illustrated here:
>
> https://github.com/jpirko/linux_mlxsw/commits/wip_attestation_all_1
>
> That branch also contains additional providers (test and sim),
> attestation core extensions, libctlv and ctlvctl. With the tools
> and kernel specifications, an attestation device can be used as follows:
>
>   # Discover CTLV devices and their family chains.
>   ctlvctl --spec-dir Documentation/ctlv/specs list
>
>   # Inspect the root-family lineage and attestation capabilities.
>   ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 families-dump
>   ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 device-get
>
>   # List the measurement registers of the attestation device.
>   ctlvctl --spec-dir Documentation/ctlv/specs query ctlv0 mr-dump
>
>   # Read RTMR0 (MR 1).
>   ctlvctl --spec-dir Documentation/ctlv/specs \
>           query ctlv0 mr-read mr.id=1
>
>   # Extend RTMR0 with 48 zero bytes (SHA-384).
>   digest=$(printf '%096d' 0)
>   ctlvctl --spec-dir Documentation/ctlv/specs \
>           exec ctlv0 mr-extend --json \
>           '{"id":1,"value":[{"hash-algo":5,"data":"hex:'"$digest"'"}]}'
>
>   # Retrieve the RTMR0 journal.
>   ctlvctl --spec-dir Documentation/ctlv/specs \
>           query ctlv0 mr-log-get --json '{"selection":[{"id":1}]}'
>
> The 20 patches are organized as follows:
>
>   1-13    add CTLV, its generator and documentation
>   14-17   add the base attestation family and implementation
>   18-20   expose the native TDX service and add the TDX family
>

I am using this to understand what the IDE setup flow would look like,
but it is unclear whether the connect flow belongs in an attestation
framework. I understand the desire to pass the certificate slot number
as part of connect, and sysfs is probably not a suitable interface for
that. However, is CTLV the interface we want to use for connect?

My patches end up doing the following. I am also unsure whether this is
the intended workflow for the attestation framework.

# ./ctlvctl/ctlvctl --spec-dir=./specs/ ops ctlv0
# ctlv/ctlv-attestation/ctlv-attestation-pci, generation 1
families-dump           query   read    fixed   request 16      reply 112..65536
ops-dump                query   read    fixed   request 16      reply 56..65536
op-schema-get           query   read    fixed   request 40      reply 552..65536
subscriptions-add       action  read    fixed   request 6160
subscriptions-remove    action  read    fixed   request 6160
event-queue-get         query   read    fixed   request 16      reply 40..65536
event-queue-set         action  read    fixed   request 40
op-changed              event   record 112
event-overflow          event   record 112
device-removed          event   record 40
device-get              action  read    fixed   request 16      reply 12984
evidence-get            action  read-write      dynamic disabled        request 26800   reply 472
device-state-changed    event   record 64
mr-log-entry-appended   event   record 73416
evidence-accept         action  read-write      dynamic disabled        request 64
evidence-accept-clear   action  read-write      dynamic disabled        request 16
devsec-state-get        query   read    dynamic disabled        request 16      reply 40..1024
devsec-run              action  read-write      dynamic disabled        request 64      reply 40
evidence-state-changed  event   record 112
state-get               action  read    fixed   request 16      reply 184
connect                 action  read-write      dynamic enabled request 88      reply 40
disconnect              action  read-write      dynamic disabled        request 40      reply 40
lock                    action  read-write      dynamic disabled        request 64      reply 40
unlock                  action  read-write      dynamic disabled        request 40      reply 40
evidence-refresh        action  read-write      dynamic disabled        request 88      reply 40

# ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 state-get
# state-get, 1 fragment, generation 0
  pci.generation 0
  pci.connected 0
  pci.locked 0
  pci.accepted 0
# 

# ./ctlvctl/ctlvctl --spec-dir=./specs/ schema ctlv0 connect                
connect (action)
request:
  root nest
    pci.generation required uint [0, 4294967295]
    pci.tsm-id required uint [0, 2147483647]
    pci.cert-slot optional uint [0, 7]
reply:
  root nest
    pci.generation required uint [0, 4294967295]
# 

# ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 connect pci.generation=0 pci.tsm-id=0

-aneesh
