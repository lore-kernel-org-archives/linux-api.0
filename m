From: peterhuewe-Mmb7MZpHnFY@public.gmane.org
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
Date: Mon, 08 Dec 2014 17:18:06 +0100
Message-ID: <279e9a5e-05a9-4826-ada1-899fdcd11cea@email.android.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com> <547E7553.2050608@linux.vnet.ibm.com> <201412050013.19082.PeterHuewe@gmx.de> <20141208135615.GC30303@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141208135615.GC30303-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi=20

On 8. Dezember 2014 14:56:15 MEZ, Jarkko Sakkinen <jarkko.sakkinen@linu=
x.intel.com> wrote:
>On Fri, Dec 05, 2014 at 12:13:18AM +0100, Peter H=C3=BCwe wrote:
>> Am Mittwoch, 3. Dezember 2014, 03:28:35 schrieb Stefan Berger:
>> > On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:
>> > > +
>> > > +/**
>> > > + * tpm2_startup() - send startup command to the TPM chip
>> > > + * @chip:		TPM chip to use.
>> > > + * @startup_type	startup type. The value is either
>> > > + *			TPM_SU_CLEAR or TPM_SU_STATE.
>> > > + *
>> > > + * 0 is returned when the operation is successful. If a negativ=
e
>number
>> > > is + * returned it remarks a POSIX error code. If a positive
>number is
>> > > returned + * it remarks a TPM error.
>> > > + */
>> > > +int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
>> > > +{
>> > > +	struct tpm2_cmd cmd;
>> > > +
>> > > +	cmd.header.in =3D tpm2_startup_header;
>> > > +
>> > > +	cmd.params.startup_in.startup_type =3D startup_type;
>> > > +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
>> > > +				"attempting to start the TPM");
>> > > +}
>> >=20
>> > I suppose you need to send this command because your firmware does
>not
>> > do it ?Following TPM1.2 I guess the BIOS / UEFI should send this
>instead
>> > and sending it later would actually be wrong. Hm, I don't find fro=
m
>> > where you are calling this... do you need it ? Can you remove it?
>> >=20
>> >     Stefan
>>=20
>> Hi,
>>=20
>> I think it would be good to send a TPM2_Startup if the TPM sends a=20
>> TPM_RC_INITIALIZE (0x100) - so it becomes atleast usable.
>> Of course the BIOS/UEFI/Firmware should send the TPM2_Startup, but i=
f
>there is=20
>> no such thing, I would prefer Linux to do it, rather than nobody.
>> (analog: This was done for embedded platforms with TPM1.2).
>>=20
>> In the current situation (v9) it is not possible to use the TPM2 on =
a
>machine=20
>> without bios integration. :( (so I cannot test here :( )
>
>Should the place be if sending self-test fails? I think the type shoul=
d
>be TPM2_SU_CLEAR. Do you agree?
>

Yes. If the first command returns "invalid post init" or whatever it is=
 called in tpm20 speech the driver should send the startup clear.


Not sure if we should send a startup state in the resume case (like on =
tpm1.2)

And also it might make sense to send a tpm_shutdown? (If we aren't alre=
ady) I think even on a machine with bios integration we have to send th=
is?


>All other issues are now fixed except this and STS3 bit issue that I=20
>look for next. In my github there is tpm2-v10 branch now with fixes
>on top. I squash the fixes right after these two remaining issues are
>fixed.
>
>> Peter
>
>/Jarkko

Peter
--=20
Sent from my mobile.
