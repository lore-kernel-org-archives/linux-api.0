From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH 2/2] exec: If possible don't wait for ptraced threads to be reaped
Date: Mon, 03 Apr 2017 16:04:58 -0500
Message-ID: <87inmlnqx1.fsf@xmission.com>
References: <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com>
        <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com>
        <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com>
        <878tnkpv8h.fsf_-_@xmission.com> <87vaqooggs.fsf_-_@xmission.com>
        <20170402153517.GA12637@redhat.com> <877f32k5ew.fsf@xmission.com>
        <20170403181252.GA31390@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170403181252.GA31390@redhat.com> (Oleg Nesterov's message of
        "Mon, 3 Apr 2017 20:12:52 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/02, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > And btw zap_other_threads(may_hang == 0) is racy. Either you need tasklist or
>> > exit_notify() should set tsk->exit_state under siglock, otherwise zap() can
>> > return the wrong count.
>>
>> zap_other_thread(tsk, 0) only gets called in the case where we don't
>> care about the return value.  It does not get called from fs/exec.c
>
> I meant that may_hang == 0 implies zap_other_threads(do_count => -1) which should
> return the number of threads which didn't pass exit_notify(). The returned value
> can be wrong unless you change exit_notify() to set exit_state under
> siglock.

Interesting an existing bug.  I won't deny that one.

Subtle to catch but easy enough to fix.

Eric
