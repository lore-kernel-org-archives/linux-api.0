From: joeyli <joeyli.kernel@gmail.com>
Subject: Re: [PATCH V34 10/29] hibernate: Disable when the kernel is locked
 down
Date: Thu, 11 Jul 2019 12:11:45 +0800
Message-ID: <20190711041145.GA28145@linux-l9pv.suse>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-11-matthewgarrett@google.com>
 <20190622175208.GB30317@amd>
 <nycvar.YFH.7.76.1906241520500.27227@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1906241520500.27227@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, rjw@rjwysocki.net, linux-pm@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi experts,

On Mon, Jun 24, 2019 at 03:21:23PM +0200, Jiri Kosina wrote:
> On Sat, 22 Jun 2019, Pavel Machek wrote:
> 
> > > There is currently no way to verify the resume image when returning
> > > from hibernate.  This might compromise the signed modules trust model,
> > > so until we can work with signed hibernate images we disable it when the
> > > kernel is locked down.
> > 
> > I keep getting these...
> > 
> > IIRC suse has patches to verify the images.
> 
> Yeah, Joey Lee is taking care of those. CCing.
>

The last time that I sent for hibernation encryption and authentication is
here:
    https://lkml.org/lkml/2019/1/3/281

It needs some big changes after review:
 - Simplify the design: remove keyring dependency and trampoline.
 - Encrypted whole snapshot image instead of only data pages.
 - Using TPM:
        - Direct use TPM API in hibernation instead of keyring
        - Localities (suggested by James Bottomley)

I am still finding enough time to implement those changes, especial TPM
parts.

Thanks
Joey Lee
