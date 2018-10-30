From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 14:32:33 -0700
Message-ID: <CAGXu5j+MYbAiSxdhLnQHdOZC-B=FWZoODxzwkYVEUqDc9SHnBQ@mail.gmail.com>
References: <20181029224031.29809-1-tycho@tycho.ws> <20181029224031.29809-2-tycho@tycho.ws>
 <20181030150254.GB3385@redhat.com> <20181030155403.GC7343@cisco>
 <20181030162752.GB7643@redhat.com> <20181030163926.GC7643@redhat.com> <20181030172143.GD7343@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030172143.GD7343@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 30, 2018 at 10:21 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> On Tue, Oct 30, 2018 at 05:39:26PM +0100, Oleg Nesterov wrote:
>> On 10/30, Oleg Nesterov wrote:
>> >
>> > On 10/30, Tycho Andersen wrote:
>> > >
>> > > @@ -828,6 +823,11 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>> > >    */
>> > >   rmb();
>> > >
>> > > + if (!sd) {
>> > > +         populate_seccomp_data(&sd_local);
>> > > +         sd = &sd_local;
>> > > + }
>> > > +
>> >
>> > To me it would be more clean to remove the "if (!sd)" check, case(SECCOMP_RET_TRACE)
>> > in __seccomp_filter() can simply do populate_seccomp_data(&sd_local) unconditionally
>> > and pass &sd_local to __seccomp_filter().
>>
>> Ah, please ignore, emulate_vsyscall() does secure_computing(NULL).

Right.

>>
>> Btw. why __seccomp_filter() doesn't return a boolean?

Because it was wrapped by __secure_computing(). *shrug* The common
method in the kernel is to use int and 0=ok.

>> Or at least, why can't case(SECCOMP_RET_TRACE) simply do
>>
>>       return __seccomp_filter(this_syscall, NULL, true);
>>
>> ?
>
> Yeah, at least the second one definitely makes sense. I can add that
> as a patch in the next version of this series unless Kees does it
> before.

I'd like to avoid changing the return value of __secure_computing() to
just avoid having to touch all the callers. And I'd prefer not to
change __seccomp_filter() to a bool, since I'd like the return values
to be consistent through the call chain.

I find the existing code more readable than a single-line return, just
because it's very explicit. I don't want to have to think any harder
when reading seccomp. ;)

-Kees

-- 
Kees Cook
