From: Andrew Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/24] proc: pick out a function to iterate task children
Date: Fri, 17 Jul 2015 18:57:29 +0300
Message-ID: <20150717155728.GB6685@odin.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <1436172445-6979-9-git-send-email-avagin@openvz.org>
 <20150714180235.GB8088@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150714180235.GB8088-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 08:02:35PM +0200, Oleg Nesterov wrote:
> On 07/06, Andrey Vagin wrote:
> >
> > -static struct pid *
> > -get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
> > +static struct task_struct *
> > +task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos)
> >  {
> 
> I won't really argue, just a question...
> 
> So this patch changes it to accept/return task_struct rather pid. Why?
> it is better to get/put "struct pid" only, not the whole task_struct.
> 
> If another caller want task_struct, the necessary conversion is simple.

Another caller wants task_struct.

Currently this function receives pid and converts it into task_struct, then
gets the next child and returns its pid. So I try to avoid extra
conversion in task_diag code.

> But again, I won't argue if you think this will complicate the non-proc
> users of this helper.
> 
> Oleg.
> 
