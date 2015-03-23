From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Mon, 23 Mar 2015 14:12:34 +0000
Message-ID: <CAHse=S-e4Rorgzt=LohtNUeVAXTLbpr8ftPGnBZXgO5sQs28RA@mail.gmail.com>
References: <cover.1426376419.git.josh@joshtriplett.org> <CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA@mail.gmail.com>
 <2381173.VxaIO6vGG3@tjmaciei-mobl4> <20150316232949.GB31751@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150316232949.GB31751@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 11:29 PM,  <josh@joshtriplett.org> wrote:
> On Mon, Mar 16, 2015 at 03:14:14PM -0700, Thiago Macieira wrote:
>> On Monday 16 March 2015 14:44:20 Kees Cook wrote:
>> > >               O_CLOEXEC
>> > >                      Set  the  close-on-exec  flag on the new file
>> > >descriptor. See the description of the O_CLOEXEC flag in open(2)  for
>> > >reasons why this may be useful.
>> >
>> > This begs the question: what happens when all CLONE_FD fds for a
>> > process are closed? Will the parent get SIGCHLD instead, will it
>> > auto-reap, or will it be un-wait-able (I assume not this...)
>>
>> Depends on CLONE_AUTOREAP. If it's on, then no one gets SIGCHLD, no one can
>> wait() on it and the process autoreaps itself.
>
> Minor nit: CLONE_AUTOREAP makes the process autoreap and nobody can wait
> on it, but if you pass SIGCHLD or some other exit signal to clone then
> you'll still get that signal.

Quick query: does CLONE_AUTOREAP also affect waiting for non-exit
events (i.e. WUNTRACED / WCONTINUED), by original parent and/or ptracer?
