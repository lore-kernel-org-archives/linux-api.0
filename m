From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [Patch v2 2/3] firmware: dmi_scan: add SBMIOS entry and DMI
 tables
Date: Thu, 23 Apr 2015 13:33:59 +0200
Message-ID: <1429788839.4370.1.camel@chaos.site>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	 <1429525187-3376-3-git-send-email-ivan.khoronzhuk@globallogic.com>
	 <20150421173613.6601da15@endymion.delvare> <553674D2.10407@globallogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <553674D2.10407@globallogic.com>
Sender: linux-doc-owner@vger.kernel.org
To: "Ivan.khoronzhuk" <ivan.khoronzhuk@globallogic.com>
Cc: linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org
List-Id: linux-api@vger.kernel.org

Le Tuesday 21 April 2015 =C3=A0 19:03 +0300, Ivan.khoronzhuk a =C3=A9cr=
it :
> On 21.04.15 18:36, Jean Delvare wrote:
> > I just found that more work is needed here for the SMBIOS v3 entry
> > point case. These entry points do not specify the exact length of t=
he
> > table, but only its maximum. The real world sample I have access to
> > indeed specifies a maximum length of 6419 bytes, but the actual tab=
le
> > only spans over 2373 bytes. It is properly terminated with a type 1=
27
> > DMI structure, so the kernel table parser ignores the garbage after=
 it.
> > The garbage is however exported to user-space above.
> >
> > I taught dmidecode to ignore the garbage, but there are two problem
> > left here. First problem is a waste of memory. Minor issue I suppos=
e,
> > who cares about a few kilobytes these days.
> >
> > Second problem is a security problem. We are leaking the contents o=
f
> > physical memory to user-space. In my case it's filled with 0xffs so=
 no
> > big deal. But what if actual data happens to be stored there? It
> > definitely shouldn't go to user-space.
> >
> > So dmi_len needs to be trimmed to the actual table size before the
> > attribute above is created. I have an idea how this could be
> > implemented easily, let me give it a try.
> >
> > Maybe we should trim the length for previous implementations, too.
> > There is no reason to walk past a type 127 structure anyway, ever.
> >
>=20
> It can happen of-cause, I've also thought about that sometime ago,
> but forget...).
> I've sent the updated series already.

Got it, reviewed and ready to push upstream. I'll do so as soon as I'm
done with other duties.

> Let me know when your fix will be ready and I will re-base the
> series if it has conflicts.

Don't worry, I'm quite good at manual conflict resolution :)

Thanks,
--=20
Jean Delvare
SUSE L3 Support

