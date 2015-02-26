From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 14:33:08 -0600
Message-ID: <20150226203308.GA18926@mail.hallyn.com>
References: <20150224154715.GA20682@mail.hallyn.com>
 <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
 <20150224164429.GB29685@ubuntumail>
 <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
 <20150225033247.GC29685@ubuntumail>
 <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com>
 <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com>
 <CALCETrWpKiurZEEOT25i_xrtQyk5dht+wjUO4+tGs+N_7JCdYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWpKiurZEEOT25i_xrtQyk5dht+wjUO4+tGs+N_7JCdYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christoph Lameter <cl@linux.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 11:38:01AM -0800, Andy Lutomirski wrote:
> On Thu, Feb 26, 2015 at 11:32 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Thu, Feb 26, 2015 at 12:28:30PM -0600, Christoph Lameter wrote:
> >> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
> >>
> >> > > Well doing that breaks su.
> >> >
> >> > Don't what exactly?  You're saying that doing
> >> >
> >> > pI' = pI
> >> > pA' = pA  (pA is ambient)
> >> > pP' = (X & fP) | (pI & (fI | pA))
> >> > pE' = pP' & (fE | pA)
> >> >
> >> > stopped su from having CAP_SETGID while
> >> >
> >> > pI' = pI
> >> > pA' = pA  (pA is ambient)
> >> > pP' = (X & fP) | (pI & (fI | pA))
> >> > pE' = pP' & fE
> >> >
> >> > worked?  I'll hope you're saying both "fail", in which case
> >>
> >> fE does not exist in cpu_vfs_cap_data. We only get fI and fP. Why in the
> >> world does setcap allow setting fE?
> >
> > It sets a bit in the magic_etc.  So fE is either all on or all off.
> >
> >> V1 does not use fE. In my newer attempt, I seemed to have worked
> >> with zeroed field that I assumed was filled in.
> >>
> >> I will just do
> >>
> >> pE' = pP'
> >>
> >> Ok?
> >
> > Andrew Morgan was against that.  What if we changed
> >
> > pE' = pP' & (fE | pA)
> >
> > to
> >
> >         if (pA)
> >                 pE' = pP' & fE
> >         else
> >                 pE' = pP'
> >
> 
> Is this backwards?

D'oh, yes.

> Also, on further bikeshedding consideration, I think I like the name
> "persistent" much better than "ambient".  Alas, "persistent" starts
> with a P.
> 
> --Andy
