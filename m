From: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v3 0/3] VFS/NFS support to destroy FS credentials
Date: Fri, 11 Aug 2017 16:53:55 +1000
Message-ID: <8760dur3wc.fsf@notabene.neil.brown.name>
References: <20170807212355.29127-1-kolga@netapp.com> <9674.1502283345@warthog.procyon.org.uk> <CAN-5tyE11DaCCXdn3y+Q4V+Lyt_UgtzU+JBhwP68gxQc5_v6pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyE11DaCCXdn3y+Q4V+Lyt_UgtzU+JBhwP68gxQc5_v6pQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Olga Kornievskaia <kolga-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu, Aug 10 2017, Olga Kornievskaia wrote:

> On Wed, Aug 9, 2017 at 8:55 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> You may also want to flush any outstanding dirty data and wait for in-progress
>> operations.
>
> Sorry for the delayed response but I've been thinking about it as this
> is a tricky one (for me at least).
>
> Even currently, each file system needs a way to deal with flushing
> cached data to storage in the situation where creds might have expired
> in between when the kernel returned control back to the user but
> before all of buffered writes are flushed. NFS4.1 has wording in the
> spec for using machine credentials in that case.
>
> At the VFS layer, there no what to tell which dirty data belongs to
> which user. Flushing all data under the superblock seems like a bad
> idea?

NFS flushes data when the file descriptor is closed.  So as long as the
user does have any open-for-write file descriptors, their data should be
safe.  Purging credentials while you still have open-for-write file
descriptors is probably not a good idea.

This is not the case if you "nocto" mount option is used, but that is
recommended only for read-mostly mounts.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmNVIUACgkQOeye3VZi
gbl03g//dlMLAoWD/cORU21y0HTUgjLnQAI6ovj6OpIYjdbO6D42jSr7f8BmCrjq
wi5caEa0RUyAhwassJr0HpCfmunW0hhDnulItxnzMGJPFsnhwjV3ALm5+lospGAE
deYtT8iy22WQAH7WsQyznUOqSxxFlvGQ3xE43k+YzzAE1urAWF25utIykN9mykTa
sMIUsiSrSPBEXcklGaWj1gklNz83G7NXvUHC5PfDw8Xup2li+zt9RmZfss5w9rH6
rO8PpYYM+OEf9uU75Egd7/3OL6TmyZRw2w5kEilObhIF2knyAGXWi6JTeHE8Nv0G
jVQRzjx6p2FdjZMH6nQpoBbclPgCgAZQEek94/lEgc34M076TlQ5Cn9rra07fMuk
cymBx5qZqVZUu5D+vhS+hb7JNb08sfPbr5Uz9vZvSA2MI9cyyl36ZtLsFLLhbElN
YWvLaRyVkjs8XjHx/Lqp1SPz7S6LJzzsF8u8tqHuvrNYc5Ufd8Hzr9eD29Ddwdn1
W95Ntm1FCveGLvTdTRoT7ac059MleyyskFWmzcveR2yWepwHRpLyGPxO9Zha5eXv
38tMHM8Z8G7P3k51Ac10Yk5MHMOFp7HhSUTEIynNYecORSMgQ6oTnhIYdV3PZ3sx
Urp4hXAHx+fle0QoBsjw6z5agpTGIaPlB+INS9yQPC4ITiZgaiY=
=CPOV
-----END PGP SIGNATURE-----
--=-=-=--
