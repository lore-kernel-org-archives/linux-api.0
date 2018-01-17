From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Wed, 17 Jan 2018 11:43:35 +0100
Message-ID: <20180117104335.m3oo3ee2xmercau3@ws.net.home>
References: <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <28167.1516032442@warthog.procyon.org.uk>
 <22576.1516097412@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <22576.1516097412-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 16, 2018 at 10:10:12AM +0000, David Howells wrote:
> Inside the kernel the MS_* flags appear to belong to a number of fundamentally
> different classes:

Good point, but I'm not sure about your terminology -- for example
"topology" sounds strange if we use "propagation" for years.

>  (1) Things like MS_SILENT and MS_REMOUNT which affect the behaviour of the
>      mount process, but aren't persistent beyond that.

 mount-operation flags  (now including MS_BIND too)

>  (2) Inter-namespace topology management, controlling how mounts are shared
>      and duplicated between namespaces.

 propagation flags

>  (3) Restrictions on accesses through a particular mountpoint, eg. MS_NODEV,
>      MS_NOEXEC.

 VFS flags (now including MS_BIND|MS_REMOUNT|MS_RDONLY too)

>  (4) Instructions to a filesystem on how a superblock is to behave.

 FS flags

> I think the classes are fundamentally different - and we've already separated
> (4) from the others inside the kernel.  However, I've no great objection to
> keeping (2) and (3) together in the same mask.  It just sounds cleaner to
> separate them. 

 I agree.

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
