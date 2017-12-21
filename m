From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: shmctl(SHM_STAT) vs. /proc/sysvipc/shm permissions discrepancies
Date: Thu, 21 Dec 2017 09:56:16 +0100
Message-ID: <CAKgNAkjSF9fXhKCxPMp92zftA4Qtq91WBt8L5UR50oQO8HgRxw@mail.gmail.com>
References: <20171219094848.GE2787@dhcp22.suse.cz> <CAKgNAkjJrmCFY-h2oqKS3zM_D+Csx-17A27mh08WKahyOVzrgQ@mail.gmail.com>
 <20171220092025.GD4831@dhcp22.suse.cz> <CAKgNAkisD7zDRoqJd6Gk1JMCZ8+Huj5QPV04nh2JXHMA+_R0-A@mail.gmail.com>
 <20171221080203.GZ4831@dhcp22.suse.cz>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221080203.GZ4831-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michal,

On 21 December 2017 at 09:02, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed 20-12-17 17:17:46, Michael Kerrisk wrote:
>> Hello Michal,
>>
>> On 20 December 2017 at 10:20, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > On Tue 19-12-17 17:45:40, Michael Kerrisk wrote:
>> >> But, is
>> >> there a pressing reason to make the change? (Okay, I guess iterating
>> >> using *_STAT is nicer than parsing /proc/sysvipc/*.)
>> >
>> > The reporter of this issue claims that "Reading /proc/sysvipc/shm is way
>> > slower than executing the system call." I haven't checked that but I can
>> > imagine that /proc/sysvipc/shm can take quite some time when there are
>> > _many_ segments registered.
>>
>> Yes, that makes sense.
>>
>> > So they would like to use the syscall but
>> > the interacting parties do not have compatible permissions.
>>
>> So, I don't think there is any security issue, since the same info is
>> available in /proc/sysvipc/*.
>
> Well, I am not sure this is a valid argument (maybe I just misread your
> statement).

(Or perhaps I was not clear enough; see below)

> Our security model _might_ be broken because of the sysipc
> proc interface existance already. I am not saying it is broken because
> I cannot see an attack vector based solely on the metadata information
> knowledge. An attacker still cannot see/modify the real data. But maybe
> there are some bugs lurking there and knowing the metadata might help to
> exploit them. I dunno.
>
> You are certainly right that modifying/adding STAT flag to comply with
> the proc interface permission model will not make the system any more
> vulnerable, though.

Yep, that was my point. Modifying _STAT behavior won't decrease security.

That said, /proc/sysvipc/* has been around for a long time now, and
nothing bad seems to have happened so far, AFAIK.

>> The only question would be whether
>> change in the *_STAT behavior might surprise some applications into
>> behaving differently. I presume the chances of that are low, but if it
>> was a concert, one could add new shmctl/msgctl/semctl *_STAT_ALL (or
>> some such) operations that have the desired behavior.
>
> I would lean towards _STAT_ALL because this is Linux specific behavior
> (I have looked at what BSD does here and they are checking permissions
> for STAT as well). It would also be simpler to revert if we ever find
> that this is a leak with security consequences.

Oh -- I was unaware of this BSD behavior. At least on the various UNIX
systems that I ever used SYSVIPC (including one or two ancient
commercial BSD derivatives), ipcs(1) showed all IPC objects. (On
FeeBSD, at least, it looks like ipcs(1) doesn't use the *_STAT
interfaces.)

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
