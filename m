From: "Reshetova, Elena" <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH] mm: extend memfd with ability to create "secret"
 memory areas
Date: Mon, 10 Feb 2020 08:06:49 +0000
Message-ID: <BL0PR11MB3281C858712D469C88F52537E7190@BL0PR11MB3281.namprd11.prod.outlook.com>
References: <20200130162340.GA14232@rapoport-lnx>
 <df5a888b-1a11-e806-741d-94684b22c966@intel.com>
 <20200208173922.GA15879@hump>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200208173922.GA15879@hump>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> On Thu, Feb 06, 2020 at 10:51:13AM -0800, Dave Hansen wrote:
> > On 1/30/20 8:23 AM, Mike Rapoport wrote:
> > >  include/linux/memfd.h      |   9 ++
> > >  include/uapi/linux/magic.h |   1 +
> > >  include/uapi/linux/memfd.h |   6 +
> > >  mm/Kconfig                 |   4 +
> > >  mm/Makefile                |   1 +
> > >  mm/memfd.c                 |  10 +-
> > >  mm/secretmem.c             | 244 +++++++++++++++++++++++++++++++++++=
++
> > >  7 files changed, 273 insertions(+), 2 deletions(-)
> >
> > It seems pretty self-contained and relatively harmless.
> >
> > But, how much work is it going to be to tell the rest of the kernel tha=
t
> > page_to_virt() doesn't work any more?
>=20
> Why page_to_virt() won't work anymore? Or you refer to that the kernel co=
de
> won't be able to access the page contents?
>=20
> > Do we need to make kmap() work on these?
>=20
> I don't think we need to make kmap() work on these. The idea is to preven=
t
> kernel from accessing such memory areas.
>=20
> > I guess fixing vm_normal_page() would fix a lot of that.
> >
> > In general, my concern about creating little self-contained memory type=
s
> > is that they will get popular and folks will start wanting more feature=
s
> > from them.  For instance, what if I want NUMA affinity, migration, or
> > large page mappings that are secret?
>=20
> Sure, why not :)
> Well, this is true for any feature: it may become popular, people will
> start using it and it will add more complexity.
>=20
> My goal is to design this thing keeping in mind that all the above (and
> probably more) will be requested sooner or later.
>=20
> > Can these pages work as guest memory?
>=20
> Actually, this is one of the driving usecases. I believe that people that
> use mem=3DX to limit kernel control of the memory and the manage the
> remaining memory for the guests can switch to fd-based approach.
>=20
> > Who would the first users of this thing be?
>=20
> We were thinking about using such areas to store small secrets, e.g. with
> openssl_malloc().
>=20

To elaborate more on this - openssl has "secure heap" feature [1], which=20
is basically a mmap area with MLOCK_ONFAULT and MADV_DONTDUMP.
It is optional feature and can be used for storing things like RSA private =
keys
in a bit more secure memory area (vs. just normal allocation). It is fully=
=20
transparent for userspace applications (hidden behind openssl API), but=20
provides additional security when enabled. So, it seems like a natural cand=
idate
for smth like securememory, which in addition to MLOCK_ONFAULT and=20
MADV_DONTDUMP can provide further security guarantees like exclusive=20
memory and no-caching.=20

[1] https://www.openssl.org/docs/manmaster/man3/OPENSSL_secure_malloc.html

Best Regards,
Elena.
