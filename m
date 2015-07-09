From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Thu, 9 Jul 2015 16:33:01 +0300
Message-ID: <20150709133301.GG5176@intel.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>
 <20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>
 <559C68B3.3010105@lge.com>
 <20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org>
 <559C6CA6.1050809@lge.com>
 <CAPM=9txmUJ58=CAxDhf12Y3Y8wz7CGBy-Bd4pQ8YAAKDsCxU8w@mail.gmail.com>
 <559DB86D.40000@lge.com>
 <20150709130848.GD21858@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150709130848.GD21858@phenom.ffwll.local>
Sender: owner-linux-mm@kvack.org
To: Gioh Kim <gioh.kim@lge.com>, Dave Airlie <airlied@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, Al Viro <viro@zeniv.linux.org.uk>, "Michael S. Tsirkin" <mst@redhat.com>, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, open@kvack.org, list@kvack.org, ABI/API <linux-api@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, gunho.lee@lge.com, Gioh Kim <gurugio@hanmail.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 09, 2015 at 03:08:48PM +0200, Daniel Vetter wrote:
> On Thu, Jul 09, 2015 at 08:55:25AM +0900, Gioh Kim wrote:
> >=20
> >=20
> > 2015-07-09 =EC=98=A4=EC=A0=84 7:47=EC=97=90 Dave Airlie =EC=9D=B4(=EA=
=B0=80) =EC=93=B4 =EA=B8=80:
> > >>>
> > >>>
> > >>>Can the various in-kernel GPU drivers benefit from this?  If so, w=
iring
> > >>>up one or more of those would be helpful?
> > >>
> > >>
> > >>I'm sure that other in-kernel GPU drivers can have benefit.
> > >>It must be helpful.
> > >>
> > >>If I was familiar with other in-kernel GPU drivers code, I tried to=
 patch
> > >>them.
> > >>It's too bad.
> > >
> > >I'll bring dri-devel into the loop here.
> > >
> > >ARM GPU developers please take a look at this stuff, Laurent, Rob,
> > >Eric I suppose.
> >=20
> > I sent a patch, https://lkml.org/lkml/2015/3/24/1182, and my opinion =
about compaction
> > to ARM GPU developers via Korea ARM branch.
> > I got a reply that they had no time to review it.
> >=20
> > I hope they're interested to this patch.
>=20
> i915 gpus would support 64kb and 2mb pages, but we never implemented th=
is.
> I don't think this would fit for gem based drivers since our backing
> storage is shmemfs. So if we want to implement page migration (which we=
'd
> probably want to make large pages work well) we'd need to pimp shmem to=
 a)
> hand large pages to us b) forward the migrate calls. Probably that mean=
s
> we need to build our own gemfs reusing shmemfs code.

AFAIK there are efforts ongoing to make large pages work with shmem.

Kirill, IIRC you mentioned that you're were looking into this a while
back?

--=20
Ville Syrj=C3=A4l=C3=A4
Intel OTC

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
