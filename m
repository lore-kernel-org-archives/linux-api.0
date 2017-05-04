From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
Date: Thu, 4 May 2017 09:58:33 -0500
Message-ID: <20170504145832.GA28002@mail.hallyn.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
 <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
 <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
 <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
 <CALCETrVZ2KH4s2uGW2J3zUQ8RNsrq=N7pJP=YDqd=+cp6fJW=g@mail.gmail.com>
 <CAEiveUdbQcfn1xC5xWMv91vL_uR1MGTvARqw-E4GDTMUZ6t=bA@mail.gmail.com>
 <CAEiveUf4p1A1fggwibN+kJW7ruasQCmzr6=GSpTZXoyjJuz00Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-7680-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAEiveUf4p1A1fggwibN+kJW7ruasQCmzr6=GSpTZXoyjJuz00Q@mail.gmail.com>
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@ker>
List-Id: linux-api@vger.kernel.org

On Thu, May 04, 2017 at 03:07:49PM +0200, Djalal Harouni wrote:
> On Sat, Apr 22, 2017 at 2:17 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
> > On Sat, Apr 22, 2017 at 1:28 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> [...]
> >>
> >> My point is that all of these need some way to handle configuration
> >> and inheritance, and I don't think that a bunch of per-task prctls is
> >> the right way.  As just an example, saying that interactive users can
> >> autoload modules but other users can't, or that certain systemd
> >> services can, etc, might be nice.  Linus already complained that he
> >> (i.e. user "torvalds" or whatever) should be able to profile the
> >> kernel but that other uids should not be able to.
> >
> > Neat, maybe this could already be achieved with this interface and
> > systemd-logind,  "ModulesAutoloadUsers=andy" in logind.conf where
> > "andy" is the only logged-in user able to trigger and autoload kernel
> > modules. However maybe we should not restrict too much other bits or
> > functionality of the other users, please let me will follow up later
> > on it.
> >
> >> I personally like my implicit_rights idea, and it might be interesting
> >> to prototype it.
> >
> 
> Andy following on the idea of per user settings, I'm curious did you
> manage to make some advance on how to store the user settings ? the
> user database format is old and not extensible, there was cgmanager or

(v2 is under very very early consideration, would love to stay in the loop
as this is considered)

> other libcgroup but for resources, and no simple thing for such
> restrictions example: "RestrictLinuxModules=user" that will prevent
> such users from making/loading extra Linux features/modules that are
> not already available...
> 
> Thanks!
> 
> -- 
> tixxdz
