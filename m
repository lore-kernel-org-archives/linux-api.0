From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][PATCH v2 4/5] exec: If possible don't wait for ptraced
        threads to be reaped
Date: Wed, 5 Apr 2017 18:15:28 +0200
Message-ID: <20170405161528.GC14536@redhat.com>
References: <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com> <874ly6a0h1.fsf_-_@xmission.com> <87efxa8lq7.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87efxa8lq7.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/02, Eric W. Biederman wrote:
>
> Take advantage of the situation when sighand->count == 1 to only wait
> for threads to reach EXIT_ZOMBIE instead of EXIT_DEAD in de_thread.

Let me comment this patch first, it looks mostly fine to me.

And note that this is what my patch does too: exec() waits until
all threads pass exit_notify() and drops cred_guard_mutex.

However, with my patch patch exec() then waits until all threads
disappear. This is uglifies the code but this is simple and safe.

With your patches exec doesn't do another wait and succeeds after
the 1st wait. I think this is wrong and the next patch is not enough.

Oleg.
