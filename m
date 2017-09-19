From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] ptrace, seccomp: add support for retrieving seccomp flags
Date: Tue, 19 Sep 2017 15:09:02 -0700
Message-ID: <CAGXu5jJfZWxeWg9UNdwteetZtHfXcpsHsz-m1N1vzTTtYkhMyw@mail.gmail.com>
References: <20170919174743.19814-1-tycho@docker.com> <CAGXu5j+0neV5uGm3qNmFSYodWoC3VsMEjP7JkFd5B_ksNFAvkg@mail.gmail.com>
 <20170919210916.6r5janszdtx7eoes@smitten> <CAGXu5jJGPLi0Pc_KHADhCmo9peivN6HP-BDJ5=BJsyMbo3VzWA@mail.gmail.com>
 <20170919215551.kaphydcaqzoesgvy@smitten>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170919215551.kaphydcaqzoesgvy@smitten>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@docker.com>, Linux API <linux-api@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, criu@openvz.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 19, 2017 at 2:55 PM, Tycho Andersen <tycho@docker.com> wrote:
> On Tue, Sep 19, 2017 at 02:43:51PM -0700, Kees Cook wrote:
>> On Tue, Sep 19, 2017 at 2:09 PM, Tycho Andersen <tycho@docker.com> wrote:
>> > Hi Kees,
>> >
>> > On Tue, Sep 19, 2017 at 01:08:28PM -0700, Kees Cook wrote:
>> >> On Tue, Sep 19, 2017 at 10:47 AM, Tycho Andersen <tycho@docker.com> wrote:
>> >> > With the new SECCOMP_FILTER_FLAG_LOG, we need to be able to extract these
>> >> > flags for checkpoint restore, since they describe the state of a filter.
>> >> >
>> >> > So, let's add PTRACE_SECCOMP_GET_FLAGS, similar to ..._GET_FILTER, which
>> >> > returns the flags of the nth filter.
>> >>
>> >> Can you split this up into factoring out the nth helper, and then
>> >> adding the new get?
>> >>
>> >> For naming, perhaps "GET_FILTER_FLAGS" instead of "GET_FLAGS" since
>> >> there may be seccomp flags in the future, etc.
>> >
>> > Sure, I'll do both of these.
>> >
>> >> Is there any sane way to add the flags to the existing GET_FILTER?
>> >
>> > I looked at this, and I don't think so. Unfortunately, we didn't use
>> > any structure for the output, it's just the raw bytes of the filter
>> > with the length used as the return value. I suppose we could append
>> > the flags after the bytes of the filter, but that seems... very ugly
>> > :). Let me know if you want to go that route.
>>
>> I think if we can make the new GET_FILTER_stuff interface more
>> extensible, we should cover any future needs for per-filter content.
>
> Ok, are you interested in something more general than
> GET_FILTER_FLAGS? Maybe GET_FILTER_METADATA with uapi struct like:
>
> struct seccomp_metadata {
>     unsigned int flags;
> };
>
> which you call by something like,
>
> struct seccomp_metadata mymeta;
>
> size = ptrace(PTRACE_SECCOMP_GET_FILTER_METADATA, pid, sizeof(mymeta), &mymeta);
> if (size < 0) {
>     /* error */
> }
> if (size != sizeof(mymeta)) {
>    /* struct seccomp_metadata sizes are different */
> }
>
> ?

Yeah, I think a sizeof could work here as a way to grow the metadata
result in the future.

Adding linux-api@ to see if anyone has thoughts on the best way to
make this future-proof...

-Kees

-- 
Kees Cook
Pixel Security
