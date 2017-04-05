From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: scope of cred_guard_mutex.
Date: Wed, 05 Apr 2017 12:53:41 -0500
Message-ID: <87shlmbv16.fsf@xmission.com>
References: <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com>
        <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
        <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com>
        <20170402161518.GC12637@redhat.com> <87inmmbjsq.fsf@xmission.com>
        <20170403183728.GB31390@redhat.com> <87fuhpjeco.fsf_-_@xmission.com>
        <20170405160845.GA14536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405160845.GA14536@redhat.com> (Oleg Nesterov's message of
        "Wed, 5 Apr 2017 18:08:45 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/03, Eric W. Biederman wrote:
>>
>> You have asked why I have problems with your patch and so I am going to
>> try to explain.  Partly I want to see a clean set of patches that we
>> can merge into Linus's tree before we make any compromises.  Because the
>> work preparing a clean patchset may inform us of something better.  Plus
>> we need to make something clean and long term maintainable in any event.
>>
>> Partly I object because your understanding and my understanding of
>> cred_guard_mutex are very different.
>
> And I think there is another problem, your understanding and my understanding
> of "clean" differ too much and it seems that we can not convince each other ;)

We have barely begun.  You have not shown anyone what your idea of a
clean fix actually is.  All I have seen from you is a quick hack that is
a hack that is back-portable.

Focusing on the back port is the wrong order to solve the issue in.  We
need to solve this in an upstream mergable and maintainable way and then
we can worry about backports.

>From a userspace perspective.  I find anything in the kernel blocking on
a zombie to be just wrong.  A zombie is dead.  Waiting for a zombie should
in all cases be optional.  The system should not break if we don't reap
a zombie.

You have made a clear case that the zombies need to exist for strace -f
to wait on.  So since the zombies must exist we should make them follow
normal zombie rules.

With your change exec still blocks waiting for zombies.

Furthermore you have to violate the reasonable rule that:
* pre-exec resources are guarded with the pre-exec process cred.
* post-exec resources are guarded with the post-exec process cred.

So from a userspace perspective I think your semantics are absolutely
insane.

We also need clean code to implement all of this (which I am still
inching towards).  But we need to be implementing something that makes
sense from a userspace perspective.


> The last series looks buggy (I'll send more emails later today), but the
> main problem is that - in my opinion! - your approach is "obviously wrong
> and much less clean". But yes, yes, I understand that this is my opinion,
> and I can be wrong.

How is changing fixing the implementation so that we don't block waiting
for zombies to be reaped wrong?

> Eric, I think we need more CC's. Linus, probably security list, the more
> the better.
>
> I am going to resend my series with more CC's, then you can nack it and
> explain what you think we should do. Perhaps someone else will suggest
> a better solution, or at least review the patches. OK?

I will be happy to look but my primary objectionions to your patch were:

- You implemented a hack for backporting rather than fixing things
  cleanly the first time.

- You made comments about cred_guard_mutex and it's scope that when I
  reviewed the code were false.  cred_guard_mutex although probably the
  wrong locking structure is semantically and fundamentally where it
  needs to be.  We can optimize it but we can't change what is protected
  to make our lives easier.

Eric
