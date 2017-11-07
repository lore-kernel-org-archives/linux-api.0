From: Boris Lukashev <blukashev@sempervictus.com>
Subject: Re: Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Mon, 6 Nov 2017 19:01:58 -0500
Message-ID: <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
References: <20171103004436.40026-1-mahesh@bandewar.net> <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com> <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com> <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-hardening-return-10400-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20171106233913.GA1518@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Micay <danielmicay@gmail.com>, =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 6, 2017 at 6:39 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Boris Lukashev (blukashev@sempervictus.com):
>> On Mon, Nov 6, 2017 at 5:14 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Daniel Micay (danielmicay@gmail.com):
>> >> Substantial added attack surface will never go away as a problem. There
>> >> aren't a finite number of vulnerabilities to be found.
>> >
>> > There's varying levels of usefulness and quality.  There is code which I
>> > want to be able to use in a container, and code which I can't ever see a
>> > reason for using there.  The latter, especially if it's also in a
>> > staging driver, would be nice to have a toggle to disable.
>> >
>> > You're not advocating dropping the added attack surface, only adding a
>> > way of dealing with an 0day after the fact.  Privilege raising 0days can
>> > exist anywhere, not just in code which only root in a user namespace can
>> > exercise.  So from that point of view, ksplice seems a more complete
>> > solution.  Why not just actually fix the bad code block when we know
>> > about it?
>> >
>> > Finally, it has been well argued that you can gain many new caps from
>> > having only a few others.  Given that, how could you ever be sure that,
>> > if an 0day is found which allows root in a user ns to abuse
>> > CAP_NET_ADMIN against the host, just keeping CAP_NET_ADMIN from them
>> > would suffice?  It seems to me that the existing control in
>> > /proc/sys/kernel/unprivileged_userns_clone might be the better duct tape
>> > in that case.
>> >
>> > -serge
>>
>> This seems to be heading toward "we need full zones in Linux" with
>> their own procfs and sysfs namespace and a stricter isolation model
>> for resources and capabilities. So long as things can happen in a
>> namespace which have a privileged relationship with host resources,
>> this is going to be cat-and-mouse to one degree or another.
>>
>> Containers and namespaces dont have a one-to-one relationship, so i'm
>> not sure that's the best term to use in the kernel security context
>
> Sorry - what's not the best term to use?

Pardon, "containers," since they're namespaces+system construct.

>
>> since there's a bunch of userspace and implementation delta across the
>> different systems (with their own security models and so forth).
>> Without accounting for what a specific implementation may or may not
>> do, and only looking at "how do we reduce privileged impact on parent
>> context from unprivileged namespaces," this patch does seem to provide
>> a logical way of reducing the privileges available in such a namespace
>> and often needed to mount escapes/impact parent context.
>
> What different implementations do is irrelevant - as an unprivileged user
> I can always, with no help, create a new user namespace mapping my current
> uid to root, and exercise this code.  So the security model implemented
> by a particular userspace namespace-using driver doesn't matter, as it
> only restricts me if I choose to use it.
>
> But, I guess you're actually saying that some program might know that it
> should never use network code so want to drop CAP_NET_*?  And you're
> saying that a "global capability bounding set" might be useful?
>

The "global capability bounding set" with forced inheritance can be
used to prevent the vector you describe wherein the capability of UID
0 in the child NS is restricted from the parent implicitly, so yes,
that nomenclature seems appropriate.

> Would it be better to actually implement it as a new bounding set that
> is maintained across user namespace creations, but is per-task (inherted
> by children of course)?  Instead of a sysctl?
>
> -serge

In line with the previous comment, the inheritance across subsequent
invocations should be forced to prevent the context you described.
Please pardon my ignorance, not sure what you mean in terms of
"per-task" across namespace creation.

-Boris

-- 
Boris Lukashev
Systems Architect
Semper Victus
