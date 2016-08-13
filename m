From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PACTH v1] mm, proc: Implement /proc/<pid>/totmaps
Date: Sat, 13 Aug 2016 14:39:53 +0200
Message-ID: <20160813123952.GA30408@pc.thejh.net>
References: <1470758743-17685-1-git-send-email-robert.foss@collabora.com>
 <20160809192414.GA19573@pc.thejh.net>
 <8ac1b493-e051-ea0e-3a71-c4476054bdb2@collabora.com>
 <CAPz6YkUKN9xOO=m2sLGNGkH9uSa4cvyDWAPPS6RFwheOS=opcA@mail.gmail.com>
 <20160810173719.GA25801@pc.thejh.net>
 <CAPz6YkWqitM+_8detGcyzU3n2PwnrMciRjeN1Bj4SER6s-24PA@mail.gmail.com>
 <20160810180546.GA486@pc.thejh.net>
 <c4e93e1f-5438-f38a-5fff-c8a48b963d4e@collabora.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c4e93e1f-5438-f38a-5fff-c8a48b963d4e-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Robin Humble <plaguedbypenguins-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Janis Danisevskis <jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, calvinowens-b10kYP2dOMg@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ben Zhang <benzh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Filipe Brandenburger <filbranden-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TZUIDd8j+nm9g@public.gmane.org
List-Id: linux-api@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2016 at 12:28:11PM -0400, Robert Foss wrote:
>=20
>=20
> On 2016-08-10 02:05 PM, Jann Horn wrote:
> >On Wed, Aug 10, 2016 at 10:45:51AM -0700, Sonny Rao wrote:
> >>On Wed, Aug 10, 2016 at 10:37 AM, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org> wrote:
> >>>On Wed, Aug 10, 2016 at 10:23:53AM -0700, Sonny Rao wrote:
> >>>>On Tue, Aug 9, 2016 at 2:01 PM, Robert Foss <robert.foss-ZGY8ohtN/8rSCDK34cm6iQ@public.gmane.org=
m> wrote:
> >>>>>
> >>>>>
> >>>>>On 2016-08-09 03:24 PM, Jann Horn wrote:
> >>>>>>
> >>>>>>On Tue, Aug 09, 2016 at 12:05:43PM -0400, robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org=
 wrote:
> >>>>>>>
> >>>>>>>From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >>>>>>>
> >>>>>>>This is based on earlier work by Thiago Goncales. It implements a =
new
> >>>>>>>per process proc file which summarizes the contents of the smaps f=
ile
> >>>>>>>but doesn't display any addresses.  It gives more detailed informa=
tion
> >>>>>>>than statm like the PSS (proprotional set size).  It differs from =
the
> >>>>>>>original implementation in that it doesn't use the full blown set =
of
> >>>>>>>seq operations, uses a different termination condition, and doesn't
> >>>>>>>displayed "Locked" as that was broken on the original implemenatio=
n.
> >>>>>>>
> >>>>>>>This new proc file provides information faster than parsing the
> >>>>>>>potentially
> >>>>>>>huge smaps file.
> >>>>>>>
> >>>>>>>Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >>>>>>>
> >>>>>>>Tested-by: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> >>>>>>>Signed-off-by: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>>+static int totmaps_proc_show(struct seq_file *m, void *data)
> >>>>>>>+{
> >>>>>>>+       struct proc_maps_private *priv =3D m->private;
> >>>>>>>+       struct mm_struct *mm;
> >>>>>>>+       struct vm_area_struct *vma;
> >>>>>>>+       struct mem_size_stats *mss_sum =3D priv->mss;
> >>>>>>>+
> >>>>>>>+       /* reference to priv->task already taken */
> >>>>>>>+       /* but need to get the mm here because */
> >>>>>>>+       /* task could be in the process of exiting */
> >>>>>>
> >>>>>>
> >>>>>>Can you please elaborate on this? My understanding here is that you
> >>>>>>intend for the caller to be able to repeatedly read the same totmaps
> >>>>>>file with pread() and still see updated information after the target
> >>>>>>process has called execve() and be able to detect process death
> >>>>>>(instead of simply seeing stale values). Is that accurate?
> >>>>>>
> >>>>>>I would prefer it if you could grab a reference to the mm_struct
> >>>>>>directly at open time.
> >>>>>
> >>>>>
> >>>>>Sonny, do you know more about the above comment?
> >>>>
> >>>>I think right now the file gets re-opened every time, but the mode
> >>>>where the file is opened once and repeatedly read is interesting
> >>>>because it avoids having to open the file again and again.
> >>>>
> >>>>I guess you could end up with a wierd situation where you don't read
> >>>>the entire contents of the file in open call to read() and you might
> >>>>get inconsistent data across the different statistics?
> >>>
> >>>If the file is read in two chunks, totmaps_proc_show is only called
> >>>once. The patch specifies seq_read as read handler. Have a look at its
> >>>definition. As long as you don't read from the same seq file in
> >>>parallel or seek around in it, simple sequential reads will not
> >>>re-invoke the show() method for data that has already been formatted.
> >>>For partially consumed data, the kernel buffers the rest until someone
> >>>reads it or seeks to another offset.
> >>
> >>Ok that's good.  If the consumer were using pread() though, would that
> >>look like a seek?
> >
> >Only if the consumer uses pread() with an offset that is not the same as
> >the end offset of the previous read.
> >
> >So if you tried to use the same file from multiple threads in parallel,
> >you might still have issues, but as long as you don't do that, it should
> >be fine.
> >
> >I guess it might make sense to document this behavior somewhere - maybe
> >the proc.5 manpage?
> >
>=20
> I'll add a note about limitations for parallel read. The overall
> documentation for this feature should live in the proc.5 manpage as well?

Yes, I think so.

+Cc linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXrxUYAAoJED4KNFJOeCOorKUQAKJdFfg+4/PL0oKFYYTpl2qO
+XanKCTYJfkSu/eEd0g69EtDiJtmbKEwpu7ywGXMHKn4L/s3tDDBK8lDKVufw8Wg
EIaMsKOMVa2dNQyQ4M2lemQ+uUFkpj5QOonnYZspkzaCywAElsiCClmmP90LvYUz
nGDk1XTQhmpGsQPXb/tyUTLCTKYsaboBPnFXqLOWeNxSUnX4P7nFiZTdWMsoK/dK
GFKhSmRZ2gSLrjOERHjotg6VlR+mvfZEdh1OP+cPGFYhhPL04TvnEhVgWgoI72SA
TrZlFIs51Hhp43+tkDTmWA+vN7qGY1KKbcLxB4kyseiULUW4H+35YJa//k3s4fgq
NW4ZKUvT7yl4E0bOAfX5bNOp5z2xgXIcb8tQa7lb05IUu5VF25PzISrMAsfBVy3t
v0IDNA2VZq+HUW7cFf68gwJEK/Gzj7JeZ4dspQovnFeImEU1xPZrqqlu73Qxz/yS
XKq1r2VnvErF1h+gKfdTi8zBm4N4XZH9Nc5ha/1VNXWk+ZfxPZaMGkqFoh16fOGQ
cAX/cjm8dqPqaZuiLxIu/FHwfzqO/AjZMf0s+8vtBIl73+0VL4mcDElUBOVxMk+f
nhGmBXc3vtgU8MP3D20ZYzXB4C+ICHrEjwCMp/mCSKXUOtqJnJ5a05XMKZJaDP/9
cu9bE5KM98bYfci8qVXH
=oL+i
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
