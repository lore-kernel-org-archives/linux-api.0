From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: scope of cred_guard_mutex.
Date: Fri, 7 Apr 2017 15:07:24 -0700
Message-ID: <CAGXu5jLDQTZm8meX3bkPgjg3GdfXEOA6Z8Boy0HZeM04G7yasQ@mail.gmail.com>
References: <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com>
 <20170402161518.GC12637@redhat.com> <87inmmbjsq.fsf@xmission.com>
 <20170403183728.GB31390@redhat.com> <87fuhpjeco.fsf_-_@xmission.com> <20170406155540.GC7444@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170406155540.GC7444-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 6, 2017 at 8:55 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> And this makes me think again that we need to restart this discusion with
> more CC's.

I'm a fan of that; I've not been able to follow this thread as it
seems to have gone far from the original deadlock problem. :) I've
seen issues with ptrace, zombies, and now exec. I'm lost. :P

>> Partly I object because your understanding and my understanding of
>> cred_guard_mutex are very different.
>>
>> As I read and understand the code the job of cred_guard_mutex is to keep
>> ptrace (and other threads of the proccess) from interferring in
>> exec and to ensure old resources are accessed with permission checks
>> using our original credentials and that new and modified resources are
>> accessed with permission checks using our new credentials.
>
> Yes, this is clear.

Maybe stupid idea: can we get a patch that just adds this kind of
documentation somewhere in the source? If we can agree on the purpose
of cred_guard_mutex, and get it into the code, that seems like a good
step in discussion...

-Kees

-- 
Kees Cook
Pixel Security
