From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Fri, 11 Mar 2011 12:55:44 +0100
Message-ID: <201103111255.44979.arnd@arndb.de>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <edfa4cf081249734807e582c14253fca.squirrel-2RFepEojUI3wYrDfM2ltn5vKXLoBo5SK@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>
Cc: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Friday 11 March 2011, Indan Zupancic wrote:
> >       http://marc.info/?l=linux-fsdevel&amp;m=127970513829285&amp;w=2
> 
> The patch there seems much more reasonable than introducing a whole
> new systemcall just for 20 lines of kernel code. New system calls are
> added too easily nowadays.

The only problem with adding new system calls is that we are stuck with
the interface until the end of time, so we must be sure not to get it
wrong. The same thing is true for any other interface such as ioctl
or extensions to existing system calls. People usually get away with
adding new ioctls more easily because it is less obvious when they
are added.

	Arnd
