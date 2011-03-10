From: Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Date: Thu, 10 Mar 2011 10:19:21 +0200
Message-ID: <20110310081921.GC11410@shisha.kicks-ass.net>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
 <20110309162513.5058c824.akpm@linux-foundation.org>
 <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>, Shaun Reich <predator106@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>, Michael Tokarev <mjt@tls.msk.ru>, Marcelo Tosatti <mtosatti@redhat.com>, John Stultz <johnstul@us.ibm.com>, Chris Friesen <chris.friesen@genband.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Artem Bityutskiy <dedekind1@gmail.com>, Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Alexander Shishkin <virtuoso@slind.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2011 at 01:36:18AM +0100, Kay Sievers wrote:
> On Thu, Mar 10, 2011 at 01:25, Andrew Morton <akpm@linux-foundation.o=
rg> wrote:
> > On Wed, =9A9 Mar 2011 16:36:51 +0200
> > Alexander Shishkin <virtuoso@slind.org> wrote:
> >
> >> Changes since v3:
> >> =9A- changed timerfd_settime() semantics (see below)
> >> Changes since v2:
> >> =9A- replaced sysfs interface with a syscall
> >> =9A- added sysctl/procfs handle to set a limit to the number of us=
ers
> >> =9A- fixed issues pointed out by Greg.
> >> Changes since v1:
> >> =9A- updated against 2.6.36-rc1,
> >> =9A- added notification/filtering options,
> >> =9A- added Documentation/ABI/sysfs-kernel-time-notify interface de=
scription.
>=20
> > It would be helpful to know if the identified users of this feature
> > actually find it useful and adequate. =9AI guess the most common
> > application is the 1,001 desktop clock widgets. =9ADo you have any
> > feedback from any of the owners of those?
>=20
> We want it for systemd, to provide cron-like functionality but withou=
t
> the need to stupidly wake up every minute and check the system time
> for possible jumps.
>=20
> It also sounds useful for a generic resume (after system suspend)
> notification for applications, which isn't really possible today.

Yes, but with John's CLOCK_BOOTTIME patches (which are in the tip tree
currently) it will be.

Regards,
--
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
