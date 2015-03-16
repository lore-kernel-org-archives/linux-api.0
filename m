From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Mon, 16 Mar 2015 16:26:12 -0700
Message-ID: <CAGXu5j+rCaWke5ajy3Lb4jWs+o_P-XidBCMGNqg7w5sVwbDRxA@mail.gmail.com>
References: <cover.1426376419.git.josh@joshtriplett.org>
	<2381173.VxaIO6vGG3@tjmaciei-mobl4>
	<CAGXu5jJr_DieZ281=H0ZNtNvOagO0pm8PRfNvRWKp4YwS=55GA@mail.gmail.com>
	<2152593.rzz5GT2AaC@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2152593.rzz5GT2AaC@tjmaciei-mobl4>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 3:50 PM, Thiago Macieira
<thiago.macieira@intel.com> wrote:
> On Monday 16 March 2015 15:36:16 Kees Cook wrote:
>> And just so I understand the races here, what happens in CLONE_FD
>> (without CLONE_AUTOREAP) case where the child dies, but the parent
>> never reads from the CLONE_FD fd, and closes it (or dies)? Will the
>> modes switch that late in the child's lifetime? (i.e. even though the
>> details were written to the fd, they were never read, yet it'll still
>> switch and generate a SIGCHLD, etc?)
>
> What happens to a child that dies during the parent's lifetime but the parent
> exits without reaping the child?
>
> The same should happen, whatever that behaviour is.

Okay, sounds like the waitpid internals are tied to the read, not the
child death. Perfect, that means it'll still be waitpid-able by
whatever process inherits the zombie. Sounds good! Thanks for
clarifying. :)

-Kees

-- 
Kees Cook
Chrome OS Security
