Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793126591;
	b=RNaZW0cfpZYAO5K0/j4+RxMTmu+d+JSXEUFuEuFESHGRmqW3WMLv4WU6pZNC1/UkLpsw
	 UrZg3Nqk7H1zFw5v59OkZpwUlozO2GicHD+0U9zgHBDz4KzQidPrIxZ1NwOXK7yoT9hkf
	 bWzHUX5GlybpbEGxPpp1cO3UDamhdRYa7bqnaCC/AqrxnJkxbvD0t/jILKOabwfI1fw8A
	 /PdqCdJWs3ddrIwzwnQw6GU8TDwsbC0U3yXlCVGeQOhtXG3UMiZwLx4W06Z4u/dMAJKuw
	 wR5AblMSAymICBaHiU+FtiSnGjlCR4RTzdW8/SpCG3am25g9gdwqF2k5/Ual5xwjB7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793126591;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xIFdqcQop16rBA6d8rokSjCRa+xyZ7YEUJL0UVFobxw=;
	b=CPUN8SmYg6xm4KdOtFotpNS4PkgFTPJRwWlke0SJk+BPjrp699PWw2Nx8GoOHOl38VAD
	 eLdThhAKo0eI2DLgbRsJnQhKRBNp9CvNwZziAhU/2Rx0+VzYMgUfBjBshIBkc5roD+Slj
	 BkrPn0zpEUr5UutDP3Uq9xsDY5iJzB3XKtTLz0NNUiQnf4Acm7+TR/uKfrFdAQuTrpC7L
	 D42vJ9ZULR2z1D6kR6tQeAbR9fy+FgQol7KyuoN12qFVQ2PJXKh9QQOGUQbAgy4uYOtxJ
	 cv/VoF2RMQQe67DFbH8+V9DRbb9WWiipm8RrZcJ0PcS9A5dgW3NWehiwESZ3wxGtpRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PCupMWgX;
	arc=none smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F8606A31A;
	Tue, 27 Oct 2026 18:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 789F8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PCupMWgX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793126590; x=1824662590;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UwTqLSGufc96edkaRFFGuSNo8Y98RISJikAmskrMGZs=;
  b=PCupMWgXdTjloa+A++EHK9iT1zMP8Wfm4hAnHBrIotUx6Jxqlq/aE2O3
   hsA1RVdlZOoXaS7xRQbzXKbKeDXViQC1imk5cDO2sHA3zyzOuWEPd9LPT
   DTfzxS4AFG4tgMHwUVpKpwM7NVPEMrteaXS+aQ1yFc5l1kl0i7ISWSxsW
   KY6ehTf7zyW/5FhjAEWuupUQkKWb1wDGuAD9a+o4/vwp7+9oR2hdgelBb
   v7bgcFAvfjU06KZ/lEPXOVo+plmfBzDWexubHpGLkuEwbQb5/x2cL20+f
   oyoFnSHQ/+SiU71j3NCj5sZk1kTcDqUG/XSrRT8S0cnNkvovBp85HMgKL
   Q==;
X-CSE-ConnectionGUID: a1lXrHtQR6aXOoOgrOHv3w==
X-CSE-MsgGUID: cqpF9eiFQdSjvFabigTQvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1736630"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1736630"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:43:09 -0700
X-CSE-ConnectionGUID: sGhZ8Nj9TKOOJVH0GytfUg==
X-CSE-MsgGUID: SmUAzGd1Tz6Ltvlu8kgzxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="6484299"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.170]) ([10.125.108.170])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:43:06 -0700
Message-ID: <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
Date: Tue, 27 Oct 2026 11:43:04 -0700
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
To: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, jgg@ziepe.ca,
 david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
 rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
 drdeeglaze@gmail.com, James.Bottomley@HansenPartnership.com, aik@amd.com,
 jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
 jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
 suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
 elena.reshetova@intel.com, dave.hansen@linux.intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
References: <20261015145053.3664509-1-jiri@resnulli.us>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261015145053.3664509-1-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/15/26 7:50 AM, Jiri Pirko wrote:
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
> Note to reviewers: Please focus on the overall design, UAPI and internal
> attestation-provider API. The internal CTLV and attestation implementations
> remain rough around the edges.
> 

< --snip-->

Hi Jiri,

I built a proof of concept on your wip_attestation_all_1 branch with help of LLM
for TDX Connect device attestation to see how it holds up, and wanted to share
what I found.

What I built:

- A ctlv-attestation-spdm family. As you proposed, the sysfs lock creates the
  assigned-TDI attestation instance; in my version unlock removes it.
  EVIDENCE_GET, EVIDENCE_ACCEPT, DEVSEC_STATE_GET and DEVSEC_RUN all go through
  your ops.

- A provider (a 'struct attestation_provider') that sits on top of PCI/TSM, so
  any backend can use it. It serves the evidence PCI/TSM already publishes, and
  asks the backend for a refresh when EVIDENCE_GET carries a challenge.

I ran it in QEMU with the devsec sample TSM, and in a TDX Connect guest on real
hardware with a real device. Both worked: lock, EVIDENCE_GET, DEVSEC_RUN
refusing a device without a verdict, RUN, and unlock. My tree has out of tree
code for TDX Connect to get things working.

The model works well for device attestation. A few things came up that I think
worth a look.

1. EVIDENCE_ACCEPT and DEVSEC_RUN take any evidence generation since the last
   device change (attestation_evidence_validate()). Ranges would narrow that,
   but they need measurement registers (attestation_ranges_required()), and a
   device has none. So a verdict survives a refresh. In QEMU with the devsec
   sample:

     EVIDENCE_GET, empty challenge   -> evidence generation 1
     EVIDENCE_GET, challenge c1      -> generation 2, measurements changed
     EVIDENCE_ACCEPT generation 1    -> ok
     EVIDENCE_GET, challenge c2      -> generation 3, measurements changed
     DEVSEC_RUN generation 1         -> ok, device in RUN

   Any process that can issue EVIDENCE_GET can do this between the appraisal and
   DEVSEC_RUN, and the device runs on evidence nobody looked at.

   Combining EVIDENCE_ACCEPT and DEVSEC_RUN, as you and Aneesh discussed, makes
   sense to me, but it doesn't completely resolve this. The combined op would
   still take generation 1 and run the device directly.

   Only the provider knows a refresh replaced the evidence. It can't tell the
   core from inside an op, because attestation_state_changed() takes the lock
   ctlv_attestation_op_pre() already holds. How about a helper the provider
   calls after a refresh? With it, the old generation gets -ESTALE:

     /* core.c, next to attestation_state_changed() */
     void attestation_evidence_replaced(struct attestation *att)
     {
             lockdep_assert_held(&att->lock);
             attestation_evidence_accept_clear_locked(att);
             attestation_evidence_ranges_clear(att, false);
             att->evidence_floor = att->evidence_generation;
             att->devsec_version++;
     }
     EXPORT_SYMBOL_NS_GPL(attestation_evidence_replaced, "ATTESTATION");

     /* the provider's evidence_get */
     if (request->challenge_length) {
             rc = pci_tsm_attest_refresh(pdev, request->challenge,
                                         request->challenge_length);
             if (rc)
                     goto out;
             attestation_evidence_replaced(att);
     }

2. TDX Connect (maybe others) does not raise an event when a device drops out of
   RUN. The provider only finds out when it asks, and on TDX even that answer
   can lag. The guest reads the state the TDX Module last saw in a TDISP
   response. A function level reset, for example, moves a locked TDI to ERROR,
   but the guest keeps reading CONFIG_LOCKED until the TDX Module sees another
   TDISP response, such as when the host asks the device for its state.

   So the provider learns about a change inside an op, where the same lock keeps
   it from calling attestation_state_changed(). DEVSEC_RUN doesn't check the
   state itself either in ctlv_attestation_devsec_run_action().

   Could the core add a version of attestation_state_changed() that a provider
   can call while the op already holds the lock? Or let the provider flag the
   change, and have the core send the notification once the op drops the lock?

3. Jason asked on 14/20 whether anyone needs a variable-length challenge. I
   don't think devices need a range. A plain read sends an empty challenge, and
   an SPDM GET_MEASUREMENTS nonce is "NL = 32 or 0". Your TDX provider always
   takes 64 (attestation_tdx_evidence_caps).

   A device needs exactly two lengths: 0 for a plain read and 32 for a refresh.
   struct attestation_evidence_caps only holds a single min/max range. It's
   checked on every request in attestation_evidence_request_decode(), and any
   range that allows both 0 and 32 also allows everything in between.

   To work around that, my provider declares 0-64 and PCI/TSM rejects any length
   other than the backend's nonce size, 32 for both backends I ran. Could the
   caps give one exact challenge length instead of a range, plus a flag that
   also allows an empty challenge? A device provider would set 32 with the flag,
   and your TDX provider 64 without it.

4. EVIDENCE_GET rejects any buffer smaller than max_length
   (attestation_evidence_decode_objects()), so userspace has to allocate for the
   worst case. Aneesh's provider declares 16M per certificate chain, so every
   read needs a 16M buffer. Could EVIDENCE_GET take a smaller buffer and return
   the length it needs, or offer a way to ask for the size?

5. evidence.challenge is a required attr of evidence-request, so a plain read
   has to send an empty one ("hex:" in Aneesh's example). Could it be optional?

6. tdx_attestation_test's discovery_and_construction_fields expects an
   inheritance chain of 4, but the TDX family inherits ctlv-attestation
   directly, which gives 3. In a real TDX guest it fails with
   "Expected 4 (4) == ctlv_chain_len(self->dev) (3)".


