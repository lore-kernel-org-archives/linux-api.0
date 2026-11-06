Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793986044;
	b=LPV1KLrU0mlW9dc07XKh2Z0oSf3w92ewKpgNVhD+UdHRpKcUb+8lZ7yIKyxx0d41SQA7
	 aJnNEmuH9PheT/XYUgCUDqr4jKJ67i4E3GjK9cWVxMFVD5/noSfiXSc4ziJj9LZ3NlIsy
	 xu7OBvbBBLfzXI1Xw0n35EV3GSsPYADoJOX3V1I5ZP1KTjr+B3S3NHrUM2Ci3dIfHH9zK
	 NpnkkHpxGyJ9HAcwmNfXNxPmjatwd2o3MKqkfWy+NwIFDOyD6pO+OImk0luyzPB2YnTDe
	 3bmLLcUdqXWrW6DkuM9OoyL/1+xKmgYjakPyKFNxMRJwYnNwekA6mfwqZqbsOVv98yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986044;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=D1OP9qC177zA3aBfRfenxMIit8o8G0GoKrdtUwc1iHk=;
	b=bpOZBhU156WAqegPnFjqvuEX6/toD0tjGtmtAxMTRvJidjPph6+u4P212gDZ8ahEhjk+
	 tggqjoEvp5BYnEnx6P4ErG/jwxc4WSdt11C+YflPRCVT5Dg6qGJTbrVvn5Fhly3Gh25gw
	 wfbrO13Y4sfefQPxqVcsxCHD0qHn5mwASk549MoHUjt28WVk6zth3rQgNcz+SZG8Ztj/h
	 Kfy5y4QWlftbkprc4pOGoOWRgjOYZahBXcTnVDqoJVsKKHr/gMvMuSSN1nJzbQmGydPFR
	 d3hXNPr2AOyiKRY3FxzalunDyWv8kZotGyJ2PXC3xaZZLPe0/EaNwz9FL+XIDL/brNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ob6o03Xe;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8853B606A329;
	Fri,  6 Nov 2026 17:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8853B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ob6o03Xe
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBB311477;
	Fri,  6 Nov 2026 09:27:19 -0800 (PST)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 282A43F632;
	Fri,  6 Nov 2026 09:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793986042; bh=6bzuAkIaDZvpb/WEZZmaV1YDCZ13Mh9rHG1iq3jJ37w=;
	h=Date:From:To:Cc:Subject:From;
	b=Ob6o03Xec1fUWggLPZ/Zu5jDYGGVgmIPtWdBk1KGltVeDja5el7//AVqGpMJtWish
	 l7EuGPFP34NXFapK/r591dA5Uok+vifaW/hB3jYQZ50pImwfLBqcssjSMwuk9B3+6Z
	 5gEQm0qrcKFXYkCxACwhnpuLvakHukn0Klu44rvQ=
Date: Fri, 6 Nov 2026 22:57:19 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: [RFC] ARM64 ESR ownership issue for signal delivery
Message-ID: <fp2tsl5lkj4rzvwfkkgogeka7uhd2bwkci37zvikjjtg7wkckd@qc2lyhdpdocx>
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

Hi,

I am sharing some details on the ARM64 ESR ownership issue during
signal delivery, along with a few possible solutions.
I would appriciate feedback on the scenarios and proposed approaches.

Introduction to ESR
~~~~~~~~~~~~~~~~~~~

ESR refers to an AArch64 system register, Exception syndrome register
which holds the information about why an exception occurred.

For relevant hardware faults, Linux exposes this value to user space, by
including ESR context in the signal frame. This was originally introduced [1]
for user space instruction emulators to identify whether a fault is read/write
and its access size without decoding the instruction itself.

Problem statement
~~~~~~~~~~~~~~~~~

ARM64 uses a task level field, current->thread.fault_code to retain the
ESR state captured during faults. This is later used to generate the ESR
context during signal frame generation. Essentially the ESR state stored
in fault_code has no ownership relation with the signals queued.

From Linux arm64 point of view, there are two categories,
* Signals with relevant ESR context - triggered by hardware faults only
* Signals without ESR context - triggered by hardware faults and software as well.

Because fault_code has no signal ownership, an ESR captured for one signal can be
included in the frame of an unrelated signal.

Some possible error scenarios are given below that show the ESR ownership issue.

Assumption:
1. Signals described as being delivered to user space are assumed to have handlers
installed that allow the task to continue.
2. Cases 2 and 3 assume that the task is traced by ptrace

Case 1: Hardware fault followed by an unrelated asynchronous signal

* An EL0 exception generates and delivers a fault signal with ESR A.
* current->thread.fault_code remains set after the signal is delivered.
* A subsequent asynchronous SIGUSR1 is delivered
* Since ESR context is added to signal frame based on non zero fault_code,
  a stale ESR context can get attached to this non fault signal.

Case 2: Two EL0 faults, each with distinct ESR values

* An EL0 store to a read-only page triggers hardware fault with ESR A
  and SIGSEGV gets queued.
* At the SIGSEGV ptrace stop, ptrace tracer
  - masks SIGSEGV
  - queues SIGUSR1 to the tracee
  - continues the tracee task with SIGSEGV and hence SIGSEGV gets requeued.
    ie. PTRACE_CONT(..., SIGSEGV)
  So essentially SIGSEGV gets deferred and SIGUSR1 gets processed first.
* Task continues with SIGUSR1 user space handler which in turn triggers another
  hardware fault with ESR B resulting in a SIGBUS. This overwrites ESR A in
  the task level storage.
* When the initially deferred SIGSEGV is later delivered,
  its ESR context is generated from ESR B instead of ESR A.

Case 3: One EL0 fault with valid ESR + software-originated fault signal without ESR

* A task masks SIGBUS signal and then self-queues the same SIGBUS/BUS_ADRERR signal
  This is software generated but uses the same encoding (signo, si_code)
  of hardware fault signal.
* The task then encounters a hardware fault with ESR A and SIGSEGV
  gets queued.
* At the SIGSEGV ptrace stop, ptrace tracer
  - masks SIGSEGV,
  - unmasks SIGBUS,
  - continues the tracee with SIGSEGV and hence SIGSEGV gets requeued
* Task continues with SIGBUS handling and the signal can get wrongly framed with ESR A.

Open questions
~~~~~~~~~~~~~~

Are there any known users for ESR context in arm64 signal frames currently?
If not, should we really continue exposing ESR context through signal frames ?

Possible solutions
~~~~~~~~~~~~~~~~~~

If we wish to expose ESR context in signal frames, below are few options.

Option 1: Task-level ESR with filtering (no changes to generic kernel)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Category A: Non-synchronous signals
Prevent signals such as SIGUSR1 from receiving an ESR context.
Fix: Allow ESR framing only for sigmask(ksig->sig) & SYNCHRONOUS_MASK

Category B: Synchronous signal codes that cannot carry ESR
Exclude codes such as TRAP_PERF, BUS_MCEERR_AO, and SEGV_MTEAERR.
Fix: Allow ESR framing only for ARM64 ESR-capable (signo, si_code) pair.

Category C: ESR-capable pairs without a captured ESR
Some software-generated signals use the same ESR-capable (signo, si_code)
pair as hardware exceptions.
Fix: Add current->thread.esr_valid, set only by ESR-capturing exception paths
and cleared after consumption or invalidation.

Required assumption: Multiple ESR-less ESR-capable(Cat C) signals may be outstanding
while esr_valid is clear. While esr_valid is set, the signal owning the ESR must
be the only outstanding ESR-capable signal until its ESR is framed or invalidated.

Atleast cases 2 and 3 violate this assumption.

Option 2: Per-signal ESR ownership flag
+++++++++++++++++++++++++++++++++++++++

Add a per signal ESR ownership flag, potentially using unused bits in the fields of
_sigfault (part of struct kernel_siginfo) to mark which queued signal owns
current->thread.fault_code.

By default, the field should stay cleared.

  - Set thread.esr_valid when an exception captures ESR.
  - Set the signal’s ESR_VALID flag when queueing it.
  - Generate an ESR context only when both are set.
  - Clear thread.esr_valid after the owning signal has framed the ESR,
     or when the owning signal is discarded
  - Detect an ownership conflict if ESR is captured while thread.esr_valid
    is already set.
  - Detect stale ownership if a flagged signal is dequeued while thread.esr_valid
     is clear.

This approach resolves ambiguity between any number of ESR-less Category C signals
and one ESR-owning signal. It detects, but does not solve, the case where multiple
ESR-owning signals coexist.

This may be involve fewer changes than Option 3, but then this option needs further
validiation of layout compatibility and sanitization of siginfo passed from/to userspace.
Also implications of reusing siginfo storage for kernel internal metada need to be
looked further.

Option 3: Add per-signal arch context
+++++++++++++++++++++++++++++++++++++

Probably a cleaner but more invasive solution is to add arch context
(ESR value and valid bit) to each struct sigqueue (ie. outside struct kernel_siginfo)
and propagate it into struct ksignal.
Context aware APIs can be used to specify ESR value and its validity while existing
APIs would leave the context invalid.

This option could open a way for ptrace to get the precise ESR value and that can be really
benefecial for POE2 use case.

[1] https://github.com/torvalds/linux/commit/15af1942dd61ee236a48b3de14d6f31c0b9e8116

Thanks,
Linu Cherian.
