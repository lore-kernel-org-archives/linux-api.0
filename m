From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Thu, 9 Jul 2015 15:08:48 +0200
Message-ID: <20150709130848.GD21858@phenom.ffwll.local>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>
 <20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>
 <559C68B3.3010105@lge.com>
 <20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org>
 <559C6CA6.1050809@lge.com>
 <CAPM=9txmUJ58=CAxDhf12Y3Y8wz7CGBy-Bd4pQ8YAAKDsCxU8w@mail.gmail.com>
 <559DB86D.40000@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <559DB86D.40000@lge.com>
Sender: owner-linux-mm@kvack.org
To: Gioh Kim <gioh.kim@lge.com>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, Al Viro <viro@zeniv.linux.org.uk>, "Michael S. Tsirkin" <mst@redhat.com>, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, open@kvack.org, list@kvack.org, ABI/API <linux-api@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, gunho.lee@lge.com, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 09, 2015 at 08:55:25AM +0900, Gioh Kim wrote:
>=20
>=20
> 2015-07-09 =EC=98=A4=EC=A0=84 7:47=EC=97=90 Dave Airlie =EC=9D=B4(=EA=B0=
=80) =EC=93=B4 =EA=B8=80:
> >>>
> >>>
> >>>Can the various in-kernel GPU drivers benefit from this?  If so, wir=
ing
> >>>up one or more of those would be helpful?
> >>
> >>
> >>I'm sure that other in-kernel GPU drivers can have benefit.
> >>It must be helpful.
> >>
> >>If I was familiar with other in-kernel GPU drivers code, I tried to p=
atch
> >>them.
> >>It's too bad.
> >
> >I'll bring dri-devel into the loop here.
> >
> >ARM GPU developers please take a look at this stuff, Laurent, Rob,
> >Eric I suppose.
>=20
> I sent a patch, https://lkml.org/lkml/2015/3/24/1182, and my opinion ab=
out compaction
> to ARM GPU developers via Korea ARM branch.
> I got a reply that they had no time to review it.
>=20
> I hope they're interested to this patch.

i915 gpus would support 64kb and 2mb pages, but we never implemented this=
.
I don't think this would fit for gem based drivers since our backing
storage is shmemfs. So if we want to implement page migration (which we'd
probably want to make large pages work well) we'd need to pimp shmem to a=
)
hand large pages to us b) forward the migrate calls. Probably that means
we need to build our own gemfs reusing shmemfs code.

I guess something similar would apply for ttm-based drivers (which use
shmemfs just for swap-in/out but otherwise have their own page allocator,
at least sometimes).

Given all that I'd expect anything implementing migrate to just create a
gpufs thing for the backing storage, no need for more hooks. There's also
other areas for better code sharing among gpu drivers (e.g. mmu notifiers
to get off userspace pages slurped in&pinned with gup or shrinker
callbacks to get the gpu off it's memory binge). But that would all be
helper libraries in drm, not sure we need anything new from the core vm.

Also there's a bit a lack of gpu drivers from the arm world in upstream,
which is probabyl why this patch series doesn't come with a user. Might b=
e
better to first upstream the driver before talking about additional
infrastructure that it needs.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
