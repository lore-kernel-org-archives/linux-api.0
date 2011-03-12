From: "Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 04:50:57 +0100 (CET)
Message-ID: <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
    <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
    <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
    <201103111255.44979.arnd@arndb.de>
    <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
    <4D7AC0FE.8070806@gmail.com>
    <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
    <4D7ADFDD.9080108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D7ADFDD.9080108-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, March 12, 2011 03:52, Ric Wheeler wrote:
> Sage was pretty clear in stating the motivation which is the use case you
> think is questionable. Probably not interesting for consumer devices, but
> definitely extremely interesting in large servers with multiple file systems.

Not really, he just said "It is frequently useful to sync a single file system",
without giving any use cases. He then gave two situations where either sync or
fsync isn't sufficient, to which I replied earlier and you called missing the
point. But that's not the same as giving a use case.

>
> In fact, we do it today as mentioned earlier in the thread - this simply
> exports that useful capability in a clean way.

Did you use the remount trick or the ioctl? If the latter, is it sufficient
for your need? If the first, would guaranteeing that mount -o remount,rw
trick will keep working solve the problem for you?

When or why would you want to sync one specific filesystem? As you're doing
it, you could explain your use case better instead of telling me I'm missing
the point.

If sync(2) didn't exist and people wanted to add it I'd complain too. This
has all the problems of sync(2), but with the "not sure if all the files are
on the file system I think" problem added.

Greetings,

Indan
