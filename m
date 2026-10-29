Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.105.59.63
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299431;
	b=IoMISWYGeRjAEGzuk5HEctiiFfjZO/9KcPnXwQCqkabsx83PqA/unv2w88QDkVUZ+adC
	 1E0bFKBqrDjPyFOnICulDqXrZdoAA/LC0M1aREGgf4jezcws3qmsb6br8vaI7Q0XDQ6of
	 jPppK3CSoj5R7H9+EwYJyADwJ93gXDvExyTmgTHTwaIk7Oll8RX0EmFO6DCsztf2VyWCg
	 xQz18B3FDz2zBUYgAhK2OnRI1XLRP2YexoQYNZB0dY8qqSYLLopyFXoWvwqziCxYpvlwa
	 YPZeosakQ6QqS+sPLyOmcQhqCd9C7thzdVyX7zEMTDeJemUQCdZAJjXMxQGyOch9O9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299431;
	h=DMARC-Filter:Received:Received:Received:X-OVh-ClientIp:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:x-ovh-tracer-id:X-VR-SPAMSTATE:
	 X-VR-SPAMSCORE:X-VR-SPAMCAUSE:DKIM-Signature;
	bh=we/9X3BNuVgC1KW/6CV4ZiXyBB/FHEFRwM/S1VU+cEI=;
	b=5UA5wpUBCm1jHh9W5FAfwfGtGSd4sod16JTjCJHvaXHBLpnaqW50And63N+AZHwj7bj+
	 H8W4G2TLyXt0Lp/wRRMzc6dzqw+X8ZzZC4V0Pztx8PxnEtA38by4MvHqAZNOQMA8yZ/1Z
	 pt+MMGkVXaHac829dAtcvW5h5P1B1Qd8Ak8qvNhBYDil3FgKSV7CfNt0NVFzOCRUyalKP
	 zZLNfMwmvyGVXWBhWKT5PzmwcruWYaJhEPVgAIcCNg0HuZ2nlXTmdawmeUQIjrybbcGT2
	 /dXDmuF3uPdqQy4JeKxZCErC/pWl4agFlYiW+j3JwJwA3a2MR7AaT/U15XEZXmkYCpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=3mdeb.com;
	spf=pass smtp.mailfrom=3mdeb.com;
	dkim=pass header.d=3mdeb.com header.i=@3mdeb.com header.a=rsa-sha256 header.s=ovhmo3617313-selector1 header.b=hwKm3KDy;
	arc=none smtp.remote-ip=46.105.59.63
Received: from 4.mo575.mail-out.ovh.net (4.mo575.mail-out.ovh.net [46.105.59.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C22606A329
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95C22606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=3mdeb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=3mdeb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=3mdeb.com header.i=@3mdeb.com header.a=rsa-sha256 header.s=ovhmo3617313-selector1 header.b=hwKm3KDy
Received: from director1.ghost.mail-out.ovh.net (unknown [10.110.0.182])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id 4jFtRF12Fvz5vhH
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:43:37 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-fwrcm (unknown [10.110.168.168])
	by director1.ghost.mail-out.ovh.net (Postfix) with ESMTPS id D72C9C0C94;
	Thu, 29 Oct 2026 18:43:33 +0000 (UTC)
Received: from 3mdeb.com ([37.59.142.109])
	by ghost-submission-7ccd8bbbb6-fwrcm with ESMTPSA
	id tW/oJdWT42ruchwA9To6vQ
	(envelope-from <sergii.dmytruk@3mdeb.com>); Thu, 29 Oct 2026 18:43:33 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-109S003405e1590-e60a-4458-a6d7-abe253eadb95,
                    80E54DDF43994B3DD4677030DFD12DA1D43C0C90) smtp.auth=sergii.dmytruk@3mdeb.com
X-OVh-ClientIp:176.111.182.218
Date: Thu, 29 Oct 2026 20:43:33 +0200
From: Sergii Dmytruk <sergii.dmytruk@3mdeb.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@HansenPartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <auOT1UwdNt67XfTq@MjU3Nj>
References: <20261015145053.3664509-1-jiri@resnulli.us>
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
In-Reply-To: <20261015145053.3664509-1-jiri@resnulli.us>
x-ovh-tracer-id: 10653264922747020625
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTGAUB1N7f5ptB6fwefbA7yDShGXTiCdDqlMAWzwPYaL4tZmXZf0LgcxNjuD0WugM+1ZHGDHarWsOxLma9Hnwdgw84/JjcelkbeP/vqwDXJY0guog5iW07zsx1pyoTMtJ4vcbNodhIT0XLQ/Glknw8bRlwUNCV7TLCsQDnebsfFrtJszoCYIBu7yRpNCUDlHvXgsgsRX8trULIjkN8lCjVdJRoAwtrnkxwHciQmw1vYGBqdP/PKhNKtG0XF0M4klZhzr+YlotarTYd1gCJkL7bVMu/XTa+fWDxywf2nlmwJ3uzs+DrGYti8fbf0RL/KCRHDVsylv7U0kRSe97ql6aqoUWjaq6abTvFVpuztgK8Shc+RleE6oFXcYmPr/Rfq0V5AgVL5tHFCCDe01up/J10igkjW/cbgGkyt4CM2aG81WzSn0tJWG0awLS7dJ6Wmf/svgS0+Pq0SEVL/nLnNkfI+91JtmSSzcOAyoI/Dhfp6YGZRS0KERmWKYmBBLEDILsjEXDCPYCn9wsPyljPKDR5mPXfRD2Rt7YM8153U6PUvWB5O8Wi/WlJ2ppB/Wke//gQR7wXhWnzUk3Cx1W/nmEikA96ZzwmVjIU7jJvZcBE/A0zf5cP7NV/RB9aYn46kAQREHDz/YA0ih8V6iOk6ZGryIeHt1xJcFWYGpQ8mxe/l9wg
DKIM-Signature: a=rsa-sha256; bh=we/9X3BNuVgC1KW/6CV4ZiXyBB/FHEFRwM/S1VU+cEI=;
 c=relaxed/relaxed; d=3mdeb.com; h=From; s=ovhmo3617313-selector1;
 t=1793299417; v=1;
 b=hwKm3KDy68L6hh7uuKvBWqyZ1I8U1il0C+XqIMPZjQ8yb1ea9TX8pTAfA2L6m8+QZvoP87DA
 Mrm66iif+qEPcMKLNJscQ2sskgAKQj4ksBG0r1maolfGRL3+LNI9iZJdhVfhgNKimkLUFNWvEG8
 pgr41hGTlZaoLJwticpVOAju8jNUIwcX593cvME7S0zXNCK6oY2WCOf6mebYCu3o9s3J8jyX0YT
 lBDdcPllbNwWJ1BNmgRhB80pghcODYP/YqkQVJFqIzhA5RR3eBCCayInMUnrpj/24GQwnRRmIqz
 C4oTglSLRW6aBuPAvPqnFueggEdyLn+XmiU4XchgJPByw==

On Thu, Oct 15, 2026 at 04:50:33PM +0200, Jiri Pirko wrote:
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

Hi,

I have no say in kernel development and wasn't trying to do a proper
review of the changes (was mostly understanding them with regard to
DRTM), so take my comments with a grain of salt, but I do think most of
them are valid.  I also get this is an RFC/PoC type of thing and
sometimes generalizing from multiple locations, those types of comments
do not apply to all instances and specify a general direction that seems
helpful.

Overall impression
------------------

I was surprised to find that 80% of the changes in an attestation RFC
are about a new kernel interface, which is also proposed as a potential
future API for many other things.  The cover letter mentions it, but
doesn't do justice to its scale: YAML specifications, code generation,
serialization, deserialization, actions, events, etc.  Things like
CORBA, COM, or D-Bus come to mind, even though they are different in
many ways.

I feel that something this size needs to be motivated more thoroughly:

1. State goals of what an interface aims to achieve, why it can't be
   done with existing measures, or how bad it would look when using only
   what's already there.

   This is mentioned briefly in the cover letter and has surfaced in
   various responses, but it should be stated explicitly given the
   objective of proposing a long-term interface.

2. Maybe try defining conditions where CTLV is applicable and when it
   doesn't make sense.

   I saw changes to this effect in replies, but it could be done more
   systematically and compare CTLV against existing alternatives to show
   where it fits among them.

3. Specify elements of the design (e.g., schema, actions, events, a tree
   of attributes, a single `ioctl()` operation) and how they serve the
   stated goals.

   For example, what use cases are enabled by partial responses?

4. Explain how the elements are to be represented, produced, and
   consumed.

   That is, the actual tree structure, information about padding,
   generation of the boilerplate, what parts are to be provided by the
   programmer, etc.  This is what existing documentation contains,
   although not very structured.

5. Possibilities of future extensions (compatible and not).

   I haven't noticed versioning, but suspect that a different `ioctl()`
   could be used.  Types or fields can be added and ignored or can fail
   parsing if unrecognized, but this has its limits.  The stance on such
   changes should be documented, so it's clear what one might expect
   going forward.

Having experience with parsing and producing TPM commands and event
logs, I understand the motivation for CTLV and see how it can remove the
most unpleasant parts of dealing with data of this sort.  However, the
machinery necessary on both kernel- and user-space sides is quite
elaborate.  It can end up making even trivial interactions hard (try
using `dbus-send` to retrieve some information or see its C API to get
what I mean).  That's why I feel like the motivational part is very much
lacking here.  Describing the approach in terms of goals and how they
are fulfilled is also partially aimed at making it easier to assess
applicability of CTLV to other subsystems by reviewers.

CTLV specification
------------------

The schema description is machine-oriented and is hard to use for
humans.  At some point, a textual version will be needed, if only to
introduce the most commonly used subset.  It has already been mentioned
that names of attributes aren't descriptive enough, and comments or some
kind of embedded help would be nice to see.

"attr-groups" vs. "attr-sets" confusion has also been mentioned.
Knowing that groups are part of IDs helps, but doesn't make it much
easier to read ("groups" and "sets" don't suggest different levels in a
hierarchy).

Documentation and comments
--------------------------

Right now, it mostly covers implementation details rather than concepts
and how they fit together.  This makes it hard to review the changes, as
the reviewer needs to discern high-level stuff from the code to assess
that code.  Having a more abstract description that's also mapped to a
particular representation would allow checking the overall design and
more fine-grained details.

There is also not much information about how the user-space is expected
to use this (i.e., encode and decode structures).  I suppose there is a
user-space library for that (saw `libctlv` mentioned), but the kernel
part isn't complete without giving an idea of how it's expected to be
used.

I was trying to compensate for the lack of documentation by reading some
comments, but many that I've seen (excluding comments on functions or
structures, those were sensible) restate what the code is doing or
repeat other comments.  Some others seem to say something important, but
do not place it in the context necessary to understand the statement,
and thus do not fulfill the purpose of explaining the code (i.e., why
it's written in a specific way).  It's worth revisiting them in some
future version.

Code
----

Quite a lot of functions are comprised of two blocks of lines with no
newlines or comments within them: declarations and the rest.  That's
fine if the body is small or uniform, but larger functions often have
identifiable steps with conditions and loops.  I'm not saying those
should always be extracted as helper functions, but some kind of visual
structure helps to understand the code.  Given that there are many
thousands of lines in here, that seems like a desirable property for
review as well.

Terminology
-----------

It may be just me, but I found some of it rather confusing, and the
absence of a glossary didn't help.

It took a while to figure out that "family" means a single-instance
class-like construct (data, methods, inheritance with virtual methods).
I also initially thought that "nest" meant a subtree, but it seems to
apply to a top-level tree as well, so it's actually just a tree called
differently (why?).  "stub" also looked weird, but that can be remedied
by documenting it better; not sure if there is a better word.

Other terms seemed just weird, like "file description" instead of "file
descriptor", mentioning of "wire" and "physical something" (no wire
transmissions and nothing physical here).  Still unsure what "placement"
means in various places.

If the terms come from netlink, their use needs to be explained here
too, or the reader needs to be referred to the relevant netlink's
documentation, if borrowing of the terms is intentional and meant to
stay.

TPM event log and MR log
------------------------

I know this will be dropped from this series, but it's still relevant to
keep in mind and will return at some point anyway.

What about measurements taken outside of the kernel?  I've seen the
discussion about extensions done in parallel, with the likely outcome of
not handling this in any way.  But there are also measurements done
before the kernel has started, for both SRTM and DRTM cases.  A way to
import measurements is needed.  Am I correct that nothing should prevent
doing it later?

DRTM perspective
----------------

While there is no TPM/DRTM attestation provider yet, an RFC seems like a
good place to make sure this can be accounted for by the final design.

All the crucial measurements happen before running the kernel and then
by the kernel.  The interesting operations in the user-space are
obtaining the log and having the ability to replay it.  Also, locality
change can block further PCR updates, so the user-space part doesn't
seem to be that important for this use case.

Linux currently doesn't extend the PCR measurements it makes to the
event log, so misalignment of the PCRs and the log won't be something
new.  However, if there is a log, it should be correct at least before
any user-space measurements are taken (IMA breaks this for PCR-10, but
would be nice to avoid this for DRTM or similarly limit the effects to a
specific PCR).  Again, relinquishing locality can be the answer here,
and I suppose that an attestation provider can handle that on its side.

Some of the replies suggest the intention for the kernel to do
measurements using the attestation subsystem.  Combined with importing
measurements, this seems to be enough to cover the needs of DRTM in
terms of data.

What remains is whether postponing extending PCRs until attestation is
online is considered acceptable and by how much they get postponed
compared to doing it early.  In principle, delaying extending the
measurements isn't all that new.  coreboot does exactly that on a lot of
boards, assuming that nothing will mess with its log until devices are
initialized.  DRTM is supposed to enter DLME in an isolated state, so it
may as well rely on it.  However, what does the use of this attestation
subsystem actually buy the kernel for the DRTM case?  And are there
reasons for all DRTM implementations to extend PCRs at the same point if
some can do it earlier?

Also, is the attestation log expected to be the way of publishing the
DRTM log?  That may make consuming it more difficult due to requiring
CTLV-specific tooling.  A TPM2.0 event log requires its own tooling, but
it's the same format SRTM uses.

Best regards,
Sergii
