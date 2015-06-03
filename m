From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Wed, 3 Jun 2015 10:11:43 -0700
Message-ID: <CALCETrWq12bmire=XwaPCtiJs3-80McaZJzyVt3U5dTHge8LxQ@mail.gmail.com>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <20150602182829.GA23449@redhat.com> <20150603144303.GC3160@smitten> <20150603164121.GA19189@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150603164121.GA19189@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tycho.andersen@canonical.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 3, 2015 at 9:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/03, Tycho Andersen wrote:
>>
>> On Tue, Jun 02, 2015 at 08:28:29PM +0200, Oleg Nesterov wrote:
>> > On 06/01, Tycho Andersen wrote:
>> > >
>> > > --- a/include/linux/seccomp.h
>> > > +++ b/include/linux/seccomp.h
>> > > @@ -25,6 +25,9 @@ struct seccomp_filter;
>> > >  struct seccomp {
>> > >   int mode;
>> > >   struct seccomp_filter *filter;
>> > > +#ifdef CONFIG_CHECKPOINT_RESTORE
>> > > + bool suspended;
>> > > +#endif
>> >
>> > Then afaics you need to change copy_seccomp() to clear ->suspended.
>> > At least if the child is not traced.
>>
>> Yes, thank you.
>
> And if we really need to play with TIF_NOTSC, then copy_seccomp() should
> set it too if SUSPEND has cleared in parent's flags.
>
>> > But why do we bother to play with TIF_NOTSC, could you explain?
>>
>> The procedure for restoring is to call seccomp suspend, restore the
>> seccomp filters (and potentially other stuff), and then resume them at
>> the end. If the other stuff happens to use RDTSC, the process gets
>> killed because TIF_NOTSC has been set.
>
> This is clear, just I thought that CRIU doesn't use rdtsc on behalf of
> the traced task...
>
>> We can work around this in criu by doing the seccomp restore as the
>> very last thing before the final sigreturn,
>
> Not sure I understand... You need to suspend at "dump" time too afaics,
> otherwise, say, syscall_seized() can fail because this syscall is nacked
> by seccomp?
>
>> but that seems like the
>> seccomp suspend API is incomplete, IMO. However, since both you and
>> Andy complained, perhaps I should remove it :)
>
> Well, this is up to you ;)
>
> But. Note that a process can also disable TSC via PR_SET_TSC. So if
> dump or restore can't work without enabling TSC you probably want to
> handle this case too.
>
> And this makes me think that this needs a separate interface. I dunno.
>

True.  Or we could keep track of all the reasons the TSC is off.

--Andy
