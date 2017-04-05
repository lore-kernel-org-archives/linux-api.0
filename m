From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][PATCH v2 3/5] clone: Disallown CLONE_THREAD with a
        shared sighand_struct
Date: Wed, 5 Apr 2017 20:11:03 +0200
Message-ID: <20170405181103.GA19444@redhat.com>
References: <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com> <874ly6a0h1.fsf_-_@xmission.com> <87k2728lrp.fsf_-_@xmission.com> <20170405162458.GF14536@redhat.com> <87o9waep28.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o9waep28.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/05, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> I agree that changing userspace semantics is something to be very
> careful with.  But at least for purposes of discussion I think this is a
> good patch.

I agree that we need it with your approach,

but imo it would be much better to not depend on the subtle changes
like this. My 2/2 or your 1/5 are already bad enough.

> I can avoid this change but it requires moving sighand->siglock
> into signal_struct and introducing a new spinlock into sighand_struct
> to just guard the signal handlers.

Oh, this looks much, much worse to me.

Oleg.
