From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Thu, 29 Nov 2018 15:41:38 +0000
Message-ID: <f55261dbc41544363b4348820f67fb01c6d7aaec.camel@bitron.ch>
References: <20181127225408.7553-1-j@bitron.ch>
         <20181127225408.7553-2-j@bitron.ch> <20181128144230.GG30395@redhat.com>
         <87r2f5gr9g.fsf@xmission.com> <20181129123409.GA10645@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129123409.GA10645@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Oleg,

Thanks for the review.

On Thu, 2018-11-29 at 13:34 +0100, Oleg Nesterov wrote:
> To me it would be more clean to call walk_process_tree(kill_descendant_visitor)
> unconditionally in find_new_reaper() right before "if (has_child_subreaper)", but
> then we will need to shift read_lock(tasklist) from walk_process_tree().

Yes, that's the reason why I added the call before the tasklist lock.
Let me know if you want me to move the read lock from
walk_process_tree() to PR_SET_CHILD_SUBREAPER (the only caller)
instead.

> So I think the patch is mostly fine, the only problem I can see is that
> PR_SET_KILL_DESCENDANTS_ON_EXIT can race with PR_SET_CHILD_SUBREAPER, they both
> need to update the bits in the same word.

Good point. I'll make it a regular bool instead of a bitfield for v2,
unless you have another approach in mind to fix this.

Jürg
