From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 12:03:07 -0500
Message-ID: <CAH2r5mvmCfLrxRHje6Wx5X84zxPEHwRMUJGsjvWBujMu7w841w@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com>
	<20656.1335450358@redhat.com>
	<CAH2r5mv1Lijdwk5zsQwYJr4Etb6fhrRyNXm-iFCQX+HecboGrQ@mail.gmail.com>
	<1335453958.9701.10.camel@lade.trondhjem.org>
	<CAH2r5mt5af-_hxBRKK72iD5Gr99bo91ec78Rov8EGVEx8=21mA@mail.gmail.com>
	<1335459642.9701.27.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1335459642.9701.27.camel@lade.trondhjem.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: David Howells <dhowells@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "wine-devel@winehq.org" <wine-devel@winehq.org>, "kfm-devel@kde.org" <kfm-devel@kde.org>, "nautilus-list@gnome.org" <nautilus-list@gnome.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 12:00 PM, Myklebust, Trond
<Trond.Myklebust@netapp.com> wrote:
> On Thu, 2012-04-26 at 11:56 -0500, Steve French wrote:
>> On Thu, Apr 26, 2012 at 10:25 AM, Myklebust, Trond
>> <Trond.Myklebust@netapp.com> wrote:
>> > On Thu, 2012-04-26 at 09:54 -0500, Steve French wrote:
>> >> On Thu, Apr 26, 2012 at 9:25 AM, David Howells <dhowells@redhat.c=
om> wrote:
>> >> > Steve French <smfrench@gmail.com> wrote:
>> >> >
>> >> >> Would it be better to make the stable vs volatile inode number=
 an attribute
>> >> >> of the volume =A0or something returned by the proposed xstat?
>> >> >
>> >> > I'm not sure what you mean by a stable vs a volatile inode numb=
er.
>> >>
>> >> Both NFS and CIFS (and SMB2) can return inode numbers or equivale=
nt
>> >> unique identifier, but in the case of CIFS some old servers don't=
 support the
>> >> calls which return inode numbers (or don't return them for all fi=
le system
>> >> types, Windows FAT?) so in these cases cifs has to create inode
>> >> numbers on the fly
>> >> on the client. =A0 inode numbers created on the client are not "s=
table" they
>> >> can change on unmount/remount (which can cause problems for backu=
p
>> >> applications).
>> >>
>> >> Similarly NFSv4 does not require that servers always return stabl=
e inode numbers
>> >> (that will never change) and introduced a concept of "volatile fi=
le handle."
>> >> We have run into this in two cases (there are probably more) -
>> >> Specialized NFS servers
>> >> for HPC which deal with lots of transient inodes, and second thos=
e for servers
>> >> which base there inode number on path (Windows NFS?). =A0See
>> >> http://docs.oracle.com/cd/E19082-01/819-1634/rfsrefer-137/index.h=
tml
>> >> or the NFSv4 RFC.
>> >>
>> >> Basically the question is whether it is worth reporting a flag on=
 the
>> >> call which returns
>> >> the inode number to indicate that the inode number is "stable" (w=
ould not change
>> >> on reboot or reconnection) or "volatile." =A0 =A0Since the majori=
ty of NFS
>> >> and SMB2 servers
>> >> can return stable inode numbers, I don't feel strongly about the =
need
>> >> for an indicator
>> >> of "stable" vs. "volatile" but I mention it because backup and
>> >> migration applications
>> >> mention this (if inode numbers are volatile, they may have to che=
ck
>> >> for hardlinks differently
>> >> for example)
>> >
>> > I don't understand. If the filesystem doesn't support real inode
>> > numbers, then why report them at all? What use would an applicatio=
n have
>> > for an inode number that can't be used to identify hard linked fil=
es?
>>
>> Well ... you have to have an inode number on the Linux client side e=
ven if
>> the server doesn't report them (or has a bug and reports duplicates)=
=2E
>> If you can't tell hardlinked files apart fix the server (but in the
>> cases where the file systems has this problem the server doesn't usu=
ally
>> support hardlinks either).
>>
>> If the server's file system internal structures don't support real i=
node
>> numbers (such as FAT or a ramdisk) then it either has to make them
>> up based on something like path name or some other attribute of the
>> file on disk.
>>
>> Servers like NetApp is where this gets interesting - for cifs e.g. l=
evel 1009
>> query file info is used to query_file_internal_info (the inode numbe=
r) but
>> what if the server can not report inode numbers (due to a bug) in
>> all cases.
>
> Right, but none of this explains why we need to report these bogus in=
ode
> numbers to the application in the xstat() reply.

the question is whether the application (backup) would need to know
that the inode numbers are bogus and from my conversations with
guys writing backup software it seems that such data is useful to them.


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
