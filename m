From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Date: Tue, 9 Dec 2014 07:47:54 -0800
Message-ID: <20141209154754.GA24564@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412042318.33889.PeterHuewe@gmx.de>
 <201412042328.29578.PeterHuewe@gmx.de>
 <trinity-0fea8cea-4011-4d04-af4a-e7583a7184b4-1417791661803@3capp-gmx-bs52>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <trinity-0fea8cea-4011-4d04-af4a-e7583a7184b4-1417791661803@3capp-gmx-bs52>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 05, 2014 at 04:01:01PM +0100, Peter Huewe wrote:
> > 
> > > Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
> > > > From: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > >
> > > > Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> > > > instead of calling tpm_get_timeouts(), assign duration and timeout
> > > > values defined in the TPM 2.0 PTP specification.
> > > >
> > > > Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > > >
> > > > + sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
> > > > + if ((sts3 & TPM_STS3_TPM2_FAM) == TPM_STS3_TPM2_FAM)
> > > > + chip->flags = TPM_CHIP_FLAG_TPM2;
> > > > +
> > > >
> > 
> > >
> > > When loading tpm_tis force=1 with my tpm1.2 chip on a machine without bios
> > > integration, it fets detected as a TPM2.0 chip :/
> > >
> > > sudo rmmod tpm_tis
> > > # modprobe tpm_tis force=1
> > > modprobe: ERROR: could not insert 'tpm_tis': No such device
> > > # dmesg
> > > [ 263.903828] tpm_tis tpm_tis: 2.0 TPM (device-id 0xB, rev-id 16)
> > > [ 263.948049] tpm_tis tpm_tis: A TPM error (10) occurred continue selftest
> > > [ 263.948120] tpm_tis tpm_tis: TPM self test failed
> > >
> > >
> > > sts3 is reported as 0xff from my TPM1.2
> > >
> > 
> > 
> > Hmm,
> > my TPM2.0 chip also reports sts3 as 0xff (when loading with force=1 on a
> > machine without bios integration)
> > 
> > [ 307.095344] sts3 ff
> > [ 307.095366] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
> > [ 307.140047] tpm_tis tpm_tis: A TPM error (256) occurred continue selftest
> > [ 307.140056] tpm_tis tpm_tis: TPM self test failed
> 
> 
> You are reading "sts3" - before requesting the locality and thus
> it returns 0xff for a TPM20 chip as well.
> --> You have to have an active locality first.
> 
> 
> For a TPM2.0 0xFF is not a valid value (if active locality is
> set), since reading commandCancel and resetEstablishment bit
> always return 0 on reads (according to spec).
> 
> --> 0xFF should be treated as a TPM1.2 (older tpms with TIS 1.2)
> --> 0x04 should be treated as TPM 2.0
> --> 0x08 should be treated as TPM1.2 (newer tpms with TIS1.3 enhanced)

Correct. I discussed with some people and verified the reason to be
such that if firmware does nothing, the locality is unopened. I have
access today to similar setup and can fix this regression and verify
my fix.

Thanks for pointing this out!

> Thanks,
> Peter

/Jarkko
