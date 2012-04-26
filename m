From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 12:10:50 -0500
Message-ID: <CAH2r5mu6i6aKLqt2EagBECSEU7jxsy-muAwcXThKJ51cd+CHpQ@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com>
	<20656.1335450358@redhat.com>
	<CAH2r5mv1Lijdwk5zsQwYJr4Etb6fhrRyNXm-iFCQX+HecboGrQ@mail.gmail.com>
	<1335453958.9701.10.camel@lade.trondhjem.org>
	<CAH2r5mt5af-_hxBRKK72iD5Gr99bo91ec78Rov8EGVEx8=21mA@mail.gmail.com>
	<1335459642.9701.27.camel@lade.trondhjem.org>
	<CAH2r5mvmCfLrxRHje6Wx5X84zxPEHwRMUJGsjvWBujMu7w841w@mail.gmail.com>
	<1335460011.9701.30.camel@lade.trondhjem.org>
	<CAH2r5muXk+frkFz9X523Ny=RMwJGeqOPH75G1ToNa5QoMo5SkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muXk+frkFz9X523Ny=RMwJGeqOPH75G1ToNa5QoMo5SkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org" <wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org>, "kfm-devel-RoXCvvDuEio@public.gmane.org" <kfm-devel-RoXCvvDuEio@public.gmane.org>, "nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org" <nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 12:09 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Thu, Apr 26, 2012 at 12:06 PM, Myklebust, Trond
> <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
>> On Thu, 2012-04-26 at 12:03 -0500, Steve French wrote:
>>> On Thu, Apr 26, 2012 at 12:00 PM, Myklebust, Trond
>>> <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
>>> > On Thu, 2012-04-26 at 11:56 -0500, Steve French wrote:
>>> >> On Thu, Apr 26, 2012 at 10:25 AM, Myklebust, Trond
>>> >> <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
>>> >> > On Thu, 2012-04-26 at 09:54 -0500, Steve French wrote:
>>> >> >> On Thu, Apr 26, 2012 at 9:25 AM, David Howells <dhowells@redh=
at.com> wrote:
>>> >> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> >> >> >
>>> >> >> >> Would it be better to make the stable vs volatile inode nu=
mber an attribute
>>> >> >> >> of the volume =A0or something returned by the proposed xst=
at?
>>> >> >> >
>>> >> >> > I'm not sure what you mean by a stable vs a volatile inode =
number.
>>> >> >>
>>> >> >> Both NFS and CIFS (and SMB2) can return inode numbers or equi=
valent
>>> >> >> unique identifier, but in the case of CIFS some old servers d=
on't support the
>>> >> >> calls which return inode numbers (or don't return them for al=
l file system
>>> >> >> types, Windows FAT?) so in these cases cifs has to create ino=
de
>>> >> >> numbers on the fly
>>> >> >> on the client. =A0 inode numbers created on the client are no=
t "stable" they
>>> >> >> can change on unmount/remount (which can cause problems for b=
ackup
>>> >> >> applications).
>>> >> >>
>>> >> >> Similarly NFSv4 does not require that servers always return s=
table inode numbers
>>> >> >> (that will never change) and introduced a concept of "volatil=
e file handle."
>>> >> >> We have run into this in two cases (there are probably more) =
-
>>> >> >> Specialized NFS servers
>>> >> >> for HPC which deal with lots of transient inodes, and second =
those for servers
>>> >> >> which base there inode number on path (Windows NFS?). =A0See
>>> >> >> http://docs.oracle.com/cd/E19082-01/819-1634/rfsrefer-137/ind=
ex.html
>>> >> >> or the NFSv4 RFC.
>>> >> >>
>>> >> >> Basically the question is whether it is worth reporting a fla=
g on the
>>> >> >> call which returns
>>> >> >> the inode number to indicate that the inode number is "stable=
" (would not change
>>> >> >> on reboot or reconnection) or "volatile." =A0 =A0Since the ma=
jority of NFS
>>> >> >> and SMB2 servers
>>> >> >> can return stable inode numbers, I don't feel strongly about =
the need
>>> >> >> for an indicator
>>> >> >> of "stable" vs. "volatile" but I mention it because backup an=
d
>>> >> >> migration applications
>>> >> >> mention this (if inode numbers are volatile, they may have to=
 check
>>> >> >> for hardlinks differently
>>> >> >> for example)
>>> >> >
>>> >> > I don't understand. If the filesystem doesn't support real ino=
de
>>> >> > numbers, then why report them at all? What use would an applic=
ation have
>>> >> > for an inode number that can't be used to identify hard linked=
 files?
>>> >>
>>> >> Well ... you have to have an inode number on the Linux client si=
de even if
>>> >> the server doesn't report them (or has a bug and reports duplica=
tes).
>>> >> If you can't tell hardlinked files apart fix the server (but in =
the
>>> >> cases where the file systems has this problem the server doesn't=
 usually
>>> >> support hardlinks either).
>>> >>
>>> >> If the server's file system internal structures don't support re=
al inode
>>> >> numbers (such as FAT or a ramdisk) then it either has to make th=
em
>>> >> up based on something like path name or some other attribute of =
the
>>> >> file on disk.
>>> >>
>>> >> Servers like NetApp is where this gets interesting - for cifs e.=
g. level 1009
>>> >> query file info is used to query_file_internal_info (the inode n=
umber) but
>>> >> what if the server can not report inode numbers (due to a bug) i=
n
>>> >> all cases.
>>> >
>>> > Right, but none of this explains why we need to report these bogu=
s inode
>>> > numbers to the application in the xstat() reply.
>>>
>>> the question is whether the application (backup) would need to know
>>> that the inode numbers are bogus and from my conversations with
>>> guys writing backup software it seems that such data is useful to t=
hem.
>>
>> You are still not explaining why they need to know the values at all=
? If
>> the values are bogus, then don't return them, and don't set the flag
>> that says they are being returned.
>
> I don't know, but assumed it was because it was an easy way
> to index them since the inode numbers even if they "change"
> on remount, are still unique.

if the call allows the inode number not to be returned, that
is probably ok (they can always use the posix stat to get
the client generated one)



--=20
Thanks,

Steve
