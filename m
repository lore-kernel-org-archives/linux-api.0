From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 2/2] exec: If possible don't wait for ptraced
 threads to be reaped
Date: Mon, 3 Apr 2017 20:12:52 +0200
Message-ID: <20170403181252.GA31390@redhat.com>
References: <87tw7axlr0.fsf@xmission.com>
 <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com>
 <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com>
 <8760ir192p.fsf@xmission.com>
 <878tnkpv8h.fsf_-_@xmission.com>
 <87vaqooggs.fsf_-_@xmission.com>
 <20170402153517.GA12637@redhat.com>
 <877f32k5ew.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <877f32k5ew.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/02, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> > And btw zap_other_threads(may_hang == 0) is racy. Either you need tasklist or
> > exit_notify() should set tsk->exit_state under siglock, otherwise zap() can
> > return the wrong count.
>
> zap_other_thread(tsk, 0) only gets called in the case where we don't
> care about the return value.  It does not get called from fs/exec.c

I meant that may_hang == 0 implies zap_other_threads(do_count => -1) which should
return the number of threads which didn't pass exit_notify(). The returned value
can be wrong unless you change exit_notify() to set exit_state under siglock.

Oleg.
