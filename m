From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] tpm: fix suspend/resume paths for TPM 2.0
Date: Mon, 2 Feb 2015 21:20:03 +0200
Message-ID: <20150202192003.GA27457@intel.com>
References: <1422510227-23256-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.11.1501291832460.1678@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501291832460.1678-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Are we good with this?

/Jarkko

On Thu, Jan 29, 2015 at 06:43:12PM +0000, Scot Doyle wrote:
> On Thu, 29 Jan 2015, Jarkko Sakkinen wrote:
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
> > Added Shutdown(CLEAR) to the remove paths of TIS and CRB drivers.
> > Changed tpm2_shutdown() to a void function because there isn't
> > much you can do except print an error message if this fails with
> > a system error.
> >=20
> > Reported-by: Peter H=FCwe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm-interface.c |  6 ++++--
> >  drivers/char/tpm/tpm.h           |  2 +-
> >  drivers/char/tpm/tpm2-cmd.c      | 19 +++++++++++--------
> >  drivers/char/tpm/tpm_crb.c       | 20 +++++---------------
> >  drivers/char/tpm/tpm_tis.c       | 26 +++++++++++++-------------
> >  5 files changed, 34 insertions(+), 39 deletions(-)
>=20
> Resume still functions on TPM 1.2 chip, with and without CONFIG_TCG_C=
RB.
>=20
> Tested-by: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
