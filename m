Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795375276;
	b=skOjDDJV0R0I+3OSrraMzuhqpl1PKf3tonTV8kABvRaXW9iaqOrYwDiQb6gfSgHpSHWx
	 no4jCWjAJOIzwyaLFSsNMmpeNC986VIdvakSVduMs5fUozKZTsieOuGZmJXYH6dQr7PhF
	 Wv5ZrONplC/AU7m3ei3rsYdHhAYvNgpgRC4heumkmcYMjC8gJCkSCZODV3ddxnofzxqCj
	 WX6dJSuMl7rzkKQxb7y0SmfrrQsS34AVr/6Q1E/2TZ4kglubMBKGAGxkjDbLh2vyxZRcq
	 1O7F4582mHnOWv5/yZ9DqVcj9Z2pRH3U45MvBBmGK2SJs+M065dIj8DUq7HdUCDlZVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795375276;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QYZJqeQ4pRcd9d2661rjTa1putVbAUbEZa/xFm9oZWE=;
	b=r9n02wMCDJ/gCIf7z5JmZFOSf28sHR4+HBKc0i40X1DxTGPEvG18zkSx0qYATBkIfI79
	 F6AcOyNop0CfDxVX778xCiPAI27D4IVknLOk9JlZdfwmhbENjdcCKTGxfy8GZdSivZyof
	 O2fRjfcwxjFakibHJsPudXtsVWNpjkAvPwBwKYEUEI2AeM966IylclM2Cnsg9bKcSUM+9
	 6IPuMVzZPRt3jsgt2dLcjK7J5FlS4Dqfg29kqbP7FFBLkTf2lwPDtacJ9x8awatxEJlaq
	 quTolSozjA2wOcwblGYWjF6w2bscC6I3BdMKA1jZ2oIjigZIBkTn1LTRm1MqJm8S0Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fivc88eL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860B606A320;
	Sun, 22 Nov 2026 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fivc88eL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B341F000CF;
	Sun, 22 Nov 2026 19:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795375276;
	bh=QYZJqeQ4pRcd9d2661rjTa1putVbAUbEZa/xFm9oZWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fivc88eLwbw0tj1SJWUCkk5xS1NvOM27bVfcC0xxeiY3pVwmymqUyWMyhBhfMhfzY
	 SUoq4IRnGzg2RGN4EeNQuTehtTnr+a+2FgqhkXG4mGqxeJE9nCxrVBZ3QmpMS2+mH0
	 oWT2/6ayNL04LSz1AmH/dSsRe/+Vssp+oL/TtF08xaiW1FTdby1BQQxVlhEVd+v6Nq
	 78RhKK/kOst7S3rg3kFMIbiwpkrik4Ubxq13lBOsdw3EhbHbdvyB8HIz3ucal1c2Do
	 WoubxLvB4KjTQrnQ1Ul9dAE3wOamcpfWnnFXtv+mRKtnr0QTnSM/9BRdxaxWa5kaGz
	 oN5MLwQEsLQqA==
Date: Sun, 22 Nov 2026 19:21:11 +0000
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: Ahmed Azeem <ahmed.azeem@arm.com>, linux-arm-kernel@lists.infradead.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Divin Raj <divin.raj@arm.com>,
	Bertrand Marquis <Bertrand.Marquis@arm.com>,
	jithu.joseph@oss.qualcomm.com, Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: Re: [PATCH RFC 1/4] uapi: firmware: arm: Add PFDI userspace ABI
Message-ID: <20261122-camouflaged-arrogant-wren-38bda8@sudeepholla>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
 <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-1-4772d18b9115@arm.com>
 <awEavIhFldTD2k46@hu-ashoraj-lv.qualcomm.com>
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
In-Reply-To: <awEavIhFldTD2k46@hu-ashoraj-lv.qualcomm.com>

On Fri, Nov 20, 2026 at 08:14:52PM -0800, Ashok Raj wrote:
> On Thu, Nov 19, 2026 at 03:36:03PM +0000, Ahmed Azeem wrote:
> > From: Divin Raj <divin.raj@arm.com>
> > 
> > Define the userspace ABI for the Arm Platform Fault Detection
> > Interface (PFDI).
> > 
> > Subsequent commits introduce a driver that exposes a per-CPU misc
> > device. The ioctl definitions, data structures, and return codes
> > must therefore be shared with userspace. Add these definitions to
> > a UAPI header and document the ABI for /dev/cpu/<cpu>/pfdi.
> > 
> > Placing the interface under include/uapi ensures availability via
> > headers_install and clearly identifies it as a userspace contract.
> > 
> > Link: https://developer.arm.com/documentation/110468/1-0alp0
> > 
> > Signed-off-by: Divin Raj <divin.raj@arm.com>
> > Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
> > ---
> >  Documentation/ABI/testing/dev-cpu-pfdi             | 103 +++++++++++++++++++++
> >  Documentation/userspace-api/ioctl/ioctl-number.rst |   1 +
> >  MAINTAINERS                                        |   7 ++
> >  include/uapi/linux/pfdi.h                          |  89 ++++++++++++++++++
> >  4 files changed, 200 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/dev-cpu-pfdi b/Documentation/ABI/testing/dev-cpu-pfdi
> > new file mode 100644
> > index 000000000000..e07ed6baa7f8
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/dev-cpu-pfdi
> > @@ -0,0 +1,103 @@
> > +What:		/dev/cpu/<cpu>/pfdi
> > +Date:		May 2026
> > +KernelVersion:	6.18
> > +Contact:	Linux ARM Kernel Mailing list <linux-arm-kernel@lists.infradead.org>
> > +Reference:	Arm Platform Fault Detection Interface, document 110468,
> > +		version 1.0 ALP0
> > +Description:	Per-CPU Arm Platform Fault Detection Interface (PFDI) misc
> > +		device nodes. Each node targets the CPU encoded in its
> > +		path and exposes the PFDI service implemented by firmware.
> > +		PFDI uses the Arm SMCCC SMC64 calling convention and is
> > +		PE-local. Userspace is therefore expected to bind itself to
> > +		the target CPU before opening or issuing ioctls on the
> > +		matching device node. Each node is single-open: only one
> > +		userspace owner at a time may hold /dev/cpu/<cpu>/pfdi for a
> > +		given CPU. Additional open attempts fail with -EBUSY while the
> > +		device is already open.
> > +
> > +		The ABI is defined in <linux/pfdi.h>. The following ioctls
> > +		are supported:
> > +
> > +		* PFDI_IOCTL_VERSION
> > +		  Read the PFDI version for the target CPU. On success the
> > +		  ioctl returns 0 and copies a 32-bit version value to
> > +		  userspace with the following layout:
> > +		  Bits[30:16] PFDI major version
> > +		  Bits[15:0] PFDI minor version
> > +
> > +		* PFDI_IOCTL_FEATURES
> > +		  Query whether a PFDI function ID is supported on the
> > +		  target CPU. Userspace passes a 32-bit PFDI function ID.
> > +		  The ioctl returns 0 when the function is supported,
> > +		  and -EOPNOTSUPP when it is not supported on the target
> > +		  CPU, reserved by the specification, or otherwise not
> > +		  recognized by firmware.
> > +
> > +		* PFDI_IOCTL_PE_TEST_ID
> > +		  Read the test engine identifier for the target CPU.
> > +		  On success the ioctl returns 0 and copies a 64-bit value to
> > +		  userspace with the following layout:
> > +		  Bits[63:32] reserved and zero
> > +		  Bits[31:24] vendor ID
> > +		  Bits[23:20] reserved and zero
> > +		  Bits[19:16] vendor-defined implementation ID
> > +		  Bits[15:8] major version
> > +		  Bits[7:0] minor version
> > +
> > +		* PFDI_IOCTL_PE_TEST_PART_COUNT
> > +		  Read the number of available test parts for the target
> > +		  CPU. On success the ioctl returns 0 and copies a signed
> > +		  64-bit count to userspace. The smallest schedulable unit is
> > +		  a test part, and valid test part indices are in the range 0
> > +		  to count - 1.
> > +
> > +		* PFDI_IOCTL_PE_TEST_RUN
> > +		  Run a requested inclusive test part range on the target
> > +		  CPU. struct pfdi_test_run.range.start and .end are signed
> > +		  64-bit values.
> > +		  Passing start = -1 and end = -1 requests execution of all
> > +		  available test parts on the target CPU. Any mixed use of
> > +		  -1, reversed ranges, out-of-range indices, or non-zero
> > +		  reserved arguments is rejected with -EINVAL, either by the
> > +		  kernel before the request is issued or by firmware.
> > +		  If firmware reports PFDI_RET_FAULT_FOUND, the ioctl returns
> > +		  -EFAULT and copies a signed 64-bit failing test part
> > +		  identifier to struct pfdi_test_run.ft_id. If the failing
> > +		  part cannot be identified, ft_id is set to
> > +		  PFDI_RET_UNKNOWN.
> 
> Hi Ahmed, Divin,
> 
> + Tony, Boris, Jithu
> 
> A few UAPI/design comments below.
> 
> The range-based PFDI_PE_TEST_RUN operation has a reasonable case for a
> structured interface: it takes an inclusive start/end range and can return a
> failing test-part ID.  Encoding that in a sysfs write would establish a
> permanent text grammar and still require a separate result-retrieval
> mechanism.
> 
> However, it would be useful to explain why all of the interface is exposed
> through per-CPU ioctls.  Intel IFS, for example, uses sysfs for simple
> control and persistent status: run_test, status, details, image_version, and
> current_batch.  That does not necessarily mean PFDI should copy IFS, but a
> hybrid design may be worth considering:
> 

+1, agree that we need not copy from Intel IFS, but we need to understand
why we need not align with similar interface. It may help the userspace
tools to some extent. I am not against IOCTL based or asking to copy sysfs,
we need what made to choose the current interface(background would be
helpful).

-- 
Regards,
Sudeep
