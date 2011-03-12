From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 05:22:38 +0100 (CET)
Message-ID: <e2b2f91fe62188975f8ddc82e581995e.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <20110311235607.GB15853@elie>
    <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
    <20110312021001.GA16833@elie>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110312021001.GA16833@elie>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, March 12, 2011 03:10, Jonathan Nieder wrote:
> Indan Zupancic wrote:
>> I'm not pushing for any official convention, just what seems good taste.
>
> In cases like this, conventions (consistency and best practices) are
> very important.

I'm in no position to decide about this code's fate anyway, I only voice
my opinion in the hope people won't make the mistake of adding this as a
new system call.

>
>> Less code added, less bloat. Architecture independent, no need to update
>> all system call tables everywhere (all archs, libc versions and strace).
>> Two files changed, instead of 7 (which only hooks up x86).
>
> Thanks for explaining.  Those do seem like good reasons to use a ioctl
> instead of a new syscall.

Ioctl or sync_file_range, it's obscure enough for an ioctl I guess.

>> In this case it's just a performance improvement over sync(2). It doesn't
>> add a new feature. Main argument given for the performance problem seems
>> to be "NFS can be slow". Anything else?
>
> Huh?  It is not just the speed of the sync --- unnecessary writeback
> will cause wear on your thumbdrive, eat up your laptop battery, and
> kill I/O performance in other tasks running at the same time.

The writeback will happen sooner or later, so there is no unnecessary
writeback, except if you're overwriting/deleting just written data. If
you're worried about unnecessary writeback then don't do any synching.
You're actually arguing againt this feature and for fsync().

Syncfs won't be called frequently anyway, if it was then fsync could
be used instead. So it's pretty much a slightly better version of sync.

You could call it sync2() and add a path parameter. And after a few
years replace it with sync3 with a flag argument added. Then add a
sync4 with a sigmask too. That seems the new convention and would be
consistent...

I think all new system calls (or other highly visible ABI change) should
have half a year thinking time, and when they're in they're guaranteed to
be not stable for at least 2 years. If after that time they're still in,
they become stable and part of the official ABI. Removing something new
should be as easy as adding something new. But the current trend of easily
added, but hard to remove features is asking for long-term messiness. It
takes time for code to depend on a new feature, so removing bad new stuff
isn't as bad as removing oldstuff. Pity Linus didn't figure that out yet.

> I'm afraid I don't understand what you're saying here at all.  Would
> you say that fsync is superfluous, too?

No, fsync actually makes sense.

Greetings,

Indan
