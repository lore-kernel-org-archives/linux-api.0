From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 08/10] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Fri, 18 Mar 2016 06:58:59 -0500
Message-ID: <201603181200.u2IC0qTi023054@d01av01.pok.ibm.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com><1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com><20160316204244.GB23966@intel.com><56EAED30.3040503@linux.vnet.ibm.com>
	<20160318085200.GA5604@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8998293776987346729=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160318085200.GA5604-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============8998293776987346729==
Content-Type: multipart/alternative;
	boundary="=_alternative 0041D4E985257F7A_="


--=_alternative 0041D4E985257F7A_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/18/2016=20
04:52:00 AM:


> Subject: Re: [tpmdd-devel] [PATCH v8 08/10] tpm: Proxy driver for=20
> supporting multiple emulated TPMs
>=20
> On Thu, Mar 17, 2016 at 01:45:20PM -0400, Stefan Berger wrote:
> > On 03/16/2016 04:42 PM, Jarkko Sakkinen wrote:
> > >On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Berger wrote:
> > >>+
> > >>+/* above flags */
> > >>+#define VTPM=5FPROXY=5FFLAG=5FTPM2  1  /* emulator is TPM 2 */
> > >>+
> > >>+/* all supported flags */
> > >>+#define VTPM=5FPROXY=5FFLAGS=5FALL  (VTPM=5FPROXY=5FFLAG=5FTPM2)
> > >This can be moved inside the .c-file?
> >=20
> > I can move that.
> >=20
> > >
> > >>+
> > >>+#define VTPM=5FPROXY=5FMAGIC 0xa1
> > >>+
> > >>+#define VTPM=5FPROXY=5FIOC=5FNEW=5FDEV   =5FIOW(VTPM=5FPROXY=5FMAGIC=
, 0x00, \
> > >>+                  struct vtpm=5Fproxy=5Fnew=5Fdev)
> > >Could we simply replace these four lines with one line:
> > >
> > >#deifne VTPM=5FPROXY=5FIOC=5FNEW=5FDEV =5FIOW('t', 0x00, struct=20
vtpm=5Fproxy=5Fnew=5Fdev);

Just move the 0xa1 over the 't' and we can get rid of the=20
VTPM=5FPROXY=5FMAGIC.

   Stefan



--=_alternative 0041D4E985257F7A_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/18/2016 04:52:00 AM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v8 08/10] tpm:
Proxy driver for <br>&gt; supporting multiple emulated TPMs</font></tt><br>=
<tt><font size=3D2>&gt; <br>&gt; On Thu, Mar 17, 2016 at 01:45:20PM -0400, =
Stefan Berger wrote:<br>&gt; &gt; On 03/16/2016 04:42 PM, Jarkko Sakkinen w=
rote:<br>&gt; &gt; &gt;On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Ber=
ger wrote:<br>&gt; &gt; &gt;&gt;+<br>&gt; &gt; &gt;&gt;+/* above flags */<b=
r>&gt; &gt; &gt;&gt;+#define VTPM=5FPROXY=5FFLAG=5FTPM2 &nbsp;1 &nbsp;/* em=
ulator
is TPM 2 */<br>&gt; &gt; &gt;&gt;+<br>&gt; &gt; &gt;&gt;+/* all supported f=
lags */<br>&gt; &gt; &gt;&gt;+#define VTPM=5FPROXY=5FFLAGS=5FALL &nbsp;(VTP=
M=5FPROXY=5FFLAG=5FTPM2)<br>&gt; &gt; &gt;This can be moved inside the .c-f=
ile?<br>&gt; &gt; <br>&gt; &gt; I can move that.<br>&gt; &gt; <br>&gt; &gt;=
 &gt;<br>&gt; &gt; &gt;&gt;+<br>&gt; &gt; &gt;&gt;+#define VTPM=5FPROXY=5FM=
AGIC 0xa1<br>&gt; &gt; &gt;&gt;+<br>&gt; &gt; &gt;&gt;+#define VTPM=5FPROXY=
=5FIOC=5FNEW=5FDEV &nbsp; =5FIOW(VTPM=5FPROXY=5FMAGIC,
0x00, \<br>&gt; &gt; &gt;&gt;+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;
&nbsp;struct vtpm=5Fproxy=5Fnew=5Fdev)<br>&gt; &gt; &gt;Could we simply rep=
lace these four lines with one line:<br>&gt; &gt; &gt;<br>&gt; &gt; &gt;#de=
ifne VTPM=5FPROXY=5FIOC=5FNEW=5FDEV =5FIOW('t', 0x00, struct vtpm=5Fproxy=
=5Fnew=5Fdev);</font></tt><br><br><tt><font size=3D2>Just move the 0xa1 ove=
r the 't' and we can get rid
of the VTPM=5FPROXY=5FMAGIC.</font></tt><br><br><tt><font size=3D2>&nbsp; &=
nbsp;Stefan</font></tt><br><BR>
--=_alternative 0041D4E985257F7A_=--



--===============8998293776987346729==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
--===============8998293776987346729==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8998293776987346729==--
