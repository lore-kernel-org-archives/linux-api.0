From: Peter =?windows-1252?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
Date: Fri, 5 Dec 2014 00:13:18 +0100
Message-ID: <201412050013.19082.PeterHuewe@gmx.de>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com> <547E7553.2050608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <547E7553.2050608-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 3. Dezember 2014, 03:28:35 schrieb Stefan Berger:
> On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:
> > +
> > +/**
> > + * tpm2_startup() - send startup command to the TPM chip
> > + * @chip:		TPM chip to use.
> > + * @startup_type	startup type. The value is either
> > + *			TPM_SU_CLEAR or TPM_SU_STATE.
> > + *
> > + * 0 is returned when the operation is successful. If a negative number
> > is + * returned it remarks a POSIX error code. If a positive number is
> > returned + * it remarks a TPM error.
> > + */
> > +int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
> > +{
> > +	struct tpm2_cmd cmd;
> > +
> > +	cmd.header.in = tpm2_startup_header;
> > +
> > +	cmd.params.startup_in.startup_type = startup_type;
> > +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> > +				"attempting to start the TPM");
> > +}
> 
> I suppose you need to send this command because your firmware does not
> do it ?Following TPM1.2 I guess the BIOS / UEFI should send this instead
> and sending it later would actually be wrong. Hm, I don't find from
> where you are calling this... do you need it ? Can you remove it?
> 
>     Stefan

Hi,

I think it would be good to send a TPM2_Startup if the TPM sends a 
TPM_RC_INITIALIZE (0x100) - so it becomes atleast usable.
Of course the BIOS/UEFI/Firmware should send the TPM2_Startup, but if there is 
no such thing, I would prefer Linux to do it, rather than nobody.
(analog: This was done for embedded platforms with TPM1.2).

In the current situation (v9) it is not possible to use the TPM2 on a machine 
without bios integration. :( (so I cannot test here :( )




Peter
