From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 02:53:35 +0100 (CET)
Message-ID: <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <20110311235607.GB15853@elie>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311235607.GB15853@elie>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, March 12, 2011 00:56, Jonathan Nieder wrote:
> Indan Zupancic wrote:
>
>> If there still is a good reason to implement this, please don't add it
>> as a new system call, but add it to sync_file_range(), as that seems
>> the best place for odd file synchronisation operations.
>
> I have no strong preference about how this is added (and in fact I'm
> quite ignorant about the usual conventions), but:

I'm not pushing for any official convention, just what seems good taste.

>  - as a sysadmin, it really _would_ be nice to be able to say
>    "sync /usr" to sync /usr;

This is independent of the implementation.

>  - the existing functionality of sync_file_range is about controlling
>    writeback behavior for files, not mounts.

True, but what happens when you sync a mount? In the end it's about odd,
non-standard syncing behaviour, so I think it fits sync_file_range well.
Like sync_file_range, it's trickier to use than it seems at first, so it
fits well with the other "keep this in mind before using it" requirements.

> So unless there is a shortage of syscall numbers or something, I find
> the request to omit this or tack it onto sync_file_range odd.  Could
> you explain the benefit?

Less code added, less bloat. Architecture independent, no need to update
all system call tables everywhere (all archs, libc versions and strace).
Two files changed, instead of 7 (which only hooks up x86). The code ends
up near the code it calls, so it makes contextual sense.

As for the reason not to add it at all, well, if everything that seemed
a good idea at the time was added as a system call it would be an even
bigger mess than it already is. So it doesn't have to be a bad idea to
not make it, not being useful enough is sufficient.

In this case it's just a performance improvement over sync(2). It doesn't
add a new feature. Main argument given for the performance problem seems
to be "NFS can be slow". Anything else?

Greetings,

Indan
