From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 24 Apr 2015 16:15:11 -0500
Message-ID: <20150424211511.GB28613@mail.hallyn.com>
References: <alpine.DEB.2.11.1503300754070.5031@gentwo.org>
 <CALCETrW9ckw=7-1JSyFkenhFu2_1MvVqjA+inOmsuuWemGaU0w@mail.gmail.com>
 <alpine.DEB.2.11.1504091024540.13650@gentwo.org>
 <alpine.DEB.2.11.1504230900260.32203@gentwo.org>
 <20150424175348.GL16377@ubuntumail>
 <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw@mail.gmail.com>
 <20150424190935.GN16377@ubuntumail>
 <CALCETrV7S0dLkNWMSYsL7MFuLgdpQwUEAjW6zTwRE8uhh_AuBQ@mail.gmail.com>
 <alpine.DEB.2.11.1504241512570.11839@gentwo.org>
 <CALCETrUrFm9n_4xTj4ELkzTSnWHfxQtANqz2wpzU7riTihLDaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUrFm9n_4xTj4ELkzTSnWHfxQtANqz2wpzU7riTihLDaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christoph Lameter <cl@linux.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 01:18:44PM -0700, Andy Lutomirski wrote:
> On Fri, Apr 24, 2015 at 1:13 PM, Christoph Lameter <cl@linux.com> wrote:
> > On Fri, 24 Apr 2015, Andy Lutomirski wrote:
> >
> >> That's sort of what my patch does -- you need CAP_SETPCAP to switch
> >> the securebit.
> >>
> >> But Christoph's patch required it to add caps to the ambient set, right?
> >
> > Yes but you seem to be just adding one additional step without too much of
> > a benefit because you still need CAP_SETPCAP.
> >
> 
> No, because I set the default to on :)

Right - I definately prefer

. default off
. CAP_SETPCAP required to turn it on (for self and children)
. once on, anyone can copy bits from (whatever we decided) to pA.

> Also, in my model you can do:
> 
> $ sudo capset cap_whatever=eip something
> $ ./something
> 
> and the program can make its cap be ambient and run a helper.  In the
> CAP_SETPCAP model, that doesn't work.
> 
> --Andy
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
