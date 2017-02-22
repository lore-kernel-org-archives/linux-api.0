From: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [RFC 1/3] procfs: fdinfo -- Extend information about epoll target
 files
Date: Wed, 22 Feb 2017 10:44:07 +0300
Message-ID: <58AD4147.20801@virtuozzo.com>
References: <20170221171254.954209904@openvz.org>
 <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
 <20170221191655.GC27653@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170221191655.GC27653@uranus>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/21/2017 10:16 PM, Cyrill Gorcunov wrote:
> On Tue, Feb 21, 2017 at 10:41:12AM -0800, Andy Lutomirski wrote:
>>> Thus lets add file position, inode and device number where
>>> this target lays. This three fields can be used as a primary
>>> key for sorting, and together with kcmp help CRIU can find
>>> out an exact file target (from the whole set of processes
>>> being checkpointed).
>>
>> I have no problem with this, but I'm wondering whether kcmp's ordered
>> comparisons could also be used for this purpose.
> 
> Yes it can, but it would increas number of kcmp calls signisicantly.

Actually it shouldn't. If you extend the kcmp argument to accept the
epollfd:epollslot pair, this would be effectively the same as if you
had all your epoll-ed files injected into your fdtable with "strange"
fd numbers. We already have two-level rbtree for this in criu, adding
extended ("strange") fd to it should be OK.

> Look, here is how we build files tree in criu: we take inode^sdev^pos
> as a primary key and remember it inside rbtree while we're dumping files
> (note also that we don't keep files opened but rather dump them in
> chunks). Then once we find that two files have same primary key
> we use kcmp to build subtree. This really helps a lot. And I plan
> to do the same with target files from epolls:
> 
>  - they gonna be handled after all opened files of all processes
>    in container (or children processes if dumping single task),
>    thus the complete tree with primary key already will be built
> 
>  - on every target file I calculate primary key and then using
>    kcmp will find if file is exactly one matching
> .
> 
