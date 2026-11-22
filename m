Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795375014;
	b=j2D8SLSRHB+ykrGNPwwdxyYP6z97JYAy4WlCEokilaaZJaLmJ0bD4y+Ij+ao5yRAajAH
	 BbculGZopVD8bdhkprnCInroot4o4PxprvQnNiLArBZkgu3j+tq2A3P494KKg3mhi0MOC
	 Qh+vYWxm6P9gCcx8sEOh8Ux1dh0kK/Fuu01HbxuOr7NR2aeCNbUIuJjOGJcF0A/d3xU0G
	 KVA5O+pCEO8yXpL6TFavIZkAXd6STHeA/YdbwU2pG3/5m7aQqVU6hqq8P5iUJRwUZvr8z
	 FdornpWbN/ixlx859nDxqmJEFTfkukOt0LJMz6urpvcAs3x9GcG44ogW+q9cT2HVwFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795375014;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=uSoTt+TxpepghCj1j5m2W66DMLP6FbjOrMJ/a3Zmg+E=;
	b=zfc3HRYV6e7MKppkGz88YmVj7wrrJtcreyy5BUqayKnhyHpGFoYQCdMB8FTX8adebpms
	 TAwe0jHE292dtQ8psx0k8X6gjNRegbum3NmL98TkTo7qO6AdLtoeYZSw+wMQslHgzbnmz
	 TZz1NmdB+YgnEzYWEBtARADC/AQMCTeW21WQ6k+BD2KuPSiAoKf2BtnmLS/RQJyGnqu1B
	 Z83uTvdlkN66O9O6rGZBUEOf8x6uOONwI0q00ekT2DlYFcBLOzQa8cVlkIMAV4lJB5zxP
	 uPayG5mgT2b478uOfW6m9UiBzUBz5qkCTfETWHi5PvA1eKYPRYU0ZEGIvjtk8zJkmKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFeQzdky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DAB606A31D;
	Sun, 22 Nov 2026 19:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFeQzdky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7DB1F000C6;
	Sun, 22 Nov 2026 19:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795375014;
	bh=uSoTt+TxpepghCj1j5m2W66DMLP6FbjOrMJ/a3Zmg+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gFeQzdkyIDBbad15Fyeby3tqqxBufjvttYjpWQGh7H4AL9MU1Eo+zuoDPuD5L43WC
	 7HrKta1V831kK1+REbSUvGZxVxnoMFleoij6NrH25cJvoRvein+aChotT/UP0rZHDe
	 UbN+44Z+NlhLDbeSaD3f/EYB6DEu2TQ8IZAhMCLfItx+sz17xkh3Rak5L0PdoT0lRQ
	 xjgE66AWNs5+2mkldFMWuEGjJTkI/uDNr8ss0WbNvyLciXUOu+ZjgQ52jYL0MxVlnx
	 Pa7BdUjzHeNdoa6O1rYfVF8vL+hwBCMAThWYKgQp9+IP8OLwMRWIwYaNm94rEiR+eY
	 p5QYdUeqgSyZA==
Date: Sun, 22 Nov 2026 19:16:50 +0000
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Ahmed Azeem <ahmed.azeem@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Divin Raj <divin.raj@arm.com>,
	Bertrand Marquis <Bertrand.Marquis@arm.com>
Subject: Re: [PATCH RFC 0/4] firmware: arm: Add Platform Fault Detection
 Interface support
Message-ID: <20261122-memorable-electric-sawfish-ac9f11@sudeepholla>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>

On Thu, Nov 19, 2026 at 03:36:02PM +0000, Ahmed Azeem wrote:
> Hi all,
> 
> This series proposes an arm64 driver for the Arm Platform Fault
> Detection
> Interface (PFDI), providing a common Linux interface for privileged
> userspace to discover and invoke firmware diagnostics.
>

I reviewed the PFDI (Platform Fault Detection Interface) specification
and found some issues that needs to be addressed. In general, this spec
is not on par with other Arm SMCCC based firmware interface specifications.
Many of these issues should have been identified as part of reviews before
the beta release and should also been raised by the team that prototyped
or wrote this driver. I threw my review comments at AI and got them
refactored as below. Hope it helps.

1. State Preservation & Calling Conventions
 - Make state preservation a conformance rule:
   Move the expectation that firmware saves and restores modified state
   from descriptive usage text ($4.6.1) into a formal requirement ($4.6.3)
   and cover it in compliance tests ($5.6).
 - In general the specification has mixed the terms platform and PE a lot.
   It needs to define "system state" and failure behavior:
   Specify exact architectural state (e.g., registers, SIMD/FP, SVE, SME)
   covered by restoration, how it interacts/matches with SMCCC and PSCI
   powerdown rules, and what happens when a test fails, encounters an
   internal error, or triggers a system-level fault reaction.
 - Clarify calling conventions: Use "SMC/HVC" where both conduits apply
   ($3.2), and explicitly mandate preserving x5–x17 within PFDI rather than
   relying on unpinned SMCCC baseline versions. In one section HVC is allowed
   while $3.2 just mentions SMC.

2. Virtualisation, Isolation & PE Scope

- Tighten error-injection isolation:
  Because PFDI_FORCE_ERROR leaves an error pending on a PE regardless
  of software context, require hypervisors to prevent cross-VM or
  cross-OS consumption during context switches or vCPU migration.
  I don't fully understand that interface TBH.
- Clarify guest PE identity: Reconcile the requirement for hypervisors
  to forward an "originating PE ID" unmodified with the fact that PFDI
  functions accept no PE ID parameter or clarify the requirement clearly.
- Define PE vs. system scope per function: Clarify whether "PE" means
  the executing CPU or a tested non-CPU resource, explain how drivers
  target remote CPUs without a target-PE argument(assuming it needs to
  run on that PE, and specify whether PFDI_FW_CHECK is PE-local or
  platform-wide. In general, the term platform and PE are mixed in the
  document which makes it hard to understand where the rules apply.

3. Function IDs, Execution Timing & Indexing

- Correct SMCCC Function ID classification: Reclassify 0xC400_02D0 –
  0xC400_02D7 from "vendor-defined" to the Standard Secure Service range
  and confirm the assigned subrange. It was very confusing to read the
  reference to vendor defined range.
- Bound CPU occupancy time: Because PFDI uses synchronous SMCCC Fast
  Calls without a timeout, cancellation mechanism, or runtime duration
  query, define a maximum execution duration, permitted call contexts,
  or a yielding/asynchronous mechanism so OS drivers (like Linux) can
  be aware of CPU time doing this test.
 - Resolve test-part indexing and zero-count conflicts: Fix the off-by-one
   discrepancy (0..test_count vs. test_count - 1), correct the
   PFDI_PE_TEST_RESULT faulting index format (= 0 vs. general index),
   and define behavior when test_count is zero (PFDI_RET_TEST_COUNT_ZERO
   is currently unused).

4. Error Injection Semantics, Compliance & Editorial Fixes

- Align reset rules and restrict injected values: Add an explicit exception
  allowing resets or firmware updates to clear pending injected errors
  ($3.5 vs. $4.9), and restrict PFDI_FORCE_ERROR (x2) from accepting
  zero or positive values alongside defining deployment/authorization
  policies.
- Resolve optionality contradictions: Clarify whether individual PEs
  can implement a subset of PFDI functions ($3.4) or must implement
  all mandatory functions ($5.1).
- Missing"Security and Safety Considerations" chapter referenced in $1.5

> We are posting this series as an RFC to seek community feedback on both
> the proposed Linux interface and the underlying firmware specification
> before the specification is finalized. This series and its validation
> use

Specification needs more work IMO, so please get them addressed first.

-- 
Regards,
Sudeep
