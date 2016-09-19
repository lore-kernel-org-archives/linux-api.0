From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 19 Sep 2016 21:56:20 +0200
Message-ID: <20160919195619.GF2903@pc.thejh.net>
References: <CAPz6YkVRcCkwv7WvdTQMH-UHhLK_k51QtNNOmNw7ySk7pfgD8w@mail.gmail.com>
 <20160912171503.GB14997@dhcp22.suse.cz>
 <CAPz6YkVs5OjYY6bWzUh5sshrMRS+aFG9=F0ptLsmUb_RD3=pzg@mail.gmail.com>
 <20160913071208.GC31898@dhcp22.suse.cz>
 <CAPz6YkXq_QPffYgBJZGxZG9SboTVoCEH2qqCgAuB6YYj1e95ig@mail.gmail.com>
 <20160914091205.GD1612@dhcp22.suse.cz>
 <0769f0c7-7869-2b0f-faac-3b5cbdb6e401@collabora.com>
 <20160919193238.GA28639@dhcp22.suse.cz>
 <20160919194001.GE2903@pc.thejh.net>
 <20160919195109.GB28639@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z+pzSjdB7cqptWpS"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160919195109.GB28639@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, John Stultz <john.stultz@linaro.org>, Minchan Kim <minchan@kernel.org>, ross.zwisler@linux.intel.com, jmarchan@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Kees Cook <keescook@chromium.org>, oleg@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Mateusz Guzik <mguzik@redhat.com>, Janis Danisevskis <jdanis@google.com>, calvinowens@fb.com, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Seth Forshee <seth.forshee@canonical.com>
List-Id: linux-api@vger.kernel.org


--z+pzSjdB7cqptWpS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 09:51:13PM +0200, Michal Hocko wrote:
> [not sure why the CC list was trimmed - do no do that please unless you
>  have a strong reason for that - if this was not intentional please
>  restpre it]

Ah, sorry, pressed the wrong key.


> On Mon 19-09-16 21:40:01, Jann Horn wrote:
> > On Mon, Sep 19, 2016 at 09:32:38PM +0200, Michal Hocko wrote:
> > > On Mon 19-09-16 11:16:31, Robert Foss wrote:
> > > > On 2016-09-14 05:12 AM, Michal Hocko wrote:
> > > > > On Tue 13-09-16 13:27:39, Sonny Rao wrote:
> > > [...]
> > > > > > Given that smaps
> > > > > > doesn't provide this in a straightforward way, what do you thin=
k is
> > > > > > the right way to provide this information?
> > > > >=20
> > > > > I would be tempted to sneak it into /proc/<pid>/statm because tha=
t looks
> > > > > like a proper place but getting this information is not for free
> > > > > performance wise so I am not really sure something that relies on=
 this
> > > > > file would see unexpected stalls. Maybe this could be worked arou=
nd by
> > > > > some caching... I would suggest to check who is actually using th=
is file
> > > > > (top/ps etc...)
> > > >=20
> > > > What would this caching look like? Can any information be re-used b=
etween
> > > > vma walks?
> > >=20
> > > yes basically return the same value if called within HZ or something
> > > similar. But that assumes that statm latency really matters and it is
> > > called often enough.
> >=20
> > That sounds horrible. If some application decides that they want to che=
ck
> > statm directly after some action or so (like after program startup), th=
is is
> > going to give them a very bad time. That probably doesn't happen
> > often - but still.
> >=20
> > I can already imagine some developer going "yeah, that usleep()... that=
's
> > because the kernel API returns stale information for a couple milliseco=
nds
> > after we do something *shrug*".
> >=20
> > What are you trying to optimize for? Ten users on the same machine, eac=
h of
> > which is running "top" because it looks so great?
>=20
> Please try to read what I wrote again. I didn't say this would be
> needed. The idea was that _if_ /proc/<pid>/statm is used very _often_
> than some caching might help to reduce the overhead. Especially when you
> consider that the information is not precise anyway. It can change
> anytime while you are doing the address space walk.

--z+pzSjdB7cqptWpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4ELjAAoJED4KNFJOeCOovyAP/jKuImSAtuAyzL8Xzq/ko2t9
v/Ot/Qh3/st88jUrhHMrKEqiXeC+ZIoWELs3i2+SFUGJHo/QIiJ+1zfhJo6TSWmc
dQWK3L2XnpntzJMyAZku/OOFpp1D7g9IpbaqN9lnSk33nCuWTp1mCOLKhK1ZyYha
UbB1YnmuhDgsO0t9pMnW8npPB42bZluKxG8rEoWhIYpNuWcwoEFQGGunjI8CTP8+
kxUX7S47Z6P7qJAPVMOtpLqyHPHIQ3oCoGY9+6gmXHi4Xldr8agRGY0i9WzLvihP
NXkhzA7rr0uYjFKznF+t921fO8Get/KzhKh0j1iXFu/w9PPYJtrSyHvS3Av7ePTw
CJ6tKpQULxvYG1VaN1Azk0Q05JJIHVvIkNMZDBI6n7lFRZKvtuSDLeXQCHub+gjf
OhRCwi/soyhc4iORni72xD24IqBmyccuoBmNaoEVW+qligD/j0UmM5Y8JwlfpHXx
iXpNdNPCAy2UODCSZCkmEmFceXBnKvbXd14PjLBRMbKRiX5mrQbeWF0nzxzcwJzS
8YtDkhQK/80uJ/KMIwx9EpJ5ScB6N5OUNmzr4fhgEnNt9TuXKH7jH80A/FHUS6aJ
YUFsfgrOqIbp7ZsQy9czAy2OLFm82iIUta8n4HoiEPpRFpClk8uJcSTnvysgbXm/
M2LrSq8YCOl+hYoKfWax
=EkYk
-----END PGP SIGNATURE-----

--z+pzSjdB7cqptWpS--
