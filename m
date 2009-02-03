From: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Tue, 3 Feb 2009 15:08:16 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902031446280.23050@alien.or.mcafeemobile.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-865313531-1233701588=:23050"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4988BD4E.8080206-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-865313531-1233701588=:23050
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 3 Feb 2009, Eric Dumazet wrote:

> Andrew Morton a écrit :
> > On Mon,  2 Feb 2009 11:20:09 -0700
> > Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
> > 
> >> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
> >> saving space in struct file.  This patch makes that change.
> > 
> > hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> > it doesn't have all the correct/well-understood memory/compiler
> > ordering semantics which spinlocks have.  And lockdep doesn't know about
> > it.
> > 
> 
> In a previous attempt (2005), I suggested using a single global lock.
> 
> http://search.luky.org/linux-kernel.2005/msg50862.html
> 
> Probably an array of hashed spinlocks would be more than enough.

That could be done, although I'm not sure it's worth going that way to 
save 4 bytes. The effective saving rate is not even 4/sizeof(struct file) 
since struct file never comes alone, and when you allocate a struct file 
you always carry more allocations behind (at least for the cases where you 
tend to have a lot of them around, so size would matter).
The add/remove path in epoll is not a super-hot one, so it could be done. 
I dunno how this change matter with the patchset though.



- Davide
--1795850513-865313531-1233701588=:23050--
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
