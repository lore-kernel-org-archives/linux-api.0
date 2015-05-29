From: "Frank Filz" <ffilzlnx-mn4gwa5WIIQysxA8WJXlww@public.gmane.org>
Subject: RE: [RFC v3 42/45] nfs: Add richacl support
Date: Fri, 29 May 2015 08:54:48 -0700
Message-ID: <045601d09a27$cb8caaa0$62a5ffe0$@mindspring.com>
References: <cover.1429868795.git.agruenba@redhat.com>	<39cf890265e2a906a1cf41d6949b5be69903a064.1429868795.git.agruenba@redhat.com>	<CAHQdGtQyEH9V_XJaQQgPkKGJLy__D0J6cmAHASeEXCZkCCrBjg@mail.gmail.com>	<CAHQdGtQCPqC=L1bxVzEQgwE16P6SX79c02Ex4=D02EQ5BgdGRA@mail.gmail.com>	<CAHpGcML5eG2bQZW1j6mkHLxvAJU=ZBK+cuYEK6dTkoEsT-MVyA@mail.gmail.com> <CAHQdGtR-Gjp11U9JHCe6XuNiXQjYa-H7DQNycyt2H6GeQ1txSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHQdGtR-Gjp11U9JHCe6XuNiXQjYa-H7DQNycyt2H6GeQ1txSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Trond Myklebust' <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, =?utf-8?Q?'Andreas_Gr=C3=BCnbacher'?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: 'Linux Kernel Mailing List' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Linux FS-devel Mailing List' <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Linux API Mailing List' <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> On Fri, May 29, 2015 at 11:00 AM, Andreas Gr=C3=BCnbacher
> <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 2015-05-29 15:15 GMT+02:00 Trond Myklebust
> <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>:
> >> [reply reordered]
> >> So having revisited the reasons why I chose the system.nfs4_acl
> >> interface when we did NFSv4 ACLs, I'm not sure we should implement
> >> system.richacl for the NFS client at all.
> >>
> >> Your assertion that "when symbolic user@domain and group@domain
> names
> >> are used in the acl, user-space needs to perform ID mapping in the
> >> same way as the kernel"  is WRONG. User space needs do no such thi=
ng,
> >> and that was the whole point of the interface; to allow the user t=
o
> >> specify ACLs in a format that is checked only on the _server_, and
> >> not on the client.
> >
> > That's only half true. Right now, user-space applications trying to
> > copy permissions between an nfs mount and another file system will
> > fail unless the application has explicitly been made nfs aware and
> > supports the "system.nfs4_acl"
> > attribute (as well as some other acl mechanism if the permissions g=
o
> > beyond the file mode).
> >
> > The same problem exists when trying to make sense of acls.
> >
> > It seems unreasonable to me to expect applications other than speci=
al
> > file system maintenance tools to cater to such file system
> > differences; there are just too many file systems out there for tha=
t
> > to work. Instead, it would be better to use an interface that can b=
e
> > generalized across file systems.
>=20
> My point is that system.richacl is not such an interface. It can only=
 ever work
> for local filesystems that understand and store local uids and gids. =
It has no
> support for the remote users/groups that are stored on your NFS/SMB
> server unless they happen to have a local mapping into uids and gids,=
 and so
> the API is inappropriate to replace the existing NFSv4 acl API on the=
 client.

Could we have both xattrs? Or a mount option that specifies which xattr=
 to have?

That way folks who don't have local idmapping for every remote identity=
 can use system.nfs4_acl while those who have local mapping for all rem=
ote identies and need to use a wide variety of tools can use system.ric=
hacl? system.richacl would obviously need to be documented that this is=
sue can arise. But that will forever be an issue, unless we store the A=
CL with symbolic names, copying from a remote server to a local filesys=
tem will always be lossy if the idmapping is incomplete.

Maybe that's too messy...

=46rank


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
