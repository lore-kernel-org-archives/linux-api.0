From: Eric Dumazet <dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Tue, 03 Feb 2009 22:55:26 +0100
Message-ID: <4988BD4E.8080206@cosmosbay.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>	<1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090203133942.2ecec281.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andrew Morton a =E9crit :
> On Mon,  2 Feb 2009 11:20:09 -0700
> Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
>=20
>> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a =
way of
>> saving space in struct file.  This patch makes that change.
>=20
> hrm.  bit_spin_lock() makes people upset (large penguiny people).  ii=
rc
> it doesn't have all the correct/well-understood memory/compiler
> ordering semantics which spinlocks have.  And lockdep doesn't know ab=
out
> it.
>=20

In a previous attempt (2005), I suggested using a single global lock.

http://search.luky.org/linux-kernel.2005/msg50862.html

Probably an array of hashed spinlocks would be more than enough.



--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
