From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Fri, 30 Nov 2018 11:33:30 +0100
Message-ID: <20181130103329.GB23670@redhat.com>
References: <20181127225408.7553-1-j@bitron.ch>
 <20181127225408.7553-2-j@bitron.ch>
 <20181128144230.GG30395@redhat.com>
 <87r2f5gr9g.fsf@xmission.com>
 <20181129123409.GA10645@redhat.com>
 <f55261dbc41544363b4348820f67fb01c6d7aaec.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f55261dbc41544363b4348820f67fb01c6d7aaec.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/29, Jürg Billeter wrote:
>
> On Thu, 2018-11-29 at 13:34 +0100, Oleg Nesterov wrote:
> > To me it would be more clean to call walk_process_tree(kill_descendant_visitor)
> > unconditionally in find_new_reaper() right before "if (has_child_subreaper)", but
> > then we will need to shift read_lock(tasklist) from walk_process_tree().
>
> Yes, that's the reason why I added the call before the tasklist lock.
> Let me know if you want me to move the read lock from
> walk_process_tree() to PR_SET_CHILD_SUBREAPER (the only caller)
> instead.

I am fine either way. We can do this later, lets keep your patch simple.

> > So I think the patch is mostly fine, the only problem I can see is that
> > PR_SET_KILL_DESCENDANTS_ON_EXIT can race with PR_SET_CHILD_SUBREAPER, they both
> > need to update the bits in the same word.
>
> Good point. I'll make it a regular bool instead of a bitfield for v2,

Agreed,

> unless you have another approach in mind to fix this.

Well, I think that is_child_subreaper/has_child_subreaper and the new
kill_descendants_on_exit should live in signal->flags, but we need some
cleanups to make this possible, so I agree with the boolean.

Oleg.
