From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/3] procfs: fdinfo -- Extend information about epoll
 target files
Date: Wed, 22 Feb 2017 10:54:38 +0300
Message-ID: <20170222075438.GB22938@uranus>
References: <20170221171254.954209904@openvz.org>
 <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
 <20170221191655.GC27653@uranus>
 <58AD4147.20801@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58AD4147.20801-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 22, 2017 at 10:44:07AM +0300, Pavel Emelyanov wrote:
> On 02/21/2017 10:16 PM, Cyrill Gorcunov wrote:
> > On Tue, Feb 21, 2017 at 10:41:12AM -0800, Andy Lutomirski wrote:
> >>> Thus lets add file position, inode and device number where
> >>> this target lays. This three fields can be used as a primary
> >>> key for sorting, and together with kcmp help CRIU can find
> >>> out an exact file target (from the whole set of processes
> >>> being checkpointed).
> >>
> >> I have no problem with this, but I'm wondering whether kcmp's ordered
> >> comparisons could also be used for this purpose.
> > 
> > Yes it can, but it would increas number of kcmp calls signisicantly.
> 
> Actually it shouldn't. If you extend the kcmp argument to accept the
> epollfd:epollslot pair, this would be effectively the same as if you
> had all your epoll-ed files injected into your fdtable with "strange"
> fd numbers. We already have two-level rbtree for this in criu, adding
> extended ("strange") fd to it should be OK.

Nope. Pavel, I guess you forget how we handle file tree in criu currently.
We call for kcmp only if we have to -- when primary key for two entries
is the same.
