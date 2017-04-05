From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC][PATCH v2 3/5] clone: Disallown CLONE_THREAD with a shared sighand_struct
Date: Wed, 05 Apr 2017 12:34:23 -0500
Message-ID: <87o9waep28.fsf@xmission.com>
References: <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com>
        <874ly6a0h1.fsf_-_@xmission.com> <87k2728lrp.fsf_-_@xmission.com>
        <20170405162458.GF14536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405162458.GF14536@redhat.com> (Oleg Nesterov's message of
        "Wed, 5 Apr 2017 18:24:59 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/02, Eric W. Biederman wrote:
>>
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1515,6 +1515,13 @@ static __latent_entropy struct task_struct *copy_process(
>>  	if ((clone_flags & CLONE_THREAD) && !(clone_flags & CLONE_SIGHAND))
>>  		return ERR_PTR(-EINVAL);
>>
>> +	/* Disallow CLONE_THREAD with a shared SIGHAND structure.  No
>> +	 * one cares
>
> Well, can't resists... I won't argue, but we can't know if no one cares
> or not. I agree that most probably this won't break something, but who
> knows... I am always scared when we add the incompatible changes.

I agree that changing userspace semantics is something to be very
careful with.  But at least for purposes of discussion I think this is a
good patch.

I can avoid this change but it requires moving sighand->siglock
into signal_struct and introducing a new spinlock into sighand_struct
to just guard the signal handlers.

However I think the change to move siglock would be a distraction from
the larger issues of this patchset.

Once we address the core issues I will be happy to revisit this.

>> and supporting it leads to unnecessarily complex
>> +	 * code.
>> +	 */
>> +	if ((clone_flags & CLONE_THREAD) && (atomic_read(&current->sighand->count) > 1))
>> +		return ERR_PTR(-EINVAL);
>
> Perhaps the comment should explain why we do this and say that
> sighand-unsharing in de_thread() depends on this.

That would be a better comment.

Eric
