From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: pkeys: Reserve PKEY_DISABLE_READ
Date: Thu, 8 Nov 2018 12:12:31 -0800
Message-ID: <20181108201231.GE5481@ram.oc3035372033.ibm.com>
References: <877ehnbwqy.fsf@oldenburg.str.redhat.com>
 <2d62c9e2-375b-2791-32ce-fdaa7e7664fd@intel.com>
 <87bm6zaa04.fsf@oldenburg.str.redhat.com>
 <6f9c65fb-ea7e-8217-a4cc-f93e766ed9bb@intel.com>
 <87k1ln8o7u.fsf@oldenburg.str.redhat.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87k1ln8o7u.fsf@oldenburg.str.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 08, 2018 at 06:37:41PM +0100, Florian Weimer wrote:
> * Dave Hansen:
>=20
> > On 11/8/18 7:01 AM, Florian Weimer wrote:
> >> Ideally, PKEY_DISABLE_READ | PKEY_DISABLE_WRITE and PKEY_DISABLE_READ |
> >> PKEY_DISABLE_ACCESS would be treated as PKEY_DISABLE_ACCESS both, and a
> >> line PKEY_DISABLE_READ would result in an EINVAL failure.
> >
> > Sounds reasonable to me.
> >
> > I don't see any urgency to do this right now.  It could easily go in
> > alongside the ppc patches when those get merged.
>=20
> POWER support has already been merged, so we need to do something here
> now, before I can complete the userspace side.
>=20
> > The only thing I'd suggest is that we make it something slightly
> > higher than 0x4.  It'll make the code easier to deal with in the
> > kernel if we have the ABI and the hardware mirror each other, and if
> > we pick 0x4 in the ABI for PKEY_DISABLE_READ, it might get messy if
> > the harware choose 0x4 for PKEY_DISABLE_EXECUTE or something.
> >=20
> > So, let's make it 0x80 or something on x86 at least.
>=20
> I don't have a problem with that if that's what it takes.
>=20
> > Also, I'll be happy to review and ack the patch to do this, but I'd
> > expect the ppc guys (hi Ram!) to actually put it together.
>=20
> Ram, do you want to write a patch?


Florian,

	I can. But I am struggling to understand the requirement. Why is
	this needed?  Are we proposing a enhancement to the sys_pkey_alloc(),
	to be able to allocate keys that are initialied to disable-read
	only?

RP

>=20
> I'll promise I finish the glibc support for this. 8-)
>=20
> Thanks,
> Florian

--=20
Ram Pai
