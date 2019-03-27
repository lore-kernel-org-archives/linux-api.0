From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked
 down
Date: Wed, 27 Mar 2019 11:35:20 +0900
Message-ID: <20190327023520.GA20766@kroah.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com>
 <20190327003130.GB27311@kroah.com>
 <CACdnJuvBJmCRnzT=4qh9cmNkRNHi3Xfha5xqUqYu8cgCRrtsqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuvBJmCRnzT=4qh9cmNkRNHi3Xfha5xqUqYu8cgCRrtsqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 07:06:36PM -0700, Matthew Garrett wrote:
> On Tue, Mar 26, 2019 at 5:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Mar 26, 2019 at 11:27:41AM -0700, Matthew Garrett wrote:
> > > From: Matthew Garrett <mjg59@google.com>
> > >
> > > debugfs has not been meaningfully audited in terms of ensuring that
> > > userland cannot trample over the kernel. At Greg's request, disable
> > > access to it entirely when the kernel is locked down. This is done at
> > > open() time rather than init time as the kernel lockdown status may be
> > > made stricter at runtime.
> 
> (snip)
> 
> > Why allow all this, why not just abort the registering of the filesystem
> > with the vfs core so it can't even be mounted?
> 
> As mentioned in the commit message, because the lockdown state can be
> made stricter at runtime - blocking at mount time would be
> inconsistent if the machine is locked down afterwards. We could
> potentially assert that it's the admin's responsibility to ensure that
> debugfs isn't mounted at the point of policy being made stricter?

Ugh, I can not read, sorry, neverind.

The patch is fine as-is.

greg k-h
