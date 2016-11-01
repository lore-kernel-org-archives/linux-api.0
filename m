From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [4.9-rc3] BUG: unable to handle kernel paging request at ffffc900144dfc60
Date: Tue, 1 Nov 2016 17:47:18 -0600
Message-ID: <CA+55aFzphURPFzAvU4z6Moy7ZmimcwPuUdYU8bj9z0J+S8X1rw@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org> <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
 <201611012336.IAC18714.VLMOQSHOFtOFJF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113d2bf2edc259054045f188
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201611012336.IAC18714.VLMOQSHOFtOFJF@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Andrew Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@alien8.de>, Jann Horn <jann@thejh.net>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho.andersen@canonical.com>
List-Id: linux-api@vger.kernel.org

--001a113d2bf2edc259054045f188
Content-Type: text/plain; charset=UTF-8

On Tue, Nov 1, 2016 at 8:36 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> I got an Oops with khungtaskd. This kernel was built with CONFIG_THREAD_INFO_IN_TASK=y .
> Is this same reason?

CONFIG_THREAD_INFO_IN_TASK is always set on x86, but I assume you also
did VMAP_STACK

And yes, it looks like it's the same "touching another process' stack"
issue, just in sched_show_task() called from check_hung_task(), which
seems to have been due to a watchdog triggering. I'm not sure what the
relationship is with the oom killer happening at the same time, but it
makes the whole thing fairly hard to read.

The cleaned-up oops looks like this:

> [  580.803660] BUG: unable to handle kernel paging request at ffffc900144dfc60
> [  580.807153] IP:  thread_saved_pc+0xb/0x20
> [  580.907040] Call Trace:
> [  580.908547]   sched_show_task+0x50/0x240
> [  580.928793]   watchdog+0x3d0/0x4f0
> [  580.930774]   ? watchdog+0x1fd/0x4f0
> [  580.932785]   ? check_memalloc_stalling_tasks+0x820/0x820
> [  580.935649]   kthread+0xfd/0x120
> [  580.937594]   ? kthread_park+0x60/0x60
> [  580.939693]   ? kthread_park+0x60/0x60
> [  580.941743]   ret_from_fork+0x27/0x40
> [  580.944608] Code: 55 48 8b bf d0 01 00 00 be 00 00 00 02 48 89 e5 e8 6b 58 3f 00 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 8b 87 e0 15 00 00 48 89 e5 <48> 8b 40 30 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> [  580.952519] RIP  [<ffffffff81026feb>] thread_saved_pc+0xb/0x20
> [  580.954654]  RSP <ffffc900004c3db8>
> [  580.956272] CR2: ffffc900144dfc60

So we have

  watchdog -> check_hung_uninterruptible_task -> check_hung_task ->
sched_show_task -> thread_saved_pc(), which oopses.

We just checked that task was TASK_UNINTERRUPTIBLE in that chain, but
clearly it races with it dying (due to oom), and so by the time er get
to thread_saved_pc() it's dead and the stack is gone.

Considering that we just print out  a useless hex number, not even a
symbol, and there's a big question mark whether this even makes sense
anyway, I suspect we should just remove it all.  The real information
would have come later as part of "show_stack()", which seems to be
doing the proper  try_get_task_stack().

So I _think_ the fix is to just remove this. Perhaps something like
the attached? Adding scheduler people since this is in their code..

              Linus

--001a113d2bf2edc259054045f188
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iv0579at0

IGtlcm5lbC9zY2hlZC9jb3JlLmMgfCA5IC0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkL2NvcmUuYyBiL2tlcm5lbC9zY2hl
ZC9jb3JlLmMKaW5kZXggNDJkNDAyN2Y5ZTI2Li4zYzMwMjI0NjYzMzEgMTAwNjQ0Ci0tLSBhL2tl
cm5lbC9zY2hlZC9jb3JlLmMKKysrIGIva2VybmVsL3NjaGVkL2NvcmUuYwpAQCAtNTE5NiwxNyAr
NTE5Niw4IEBAIHZvaWQgc2NoZWRfc2hvd190YXNrKHN0cnVjdCB0YXNrX3N0cnVjdCAqcCkKIAkJ
c3RhdGUgPSBfX2ZmcyhzdGF0ZSkgKyAxOwogCXByaW50ayhLRVJOX0lORk8gIiUtMTUuMTVzICVj
IiwgcC0+Y29tbSwKIAkJc3RhdGUgPCBzaXplb2Yoc3RhdF9uYW0pIC0gMSA/IHN0YXRfbmFtW3N0
YXRlXSA6ICc/Jyk7Ci0jaWYgQklUU19QRVJfTE9ORyA9PSAzMgotCWlmIChzdGF0ZSA9PSBUQVNL
X1JVTk5JTkcpCi0JCXByaW50ayhLRVJOX0NPTlQgIiBydW5uaW5nICAiKTsKLQllbHNlCi0JCXBy
aW50ayhLRVJOX0NPTlQgIiAlMDhseCAiLCB0aHJlYWRfc2F2ZWRfcGMocCkpOwotI2Vsc2UKIAlp
ZiAoc3RhdGUgPT0gVEFTS19SVU5OSU5HKQogCQlwcmludGsoS0VSTl9DT05UICIgIHJ1bm5pbmcg
dGFzayAgICAiKTsKLQllbHNlCi0JCXByaW50ayhLRVJOX0NPTlQgIiAlMDE2bHggIiwgdGhyZWFk
X3NhdmVkX3BjKHApKTsKLSNlbmRpZgogI2lmZGVmIENPTkZJR19ERUJVR19TVEFDS19VU0FHRQog
CWZyZWUgPSBzdGFja19ub3RfdXNlZChwKTsKICNlbmRpZgo=
--001a113d2bf2edc259054045f188--
