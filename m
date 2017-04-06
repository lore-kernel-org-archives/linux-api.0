From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: scope of cred_guard_mutex.
Date: Thu, 6 Apr 2017 17:55:40 +0200
Message-ID: <20170406155540.GC7444@redhat.com>
References: <87tw7axlr0.fsf@xmission.com>
 <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com>
 <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com>
 <8760ir192p.fsf@xmission.com>
 <20170402161518.GC12637@redhat.com>
 <87inmmbjsq.fsf@xmission.com>
 <20170403183728.GB31390@redhat.com>
 <87fuhpjeco.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87fuhpjeco.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/03, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> >> I reviewed the code and cred_guard_mutex needs to cover what it covers.
> >
> > I strongly, strongly disagree. Its scope is unnecessary huge, we should narrow
> > it in any case, even if the current code was not bugy. But this is almost
> > offtopic, lets discuss this separately.

And let me repeat/clarify.

I meant, I see absolutely no reason to do copy_strings() with this mutex held,
for example. And note that copy_strings() can use a lot of memory/time, it can
trigger oom,swapping, etc. I also think that we can probably do
check_unsafe_exec() which in particular sets LSM_UNSAFE_ at bit later, but I
am less sure about this and this needs more work.

And perhaps more changes like this to narrow the scope of this mutex. And I
thought you were already agree with this?


> You have asked why I have problems with your patch and so I am going to
> try to explain.  Partly I want to see a clean set of patches that we
> can merge into Linus's tree before we make any compromises.

Sure, me too. I do not see a simple and clean fix, your attempts were wrong
so far and imo were worse even if they were correct.

And this makes me think again that we need to restart this discusion with
more CC's.

> Partly I object because your understanding and my understanding of
> cred_guard_mutex are very different.
>
> As I read and understand the code the job of cred_guard_mutex is to keep
> ptrace (and other threads of the proccess) from interferring in
> exec and to ensure old resources are accessed with permission checks
> using our original credentials and that new and modified resources are
> accessed with permission checks using our new credentials.

Yes, this is clear.

> I object to your patch in particular because you deliberately mess up
> the part of only making old resources available with old creds and
> new resources available with new creds.

Could you spell please? I don't understand.

> AKA What I see neededing to be protected looks something like:
> 	mutex_lock();
>         new_cred = compute_new_cred(tsk);
>         new_mm = compute_new_mm(tsk);
>         tsk->mm = new_mm;
>         tsk->cred = new_cred;
>         zap_other_threads(tsk);
>         update_sighand(tsk);
>         update_signal(tsk);
>         do_close_on_exec();
>         update_tsk_fields(tsk);
>         mutex_unlock();
>
> The only way I can see of reducing the scope of cred_guard_mutex is
> performing work in such a way that ptrace and the other threads can't
> interfere and then taking the lock.  Computing the new mm and the new
> credentials are certainly candidates for that kind of treatment.

OK. And yes, I am not sure this all is optimal, but didn't I say from
the very beginning that unlikely we can change this?

Now let me quote your next email:

On 04/05, Eric W. Biederman wrote:
>
> We have barely begun.  You have not shown anyone what your idea of a
> clean fix actually is.  All I have seen from you is a quick hack that is
> a hack that is back-portable.

Yes. I really tried to make a back-portable fix. Otherwise I would start
with ->notify_count cleanups.

> With your change exec still blocks waiting for zombies.

And this is what we currently do. Whether we should do this may be debatable,
but why do you blame my patch?

> Furthermore you have to violate the reasonable rule that:
> * pre-exec resources are guarded with the pre-exec process cred.
> * post-exec resources are guarded with the post-exec process cred.

For example?

> So from a userspace perspective I think your semantics are absolutely
> insane.

Which semantics were changed by my patch?

> - You made comments about cred_guard_mutex and it's scope that when I
>   reviewed the code were false.

Which of my comments was wrong?

> We can optimize it

And this is what I meant when I said "we should narrow it in any case"

> but we can't change what is protected

I am not that sure. But a) I did not even try to suggest to change anything
in this area right now, and b) I said that unlikely this is possible.

Oleg.
