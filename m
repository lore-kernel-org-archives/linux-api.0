From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [4.9-rc3] BUG: unable to handle kernel paging request at
 ffffc900144dfc60
Date: Thu, 3 Nov 2016 07:32:23 +0100
Message-ID: <20161103063223.GA3267@gmail.com>
References: <cover.1475257877.git.luto@kernel.org>
 <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <201611012336.IAC18714.VLMOQSHOFtOFJF@I-love.SAKURA.ne.jp>
 <CA+55aFzphURPFzAvU4z6Moy7ZmimcwPuUdYU8bj9z0J+S8X1rw@mail.gmail.com>
 <201611021950.FEJ34368.HFFJOOMLtQOVSF@I-love.SAKURA.ne.jp>
 <CA+55aFwAe6EL5Epo1WopkJVfpf7f+ZDnHjJuNR8=qCv+Trr8qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwAe6EL5Epo1WopkJVfpf7f+ZDnHjJuNR8=qCv+Trr8qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Andrew Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Jann Horn <jann@thejh.net>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho.andersen@canonical.com>
List-Id: linux-api@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Nov 2, 2016 at 4:50 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >>
> >> So I _think_ the fix is to just remove this. Perhaps something like
> >> the attached? Adding scheduler people since this is in their code..
> >
> > That is not sufficient, for another Oops occurs inside stack_not_used().
> > Since I don't want to break stack_not_used(), can we tolerate nested
> > try_get_task_stack() usage and protect the whole sched_show_task()?
> 
> Sure, looks good to me.
> 
> But as Andy says, we should probably apply my patch too, just to get
> rid of the useless hex printk and the ugly ifdeffery.

Agreed, and I have applied both fixes to sched/urgent.

Thanks,

	Ingo
