From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked
 down
Date: Thu, 28 Mar 2019 03:31:52 +0900
Message-ID: <20190327183152.GB9371@kroah.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com>
 <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com>
 <20190327003057.GA27311@kroah.com>
 <CALCETrVDDf4dj3Md1Nxc5P_NCToXGnAbEO3bGfwgKSfeVmU4Kw@mail.gmail.com>
 <20190327050615.GA548@kroah.com>
 <16124107-70D3-4CA0-9766-36FC6DC10128@amacapital.net>
 <20190327053342.GA17484@kroah.com>
 <CALCETrUW=r=xyr4pGiGnn9zUEevf=z6PP3111Ds6qguV5SjYUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUW=r=xyr4pGiGnn9zUEevf=z6PP3111Ds6qguV5SjYUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 10:39:53AM -0700, Andy Lutomirski wrote:
> On Tue, Mar 26, 2019 at 10:33 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Mar 26, 2019 at 10:29:41PM -0700, Andy Lutomirski wrote:
> > >
> > >
> > > > On Mar 26, 2019, at 10:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > >> On Tue, Mar 26, 2019 at 09:29:14PM -0700, Andy Lutomirski wrote:
> > > >>> On Tue, Mar 26, 2019 at 5:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >>>
> > > >>>> On Tue, Mar 26, 2019 at 12:20:24PM -0700, Andy Lutomirski wrote:
> > > >>>> On Tue, Mar 26, 2019 at 11:28 AM Matthew Garrett
> > > >>>> <matthewgarrett@google.com> wrote:
> > > >>>>>
> > > >>>>> From: Matthew Garrett <mjg59@google.com>
> > > >>>>>
> > > >>>>> debugfs has not been meaningfully audited in terms of ensuring that
> > > >>>>> userland cannot trample over the kernel. At Greg's request, disable
> > > >>>>> access to it entirely when the kernel is locked down. This is done at
> > > >>>>> open() time rather than init time as the kernel lockdown status may be
> > > >>>>> made stricter at runtime.
> > > >>>>
> > > >>>> Ugh.  Some of those files are very useful.  Could this perhaps still
> > > >>>> allow O_RDONLY if we're in INTEGRITY mode?
> > > >>>
> > > >>> Useful for what?  Debugging, sure, but for "normal operation", no kernel
> > > >>> functionality should ever require debugfs.  If it does, that's a bug and
> > > >>> should be fixed.
> > > >>>
> > > >>
> > > >> I semi-regularly read files in debugfs to diagnose things, and I think
> > > >> it would be good for this to work on distro kernels.
> > > >
> > > > Doing that for debugging is wonderful.  People who want this type of
> > > > "lock down" are trading potential security for diagnositic ability.
> > > >
> > >
> > > I think you may be missing the point of splitting lockdown to separate integrity and confidentiality.  Can you actually think of a case where *reading* a debugfs file can take over a kernel?
> >
> > Reading a debugfs file can expose loads of things that can help take
> > over a kernel, or at least make it easier.  Pointer addresses, internal
> > system state, loads of other fun things.  And before 4.14 or so, it was
> > pretty trivial to use it to oops the kernel as well (not an issue here
> > anymore, but people are right to be nervous).
> >
> > Personally, I think these are all just "confidentiality" type things,
> > but who really knows given the wild-west nature of debugfs (which is as
> > designed).  And given that I think this patch series just crazy anyway,
> > I really don't care :)
> >
> 
> As far as I'm concerned, preventing root from crashing the system
> should not be a design goal of lockdown at all.  And I think that the
> "integrity" mode should be as non-annoying as possible, so I think we
> should allow reading from debugfs.

Sorry, the "crash the system" is not the issue here.  The issue is if
everyone can "ensure" that "everything" in debugfs is "safe" for this
mode of "lock down".  Given that no one has any idea of what really is
in debugfs, and to try to compare that with the design goals of what
"lock down" really is trying to achive, I think the goal of just giving
up and restricting access is fine if that makes people feel better about
this whole thing.

If this is locked down, it is going to cause distros more pain in
debugging user's issues, but that's their choice, not mine :)

thanks,

greg k-h
