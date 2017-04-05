From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][PATCH 2/2] exec: If possible don't wait for ptraced
        threads to be reaped
Date: Wed, 5 Apr 2017 18:44:30 +0200
Message-ID: <20170405164429.GG14536@redhat.com>
References: <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com> <87vaqooggs.fsf_-_@xmission.com> <20170402153517.GA12637@redhat.com> <877f32k5ew.fsf@xmission.com> <20170403181252.GA31390@redhat.com> <87inmlnqx1.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87inmlnqx1.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/03, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > I meant that may_hang == 0 implies zap_other_threads(do_count => -1) which should
> > return the number of threads which didn't pass exit_notify(). The returned value
> > can be wrong unless you change exit_notify() to set exit_state under
> > siglock.

but I forgot to add that, of course, this problem is very minor because
we can only miss a thread which is already at the end of exit_notify()
so nothing bad can happen.

But imo should be fixed anyway, simply because this looks wrong/racy.
Your recent 4/5 has the same problem.

> Interesting an existing bug.

Hmm... what do you mean? The current code looks fine.

Oleg.
