From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add new capability to allow a process to migrate
 other tasks between cgroups
Date: Wed, 19 Oct 2016 16:52:51 -0400
Message-ID: <20161019205251.GG3044@htj.duckdns.org>
References: <1476743724-9104-1-git-send-email-john.stultz@linaro.org>
 <CALCETrXrZpLH8NsSmaoH5ChW5+6Zb=nLsznj=x4jeWUjpQ-ecA@mail.gmail.com>
 <CALAqxLW0_Xi0vrTkTN+Gmp3yKfOcmCYYCi5f4COgPiYY=odEJA@mail.gmail.com>
 <CAKgNAkjTYu53ji=gP2qXRYpvUEdAP=gxg0BR40JJ54z+XBha-A@mail.gmail.com>
 <CALAqxLW7XS3KyA=cCKvxJAuOYhkw_d0vUJ6=RpN0a=RL2fYm=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALAqxLW7XS3KyA=cCKvxJAuOYhkw_d0vUJ6=RpN0a=RL2fYm=w@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Oct 18, 2016 at 09:54:37AM -0700, John Stultz wrote:
> > Also, CAP_SYS_RESOURCE deserves consideration (34 uses in capable()
> > checks). I'd say, since cgroups are about resources, so there's
> > something of a match there., so it's also worth considering.
> 
> I'll try to look into CAP_SYS_RESOURCE.
> 
> Colin/Todd: Any objection from the Android side on CAP_SYS_RESOURCE?
> 
> (Or we could just create a new 512bit CAP2_ capabilities interface! :P)

FWIW, if CAP_SYS_RESOURCE works, I'd be happy with that.

Thanks.

-- 
tejun
