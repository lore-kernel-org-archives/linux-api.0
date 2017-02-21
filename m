From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 1/3] procfs: fdinfo -- Extend information about epoll target files
Date: Tue, 21 Feb 2017 10:41:12 -0800
Message-ID: <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
References: <20170221171254.954209904@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170221171254.954209904-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 21, 2017 at 8:59 AM, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> Since it is possbile to have same number in tfd field (say
> file added, closed, then nother file dup'ed to same number
> and added back) it is imposible to distinguish such target
> files solely by their numbers.
>
> Strictly speaking regular applications don't need to recognize
> these targets at all but for checkpoint/restore sake we need
> to collect targets to be able to push them back on restore
> in proper order.
>
> Thus lets add file position, inode and device number where
> this target lays. This three fields can be used as a primary
> key for sorting, and together with kcmp help CRIU can find
> out an exact file target (from the whole set of processes
> being checkpointed).

I have no problem with this, but I'm wondering whether kcmp's ordered
comparisons could also be used for this purpose.
