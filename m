From: Olga Kornievskaia <kolga-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 1/1] destroy_creds.2: new page documenting destroy_creds()
Date: Fri, 11 Aug 2017 09:37:13 -0400
Message-ID: <5881BC11-5F14-4752-BC9D-FDB08E4314AA@netapp.com>
References: <20170807212355.29127-1-kolga@netapp.com>
 <20170807212355.29127-3-kolga@netapp.com>
 <1502281848.12841.2.camel@redhat.com>
 <87378yr2sx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87378yr2sx.fsf-wvvUuzkyo1HefUI2i7LXDhCRmIWqnp/j@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> On Aug 11, 2017, at 3:17 AM, NeilBrown <neilb-IBi9RG/b67k@public.gmane.org> wrote:
>=20
> On Wed, Aug 09 2017, Jeff Layton wrote:
> ....
>>=20
>> Thanks, that helps a bit. I'm less clear on what the higher-level
>> vision is here though:
>>=20
>> Are we all going to be running scripts on logout that scrape
>> /proc/mounts and run fslogout on each? Will this be added to =
kdestroy?
>>=20
>> Or are you aiming to have KCM do this on some trigger? (see:
>> https://fedoraproject.org/wiki/Changes/KerberosKCMCache)
>>=20
>> Also, doing this per-mount seems wrong to me. Shouldn't this be done =
on
>> a per-net-namespace basis or maybe even globally?
>=20
> Having looked at the code, I think this is invalidating cached
> credentials globally -- or at least, globally for all filesystems that
> use sunrpc.

Yes all filesystems that use sunrpc could benefit from by calling the=20
same routine that NFS calls. It only does it per =E2=80=9Cauth=E2=80=9D =
flavor. If you=20
have multiple flavor mounts, only specified one is effected.

> I actually question the premise for wanting to do this.  Tickets have =
a
> timeout and will expire.  Any code that is allowed to get a ticket, =
can
> hold on to it as long as it likes - but it will cease to work after =
the
> expiry time.

However, when kdestroy is called, then any code that tries to use it
will yet. User land is unaware that the kernel has cached his=20
credentials.

>  Hunting out all the places that a key might be cached, and
> invalidating them, seems to deviate from the model. =20

No caching should be valid after credentials were explicitly removed.=20

> If you are concerned
> about leaving credentials around where they can theoretically be
> misused, then set a smaller expiry time.

That=E2=80=99s correct. The only means that people who have complained=20=

about is left with is using short credentials. But security context=20
establishment is not for-free and impacts performance.

> What is the threat-model that this change is supposed to guard =
against?

It=E2=80=99s a limitation of a system that I feel has solution of =
providing the=20
extension to kdestroy that destroys FS creds.

What=E2=80=99s the disadvantage of providing this feature? There are =
folks who=20
have been asking for it. It tightens up the security.

> Looking that the syscall itself:
> 1/ why restrict the call to directories only?

No real reason. It seems unlikely that the practical unlog application =
would=20
open a filesystem specific file and then call the unlog on that file. =
It=E2=80=99ll be
problematic as without creds no close can be done and would leave state
on the server?

> 2/ Every new syscall should have a 'flags' argument, because you never
>    know when you'll need one.

Ok.

>=20
> NeilBrown
>=20
>=20
>>=20
>> It seems like we can afford to be rather cavalier about destroying
>> creds here. Even if we purge creds for a user that should have =
remained
>> valid, we just end up having to re-upcall for them, right?
>> --=20
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
