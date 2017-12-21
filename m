From: Michal Hocko <mhocko@kernel.org>
Subject: Re: shmctl(SHM_STAT) vs. /proc/sysvipc/shm permissions discrepancies
Date: Thu, 21 Dec 2017 09:02:03 +0100
Message-ID: <20171221080203.GZ4831@dhcp22.suse.cz>
References: <20171219094848.GE2787@dhcp22.suse.cz>
 <CAKgNAkjJrmCFY-h2oqKS3zM_D+Csx-17A27mh08WKahyOVzrgQ@mail.gmail.com>
 <20171220092025.GD4831@dhcp22.suse.cz>
 <CAKgNAkisD7zDRoqJd6Gk1JMCZ8+Huj5QPV04nh2JXHMA+_R0-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkisD7zDRoqJd6Gk1JMCZ8+Huj5QPV04nh2JXHMA+_R0-A@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, Manfred Spraul <manfred@colorfullife.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, Mike Waychison <mikew@google.com>, LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Wed 20-12-17 17:17:46, Michael Kerrisk wrote:
> Hello Michal,
> 
> On 20 December 2017 at 10:20, Michal Hocko <mhocko@kernel.org> wrote:
> > On Tue 19-12-17 17:45:40, Michael Kerrisk wrote:
> >> But, is
> >> there a pressing reason to make the change? (Okay, I guess iterating
> >> using *_STAT is nicer than parsing /proc/sysvipc/*.)
> >
> > The reporter of this issue claims that "Reading /proc/sysvipc/shm is way
> > slower than executing the system call." I haven't checked that but I can
> > imagine that /proc/sysvipc/shm can take quite some time when there are
> > _many_ segments registered.
> 
> Yes, that makes sense.
> 
> > So they would like to use the syscall but
> > the interacting parties do not have compatible permissions.
> 
> So, I don't think there is any security issue, since the same info is
> available in /proc/sysvipc/*.

Well, I am not sure this is a valid argument (maybe I just misread your
statement). Our security model _might_ be broken because of the sysipc
proc interface existance already. I am not saying it is broken because
I cannot see an attack vector based solely on the metadata information
knowledge. An attacker still cannot see/modify the real data. But maybe
there are some bugs lurking there and knowing the metadata might help to
exploit them. I dunno.

You are certainly right that modifying/adding STAT flag to comply with
the proc interface permission model will not make the system any more
vulnerable, though.

> The only question would be whether
> change in the *_STAT behavior might surprise some applications into
> behaving differently. I presume the chances of that are low, but if it
> was a concert, one could add new shmctl/msgctl/semctl *_STAT_ALL (or
> some such) operations that have the desired behavior.

I would lean towards _STAT_ALL because this is Linux specific behavior
(I have looked at what BSD does here and they are checking permissions
for STAT as well). It would also be simpler to revert if we ever find
that this is a leak with security consequences.

What do other people think? I can prepare a patch.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
