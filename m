From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Thu, 27 Sep 2018 16:10:29 -0700
Message-ID: <CAGXu5jJ8VSJ6BqqxAL+B12bv2xTNU3CzpBOMf-zEChO9opaFMA@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com> <20180927224839.GF15491@cisco.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927224839.GF15491@cisco.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>, Stephane Graber <stgraber@ubuntu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 3:48 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
>> On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
>> struct seccomp_notif {
>>         __u16                      len;                  /*     0     2 */
>>
>>         /* XXX 6 bytes hole, try to pack */
>>
>>         __u64                      id;                   /*     8     8 */
>>         __u32                      pid;                  /*    16     4 */
>>         __u8                       signaled;             /*    20     1 */
>>
>>         /* XXX 3 bytes hole, try to pack */
>>
>>         struct seccomp_data        data;                 /*    24    64 */
>>         /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
>>
>>         /* size: 88, cachelines: 2, members: 5 */
>>         /* sum members: 79, holes: 2, sum holes: 9 */
>>         /* last cacheline: 24 bytes */
>> };
>> struct seccomp_notif_resp {
>>         __u16                      len;                  /*     0     2 */
>>
>>         /* XXX 6 bytes hole, try to pack */
>>
>>         __u64                      id;                   /*     8     8 */
>>         __s32                      error;                /*    16     4 */
>>
>>         /* XXX 4 bytes hole, try to pack */
>>
>>         __s64                      val;                  /*    24     8 */
>>
>>         /* size: 32, cachelines: 1, members: 4 */
>>         /* sum members: 22, holes: 2, sum holes: 10 */
>>         /* last cacheline: 32 bytes */
>> };
>>
>> How about making len u32, and moving pid and error above "id"? This
>> leaves a hole after signaled, so changing "len" won't be sufficient
>> for versioning here. Perhaps move it after data?
>
> I'm not sure what you mean by "len won't be sufficient for versioning
> here"? Anyway, I can do some packing on these; I didn't bother before
> since I figured it's a userspace interface, so saving a few bytes
> isn't a huge deal.

I was thinking the "len" portion was for determining if the API ever
changes in the future. My point was that given the padding holes, e.g.
adding a u8 after signaled, "len" wouldn't change, so the kernel might
expect to starting reading something after signaled that it wasn't
checking before, but the len would be the same.

>> I have to say, I'm vaguely nervous about changing the semantics here
>> for passing back the fd as the return code from the seccomp() syscall.
>> Alternatives seem less appealing, though: changing the meaning of the
>> uargs parameter when SECCOMP_FILTER_FLAG_NEW_LISTENER is set, for
>> example. Hmm.
>
> From my perspective we can drop this whole thing. The only thing I'll
> ever use is the ptrace version. Someone at some point (I don't
> remember who, maybe stgraber) suggested this version would be useful
> as well.

Well that would certainly change the exposure of the interface pretty
drastically. :)

So, let's talk more about this, as it raises another thought I had
too: for the PTRACE interface to work, you have to know specifically
which filter you want to get notifications for. Won't that be slightly
tricky?

> Anyway, let me know if your nervousness outweighs this, I'm happy to
> drop it.

I'm not opposed to keeping it, but if you don't think anyone will use
it ... we should probably drop it just to avoid the complexity. It's a
cool API, though, so I'd like to hear from others first before you go
tearing it out. ;) (stgraber added to CC)

>> It is possible (though unlikely given the type widths involved here)
>> for unotif = {} to not initialize padding, so I would recommend an
>> explicit memset(&unotif, 0, sizeof(unotif)) here.
>
> Orly? I didn't know that, thanks.

Yeah, it's a pretty annoying C-ism. The spec says that struct
_members_ will get zero-initialized, but it doesn't say anything about
padding. >_< In most cases, the padding gets initialized too, just
because of bit widths being small enough that they're caught in the
member initialization that the compiler does. But for REALLY big
holes, they may get missed. In this case, while the padding is small,
it's directly exposed to userspace, so I want to make it robust.

>> > +       if (copy_from_user(&size, buf, sizeof(size)))
>> > +               return -EFAULT;
>> > +       size = min_t(size_t, size, sizeof(resp));
>> > +       if (copy_from_user(&resp, buf, size))
>> > +               return -EFAULT;
>>
>> For sanity checking on a double-read from userspace, please add:
>>
>>     if (resp.len != size)
>>         return -EINVAL;
>
> Won't that fail if sizeof(resp) < resp.len, because of the min_t()?

Ah, true. In that case, probably do resp.len = size to avoid any logic
failures due to the double-read? I just want to avoid any chance of
confusing the size and actually using it somewhere.

-Kees

-- 
Kees Cook
Pixel Security
