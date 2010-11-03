From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Wed, 3 Nov 2010 12:03:12 -0700
Message-ID: <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
 <20101103023422.GB5782@kroah.com> <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
 <20101103181634.GF7441@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103181634.GF7441-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 3, 2010 at 11:16 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Nov 02, 2010 at 08:37:42PM -0700, Mike Waychison wrote:
>> On Tue, Nov 2, 2010 at 7:34 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>> > On Tue, Nov 02, 2010 at 06:29:25PM -0700, Mike Waychison wrote:
>> >> This patchset applies to v2.6.36.
>> >>
>> >> The following series implements support for 'netoops', a simple d=
river that
>> >> will deliver kmsg logs together with machine specifics over the n=
etwork.
>> >
>> > We already have the ability to send oopses over the network today,
>> > through the network consolst stuff. What does this patch set do th=
at is
>> > different from our existing stuff that warrants such a big change?
>> >
>>
>> Hi Greg,
>>
>> I am a little familiar with the netconsole suppport. =A0I should hav=
e
>> added a comparison to the cover email :(
>>
>> We never adopted netconsole for a couple different reasons. =A0The
>> reasons have slightly changed over the years, but even today we find
>> that it isn't a substitute for netoops' semantics.
>
> Ah, but it sounds like it would be better to fix up netoops to handle
> your needs.

Perhaps, but I don't agree that overly complicating one simple driver
to handle a wildly different set of semantics is justified when it can
be implemented in another simple driver.

>
>> With the number of machines we have, streaming large amounts of
>> consoles within the data center can really add up. =A0This gets wors=
e
>> when you take into account how reliant we are on kernel logging like
>> OOM conditions (which are very regular and very verbose). =A0Events =
in
>> the data center (such as application growth) tend to be temporally
>> correlated, which causes large bursts of logging when we are OOM. =A0=
We
>> aren't so interested in this kernel verbosity from a global collecti=
on
>> standpoint though, and haven't been keen on the amount of extra
>> un-regulated UDP traffic it would generate. =A0We are however intere=
sted
>> in kernel oopses though (which occur far less often).
>
> Understood, I'm sure that a change to allow this to the existing neto=
ops
> code would be appreciated by many.

Do you mean netconsole here?

>
>> In terms of the data received, we've really benefited by having
>> structured data in the payload.
>
> I bet the whole world would benefit by having the oops messages in a
> more "structured" manner. =A0We have done changes in the past to prov=
ide
> this type of thing in a "more parsable" manner, to help stuff like
> kerneloops.org. =A0I'm sure that adding this type of information to t=
he
> main oops core/messages would be a good overall goal, instead of only
> having it available to only this one option/user, right?

It'd be great to figure out how to make this sort of data structured
in the logs, but it's not really a battle that I'm willing to fight.
It seems that as a community, we haven't figured out a good way to
provide any sort of committed ABI via printk (perhaps rightly so).

Another aspect that makes me _not_ want to go this route is the
pushback we've received in the past about not having too much data get
added to the oops messages themselves, as folks still relied on
literal screenshots of oopses.

>
>> Another area where the two approaches have differed has been in
>> handling of network reliability. =A0Historically (though less and le=
ss
>> now), we found that we had to transmit data several times. =A0We als=
o
>> used to explicitly space out packets with delays to handle switch ch=
ip
>> buffer overruns. =A0Both of these functions I presume could be added=
 to
>> netconsole without too much of a problem.
>
> Yes, I agree netconsole would be good to get this type of change.
>
>> Lastly, this patchset also introduces a 'one-shot' mode, which has
>> saved our bacon several times in the past as well. =A0It's not total=
ly
>> uncommon for the kernel's crash path to be buggy, in turn causing th=
e
>> kernel to emit Oopses until the cows come home (or rather, until the
>> hardware watchdogs trip). =A0One-shot keeps us from emitting too muc=
h
>> garbage on the network when this happens.
>
> I thought we had something like "only show the first oops" somewhere =
in
> the kernel, perhaps I'm just imagining things...
>
> If I am, adding this for all oopses would also be good.

Well, there is always panic_on_oops, which we use, but that alone
doesn't solve the recursive oops problem.

>
>> I hope the above comparison of semantics outlines the motivations we
>> have for not using netconsole and favoring an approach like that use=
d
>> in netoops :)
>
> I think you have just convinced me that you should add this type of
> functionality for all oops messages even more, instead of only doing =
it
> for your one type of oops transport :)

I think you are heavily discounting the value of structured data :(
It also doesn't help that printk's aren't transactional to each other
when oopsing (which essentially makes concurrently oopsing CPUs shit
all over each other in the logs, leading to unparseable data).  You
are welcome to push the rock up hill for structured log data though ;)

> As for the user/kernel interface, perhaps exporting the data in a tex=
t
> format that is "tagged" would be best? =A0Then the whole world can pa=
rse
> it easily.

=46WIW, another semantic difference between netconsole and netoops (tha=
t
I had missed in the last email) is filtering: we really do want to get
the whole log when a crash happens, debug messages and all.
Netconsole is subject to console filtering (which we _do_ want as
debug messages going out the uart slows the whole world down).

netconsole and netoops _do_ have bits in common, for instance the
handling of NETDEV events and source+target configuration.  I'd rather
those bits become common between the two than figure out how to jam
the semantics we need into netconsole.
