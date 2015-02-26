From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 15:19:54 -0600
Message-ID: <20150226211954.GC19273@mail.hallyn.com>
References: <20150225033247.GC29685@ubuntumail>
 <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com>
 <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com>
 <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
 <20150226203405.GB18926@mail.hallyn.com>
 <CALCETrUB1bb4TiiBgdAMVtRJcEAoDzuOH+StTLPVL8QiXXdOfQ@mail.gmail.com>
 <20150226205512.GA19273@mail.hallyn.com>
 <CALCETrXGO+ejHAfic4fozf1y48WDBdk3Mo=dFt8MMxtN1HOuUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXGO+ejHAfic4fozf1y48WDBdk3Mo=dFt8MMxtN1HOuUg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christoph Lameter <cl@linux.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 12:58:33PM -0800, Andy Lutomirski wrote:
> On Thu, Feb 26, 2015 at 12:55 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Thu, Feb 26, 2015 at 12:51:57PM -0800, Andy Lutomirski wrote:
> >> On Thu, Feb 26, 2015 at 12:34 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >> > On Thu, Feb 26, 2015 at 02:13:00PM -0600, Christoph Lameter wrote:
> >> >> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
> >> >>
> >> >> > Andrew Morgan was against that.  What if we changed
> >> >> >
> >> >> > pE' = pP' & (fE | pA)
> >> >> >
> >> >> > to
> >> >> >
> >> >> >     if (pA)
> >> >> >             pE' = pP' & fE
> >> >> >     else
> >> >> >             pE' = pP'
> >> >> >
> >> >>
> >> >> Same problem as before. The ambient bits will not be set in pE'.
> >> >
> >> > And what if I weren't scatterbrained and we did
> >> >
> >> >         if (pA)
> >> >                 pE' = pP'
> >> >         else
> >> >                 pE' = pP' & fE
> >> >
> >> > All pP' bits would be set in pE'.
> >>
> >> That seems reasonable to me, except for my paranoia:
> >>
> >> What if there's a program with CAP_DAC_OVERRIDE in fP and fE set to
> >> the empty set (i.e. the magic effective bit cleared), and the program
> >> relies on that.  A malicious user has CAP_NET_BIND and sets pA =
> >> CAP_NET_BIND.  Boom!
> >>
> >> If we changed that to if (pA') and zeroed pA if fP is non-empty then
> >> this problem goes away.
> >
> > Hm, the problem is that then the empty pA is inherited by children.
> > I do see that any program with fP set should probably run with only
> > what it requested.  Would
> >
> >          if (pA && is_empty(fP))
> >                  pE' = pP'
> >          else
> >                  pE' = pP' & fE
> >
> > help?  Or are you worried about a program with fP set which then
> > executes other programs?
> 
> The particular worry I expressed there was just about pE.
> 
> I'm still extremely nervous about allowing nonempty pA to propagate to
> setuid or nonzero fP programs.  It's less obviously dangerous if pA is
> never a superset of pP, but it could still cause problems with setuid
> programs that execute intentionally deprivileged helpers.

I don't think that what you want is compatible with what Christoph
wants.  (He also thinks that what I want is not compatible with what
he wants, but I still think it is)

The approach I'm taking is that pA is useless if pI is not set.  For
a privileged program to fill its pI is a pretty special thing now,
so this shouldn't be catching anyone by surprise.  Furthermore,
the privileged program which is filling both its pI and pA
and then executing other files could achieve the same result
by filling pI and setting file capaiblities on all executables.
Setting pA gives them a different tradeoff (limiting the
capabilities trust to its process tree, but to all binaries)
which should do what Christoph wants.  By limiting the effective pA to fP
if fP is not empty, we'r eonly prevneting the file which
had fP set from running in an unexpected way which should be
safer.  (But if it executes another file, that file, it will
receive the original pA)
