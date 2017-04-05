From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: scope of cred_guard_mutex.
Date: Wed, 5 Apr 2017 18:08:45 +0200
Message-ID: <20170405160845.GA14536@redhat.com>
References: <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <20170402161518.GC12637@redhat.com> <87inmmbjsq.fsf@xmission.com> <20170403183728.GB31390@redhat.com> <87fuhpjeco.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fuhpjeco.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/03, Eric W. Biederman wrote:
>
> You have asked why I have problems with your patch and so I am going to
> try to explain.  Partly I want to see a clean set of patches that we
> can merge into Linus's tree before we make any compromises.  Because the
> work preparing a clean patchset may inform us of something better.  Plus
> we need to make something clean and long term maintainable in any event.
>
> Partly I object because your understanding and my understanding of
> cred_guard_mutex are very different.

And I think there is another problem, your understanding and my understanding
of "clean" differ too much and it seems that we can not convince each other ;)

The last series looks buggy (I'll send more emails later today), but the
main problem is that - in my opinion! - your approach is "obviously wrong
and much less clean". But yes, yes, I understand that this is my opinion,
and I can be wrong.

Eric, I think we need more CC's. Linus, probably security list, the more
the better.

I am going to resend my series with more CC's, then you can nack it and
explain what you think we should do. Perhaps someone else will suggest
a better solution, or at least review the patches. OK?

Oleg.
