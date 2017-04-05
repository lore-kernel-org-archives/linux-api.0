From: Kees Cook <keescook@chromium.org>
Subject: Re: scope of cred_guard_mutex.
Date: Wed, 5 Apr 2017 09:11:18 -0700
Message-ID: <CAGXu5j+ngHnxcauv1aJYZke0TQ8LxMxt9nv-=q+EjG33dPzyrA@mail.gmail.com>
References: <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com>
 <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
 <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com>
 <20170402161518.GC12637@redhat.com> <87inmmbjsq.fsf@xmission.com>
 <20170403183728.GB31390@redhat.com> <87fuhpjeco.fsf_-_@xmission.com> <20170405160845.GA14536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405160845.GA14536@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 5, 2017 at 9:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
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
>
> The last series looks buggy (I'll send more emails later today), but the
> main problem is that - in my opinion! - your approach is "obviously wrong
> and much less clean". But yes, yes, I understand that this is my opinion,
> and I can be wrong.
>
> Eric, I think we need more CC's. Linus, probably security list, the more
> the better.
>
> I am going to resend my series with more CC's, then you can nack it and
> explain what you think we should do. Perhaps someone else will suggest
> a better solution, or at least review the patches. OK?

I've been following along, but it seems like there are a lot of edge
cases in these changes. I'll try to meaningfully comment on the coming
emails... having code examples of why various things will/won't work
go a long way for helping understand what's safe or not...

-Kees

-- 
Kees Cook
Pixel Security
