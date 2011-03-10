From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Date: Thu, 10 Mar 2011 10:08:18 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103101004540.2787@localhost6.localdomain6>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <20110309162513.5058c824.akpm@linux-foundation.org> <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-231965284-1299748105=:2787"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>, Shaun Reich <predator106@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>, Michael Tokarev <mjt@tls.msk.ru>, Marcelo Tosatti <mtosatti@redhat.com>, John Stultz <johnstul@us.ibm.com>, Chris Friesen <chris.friesen@genband.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Artem Bityutskiy <dedekind1@gmail.com>, Davide Libenzi <davidel@xmailserver.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-231965284-1299748105=:2787
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 10 Mar 2011, Kay Sievers wrote:

> On Thu, Mar 10, 2011 at 01:25, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed,  9 Mar 2011 16:36:51 +0200
> > Alexander Shishkin <virtuoso@slind.org> wrote:
> >
> >> Changes since v3:
> >>  - changed timerfd_settime() semantics (see below)
> >> Changes since v2:
> >>  - replaced sysfs interface with a syscall
> >>  - added sysctl/procfs handle to set a limit to the number of users
> >>  - fixed issues pointed out by Greg.
> >> Changes since v1:
> >>  - updated against 2.6.36-rc1,
> >>  - added notification/filtering options,
> >>  - added Documentation/ABI/sysfs-kernel-time-notify interface description.
> 
> > It would be helpful to know if the identified users of this feature
> > actually find it useful and adequate.  I guess the most common
> > application is the 1,001 desktop clock widgets.  Do you have any
> > feedback from any of the owners of those?
> 
> We want it for systemd, to provide cron-like functionality but without
> the need to stupidly wake up every minute and check the system time
> for possible jumps.
> 
> It also sounds useful for a generic resume (after system suspend)
> notification for applications, which isn't really possible today.

Note, that we have CLOCK_BOOTTIME pending for .39 which aims at the
same problem. It's basically CLOCK_MONOTONIC adjusted by the time we
were in suspend. So while CLOCK_MONOTONIC timers are not aware of the
time spent in suspend CLOCK_BOOTTIME timers are. The reason for
implementing CLOCK_BOOTTIME was basically the same problem.

Thanks,

	tglx
---1463795968-231965284-1299748105=:2787--
