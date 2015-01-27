From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix suspend/resume paths for TPM 2.0
Date: Tue, 27 Jan 2015 19:23:37 +0200
Message-ID: <1422379417.2912.4.camel@linux.intel.com>
References: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
	 <1422377842.2912.1.camel@linux.intel.com>
	 <20150127170308.GA10140@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150127170308.GA10140-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>, peterhuewe-Mmb7MZpHnFY@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-01-27 at 10:03 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 27, 2015 at 06:57:22PM +0200, Jarkko Sakkinen wrote:
> > > > +	/* TPM 1.2 requires self-test on resume. */
> > > > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > > > +		ret = tpm_do_selftest(chip);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > 
> > > Just to note, the return value from tpm_do_selftest() on TPM 1.2 chips was 
> > > previously ignored. Mine does return 0.
> > 
> > Right. I can update the patch to ignore return value if the majority
> > wants that.
> 
> What happens to the system when pnp_driver.resume() returns failure?
> 
> Should tpm ever report failure on resume to the rest of the kernel?
> 
> Shouldn't this stuff be in tpm_pm_resume common code anyhow?

I think it should but not in the scope of this bug fix IMHO.

> Jason

/Jarkko
