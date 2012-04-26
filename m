From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended
 file stats available
Date: Thu, 26 Apr 2012 12:06:22 -0500
Message-ID: <CAH2r5mut083KtCZWMsvC08WtJPJpBxXm6M0HCY4hk8T3hN7xdg@mail.gmail.com>
References: <CAH2r5muMb8m9-fMc_tcfn3ku_s55q9EEbc-vzvoFjPnsDdq1gA@mail.gmail.com>
	<20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419140612.17272.57774.stgit@warthog.procyon.org.uk>
	<20120424212911.GA26073@fieldses.org>
	<18765.1335447954@redhat.com>
	<20120426142816.GB7176@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20120426142816.GB7176@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 26, 2012 at 9:28 AM, J. Bruce Fields <bfields@fieldses.org>=
 wrote:
> On Thu, Apr 26, 2012 at 02:45:54PM +0100, David Howells wrote:
>> Steve French <smfrench@gmail.com> wrote:
>>
>> > I also would prefer that we simply treat the time granularity as p=
art
>> > of the superblock (mounted volume) ie returned on fstat rather tha=
n on
>> > every stat of the filesystem. =A0 For cifs mounts we could conceiv=
ably
>> > have different time granularity (1 or 2 second) on mounts to old
>> > servers rather than 100 nanoseconds.
>>
>> The question is whether you want to have to do a statfs in addition =
to a stat?
>> I suppose you can potentially cache the statfs based on device numbe=
r.
>>
>> That said, there are cases where caching filesystem-level info based=
 on i_dev
>> doesn't work. =A0OpenAFS springs to mind as that only has one superb=
lock and
>> thus one set of device numbers, but keeps all the inodes for all the=
 different
>> volumes it may have mounted there.
>>
>> I don't know whether this would be a problem for CIFS too - say on a=
 windows
>> server you fabricate P:, for example, by joining together several fi=
lesystems
>> (with junctions?). =A0How does this appear on a Linux client when it=
 steps from
>> one filesystem to another within a mounted share?
>
> In the NFS case we do try to preserve filesystem boundaries as well a=
s
> we can--the protocol has an fsid field and the client creates a new
> mount each time it sees it change. =A0And the protocol defines time_d=
elta
> as a per-filesystem attribute (though, somewhat hilariously, there's
> also a per-filesystem "homogeneous" attribute that a server can clear=
 to
> indicate the per-filesystem attributes might actually vary within the
> filesystem.)

Thank you for reminding me, I need to look at this case more ...
although cifs creates  implicit submounts (as we traverse DFS referrals=
)
there are probably cases where we need to do the same thing as NFS
and look at the fsid so we don't run into a Windows server
exporting something with a "junction" (e.g. directory redirection to
a DVD drive for example) and thus cross file system volume boundaries.


--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
