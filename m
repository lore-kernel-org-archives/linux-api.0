From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix suspend/resume paths for TPM 2.0
Date: Tue, 27 Jan 2015 18:57:22 +0200
Message-ID: <1422377842.2912.1.camel@linux.intel.com>
References: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1501271620520.1725-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: peterhuewe-Mmb7MZpHnFY@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-01-27 at 16:52 +0000, Scot Doyle wrote:
> On Tue, 27 Jan 2015, Jarkko Sakkinen wrote:
> > Fixed suspend/resume paths for TPM 2.0 and consolidated all the
> > associated code to the tpm_pm_suspend() and tpm_pm_resume()
> > functions. Resume path should be handled by the firmware, i.e.
> > Startup(CLEAR) for hibernate and Startup(STATE) for suspend.
> >=20
> > There might be some non-PC embedded devices in the future where
> > Startup() is not the handled by the FW but fixing the code for
> > those IMHO should be postponed until there is hardware available
> > to test the fixes although extra Startup in the driver code is
> > essentially a NOP.
> >=20
> > Reported-by: Peter H=C3=BCwe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
>=20
> ...
>=20
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -865,25 +865,23 @@ static void tpm_tis_reenable_interrupts(struc=
t tpm_chip *chip)
> >  static int tpm_tis_resume(struct device *dev)
> >  {
>=20
> ...
>=20
> > +	/* TPM 1.2 requires self-test on resume. */
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > +		ret =3D tpm_do_selftest(chip);
> > +		if (ret < 0)
> > +			return ret;
>=20
> Just to note, the return value from tpm_do_selftest() on TPM 1.2 chip=
s was=20
> previously ignored. Mine does return 0.

Right. I can update the patch to ignore return value if the majority
wants that.

/Jarkko
