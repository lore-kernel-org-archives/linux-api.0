From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked
 down
Date: Wed, 27 Mar 2019 09:30:57 +0900
Message-ID: <20190327003057.GA27311@kroah.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com>
 <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 12:20:24PM -0700, Andy Lutomirski wrote:
> On Tue, Mar 26, 2019 at 11:28 AM Matthew Garrett
> <matthewgarrett@google.com> wrote:
> >
> > From: Matthew Garrett <mjg59@google.com>
> >
> > debugfs has not been meaningfully audited in terms of ensuring that
> > userland cannot trample over the kernel. At Greg's request, disable
> > access to it entirely when the kernel is locked down. This is done at
> > open() time rather than init time as the kernel lockdown status may be
> > made stricter at runtime.
> 
> Ugh.  Some of those files are very useful.  Could this perhaps still
> allow O_RDONLY if we're in INTEGRITY mode?

Useful for what?  Debugging, sure, but for "normal operation", no kernel
functionality should ever require debugfs.  If it does, that's a bug and
should be fixed.

thanks,

greg k-h
