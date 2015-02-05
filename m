From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [capabilities] Allow normal inheritance for a configurable set
 of capabilities
Date: Thu, 5 Feb 2015 16:23:27 +0100
Message-ID: <20150205152327.GA31086@mail.hallyn.com>
References: <alpine.DEB.2.11.1502021018500.5029@gentwo.org>
 <20150202171257.GD24351@ubuntumail>
 <alpine.DEB.2.11.1502030920050.6059@gentwo.org>
 <20150203155544.GE2923@mail.hallyn.com>
 <alpine.DEB.2.11.1502031117100.6368@gentwo.org>
 <20150203172653.GB4748@mail.hallyn.com>
 <CALQRfL5iyu0n5rJCNLUVNMiekBEXzEnPFU-Fz0AibJ+E0d6o-Q@mail.gmail.com>
 <20150205003434.GC23013@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150205003434.GC23013@mail.hallyn.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, Christoph Lameter <cl@linux.com>, casey@schaufler-ca.com, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, akpm@linuxfoundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Andrew G. Morgan (morgan@kernel.org):
> > I'm not generally in favor of this. Mostly because this seems to be a
> > mini-root kind of inheritance that propagates privilege to binaries
> > that aren't prepared for privilege.
> 
> Earlier in this thread, Casey said:
> 
> | One of the holes in the 1003.1e spec is what to do with a program file
> | that does not have a capability set attached to it. The two options are
> | drop all capabilities and leave the capabilities alone. The latter gives
> | you what you're asking for. The former is arguably safer.
> 
> and
> 
> | It's what we did in Trusted Irix. It made life much easier.
> 
> I'm going to need to clear my head a bit before I try to compare that to
> the root cause of the sendmail capabilities bug.
> 
> >  I don't really buy the mmap code
> > concern because the model as it stands says that you trust the binary
> > (and all of the various ways it was programmed to execute code) with
> > specific privileges. If the binary mmap's some code (PAM modules come
> > to mind) then that is part of what it was programmed to/allowed to do.
> 
> That's not really the point...  The point is that yes, a mini-root is
> exactly what is being asked for :)  I'm not saying I expect an adversary
> to do the mmap+jump, but that currently it is a, and the only, way to
> do unprivileged userid with retaining some privileges to run legacy
> programs.
> 
> > That being said, if you really really want this kind of thing, then
> > make it a single secure bit (with another lock on/off bit) which, when
> > set, makes: fI default to X.
> > 
> >    pP' = (X & fP) | (pI & fI)
> > 
> > That way the per-process bounding set still works as advertised and
> > you don't need to worry about the existing semantics being violated.
> 
> Maybe that is the way to go...

We could require nnp to set the new securebit, and add a
CONFIG_SECURITY_LULZ_I_DONT_CARE to skip that requirement.
(Or maybe that just makes things worse by having more
different sets of rules...)
