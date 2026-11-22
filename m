Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795375475;
	b=NLAY2Vq3mid44TJ5iuT/tU+4susG22vr/wR+429DnAv3Eeq3NifNlSfETFScE9PYBj/H
	 rqt6lrF2o0pXmY9IMDnBF9Y+rIHK0nmqz6c3NQIyMkmpFlZALGRqmSJ7VDoVPfckJxtwl
	 brNNcxP9TIteoot3RIjWpauLZAh/iMPXaBcWIZ84d5ErnoMAPde31wPsQV8z2UGr9P0G3
	 qgAX3KrE7ORfKekeKM8Iicl3d7Y5iFMl2PaHjPqv21mH+K7KDLHQKTlNF6DRmYUnfkemP
	 uNFSJ8kIX88IDDZddRmNp5Vubb9kY/U2Rw60B2Wj0HDQtLl5a5vUKA77cOTEO/rFCiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795375475;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CHVKomnHyMaBE4qRz2ed+npw+rJDBubPaLp8NV9yPnI=;
	b=XS5XSMpsMGtho6ifV4IhGoru521BmjmDS2khvWRLZ9WTxkA3G3gmgvq8MSMeuzdtyOmv
	 ONAzAnJZuGdzgnX05o7KMkCqQ85fM91C+LilXqZ/M5BDikd3x6ApCS5jsTytxRQzL/t0q
	 TmxyIuBi2Il8FF+loUJbKCdnVA64ZSa6bcYL5tidI7XxA5/PUNl7M3Buqd2Gt1iKXa4kI
	 9at9xNO1Uz3+AWXZpI+ITa/as2/hfHa6OdDKkA856JsqVkvBzUhOEYGo+MFhalG9mDwKB
	 Wanz7bKxKKo/g0ql7e8yiShkJMV4jfFfLgNHZIeDK796aAWwpxp6GA5Jyq3ZciiBQ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPH12Rmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF679606A31A;
	Sun, 22 Nov 2026 19:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPH12Rmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBFB1F000C4;
	Sun, 22 Nov 2026 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795375474;
	bh=CHVKomnHyMaBE4qRz2ed+npw+rJDBubPaLp8NV9yPnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LPH12Rmmk43u6G72a1xsTOyFqx4FmQo/J1sXM6p1VUt0+QwzsvOmf3/URw0RwATFU
	 s3dF+dISsoR/pT9ianFbvC9OkQvpt5sn/JplpcMPhz5PTwupctkjs0GYeYyvsMFLkn
	 Zvqm5UfZ+aEYJPD+sZTHqySThVTUdXzchRCsgAlxGykPzhmhWMRYvNwXRa0pGLXHRt
	 H8+e61mFmXvo12u011y8P+uK1IKBpODWJIOImjp1CTKgiJnm2sm0/BooO5ko1BUhNW
	 EeKKNrKvzWaWhIpiSCCzJLcoeh8hD/iUQeIvCM2M60IHiEnPikXHYP+wYAVv7OJBYd
	 qs7YqnWQIKXZg==
Date: Sun, 22 Nov 2026 19:24:29 +0000
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Jithu Joseph <jithu.joseph@oss.qualcomm.com>
Cc: Ahmed Azeem <ahmed.azeem@arm.com>, linux-arm-kernel@lists.infradead.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Divin Raj <divin.raj@arm.com>,
	Bertrand Marquis <Bertrand.Marquis@arm.com>,
	Ashok Raj <ashok.raj@oss.qualcomm.com>, punita@qti.qualcomm.com,
	jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH RFC 0/4] firmware: arm: Add Platform Fault Detection
 Interface support
Message-ID: <20261122-thundering-effective-chimera-bebbc7@sudeepholla>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
 <13d32bf7-7f74-4dc5-a875-671167149df9@oss.qualcomm.com>
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
In-Reply-To: <13d32bf7-7f74-4dc5-a875-671167149df9@oss.qualcomm.com>

On Fri, Nov 20, 2026 at 04:44:15PM -0800, Jithu Joseph wrote:
> On 11/19/2026 7:36 AM, Ahmed Azeem wrote:
> > Hi all,
> > 
> > This series proposes an arm64 driver for the Arm Platform Fault
> > Detection
> > Interface (PFDI), providing a common Linux interface for privileged
> > userspace to discover and invoke firmware diagnostics.
> > 
> > We are posting this series as an RFC to seek community feedback on both
> > the proposed Linux interface and the underlying firmware specification
> > before the specification is finalized. This series and its validation
> > use
> > the PFDI 1.0 ALP0 specification [1]. The current public revision is PFDI
> > 1.0 BET0 [2]. Feedback on the software integration will help identify
> > any
> > changes needed to align an upstream implementation with the evolving
> > specification.
> >
>  
> ...
> 
> > 
> > I would appreciate feedback on the specification's suitability for Linux
> > integration, the proposed per-CPU ioctl ABI, the worker and hotplug
> > model,
> > and whether this belongs under drivers/firmware. In particular, is this
> > the right scope for a common PFDI interface, and should error injection
> > be exposed separately from normal diagnostic operations?
> > 
> 
> Thanks for the RFC
> 
> I haven't read through the specs or code in great detail, but I thought I
> would send in my initial thoughts.
> 
> Most of it comes from my experience developing/up-streaming a similar
> feature in my prior job at Intel called In Field Scan [1] / [2].
> 

Good to know, you feedback will be much appreciated.

> I think creating per-cpu threads just for this feature might be an overkill
> on a system with large core-counts. I think an alternate approach like below
> might work for this.

Agreed.

> 
> 1. Drop the per-CPU kthreads and the cpuhp state; run each request on the
> target CPU when it arrives ... something like cpus_read_lock();
> if (!cpu_online(cpu)
>         ret = -ENODEV;
> else
>         ret = work_on_cpu(cpu, pfdi_op_fn, &req);   /* or smp_call_on_cpu() */
>  cpus_read_unlock();
>

Yes much simpler.

> (IFS used an alternate cpu stopper mechanism as it had the additional
> responsibility of synchronizing sibling threads and related timing etc ...
> it might not be needed here )
>

Ah ok, thanks for the info.

-- 
Regards,
Sudeep
