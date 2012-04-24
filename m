From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended
 file stats available
Date: Tue, 24 Apr 2012 17:08:28 -0500
Message-ID: <CAH2r5muMb8m9-fMc_tcfn3ku_s55q9EEbc-vzvoFjPnsDdq1gA@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419140612.17272.57774.stgit@warthog.procyon.org.uk>
	<20120424212911.GA26073@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120424212911.GA26073-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 24, 2012 at 4:29 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>=
 wrote:
> On Thu, Apr 19, 2012 at 03:06:12PM +0100, David Howells wrote:
>> Add a pair of system calls to make extended file stats available, in=
cluding
>> file creation time, inode version and data version where available t=
hrough the
>> underlying filesystem.
>>
>> The idea was initially proposed as a set of xattrs that could be ret=
rieved with
>> getxattr(), but the general preferance proved to be for new syscalls=
 with an
>> extended stat structure.
>>
>> This has a number of uses:
>>
>> =A0(1) Creation time: The SMB protocol carries the creation time, wh=
ich could be
>> =A0 =A0 =A0exported by Samba, which will in turn help CIFS make use =
of FS-Cache as
>> =A0 =A0 =A0that can be used for coherency data.
>>
>> =A0 =A0 =A0This is also specified in NFSv4 as a recommended attribut=
e and could be
>> =A0 =A0 =A0exported by NFSD [Steve French].
>>
>> =A0(2) Lightweight stat: Ask for just those details of interest, and=
 allow a
>> =A0 =A0 =A0netfs (such as NFS) to approximate anything not of intere=
st, possibly
>> =A0 =A0 =A0without going to the server [Trond Myklebust, Ulrich Drep=
per].
>>
>> =A0(3) Heavyweight stat: Force a netfs to go to the server, even if =
it thinks its
>> =A0 =A0 =A0cached attributes are up to date [Trond Myklebust].
>>
>> =A0(4) Inode generation number: Useful for FUSE and userspace NFS se=
rvers [Bernd
>> =A0 =A0 =A0Schubert].
>>
>> =A0(5) Data version number: Could be used by userspace NFS servers [=
Aneesh Kumar].
>>
>> =A0 =A0 =A0Can also be used to modify fill_post_wcc() in NFSD which =
retrieves
>> =A0 =A0 =A0i_version directly, but has just called vfs_getattr(). =A0=
It could get it
>> =A0 =A0 =A0from the kstat struct if it used vfs_xgetattr() instead.
>>
>> =A0(6) BSD stat compatibility: Including more fields from the BSD st=
at such as
>> =A0 =A0 =A0creation time (st_btime) and inode generation number (st_=
gen) [Jeremy
>> =A0 =A0 =A0Allison, Bernd Schubert].
>>
>> =A0(7) Extra coherency data may be useful in making backups [Andreas=
 Dilger].
>>
>> =A0(8) Allow the filesystem to indicate what it can/cannot provide: =
A filesystem
>> =A0 =A0 =A0can now say it doesn't support a standard stat feature if=
 that isn't
>> =A0 =A0 =A0available, so if, for instance, inode numbers or UIDs don=
't exist...
>>
>> =A0(9) Make the fields a consistent size on all arches and make them=
 large.
>>
>> (10) Store a 16-byte volume ID in the superblock that can be returne=
d in struct
>> =A0 =A0 =A0xstat [Steve French].
>>
>> (11) Include granularity fields in the time data to indicate the gra=
nularity of
>> =A0 =A0 =A0each of the times (NFSv4 time_delta) [Steve French].
>
> It looks like you're including this with *each* time? =A0But surely
> there's no filesystem with different granularity (say) for ctime than
> for mtime. =A0Also, nfsd will want only one time_delta, not one for e=
ach
> time.
>
> Note also we need to document carefully what this means: I think it
> should be the granularity that the filesystem is capable of
> representing, but people are sometimes surprised to find out that the
> actual time source is usually more coarse-grained than that.

I also would prefer that we simply treat the time granularity as part
of the superblock (mounted volume) ie returned on fstat rather than on
every stat of the filesystem.   For cifs mounts we could conceivably
have different time granularity (1 or 2 second) on mounts to old
servers rather than 100 nanoseconds.


--=20
Thanks,

Steve
