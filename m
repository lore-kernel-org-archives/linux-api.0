Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793205419;
	b=dIOpabPf8sapVDO0J5TToKPQlggMOXBpFi9yy7PhnRYcAvpKEYMJmel1CAeEOk9IqIWI
	 SGxUrphUAqZnmiSG1ck8wm/ygcwAj9o3pcKKwHvlSb8EZjr9XD+kA/zX5O5iD3nef4TD6
	 eYltRucURRd+jVRPLQlq0uGlt7EK5mbEQsqSkQwUQEhupvpqMrkeABRUaEZ+kccIo7/7m
	 CfdRtc8K+IVh3hdqCf7u+dMedJrQMpZ86nWZccoALzvRdTGmF7OqURWoSD6UObz2PEHmv
	 +uL1QRdw6GdUT0sFkYq4cZoiH2GTE6tuqrRyYUh1vhci9S9oaqsKTwuYMTCpwesTrHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205419;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/Mi6YhYpR0p0j3+EqF4sYxSKOA3pyz2Yf6RF0rom5O8=;
	b=PN/WfZar1xVrOIUQgh3hORrhGiO3t2SeVHwObxSmKmEZ0NlHmSf/IFNWde3S7g8afNH5
	 EqIG4MygM1DPpfpJHuXTqiqs4SfZri27RMw2kDhovL5gKnpUM+MWmt2OcKr5Vjo6J22D/
	 MG+cHa0U2dvQhJr2KaGpOzkWv29uX9J+kndfoFvekZL1atL18cOUbeBO8f+GJ8jAqmlp9
	 im3a3megNe14L0tvZu20gAChd2dUEdOKkw+OXaBN9JNp6+aquStGBfj+14gYPnhVDgIF9
	 CXOD33dgB/Mi34nK8Z9AhIQOXZNtETfVuqZ9MTxDeW6npysgMu91KkancxMufl3X5UQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=armoriq.io;
	spf=pass smtp.mailfrom=armoriq.io;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pO+AIjoj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.47
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB29606A323
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 16:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CB29606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=armoriq.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=armoriq.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pO+AIjoj
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6798af41644so967926d50.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 09:36:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793205417; cv=none;
        d=google.com; s=arc-20260327;
        b=WOz1T+hVNJ2rVBTrMqgB1zRYEgfuXq8eLMiv4Eq5r70+MxCvGwleMNwmHBIHXVLORw
         ddptGTpc2oCdiVqjIwuCFp7GXsGYR6TNYETKasfWE8CACSlw8LRbZAan2XJYfPlsIFFm
         knpwsuRhHXE8fPZJikApUaxa84yodFjGnnHMklO1vdhOCz/DTGdacmVw3FEV7uNeKWAu
         LYKo6w4pU8ujahUPKL4OqWcx2z4wfZAAqh1I4SIW930e8qDqzeBb6fXnxNdn8sKaD5NC
         YAt8MC4E0n6bNowPLGx5/o9H7u6Z/LaHNBrZWJHkw2n7FAreUPDPDUoSNtb3d94trLmS
         GBYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Mi6YhYpR0p0j3+EqF4sYxSKOA3pyz2Yf6RF0rom5O8=;
        fh=+ozVB8EWLjPtpG5Q+uEDByvTImKdbIxx8LEs+Jpenjo=;
        b=sr4z81+pxGfDBodIk2l6bH5tZoUOu6LxVs8Cb4aufQykKk/3tU/r9ktCqIR/BCSBFc
         J28SOTxxA8IkCFJD1NYawEqflBMqi9Awl9if9t/HjrY7tTw08eMgLuhD677BVwV36e3a
         y5Tf5H+tviaO66y8BNCVczqIk5S4z18HpOXv25NoW2VtNYiaEQjAJ5tThtNTZtjqujDJ
         hsmUjIyuIL62cxMBzxXLiu0VUP84QURfunwtjGs0EW/ZUXWJv4yuwJLksykGegZxSNUk
         k+4z59wsK6VLVOhekLoxpIESm1lA475THAmGdUnDs4hT1JDBlYYMFbqjXs2I3Dfk6Ryv
         2NPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1793205417; x=1793810217; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Mi6YhYpR0p0j3+EqF4sYxSKOA3pyz2Yf6RF0rom5O8=;
        b=pO+AIjojAeQbRm+fftAD5MVNIjof/eOOeAz13NM/UJ8p4wKpNsW/+6ADJMWAh96P8E
         9nzrnlAM20Uq72aW/gWYELah9ofluFGQ7Zf4xrAVf2GXn/NUaC/fr4t/TMFAm6ql/eVv
         29H4t40KqIHAA47qbJRd9QiIhFOz5t8QoPsKpfKecUn5ZQqpu4umIGZLyVOw/ywp+FEC
         1zOFdjxcsj3qKHRXsCv4ow6NGUMaj0E8pGiYfb/KS7MR52nfSv2qpsNTaIjdSnA+VLDt
         HBff84zP55t5JOzsReiLJ5qB0odXAbKK9lYVZ1m0Qp3erY12Qs7LIlJFrD/DvGm2u4a+
         V/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793205417; x=1793810217;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Mi6YhYpR0p0j3+EqF4sYxSKOA3pyz2Yf6RF0rom5O8=;
        b=J3WdiDRjkA4cLxdu8QwRcJ2URv+Db057C+uGO0W3W9nRxUJSYamn05+XOfNr0Z0HmZ
         6U2KfLrhMC9mysgv22EDfCn7K6bUvcQTPsp+HHWqg6fiAbq5ZYZxBoCrv32D+Dgp130j
         90qOz34P2R1Dib5KjJ4hLWtm5bIOxXUa/om8J0wRcf0hsaG2ivHZQaA816KNmnDWkRPT
         01fY7PJog8LuVI8wH5T1cM9TR6ATby2WtJCE51oSAVubOKgO+lRVOvjOrKFkGEu9uT+b
         DeoiauFohnaTj2+9PlX+smB/2pSO2AbMVkiEvfIr/p+qHwAqGjntgiC7hBVPxPGngjQ+
         4e6w==
X-Forwarded-Encrypted: i=1; AKwUvBzg7lQq8T+4S0xhi99TXP67Z9YoLUiRsW3JWpAbYVXDgu1NBrqOlpuYd8cUjpZNFETG/89HfHXOY5k=@vger.kernel.org
X-Gm-Message-State: AFq9FYINC/5VGztAXsL1XbUIw4Qb3Y73wmUe4hf1KSTC1F4aOkfU+d2a
	WiEqLTgpTP9K3blR69HDHH0+mzeR8piGkwF7/jnCVmrdlIn3YbVm8bjgQdhag+RJkD34EB2+5bt
	NXI2VGVKmacjeQlOx1bM1weVU14amRgOuBQ63nhKu6eo=
X-Gm-Gg: AYBFou2SUA+LWkO/jIZCsege6YoF0+Mmnrdo/GrtwoT5PjsTQhl0KWWuNS3Wo3A5x06
	+nVEXRO/WVkREjFOhCFA7g5OHzxLUNrB1ZE4LhOZ/fZr360bUQ8G0Yb8kyuUWAVfnsZcfCft6e2
	xHgV+gBLC3ky74Boqa/BF2Sju7WjuO59A75r8q5LUzBAQU8SYYqn0QjgfpqMlkrmc0J4jdN4Xl1
	2jbg4KOcuBBId7dFrEQs2uPWcN8xrMqk7QsVSPngx/2FHQ1ac63FBClksXr+gSlt8zz4h8bk4sJ
	zhavILvSonrSgnTMUf/BeAFze220xQxyfePYuWu7mLBGQSxmQRldRCfUlwQKxJNU8zIdmLtmwQL
	/WnMUn+nHoUVW2U0Gsh8Xxi6ZTJPWGtJfwSLDwqASQ4/vvFy1LjXgaB8aNb9/Djm4dNCqPjoWOh
	nbi/8kLr1Mt75/SLUqE7tFxiZjV6ZL1FPlvFWaAw943phrovg1
X-Received: by 2002:a05:690e:1907:b0:678:fc00:8b1d with SMTP id
 956f58d0204a3-67a7b98381cmr2898305d50.11.1793205416561; Wed, 28 Oct 2026
 09:36:56 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028133335.75899-1-ketan@armoriq.io> <20261028133335.75899-2-ketan@armoriq.io>
 <20261028.ecf3e62c6cf5@gnoack.org> <CAKS=Y5WqExXSEu3PPbFY5J0GDaYJyjxqQc8HYUKAnQ6fpEfAsQ@mail.gmail.com>
In-Reply-To: <CAKS=Y5WqExXSEu3PPbFY5J0GDaYJyjxqQc8HYUKAnQ6fpEfAsQ@mail.gmail.com>
From: Ketan Bhardwaj <ketan@armoriq.io>
Date: Wed, 28 Oct 2026 12:36:42 -0400
X-Gm-Features: AclHuK-qMO2rcpFvjjILt3QbN76ve3nvqIfklh4CNfb0NTWyJsVagURjyaSRpQQ
Message-ID: <CAKS=Y5WRbX6fnoNLKjm=3iE3i-V6g=t0oHYu10X_EMjg+O7TWQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/6] docs: security: Describe the Kernel Assurance
 Plane design
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack3000@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E . Hallyn" <serge@hallyn.com>, linux-security-module@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, 
	linux-api@vger.kernel.org, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	linux-kernel@vger.kernel.org, "HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

G=C3=BCnther,

Thanks for taking the time to go through this in detail. Your questions
help identify where the document mixes three things: the objective's
lifecycle, the policy derived from it, and the mechanisms enforcing that
policy. We need to distinguish those more clearly.

Replies inline.

> Can you please also set apart how it is conceptually different to
> Landlock?
>
> Landlock can see paths (unlike Seccomp), and Landlock policies
> (rulesets) are defined and enforced by unprivileged processes through
> its userspace API.
>
> What is missing in Landlock which does not make it usable for your
> use case?

Landlock is certainly usable for confining an agent workload. Path-based
restrictions, inherited confinement, and unprivileged policy installation
are not distinctions we should claim for KAP.

The distinction we are trying to establish is an independently managed
authority context whose lifetime is associated with an objective, rather
than a particular process or sandbox instance.

For example, an objective can have several already-running workers. Some
may have been launched separately by the runtime, rather than being
descendants of one application process. The objective's authority can
change while those workers continue running. We want a trusted controller
to update or revoke that authority, with the kernel checking subsequent
protected operations against the current state, without requiring the
workers to cooperate.

Landlock's documented enforcement API applies restrictions to the
calling thread, or its thread group with TSYNC, with inheritance for
future descendants [4]. The interface we are exploring instead lets an
authorized external controller manage a shared authority context to
which independently executing tasks are explicitly bound. That is a
lifecycle and control-model distinction, not a distinction about whether
paths can be restricted.

The kernel would not interpret the objective. Userspace supplies the
policy and an association with the objective's authority state. The
kernel maintains the task binding and enforces that state.

> Obviously, there are missing features that people would want in
> Landlock, but that's an argument that doesn't count IMHO, since it's
> still easier to add these features to Landlock than to create a new
> separate LSM.

Agreed that a list of missing access checks would not justify a separate
LSM.

Our preference is to keep objective identity, authority generation,
execution binding, and revocation as an independent abstraction that can
coexist with different confinement mechanisms. We do not want agent
runtime frameworks to make the objective's lifecycle specific to one
sandbox policy implementation.

That does not establish that every part of this RFC is necessary, or that
the current implementation is the right decomposition. It does establish
what we would like to preserve while revising it: a common
authority-lifecycle contract, rather than another collection of sandbox
rules.

I would appreciate your guidance on what a minimal, independently
reviewable version of that abstraction would need to demonstrate. I give
a concrete example below.

> It's unclear to me why procfs is not covered with "file", since you
> are already doing path-based matching. What operations are restricted
> by "descriptor" is also unclear to me.

In this implementation, procfs is a separate category selected for paths
under /proc, with normalization of the current task's numeric PID to
/proc/self. It is still path-based enforcement. There is no fundamental
objective-authority requirement for making it a separate category, and
the documentation should not suggest that it provides a distinct,
comprehensive procfs security model.

descriptor currently refers to checks at file_receive, using the
received file's resolved path. It is not a general policy over every
descriptor operation or a complete implementation of descriptor
inheritance and transfer semantics.

Regular file use is also checked through file_permission, but that
should not be conflated with complete descriptor-lifecycle coverage. We
will update documentation to identify the exact operations covered,
particularly the distinctions between receiving a descriptor, using an
existing descriptor, and accessing an existing mapping.

> FWIW since pathname Unix Domain Socket are also addressed by path,
> we found it useful to express the rules about them with paths as well,
> in Landlock.
>
> In networking and IPC, I am a bit missing how that would work when
> *offering* a service (listen(), bind()). Do you have thoughts on that?

That makes sense. The current Unix-domain checks use coarse operation
identifiers, unix:stream_connect and unix:may_send, rather than
identifying the particular endpoint. They are not sufficient for
expressing which pathname socket a task may communicate with.

For pathname sockets, using the resolved endpoint is a better direction
than treating all Unix-domain communication as one permission. Abstract
sockets would need their own explicit semantics.

The current network implementation covers connect(), not a complete
service-offering policy. bind(), listen(), and use of accepted or
already-connected sockets need to be addressed explicitly. A connect
restriction should not be presented as covering those cases.

These are gaps in the prototype's mediation coverage, not reasons for
introducing the independent authority object. I should make that
separation clear in the document.

> What is sysv:flag=3DN? You might be interested in the discussion we had
> at [1] ... many of its integer identifiers are not FD-like handles,
> but just live fully accessible to the entire IPC namespace.

It is the flag argument received by the ipc_permission hook. The current
implementation formats that value into a predicate target; it does not
use ipcp to identify the particular IPC object.

Your concern applies directly. This does not establish object-scoped
System V IPC confinement, and those identifiers cannot be treated as
descriptors carrying an authority association. Thanks for the reference.
We need either a properly specified object/namespace model and
corresponding tests, or a much narrower statement of what this check
provides.

> Can it be turned off as well?
>
> You are creating policies through the file system, but you are at the
> same time restricting access to the file system with these policies.
> How does that work?

On io_uring, the three checks shown cover override_creds, sqpoll, and
uring_cmd. They do not provide a blanket disable switch for the interface
or complete lineage handling for every asynchronous operation. The
documentation should not imply otherwise.

On KAP itself, a bound task has no per-task opt-out. The current group
modes are enforce and revoked; enforce means evaluating the installed
policy, not disabling enforcement. kap.default=3Dopen affects the
additional check on unbound execution, not enforcement for already-bound
tasks. If the policy evaluates to true, it is effectively turned off.
However, thanks
for the input; we will explore if a blanket turn-off is feasible if
desired / necessary.

The control-plane writer is a separate trusted runtime component, outside
the workload's restricted igroup. It installs and updates the policy; the
managed workload does not manage its own control files. There is no
blanket exemption allowing a bound workload to access those files.

The administrator remains trusted and can replace policy or change group
state. Writable control-plane descriptors must also remain with the
trusted component, not be passed to the managed workload. This is not
intended to protect against a malicious administrator.

> Chosen: a separate hierarchy. A container usually places all of its
> tasks in one cgroup, while several objectives can run inside it, each
> needing its own authority. Tying authority to resource partitioning
> would prevent that, and authority must also follow setns, which
> cgroup membership does not.
>
> I find both arguments unconvincing.

Thanks for pointing this out you are right. trhe current cgroup argument
is overstated as written. Userspace can create sub-cgroups and choose
their membership. Also, entering another cgroup namespace does not itself
change cgroup membership, so the statement about setns() may not be a
sound distinction [5].

The reason for wanting an independent association is that resource
organization and objective-authority organization need not coincide.

For example, one objective may have workers in both interactive and
background resource groups, while each resource group contains workers
serving several objectives. Updating the objective's authority should
not require reorganizing those resource groups.

The intended distinction is therefore not "Linux cannot group tasks by
something defined in userspace." It already can. It is that we want an
authority association and lifecycle independent of the resource
hierarchy.

That is our argument and the one document should make, together
with an example showing why that independence is useful.

> If it's a BPF program, you can also audit it in one place ... lobbying
> to get CONFIG_BPF_LSM enabled ... is probably not substantially
> different than ... CONFIG_KAP_LSM enabled.

Agreed. Auditability and configuration availability are not sufficient
arguments against BPF LSM. BPF LSM can implement enforcement at security
hooks, and I should not imply otherwise [6].

What we are seeking is a shared contract for authority-object lifetime,
task attachment, inheritance, updates, and revocation. A particular BPF
implementation could implement parts of that contract; the question is
which semantics should be common rather than independently reconstructed
by each agent runtime framework.

The built-in implementation makes the proposed contract concrete, but
its existence is not proof that this is the smallest implementation. I
would welcome guidance on reducing the mechanism while preserving an
independent objective-authority abstraction.

> I'm surprised that it's privileged, since existing AI agent software
> tends to run unprivileged. Who would be operating this and defining
> the policies?
>
> ... are roughly equivalent to the goals that you give to the model
> in an agent prompt?
>
> Does the agent software communicate with a privileged agent? Or does
> the agent software spawn off namespaces to attain the necessary
> privileges?

The initial deployment model is a supervised agent runtime, not an
unprivileged application installing its own sandbox.

A user supplies a task, but that prompt is not itself an authorization
grant. The trusted runtime combines the task with configured workspace
access, tool contracts, credential bindings, administrator policy, and
any required approvals to produce the executable policy.

Our intentd work maintains the objective's current authority and
lifecycle in userspace. A privileged runtime-side or guest-side component
installs the resulting state before starting the managed workload. The
agent itself runs unprivileged. The runtime integration is described in
[2].

In the submitted control path, writes require authorization against the
initial user namespace. Creating a new user namespace is not how an
agent obtains permission to install KAP policy.

This deployment assumption needs to be explicit. It is a different trust
model from unprivileged self-restriction, not an argument that
self-restriction is inadequate.

> More of a terminology remark, but when you consider the kernel layer
> only, it feels like the compiled predicate snapshot *is* the policy
> that you are enforcing?

Yes. From the kernel's perspective, the predicate snapshot is the policy.

The distinction I intended was between interpreting the objective and
enforcing the resulting policy. The former stays in userspace. The
current kernel code also parses and compiles the supplied pattern
representation, so "policy stays in userspace" may too broad and
misleading.

A better description is: objective interpretation, authorization
decisions, and validation of upstream artifacts remain in userspace;
the kernel enforces the installed policy and its execution binding.

> I don't understand why the JSON format is a question for the kernel
> review; you can do the interface in a format that is suitable for the
> kernel, and translate from JSON into that format in userspace ...

Agreed. JSON is a prototype representation, not a requirement of the
model. Translation from a userspace policy format should happen before
installation.

The kernel-facing questions should concern a bounded, versioned
representation, validation, atomic installation, and update semantics.
They should not require the kernel to accommodate the userspace
configuration language.

> I believe we added such hooks for the Landlock namespace and
> capability support.

Thanks for pointing that out. The current linux-next documentation
describes namespace and capability restrictions, including namespace
acquisition through unshare(), clone(), and setns() [7]. I will check the
available hook coverage against the intended base and remove the blanket
statement that these paths lack hooks.

Direct calls to KAP are not essential to the design. Where the common
hooks cover the operation, that is the integration point we should use.
Any remaining coverage gap should be described as a generic hook
requirement, not as a reason to hardwire KAP into the syscall path.

> I've read the doc, but still don't understand how that model is
> supposed to work. Do you maybe have a concrete motivational example
> which defines such a policy and demonstrates why that is different
> and can not implemented with one of the other LSMs or the BPF-LSM
> instead?

Yes. Here is a smaller example than the current architectural description.

An agent runtime has two objectives executing in the same environment
through separate worker processes. Both can initially access a package
cache and contact a package registry.

The relevant authority contents are:

    Objective O1, generation 7:
        file access: /workspace, /package-cache
        network connect: 192.0.2.1:443

    Objective O2, generation 4:
        file access: /workspace, /package-cache
        network connect: 192.0.2.1:443

These are abbreviated policy contents, not complete startup grants.

O1 finishes dependency installation and moves to offline testing. O2 is
still doing package-resolution work. The controller changes only O1:

    Objective O1, generation 8:
        file access: /workspace
        network connect: none

A worker created under O1/generation 7 is still alive and may have an
already-open regular file in /package-cache. We want its next covered
file-access or connection check to fail without relying on that worker
to restrict itself. O2's authority should be unaffected.

In the RFC's epoch model, advancing O1's generation invalidates old task
bindings. Authorized continuations must be explicitly rebound to the
current generation; old workers do not silently acquire the replacement
authority. This is fail-closed invalidation at the next covered check,
not termination of the process, recovery of data already read, or
cancellation of every operation already in flight.

The RFC still has a disclosed concurrent-binding race and needs
selftests. I am describing the intended contract and the behavior the
revised tests should establish, not claiming complete coverage today.

There is a related implementation experience behind this. In our Agent
Substrate/Kata integration, we had to ensure that a failed
authority-binding step could not leave the workload running unbound. We
also initially installed a grant that omitted operations needed during
startup and stranded the workload. Those experiences are described in
[2].

Suspend/resume exposed another boundary: a VM snapshot can restore an
older kernel authority state. Our runtime therefore checks the current
objective state outside the snapshot before allowing the workload to
resume [3]. A guest-local epoch alone cannot solve rollback of the entire
guest. That is a runtime responsibility, not a guarantee supplied by this
patch series.

These examples motivated separating the objective's authority lifecycle
from the process and sandbox lifecycle.

They do not demonstrate that equivalent behavior is impossible to
construct with BPF or another programmable security mechanism.
The question we are bringing upstream is whether
this lifecycle deserves a common, independent kernel-visible
abstraction, rather than remaining runtime-specific coordination around
separately installed policies.

There is also a distinction between the broader design and this RFC:
the lineage root is currently an opaque userspace-supplied reference.
The kernel is not verifying a proof or proving that one policy
is a valid refinement of another. Those decisions remain trusted
userspace responsibilities in this version.

Would you suggest a way to present and implement a minimal independent
authority-domain facility that composes with existing LSM enforcement,
while keeping objective lifecycle management separate from any
particular sandbox implementation?

More specifically, would a smaller series focused on task binding and
inheritance, atomic authority-generation updates, revocation, and a
narrowly defined set of enforcement points make the model easier to
evaluate? What comparison and tests would you want to see to assess
whether that independent abstraction is justified?

We are open to changing the interface and implementation substantially.
What we would like to preserve is the separation between
objective-authority management and any one agent runtime framework or
confinement policy implementation.

I have included the broader motivation in [1] and the implementation
accounts in [2] and [3] as background. The RFC itself should contain the
concrete model and evidence needed for review without requiring readers
to follow those posts.

Thanks again for the detailed feedback.

Ketan

[1] AI agents need an OS-level enforcement primitive:
https://armoriq.substack.com/p/ai-agents-need-a-os-level-enforcement

[2] From Objective to Syscall: Building the First Intent Container:
https://armoriq.substack.com/p/from-objective-to-syscall-building

[3] Execution State Can Travel Backward. Authority Cannot:
https://armoriq.substack.com/p/execution-state-can-travel-backward

[4] Landlock documentation:
https://docs.kernel.org/userspace-api/landlock.html

[5] Control Group v2 documentation:
https://docs.kernel.org/admin-guide/cgroup-v2.html

[6] BPF LSM documentation:
https://docs.kernel.org/bpf/prog_lsm.html

[7] Landlock documentation, linux-next:
https://docs.kernel.org/next/userspace-api/landlock.html

On Wed, Oct 28, 2026 at 12:03=E2=80=AFPM Ketan Bhardwaj <ketan@armoriq.io> =
wrote:
>
> Hi G=C3=BCnther,
>
> Thanks for the detailed feedback. These are great points.
>
> I am working on a response to address the conceptual differences with Lan=
dlock and clarify the points on the control plane, IPC, and the privilege m=
odel. I will get back to you shortly with more details and a concrete examp=
le.
>
> Best,
> Ketan
>
> On Wed, Oct 28, 2026 at 11:17=E2=80=AFAM G=C3=BCnther Noack <gnoack3000@g=
mail.com> wrote:
>>
>> Hello!
>>
>> On Wed, Oct 28, 2026 at 09:33:30AM -0400, Ketan Bhardwaj wrote:
>> > Describe the Kernel Assurance Plane (KAP) design.
>> >
>> > Agents and other long-running tasks act on behalf of an objective that=
 a
>> > user approved. Linux decides whether a task may perform an operation,
>> > but not whether the operation still belongs to that objective. Seccomp=
,
>> > LSM profiles, namespaces and cgroups cannot hold several objectives ap=
art
>> > inside one environment, or revoke one objective's authority while its
>> > task runs.
>> >
>> > KAP introduces objective-scoped authority as a kernel subsystem. The
>> > document covers Intent Lineage Groups, the authority model and the
>> > control plane under /sys/kernel/security/kap, where igroups are create=
d
>> > with mkdir as cgroups are. For each design decision it lists the
>> > alternatives considered, and it ends with the questions on which
>> > maintainer feedback is wanted.
>> >
>> > Assisted-by: Claude
>> > Co-developed-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
>> > Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
>> > Assisted-by: Codex
>> > Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
>> > ---
>> >  Documentation/ABI/testing/securityfs-kap | 111 +++++++++++
>> >  Documentation/security/index.rst         |   1 +
>> >  Documentation/security/kap.rst           | 236 ++++++++++++++++++++++=
+
>> >  3 files changed, 348 insertions(+)
>> >  create mode 100644 Documentation/ABI/testing/securityfs-kap
>> >  create mode 100644 Documentation/security/kap.rst
>> >
>> > diff --git a/Documentation/ABI/testing/securityfs-kap b/Documentation/=
ABI/testing/securityfs-kap
>> > new file mode 100644
>> > index 0000000..066de0b
>> > --- /dev/null
>> > +++ b/Documentation/ABI/testing/securityfs-kap
>> > @@ -0,0 +1,111 @@
>> > +What:                /sys/kernel/security/kap/
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Kernel Assurance Plane control directory in securityfs.
>> > +             The ABI is experimental and intended for RFC review.
>> > +
>> > +What:                /sys/kernel/security/kap/kap.default
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read or write "open" or "closed". When closed, a task
>> > +             outside the initial PID namespace that is bound to no ig=
roup
>> > +             cannot start a program.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Directory of Intent Lineage Groups. Create an igroup wit=
h
>> > +             mkdir, as a cgroup is created.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.in=
stall
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Write the lineage root, authority epoch, optional expiry=
 and
>> > +             transition, and the authority as one key=3Dvalue documen=
t in a
>> > +             single write. The fields commit together or not at all.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.pr=
ocs
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Write a pid to bind that process, with all of its thread=
s,
>> > +             to the igroup. Reads return the pids written.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.li=
neage_root
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read or write the opaque lineage root for the igroup.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.au=
thority_epoch
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read or write the current authority epoch. A lower value=
 is
>> > +             refused, and a write clears revoked mode. Bound tasks wh=
ose
>> > +             recorded epoch is stale fail KAP checks closed.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.au=
thority
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read or write the authority document for the igroup, in =
a
>> > +             strict subset of JSON, with a "predicates" array, each p=
redicate having a
>> > +             "kind" and "allow" and "deny" arrays of patterns. The
>> > +             Kernel Assurance Plane design document lists the kinds a=
nd
>> > +             how patterns match.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.ex=
pires_at
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read or write the authority expiry in seconds since the =
Unix
>> > +             epoch, or 0 for none. An expiry already in the past is
>> > +             refused. Once it passes, every check for the igroup fail=
s
>> > +             closed.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.tr=
ansition
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Write a transition record whose sequence number is highe=
r
>> > +             than the last one, to prevent replay. Reads return the l=
ast
>> > +             sequence number.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.mo=
de
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read or write igroup mode. Supported values are "enforce=
" and
>> > +             "revoked". A revoked igroup refuses every operation.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.ev=
ents
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read recent KAP decisions as JSON lines with the fields
>> > +             ts_ns, igroup, decision, operation, target, reason, epoc=
h,
>> > +             root and pid.
>> > +
>> > +What:                /sys/kernel/security/kap/igroups/<igroup>/kap.ig=
fd
>> > +Date:                October 2026
>> > +KernelVersion:       RFC
>> > +Contact:     Ketan Bhardwaj <ketan@armoriq.io>
>> > +Description:
>> > +             Read the igroup's name, epoch and lineage root on one li=
ne.
>> > diff --git a/Documentation/security/index.rst b/Documentation/security=
/index.rst
>> > index 00650dc..937193b 100644
>> > --- a/Documentation/security/index.rst
>> > +++ b/Documentation/security/index.rst
>> > @@ -18,6 +18,7 @@ Security Documentation
>> >     siphash
>> >     tpm/index
>> >     digsig
>> > +   kap
>> >     landlock
>> >     secrets/index
>> >     ipe
>> > diff --git a/Documentation/security/kap.rst b/Documentation/security/k=
ap.rst
>> > new file mode 100644
>> > index 0000000..22c2729
>> > --- /dev/null
>> > +++ b/Documentation/security/kap.rst
>> > @@ -0,0 +1,236 @@
>> > +.. SPDX-License-Identifier: GPL-2.0
>> > +
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > +Kernel Assurance Plane
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > +
>> > +Kernel Assurance Plane (KAP) introduces objective-scoped authority as=
 a kernel
>> > +subsystem. Intent Lineage Groups (igroups) are its core kernel object=
, LSM hooks
>> > +are its enforcement mechanism, and securityfs is its control-plane in=
terface.
>> > +
>> > +This document describes the design for review. It lists the alternati=
ves that
>> > +were considered for each decision and the questions on which maintain=
er feedback
>> > +is wanted.
>> > +
>> > +Motivation
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > +
>> > +A task increasingly runs on behalf of an objective that a user approv=
ed, for
>> > +example an AI agent asked to fix a failing test. Over hours it starts=
 programs,
>> > +reads and writes files and opens connections. Linux decides whether t=
he task
>> > +may perform each operation. It does not decide whether the operation =
still
>> > +belongs to the objective the task was started for.
>> > +
>> > +Existing mechanisms cover parts of this. Seccomp filters syscalls but=
 cannot see
>> > +paths or objectives. LSM profiles, such as AppArmor or SELinux, are a=
ttached to
>> > +programs or labels, not to an objective, and cannot be narrowed for o=
ne task
>> > +while it runs.
>>
>> Can you please also set apart how it is conceptually different to
>> Landlock?
>>
>> Landlock can see paths (unlike Seccomp), and Landlock policies
>> (rulesets) are defined and enforced by unprivileged processes through
>> its userspace API.  It is already a popular choice for AI agent
>> sandboxing and orchestration frameworks.
>>
>> What is missing in Landlock which does not make it usable for your use
>> case?
>>
>> (Obviously, there are missing features that people would want in
>> Landlock, but that's an argument that doesn't count IMHO, since it's
>> still easier to add these features to Landlock than to create a new
>> separate LSM.)
>>
>>
>> > +Namespaces and cgroups partition resources rather than
>> > +authority. None of them lets several objectives run in one environmen=
t, each
>> > +held to its own authority, or fails a task closed the moment its auth=
ority is
>> > +revoked.
>> > +
>> > +Model
>> > +=3D=3D=3D=3D=3D
>> > +
>> > +``igroup``
>> > +  Intent Lineage Group, the unit KAP enforces. An igroup owns an auth=
ority
>> > +  snapshot, a lineage root, the current epoch, an optional expiry, a =
transition
>> > +  sequence, its bound tasks and an event log. A process is bound by w=
riting its
>> > +  pid to the igroup, which binds all of its threads. Children inherit=
 the
>> > +  binding, and it is kept across exec and setns.
>> > +
>> > +``authority snapshot``
>> > +  The predicate set for one igroup epoch, with typed ``allow`` and ``=
deny``
>> > +  arrays for exec, file, network connect, credential, IPC, namespace,
>> > +  descriptor, procfs, executable memory, BPF, ptrace and io_uring che=
cks. File
>> > +  predicates also govern rename, link, unlink, mkdir, rmdir, mknod, s=
ymlink and
>> > +  truncate, so a file cannot be moved into a denied path. A deny wins=
 over an
>> > +  allow, and an operation no predicate allows is refused. The snapsho=
t is
>> > +  compiled once when it is installed.
>> > +
>> > +  In this RFC the snapshot is a document in a strict subset of JSON, =
with no
>> > +  whitespace around the ``"predicates"`` and ``"kind"`` keys and no e=
scaped
>> > +  quotes::
>> > +
>> > +    {"predicates":[{"kind":"file","allow":["/srv/work"],"deny":["/srv=
/work/keys"]},
>> > +                   {"kind":"exec","allow":["/usr/bin/*"],"deny":[]}]}
>> > +
>> > +  The kinds are ``exec``, ``file``, ``net``, ``cred``, ``ipc``, ``nam=
espace``,
>> > +  ``descriptor``, ``procfs``, ``execmem``, ``bpf``, ``ptrace`` and
>> > +  ``io_uring``. File, descriptor and procfs patterns match a path and
>> > +  everything below it. Other patterns match exactly, or by prefix whe=
n they
>> > +  end in ``*``. A program is allowed by the path it resolves to, and =
refused
>> > +  by a deny on either that path or the name it was started with.
>> > +
>> > +  Each kind is matched against a target string:
>> > +
>> > +  * ``exec``, ``file``, ``descriptor``, ``procfs``: a path. A rename,=
 link or
>> > +    other path operation is checked as its parent directory plus its =
name.
>>
>> It's unclear to me why procfs is not covered with "file", since you
>> are already doing path-based matching.  What operations are restricted
>> by "descriptor" is also unclear to me.
>>
>> > +  * ``execmem``: the path of the mapped file, or ``anonymous``.
>> > +  * ``net``: the destination address and port, as in ``192.0.2.1:443`=
`, or
>> > +    ``family:N`` for an address family other than IPv4 and IPv6. A co=
nnect
>> > +    with ``AF_UNSPEC`` is not checked; ``AF_UNIX`` is checked as ``ip=
c``.
>> > +  * ``cred``: ``uid=3DU,euid=3DU,suid=3DU,fsuid=3DU``, ``gid=3DG,egid=
=3DG,sgid=3DG,fsgid=3DG``,
>> > +    ``groups`` or ``capset``.
>> > +  * ``ipc``: ``unix:stream_connect``, ``unix:may_send`` or ``sysv:fla=
g=3DN``.
>>
>> FWIW since pathname Unix Domain Socket are also addressed by path, we
>> found it useful to express the rules about them with paths as well, in
>> Landlock.
>>
>> In networking and IPC, I am a bit missing how that would work when
>> *offering* a service (listen(), bind()).  Do you have thoughts on
>> that?
>>
>> What is `sysv:flag=3DN`?  You might be interested in the discussion we
>> had at [1] -- I found System V IPC tricky to restrict, because many of
>> its integer identifiers are not FD-like handles, but just live fully
>> accessible to the entire IPC namespace.
>>
>> [1] https://lore.kernel.org/all/20260727230833.138165-1-utilityemal77@gm=
ail.com/
>>
>> > +  * ``namespace``: ``TYPE:OPERATION`` for clone, unshare and setns, w=
here
>> > +    TYPE is ``mount``, ``pid``, ``net``, ``user``, ``uts``, ``ipc``,
>> > +    ``cgroup`` or ``time``; ``user`` for creating a user namespace; a=
nd
>> > +    ``mount:mount:FSTYPE:PATH``, ``mount:umount:PATH``,
>> > +    ``mount:pivotroot:OLD:NEW`` and ``mount:move:FROM:TO`` for mounts=
.
>> > +  * ``ptrace``: ``same-igroup``, ``igroup=3DNAME`` or ``unconfined``,=
 for the
>> > +    other task.
>> > +  * ``bpf``: ``cmd=3DN``, with ``map_type=3DN`` or ``prog_type=3DN`` =
when creating
>> > +    a map or loading a program.
>> > +  * ``io_uring``: ``override_creds``, ``sqpoll`` or ``uring_cmd``.
>>
>> Can it be turned off as well?
>>
>>
>> > +``epoch``
>> > +  Monotonic authority generation. Installing a higher epoch fails eve=
ry task
>> > +  still bound to an older one closed from its next check.
>> > +
>> > +``lineage root``
>> > +  Opaque identifier supplied by userspace that ties the installed aut=
hority to
>> > +  a committed execution lineage.
>> > +
>> > +The kernel does not parse planning or policy languages. A privileged =
userspace
>> > +runtime validates those artifacts and installs kernel-ready state. Ta=
sks that
>> > +are bound to no igroup are not checked, except for the exec check tha=
t
>> > +``kap.default`` enables.
>> > +
>> > +Control plane
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > +
>> > +KAP state lives under ``/sys/kernel/security/kap``::
>> > +
>> > +  /sys/kernel/security/kap/
>> > +    kap.default
>> > +    igroups/            created with mkdir, as cgroups are
>> > +      <igroup>/
>> > +        kap.install
>> > +        kap.procs
>> > +        kap.lineage_root
>> > +        kap.authority_epoch
>> > +        kap.authority
>> > +        kap.expires_at
>> > +        kap.transition
>> > +        kap.mode
>> > +        kap.events
>> > +        kap.igfd
>> > +
>> > +``kap.default``
>> > +  ``open`` (the default) or ``closed``. When closed, a task outside t=
he initial
>> > +  PID namespace that is bound to no igroup cannot start a program, so=
 a bind
>> > +  that failed cannot leave a workload running without authority.
>> > +
>> > +``kap.install``
>> > +  Write the lineage root, epoch, optional expiry and transition, and =
the
>> > +  authority as one ``key=3Dvalue`` document in a single write. They c=
ommit
>> > +  together or not at all.
>> > +
>> > +``kap.procs``
>> > +  Write a pid to bind that process, with all of its threads, to the i=
group.
>> > +  Reads return the pids written.
>> > +
>> > +``kap.lineage_root``, ``kap.authority``
>> > +  Read or write the lineage root or the authority document. A write t=
o
>> > +  ``kap.authority`` is compiled before it replaces the current author=
ity; a
>> > +  document that does not compile leaves it unchanged.
>> > +
>> > +``kap.authority_epoch``, ``kap.expires_at``
>> > +  Read or write the epoch, or the expiry in seconds since the Unix ep=
och (0 for
>> > +  none). A lower epoch, or an expiry already in the past, is refused.=
 Writing
>> > +  an epoch, or installing authority, also clears revoked mode.
>> > +
>> > +``kap.transition``
>> > +  Write a transition record whose sequence number is higher than the =
last one.
>> > +  Reads return the last sequence number.
>> > +
>> > +``kap.mode``
>> > +  ``enforce`` or ``revoked``. A revoked igroup refuses every operatio=
n.
>> > +
>> > +``kap.events``
>> > +  Read recent decisions as JSON lines with the fields ``ts_ns``, ``ig=
roup``,
>> > +  ``decision``, ``operation``, ``target``, ``reason``, ``epoch``, ``r=
oot``
>> > +  (the lineage root) and ``pid``.
>> > +
>> > +``kap.igfd``
>> > +  Read the igroup's name, epoch and lineage root on one line. The nam=
e is
>> > +  reserved for future igroup file descriptors.
>> > +
>> > +Design decisions
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > +
>> > +Where the control plane lives
>> > +-----------------------------
>> > +
>> > +Igroups are created and destroyed by userspace, so the control plane =
needs
>> > +directories that userspace can create. securityfs does not allow user=
space
>> > +mkdir.
>> > +
>> > +Considered:
>> > +
>> > +* A dedicated filesystem mounted at ``/sys/fs/kap``, the prototype's =
first
>> > +  interface. It works, but puts security state outside securityfs, wh=
ere the
>> > +  other LSMs keep theirs.
>> > +* securityfs with control files, for example writing a name to a ``cr=
eate`` file
>> > +  to make an igroup. This keeps everything in securityfs but replaces=
 mkdir and
>> > +  rmdir with a private protocol that every tool has to learn.
>> > +
>> > +Chosen: a small internal filesystem that the kernel mounts itself and=
 links
>> > +under securityfs, the approach AppArmor uses for policy namespaces
>> > +(``apparmorfs``, linked as ``/sys/kernel/security/apparmor/policy``).=
 Users only
>> > +see paths under securityfs, and an igroup is created with mkdir, the =
way a
>> > +cgroup is.
>>
>> You are creating policies through the file system, but you are at the
>> same time restricting access to the file system with these policies.
>> How does that work?
>>
>> > +Igroups rather than a cgroup controller
>> > +---------------------------------------
>> > +
>> > +Considered: making KAP a cgroup controller, since igroups are created=
 like
>> > +cgroups and follow the process tree.
>> > +
>> > +Chosen: a separate hierarchy. A container usually places all of its t=
asks in
>> > +one cgroup, while several objectives can run inside it, each needing =
its own
>> > +authority. Tying authority to resource partitioning would prevent tha=
t, and
>> > +authority must also follow setns, which cgroup membership does not.
>> > +
>> > +A static LSM rather than BPF LSM programs
>> > +-----------------------------------------
>> > +
>> > +Considered: implementing the checks as BPF LSM programs.
>> > +
>> > +Chosen: a built-in LSM. Igroup membership, epochs and inheritance acr=
oss fork,
>> > +exec and setns are kernel object state with fixed semantics that revi=
ewers can
>> > +audit in one place. BPF LSM also needs ``CONFIG_BPF_LSM`` and BTF, wh=
ich many
>> > +minimal kernels do not enable.
>>
>> I find both arguments unconvincing.  If it's a BPF program, you can
>> also audit it in one place - in the BPF program.  And the lobbying to
>> get CONFIG_BPF_LSM enabled in these kernels is probably not
>> substantially different than the lobbying to get CONFIG_KAP_LSM
>> enabled.
>>
>> > +
>> > +Policy stays in userspace
>> > +-------------------------
>> > +
>> > +Considered: parsing a policy language in the kernel.
>> > +
>> > +Chosen: the kernel accepts only a compiled predicate snapshot. Planni=
ng,
>> > +policy validation and signature checks stay in privileged userspace, =
and the
>> > +snapshot is compiled into per-kind pattern sets once at install time.
>>
>> I'm surprised that it's privileged, since existing AI agent software
>> tends to run unprivileged.  Who would be operating this and defining
>> the policies?  From your description I would have expected that the
>> "objectives" that inform the policies are roughly equivalent to the
>> goals that you give to the model in an agent prompt?  Does the agent
>> software communicate with a privileged agent?  Or does the agent
>> software spawn off namespaces to attain the necessary privileges?
>>
>> More of a terminology remark, but when you consider the kernel layer
>> only, it feels like the compiled predicate snapshot *is* the policy
>> that you are enforcing?
>>
>>
>> > +Questions for maintainers
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> > +
>> > +1. Is an internal filesystem linked under securityfs, as AppArmor doe=
s,
>> > +   acceptable for a control plane that needs userspace mkdir?
>> > +2. Should igroup removal follow cgroups, with rmdir allowed once no t=
ask is
>> > +   bound?
>> > +3. Is a separate igroup hierarchy the right call, or should this be a=
 cgroup
>> > +   controller despite the cases above?
>> > +4. The predicate format is a JSON document and experimental. Is a bin=
ary
>> > +   format preferred, or reuse of an existing ruleset format such as
>> > +   Landlock's?
>>
>> I don't understand why the JSON format is a question for the kernel
>> review; you can do the interface in a format that is suitable for the
>> kernel, and translate from JSON into that format in userspace, not
>> mixing the layering between that userspace component and kernel space.
>>
>>
>> > +5. unshare and setns have no LSM hook, so the series calls KAP from t=
hem
>> > +   directly. Would a hook for namespace transitions be acceptable, or=
 is there
>> > +   an existing one that should be used instead?
>>
>> I believe we added such hooks for the Landlock namespace and
>> capability support.
>>
>>
>> > +6. The LSM ID is provisional and should be confirmed.
>> > +
>> > +RFC status
>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > +
>> > +This interface is experimental. The RFC is intended to make the autho=
rity and
>> > +lineage model reviewable, not to freeze the userspace ABI.
>>
>> I have to admit, I've read the doc, but still don't understand how
>> that model is supposed to work.  Do you maybe have a concrete
>> motivational example which defines such a policy and demonstrates why
>> that is different and can not implemented with one of the other LSMs
>> or the BPF-LSM instead?
>>
>> =E2=80=93G=C3=BCnther
