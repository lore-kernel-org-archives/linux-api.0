From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for
 supporting	multiple emulated TPMs
Date: Wed, 9 Mar 2016 13:44:29 -0500
Message-ID: <201603091844.u29IiWPo016087@d03av01.boulder.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com><1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<CALCETrXDfHRdFnqK15o1yD8106sn4e6Susr9j7=GGi4sb-p0qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8362569175340286854=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CALCETrXDfHRdFnqK15o1yD8106sn4e6Susr9j7=GGi4sb-p0qQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============8362569175340286854==
Content-Type: multipart/alternative;
	boundary="=_alternative 0066F33385257F71_="


--=_alternative 0066F33385257F71_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote on 03/09/2016 01:01:05 PM:


>=20
> On Wed, Mar 9, 2016 at 9:39 AM, Stefan Berger
> <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > This patch implements a driver for supporting multiple emulated TPMs=20
in a
> > system.
> >
> > The driver implements a device /dev/vtpmx that is used to created
> > a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side=20
that
> > is accessed using a file descriptor returned by an ioctl.
> > The device /dev/tpmX is the usual TPM device created by the core TPM
> > driver. Applications or kernel subsystems can send TPM commands to it
> > and the corresponding server-side file descriptor receives these
> > commands and delivers them to an emulated TPM.
>=20
> Nifty!
>=20
> Is anyone considering writing a modification or replacement of
> trousers that creates claims the real tpm and exposes a vtpm that
> handles multiplexing internally?  Does the vtpm driver intelligently
> support multiple simultaneous clients?

The vtpm driver allows to use an independent trousers instance in each=20
container.

Using the VTPM=5FNEW=5FDEV ioctl the container mgmt. stack can create a=20
/dev/tpmX (X=3D0,1,2,...) device and a file descriptor. The file descriptor=
=20
is passed to a vTPM instance, the /dev/tpmX is moved into the container,=20
meaning a device with the same major/minor numbers is created in the=20
container. This then allows each container to talk to an independent vTPM. =

The vTPM can either be 1.2 or 2.

   Stefan



--=_alternative 0066F33385257F71_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Andy Lutomirski &lt;luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org&gt; wrote on
03/09/2016 01:01:05 PM:<br><br></font></tt><br><tt><font size=3D2>&gt; <br>=
&gt; On Wed, Mar 9, 2016 at 9:39 AM, Stefan Berger<br>&gt; &lt;stefanb@linu=
x.vnet.ibm.com&gt; wrote:<br>&gt; &gt; This patch implements a driver for s=
upporting multiple emulated
TPMs in a<br>&gt; &gt; system.<br>&gt; &gt;<br>&gt; &gt; The driver impleme=
nts a device /dev/vtpmx that is used to created<br>&gt; &gt; a client devic=
e pair /dev/tpmX (e.g., /dev/tpm10) and a server
side that<br>&gt; &gt; is accessed using a file descriptor returned by an i=
octl.<br>&gt; &gt; The device /dev/tpmX is the usual TPM device created by =
the core
TPM<br>&gt; &gt; driver. Applications or kernel subsystems can send TPM com=
mands
to it<br>&gt; &gt; and the corresponding server-side file descriptor receiv=
es these<br>&gt; &gt; commands and delivers them to an emulated TPM.<br>&gt=
; <br>&gt; Nifty!<br>&gt; <br>&gt; Is anyone considering writing a modifica=
tion or replacement of<br>&gt; trousers that creates claims the real tpm an=
d exposes a vtpm that<br>&gt; handles multiplexing internally? &nbsp;Does t=
he vtpm driver intelligently<br>&gt; support multiple simultaneous clients?=
</font></tt><br><br><tt><font size=3D2>The vtpm driver allows to use an ind=
ependent trousers
instance in each container.</font></tt><br><br><tt><font size=3D2>Using the=
 VTPM=5FNEW=5FDEV ioctl the container mgmt. stack
can create a /dev/tpmX (X=3D0,1,2,...) device and a file descriptor. The
file descriptor is passed to a vTPM instance, the /dev/tpmX is moved into
the container, meaning a device with the same major/minor numbers is created
in the container. This then allows each container to talk to an independent
vTPM. The vTPM can either be 1.2 or 2.</font></tt><br><br><tt><font size=3D=
2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 0066F33385257F71_=--



--===============8362569175340286854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
--===============8362569175340286854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8362569175340286854==--
