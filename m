From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v9 09/11] seccomp: introduce writer locking
Date: Thu, 10 Jul 2014 02:25:12 -0700
Message-ID: <CAGXu5jL6q1d16uA1Yu+QO4eV7zWwcWEWgkZrwmsfymbMvEr6+Q@mail.gmail.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
	<1403911380-27787-10-git-send-email-keescook@chromium.org>
	<20140709184215.GA4866@redhat.com>
	<20140709185549.GB4866@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20140709185549.GB4866@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 9, 2014 at 11:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/09, Oleg Nesterov wrote:
>>
>> On 06/27, Kees Cook wrote:
>> >
>> >  static u32 seccomp_run_filters(int syscall)
>> >  {
>> > -   struct seccomp_filter *f;
>> > +   struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
>>
>> I am not sure...
>>
>> This is fine if this ->filter is the 1st (and only) one, in this case
>> we can rely on rmb() in the caller.
>>
>> But the new filter can be installed at any moment. Say, right after that
>> rmb() although this doesn't matter. Either we need smp_read_barrier_depends()
>> after that, or smp_load_acquire() like the previous version did?
>
> Wait... and it seems that seccomp_sync_threads() needs smp_store_release()
> when it sets thread->filter = current->filter by the same reason?
>
> OTOH. smp_store_release() in seccomp_attach_filter() can die, "current"
> doesn't need a barrier to serialize with itself.

I have lost track of what you're suggesting to change. :)

Since rmb() happens before run_filters, isn't the ACCESS_ONCE
sufficient? We only care that TIF_SECCOMP, mode, and some filter is
valid. In a tsync thread race, it's okay to use not use the deepest
filter node in the list, it just needs A filter.

-Kees

-- 
Kees Cook
Chrome OS Security
